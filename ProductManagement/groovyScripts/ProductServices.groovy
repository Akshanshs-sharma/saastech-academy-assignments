package org.apache.ofbiz.productmgmt

import org.apache.ofbiz.entity.condition.EntityCondition
import org.apache.ofbiz.entity.condition.EntityOperator
import org.apache.ofbiz.entity.condition.EntityFunction
import org.apache.ofbiz.entity.util.EntityUtil
import org.apache.ofbiz.base.util.UtilDateTime
import org.apache.ofbiz.entity.GenericValue
import org.apache.ofbiz.service.ServiceUtil
import java.sql.Timestamp
import java.math.BigDecimal

/**
 * Search for products using name, id, category, price range, and feature filters.
 */
Map findProduct() {
    Map resultMap = success()
    List searchConds = []
    Timestamp nowTimestamp = UtilDateTime.nowTimestamp()

    // 1. Build query filters based on inputs
    if (parameters.productId) {
        searchConds.add(EntityCondition.makeCondition(
            EntityFunction.upperField('productId'),
            EntityOperator.LIKE,
            '%' + parameters.productId.toUpperCase() + '%'
        ))
    }
    if (parameters.productName) {
        searchConds.add(EntityCondition.makeCondition(
            EntityFunction.upperField('productName'),
            EntityOperator.LIKE,
            '%' + parameters.productName.toUpperCase() + '%'
        ))
    }
    if (parameters.productCategoryId) {
        searchConds.add(EntityCondition.makeCondition('productCategoryId', EntityOperator.EQUALS, parameters.productCategoryId))
    }
    if (parameters.productFeatureId) {
        searchConds.add(EntityCondition.makeCondition('productFeatureId', EntityOperator.EQUALS, parameters.productFeatureId))
    }
    if (parameters.productFeatureTypeId) {
        searchConds.add(EntityCondition.makeCondition('productFeatureTypeId', EntityOperator.EQUALS, parameters.productFeatureTypeId))
    }
    if (parameters.featureDescription) {
        searchConds.add(EntityCondition.makeCondition(
            EntityFunction.upperField('featureDescription'),
            EntityOperator.LIKE,
            '%' + parameters.featureDescription.toUpperCase() + '%'
        ))
    }
    if (parameters.minPrice != null) {
        searchConds.add(EntityCondition.makeCondition('price', EntityOperator.GREATER_THAN_EQUAL_TO, parameters.minPrice))
    }
    if (parameters.maxPrice != null) {
        searchConds.add(EntityCondition.makeCondition('price', EntityOperator.LESS_THAN_EQUAL_TO, parameters.maxPrice))
    }

    // 2. Query matching products from FindProductView
    List<GenericValue> searchResults = from('FindProductView').where(searchConds).queryList()

    // Filter by dates in memory
    searchResults = searchResults.findAll { item ->
        // Active price check
        boolean activePrice = true
        if (item.priceFromDate) {
            Timestamp from = item.priceFromDate
            Timestamp thru = item.priceThruDate
            activePrice = from.before(nowTimestamp) && (thru == null || thru.after(nowTimestamp))
        }
        
        // Active price type filter: only LIST_PRICE
        if (item.productPriceTypeId && item.productPriceTypeId != 'LIST_PRICE') {
            activePrice = false
        }
        
        // Active category check
        boolean activeCategory = true
        if (item.categoryFromDate) {
            Timestamp from = item.categoryFromDate
            Timestamp thru = item.categoryThruDate
            activeCategory = from.before(nowTimestamp) && (thru == null || thru.after(nowTimestamp))
        }

        // Active feature check
        boolean activeFeature = true
        if (item.featureFromDate) {
            Timestamp from = item.featureFromDate
            Timestamp thru = item.featureThruDate
            activeFeature = from.before(nowTimestamp) && (thru == null || thru.after(nowTimestamp))
        }

        return activePrice && activeCategory && activeFeature
    }

    // 3. De-duplicate by productId and aggregate category names and features
    Map uniqueProducts = [:]
    for (GenericValue item : searchResults) {
        String productId = item.productId
        if (!uniqueProducts.containsKey(productId)) {
            uniqueProducts[productId] = [
                productId: item.productId,
                productName: item.productName ?: '',
                internalName: item.internalName ?: '',
                price: item.price ?: null,
                categories: [] as Set,
                features: [] as Set
            ]
        }
        Map prodData = uniqueProducts[productId]
        if (item.categoryName) {
            prodData.categories.add(item.categoryName)
        }
        if (item.featureDescription) {
            prodData.features.add(item.featureDescription)
        }
    }

    // Convert sets to lists for easy rendering
    List productList = uniqueProducts.values().collect { prod ->
        [
            productId: prod.productId,
            productName: prod.productName,
            internalName: prod.internalName,
            price: prod.price,
            categories: prod.categories.toList(),
            features: prod.features.toList()
        ]
    }

    resultMap.productList = productList
    return resultMap
}

/**
 * Create a new product.
 */
Map createProduct() {
    Map resultMap = success()

    // 1. Check if product already exists using the findProduct service
    Map findResult = run service: 'findProduct', with: [productName: parameters.productName]
    boolean exists = false
    if (findResult.productList) {
        exists = findResult.productList.any { it.productName.equalsIgnoreCase(parameters.productName) }
    }
    if (exists) {
        return error("Product with name [${parameters.productName}] already exists.")
    }

    // 2. Create the base Product
    String productId = delegator.getNextSeqId("Product")
    GenericValue newProduct = delegator.makeValue("Product", [
        productId: productId,
        productName: parameters.productName,
        internalName: parameters.productName,
        productTypeId: "FINISHED_GOOD",
        isVirtual: "N",
        isVariant: "N"
    ])
    newProduct.create()

    // 3. Associate product to the specified category
    GenericValue pcm = delegator.makeValue("ProductCategoryMember", [
        productId: productId,
        productCategoryId: parameters.productCategoryId,
        fromDate: UtilDateTime.nowTimestamp()
    ])
    pcm.create()

    // 4. Create the product price (LIST_PRICE)
    GenericValue pp = delegator.makeValue("ProductPrice", [
        productId: productId,
        productPriceTypeId: "LIST_PRICE",
        productPricePurposeId: "PURCHASE",
        currencyUomId: "USD",
        productStoreGroupId: "_NA_",
        fromDate: UtilDateTime.nowTimestamp(),
        price: parameters.price
    ])
    pp.create()

    resultMap.productId = productId
    return resultMap
}

/**
 * Update product price and feature associations.
 */
Map updateProduct() {
    Map resultMap = success()
    String productId = parameters.productId

    // 1. Ensure product exists
    GenericValue product = from("Product").where(productId: productId).queryOne()
    if (!product) {
        return error("Product with ID [${productId}] does not exist.")
    }

    // 2. Update price if provided
    if (parameters.price != null) {
        // Find existing active LIST_PRICE price
        GenericValue productPrice = from("ProductPrice")
            .where(productId: productId, productPriceTypeId: "LIST_PRICE", productPricePurposeId: "PURCHASE", currencyUomId: "USD", productStoreGroupId: "_NA_")
            .filterByDate()
            .queryFirst()
        if (productPrice) {
            productPrice.price = parameters.price
            productPrice.store()
        } else {
            GenericValue newPrice = delegator.makeValue("ProductPrice", [
                productId: productId,
                productPriceTypeId: "LIST_PRICE",
                productPricePurposeId: "PURCHASE",
                currencyUomId: "USD",
                productStoreGroupId: "_NA_",
                fromDate: UtilDateTime.nowTimestamp(),
                price: parameters.price
            ])
            newPrice.create()
        }
    }

    // 3. Update features (add feature mapping if provided)
    if (parameters.productFeatureId) {
        // Verify feature exists
        GenericValue feature = from("ProductFeature").where(productFeatureId: parameters.productFeatureId).queryOne()
        if (!feature) {
            return error("Product Feature with ID [${parameters.productFeatureId}] does not exist.")
        }

        // Check if already applied
        GenericValue pfa = from("ProductFeatureAppl")
            .where(productId: productId, productFeatureId: parameters.productFeatureId)
            .filterByDate()
            .queryFirst()
        if (!pfa) {
            GenericValue newPfa = delegator.makeValue("ProductFeatureAppl", [
                productId: productId,
                productFeatureId: parameters.productFeatureId,
                productFeatureApplTypeId: "STANDARD_FEATURE",
                fromDate: UtilDateTime.nowTimestamp()
            ])
            newPfa.create()
        }
    }

    resultMap.productIdOut = productId
    return resultMap
}

/**
 * Establish a virtual-variant relationship between two products.
 */
Map assocProductToVirtual() {
    Map resultMap = success()
    String productId = parameters.productId
    String virtualProductId = parameters.virtualProductId

    // 1. Ensure both products exist
    GenericValue variantProduct = from("Product").where(productId: productId).queryOne()
    if (!variantProduct) {
        return error("Variant Product with ID [${productId}] does not exist.")
    }
    GenericValue virtualProduct = from("Product").where(productId: virtualProductId).queryOne()
    if (!virtualProduct) {
        return error("Virtual Product with ID [${virtualProductId}] does not exist.")
    }

    // Set flags on products to represent virtual-variant status
    virtualProduct.isVirtual = "Y"
    virtualProduct.store()

    variantProduct.isVariant = "Y"
    variantProduct.store()

    // 2. Establish relationship using ProductAssoc if it doesn't already exist
    Timestamp fromDate = UtilDateTime.nowTimestamp()
    GenericValue assoc = from("ProductAssoc")
        .where(productId: virtualProductId, productIdTo: productId, productAssocTypeId: "PRODUCT_VARIANT")
        .filterByDate()
        .queryFirst()
    if (!assoc) {
        GenericValue newAssoc = delegator.makeValue("ProductAssoc", [
            productId: virtualProductId,
            productIdTo: productId,
            productAssocTypeId: "PRODUCT_VARIANT",
            fromDate: fromDate,
            quantity: BigDecimal.ONE
        ])
        newAssoc.create()
        resultMap.fromDate = fromDate
    } else {
        resultMap.fromDate = assoc.fromDate
    }

    return resultMap
}

/**
 * Modify an existing variant relationship.
 */
Map updateProductVariant() {
    Map resultMap = success()
    String productId = parameters.productId
    String virtualProductId = parameters.virtualProductId

    // Find active relationship
    GenericValue assoc = from("ProductAssoc")
        .where(productId: virtualProductId, productIdTo: productId, productAssocTypeId: "PRODUCT_VARIANT")
        .filterByDate()
        .queryFirst()

    if (!assoc) {
        return error("Variant relationship between Virtual Product [${virtualProductId}] and Variant Product [${productId}] does not exist.")
    }

    if (parameters.thruDate) {
        assoc.thruDate = parameters.thruDate
    }
    if (parameters.sequenceNum != null) {
        assoc.sequenceNum = parameters.sequenceNum
    }
    if (parameters.quantity != null) {
        assoc.quantity = parameters.quantity
    }

    assoc.store()
    return resultMap
}

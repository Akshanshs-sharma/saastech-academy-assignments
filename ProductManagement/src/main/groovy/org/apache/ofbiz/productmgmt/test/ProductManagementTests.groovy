package org.apache.ofbiz.productmgmt.test

import org.apache.ofbiz.entity.GenericValue
import org.apache.ofbiz.service.ServiceUtil
import org.apache.ofbiz.service.testtools.OFBizTestCase
import java.math.BigDecimal
import java.sql.Timestamp

class ProductManagementTests extends OFBizTestCase {

    ProductManagementTests(String name) {
        super(name)
    }

    void testProductLifecycleAndRelationships() {
        String testProductName = "Test Product " + System.currentTimeMillis()
        String categoryId = "PM_CAT_APPAREL"
        BigDecimal initialPrice = new BigDecimal("29.99")

        // 1. Test Create Product
        Map createCtx = [
            productName: testProductName,
            productCategoryId: categoryId,
            price: initialPrice,
            userLogin: userLogin
        ]
        Map createResult = dispatcher.runSync("createProduct", createCtx)
        assert ServiceUtil.isSuccess(createResult)
        String productId = createResult.productId
        assert productId != null

        // Verify database records
        GenericValue product = from("Product").where("productId", productId).queryOne()
        assert product != null
        assert product.productName == testProductName

        GenericValue categoryMember = from("ProductCategoryMember")
            .where("productId", productId, "productCategoryId", categoryId)
            .queryFirst()
        assert categoryMember != null

        GenericValue productPrice = from("ProductPrice")
            .where("productId", productId, "productPriceTypeId", "LIST_PRICE")
            .queryFirst()
        assert productPrice != null
        assert productPrice.price.compareTo(initialPrice) == 0

        // 2. Test Duplicate Name Check
        Map dupResult = dispatcher.runSync("createProduct", createCtx)
        assert ServiceUtil.isError(dupResult)

        // 3. Test Find Product Service
        Map findCtx = [
            productName: testProductName,
            userLogin: userLogin
        ]
        Map findResult = dispatcher.runSync("findProduct", findCtx)
        assert ServiceUtil.isSuccess(findResult)
        List products = findResult.productList
        assert products != null && products.size() == 1
        assert products[0].productId == productId

        // 4. Test Update Product (Price and Features)
        BigDecimal updatedPrice = new BigDecimal("34.99")
        String featureId = "PM_FEAT_RED" // from demo data

        Map updateCtx = [
            productId: productId,
            price: updatedPrice,
            productFeatureId: featureId,
            userLogin: userLogin
        ]
        Map updateResult = dispatcher.runSync("updateProduct", updateCtx)
        assert ServiceUtil.isSuccess(updateResult)

        // Verify updated price and feature
        GenericValue updatedPriceVal = from("ProductPrice")
            .where("productId", productId, "productPriceTypeId", "LIST_PRICE")
            .filterByDate()
            .queryFirst()
        assert updatedPriceVal != null
        assert updatedPriceVal.price.compareTo(updatedPrice) == 0

        GenericValue featureAppl = from("ProductFeatureAppl")
            .where("productId", productId, "productFeatureId", featureId)
            .filterByDate()
            .queryFirst()
        assert featureAppl != null

        // 5. Test Associate Variant to Virtual
        // First create a virtual product
        String virtualProductName = "Test Virtual Product " + System.currentTimeMillis()
        Map createVirtualCtx = [
            productName: virtualProductName,
            productCategoryId: categoryId,
            price: new BigDecimal("49.99"),
            userLogin: userLogin
        ]
        Map createVirtualResult = dispatcher.runSync("createProduct", createVirtualCtx)
        assert ServiceUtil.isSuccess(createVirtualResult)
        String virtualProductId = createVirtualResult.productId

        // Link variant (productId) to virtual (virtualProductId)
        Map assocCtx = [
            productId: productId,
            virtualProductId: virtualProductId,
            userLogin: userLogin
        ]
        Map assocResult = dispatcher.runSync("assocProductToVirtual", assocCtx)
        assert ServiceUtil.isSuccess(assocResult)
        Timestamp fromDate = assocResult.fromDate
        assert fromDate != null

        // Verify association exists
        GenericValue productAssoc = from("ProductAssoc")
            .where("productId", virtualProductId, "productIdTo", productId, "productAssocTypeId", "PRODUCT_VARIANT")
            .queryFirst()
        assert productAssoc != null
        assert productAssoc.fromDate == fromDate

        // Verify isVirtual and isVariant flags are updated
        GenericValue updatedVirtual = from("Product").where("productId", virtualProductId).queryOne()
        assert updatedVirtual.isVirtual == "Y"
        GenericValue updatedVariant = from("Product").where("productId", productId).queryOne()
        assert updatedVariant.isVariant == "Y"

        // 6. Test Update Product Variant Relationship
        Map updateVariantCtx = [
            productId: productId,
            virtualProductId: virtualProductId,
            sequenceNum: 10L,
            quantity: new BigDecimal("2.500000"),
            userLogin: userLogin
        ]
        Map updateVariantResult = dispatcher.runSync("updateProductVariant", updateVariantCtx)
        assert ServiceUtil.isSuccess(updateVariantResult)

        // Verify updated relationship values
        GenericValue updatedAssoc = from("ProductAssoc")
            .where("productId", virtualProductId, "productIdTo", productId, "productAssocTypeId", "PRODUCT_VARIANT")
            .queryFirst()
        assert updatedAssoc != null
        assert updatedAssoc.sequenceNum == 10L
        assert updatedAssoc.quantity.compareTo(new BigDecimal("2.500000")) == 0
    }
}

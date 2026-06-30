import org.apache.ofbiz.service.ServiceUtil
import java.math.BigDecimal

// Fetch categories and features for selection lists
context.categoriesList = from("ProductCategory").queryList() ?: []
context.featuresList = from("ProductFeature").queryList() ?: []

Map serviceCtx = [:]
if (parameters.productId) serviceCtx.productId = parameters.productId
if (parameters.productName) serviceCtx.productName = parameters.productName
if (parameters.productCategoryId) serviceCtx.productCategoryId = parameters.productCategoryId
if (parameters.productFeatureId) serviceCtx.productFeatureId = parameters.productFeatureId
if (parameters.productFeatureTypeId) serviceCtx.productFeatureTypeId = parameters.productFeatureTypeId
if (parameters.featureDescription) serviceCtx.featureDescription = parameters.featureDescription

if (parameters.minPrice) {
    try {
        serviceCtx.minPrice = new BigDecimal(parameters.minPrice)
    } catch (NumberFormatException e) {
        // Ignore
    }
}
if (parameters.maxPrice) {
    try {
        serviceCtx.maxPrice = new BigDecimal(parameters.maxPrice)
    } catch (NumberFormatException e) {
        // Ignore
    }
}

// Execute findProduct service
Map findResult = run service: 'findProduct', with: serviceCtx
context.productList = findResult.productList ?: []

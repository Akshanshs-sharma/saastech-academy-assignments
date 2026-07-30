# **Shopify → HotWax Commerce Field Mapping**

*Query: GetUnifiedOrderDetails  |  Source: OrderUnifiedMegaQuery.ftl*

## **1\. Order (root)**

| Shopify Field (leaf) | Shopify Path (dotted) | HotWax Entity / Table | HotWax Field | Description |
| :---- | :---- | :---- | :---- | :---- |
| legacyResourceId | order.legacyResourceId | OrderHeader | externalId | Shopify internal order ID (integer) |
| id | order.id | OrderHeader | shopifyOrderId | Shopify GraphQL Order ID (gid://shopify/Order/...) |
| number | order.number | OrderHeader | orderName | User-facing order number (e.g. \#1001) |
| name | order.name | OrderHeader | orderId | Full order name/reference used as HotWax Order ID |
| tags | order.tags | OrderAttribute | attrValue | Stored with attrName='SHOPIFY\_TAGS', comma-separated |
| sourceName | order.sourceName | OrderHeader | salesChannelEnumId | Mapped to sales channel (e.g., POS, Web, Mobile) |
| currencyCode | order.currencyCode | OrderHeader | currencyUomId | Order currency (e.g., USD, CAD) |
| presentmentCurrencyCode | order.presentmentCurrencyCode | OrderHeader | currencyUomId | Same as currencyCode if not multi-currency |
| email | order.email | PartyContactMech / TelecomNumber | emailAddress | Customer email linked to Party |
| phone | order.phone | PartyContactMech / TelecomNumber | contactNumber | Customer phone linked to Party |
| customerLocale | order.customerLocale | Party | locale | Locale of the customer |
| displayFulfillmentStatus | order.displayFulfillmentStatus | OrderHeader | statusId | Mapped to HotWax status (e.g., ORDER\_COMPLETED) |
| statusPageUrl | order.statusPageUrl | OrderAttribute | attrValue | Stored as attrName='STATUS\_PAGE\_URL' |
| createdAt | order.createdAt | OrderHeader | orderDate | Timestamp when order was created |
| cancelledAt | order.cancelledAt | OrderHeader | statusId | Updates order status to ORDER\_CANCELLED if present |
| closedAt | order.closedAt | OrderHeader | statusId | Updates order status if fully closed/archived |
| updatedAt | order.updatedAt | OrderHeader | lastUpdatedTxStamp | Last updated timestamp |
| note | order.note | OrderNote | noteInfo | Customer or staff notes added to order |
| discountCodes | order.discountCodes | OrderAdjustment | description | Stores the applied discount codes |

## **2\. order.currentTotalPriceSet**

| Shopify Field (leaf) | Shopify Path (dotted) | HotWax Entity / Table | HotWax Field | Description |
| :---- | :---- | :---- | :---- | :---- |
| shopMoney.amount | order.currentTotalPriceSet.shopMoney.amount | OrderHeader | grandTotal | Current total after discounts/returns |
| shopMoney.currencyCode | order.currentTotalPriceSet.shopMoney.currencyCode | OrderHeader | currencyUomId | Currency for the grandTotal |
| presentmentMoney.amount | order.currentTotalPriceSet.presentmentMoney.amount | OrderHeader | grandTotal | Presentment total amount |
| presentmentMoney.currencyCode | order.currentTotalPriceSet.presentmentMoney.currencyCode | OrderHeader | currencyUomId | Presentment currency |

## **3\. order.totalPriceSet**

| Shopify Field (leaf) | Shopify Path (dotted) | HotWax Entity / Table | HotWax Field | Description |
| :---- | :---- | :---- | :---- | :---- |
| shopMoney.amount | order.totalPriceSet.shopMoney.amount | OrderHeader | grandTotal | Original total order amount |
| shopMoney.currencyCode | order.totalPriceSet.shopMoney.currencyCode | OrderHeader | currencyUomId | Original currency |
| presentmentMoney.amount | order.totalPriceSet.presentmentMoney.amount | OrderHeader | grandTotal | Original presentment total |
| presentmentMoney.currencyCode | order.totalPriceSet.presentmentMoney.currencyCode | OrderHeader | currencyUomId | Original presentment currency |

## **4\. order.shippingAddress**

| Shopify Field (leaf) | Shopify Path (dotted) | HotWax Entity / Table | HotWax Field | Description |
| :---- | :---- | :---- | :---- | :---- |
| name | order.shippingAddress.name | PostalAddress | toName | Full name for shipping |
| address1 | order.shippingAddress.address1 | PostalAddress | address1 | Street address line 1 |
| address2 | order.shippingAddress.address2 | PostalAddress | address2 | Street address line 2 / apartment |
| city | order.shippingAddress.city | PostalAddress | city | City name |
| country | order.shippingAddress.country | PostalAddress | countryGeoId | Country name or ISO code |
| zip | order.shippingAddress.zip | PostalAddress | postalCode | Postal / ZIP code |
| provinceCode | order.shippingAddress.provinceCode | PostalAddress | stateProvinceGeoId | State or province code |
| countryCodeV2 | order.shippingAddress.countryCodeV2 | PostalAddress | countryGeoId | ISO 3166-1 alpha-2 country code |
| latitude | order.shippingAddress.latitude | PostalAddress | latitude | Geo latitude if needed |
| longitude | order.shippingAddress.longitude | PostalAddress | longitude | Geo longitude if needed |
| phone | order.shippingAddress.phone | TelecomNumber | contactNumber | Shipping contact phone number |

## **5\. order.billingAddress**

| Shopify Field (leaf) | Shopify Path (dotted) | HotWax Entity / Table | HotWax Field | Description |
| :---- | :---- | :---- | :---- | :---- |
| name | order.billingAddress.name | PostalAddress | toName | Full name for billing |
| address1 | order.billingAddress.address1 | PostalAddress | address1 | Billing address line 1 |
| address2 | order.billingAddress.address2 | PostalAddress | address2 | Billing address line 2 |
| city | order.billingAddress.city | PostalAddress | city | Billing city |
| country | order.billingAddress.country | PostalAddress | countryGeoId | Billing country |
| zip | order.billingAddress.zip | PostalAddress | postalCode | Billing postal code |
| provinceCode | order.billingAddress.provinceCode | PostalAddress | stateProvinceGeoId | Billing province code |
| countryCodeV2 | order.billingAddress.countryCodeV2 | PostalAddress | countryGeoId | Billing country ISO code |
| latitude | order.billingAddress.latitude | PostalAddress | latitude | Billing geo latitude |
| longitude | order.billingAddress.longitude | PostalAddress | longitude | Billing geo longitude |
| phone | order.billingAddress.phone | TelecomNumber | contactNumber | Billing contact phone number |

## **6\. order.retailLocation**

| Shopify Field (leaf) | Shopify Path (dotted) | HotWax Entity / Table | HotWax Field | Description |
| :---- | :---- | :---- | :---- | :---- |
| id | order.retailLocation.id | OrderHeader | originFacilityId | POS retail location Shopify gid |
| legacyResourceId | order.retailLocation.legacyResourceId | Facility | externalId | Legacy location ID mapped to HotWax Facility |

## **7\. order.customer**

| Shopify Field (leaf) | Shopify Path (dotted) | HotWax Entity / Table | HotWax Field | Description |
| :---- | :---- | :---- | :---- | :---- |
| legacyResourceId | order.customer.legacyResourceId | Party | externalId | Shopify legacy customer ID |
| id | order.customer.id | Party | partyId | Shopify customer gid linked to Party |
| firstName | order.customer.firstName | Person | firstName | Customer first name |
| lastName | order.customer.lastName | Person | lastName | Customer last name |
| defaultEmailAddress.emailAddress | order.customer.defaultEmailAddress.emailAddress | ContactMech | infoString | Default customer email address |
| defaultPhoneNumber.phoneNumber | order.customer.defaultPhoneNumber.phoneNumber | TelecomNumber | contactNumber | Default customer phone number |

## **8\. order.customAttributes**

| Shopify Field (leaf) | Shopify Path (dotted) | HotWax Entity / Table | HotWax Field | Description |
| :---- | :---- | :---- | :---- | :---- |
| key | order.customAttributes.key | OrderAttribute | attrName | Custom attribute key |
| value | order.customAttributes.value | OrderAttribute | attrValue | Custom attribute value |

## **9\. order.discountApplications**

| Shopify Field (leaf) | Shopify Path (dotted) | HotWax Entity / Table | HotWax Field | Description |
| :---- | :---- | :---- | :---- | :---- |
| \_\_typename | order.discountApplications.\_\_typename | OrderAdjustment | orderAdjustmentTypeId | Type of discount (e.g., PROMOTION\_ADJUSTMENT) |
| code (DiscountCodeApplication) | order.discountApplications.code | OrderAdjustment | description | Discount code applied (DiscountCodeApplication) |
| index (DiscountCodeApplication) | order.discountApplications.index | OrderAdjustment | orderItemSeqId | Index of the discount application |
| title (AutomaticDiscountApplication) | order.discountApplications.title | OrderAdjustment | description | Title of the discount (Automatic/Manual) |
| index (AutomaticDiscountApplication) | order.discountApplications.index | OrderAdjustment | orderItemSeqId | Index of the discount application |
| index (ManualDiscountApplication) | order.discountApplications.index | OrderAdjustment | orderItemSeqId | Index of the discount application |
| description (ManualDiscountApplication) | order.discountApplications.description | OrderAdjustment | comments | Description of manual discount |
| title (ManualDiscountApplication) | order.discountApplications.title | OrderAdjustment | description | Title of the discount (Automatic/Manual) |

## **10\. order.fulfillments**

| Shopify Field (leaf) | Shopify Path (dotted) | HotWax Entity / Table | HotWax Field | Description |
| :---- | :---- | :---- | :---- | :---- |
| id | order.fulfillments.id | Shipment | externalId | Shopify fulfillment gid |
| legacyResourceId | order.fulfillments.legacyResourceId | Shipment | externalId | Shopify legacy fulfillment ID |
| updatedAt | order.fulfillments.updatedAt | Shipment | lastUpdatedTxStamp | Last update timestamp on fulfillment |
| location.id | order.fulfillments.location.id | Facility | externalId | Shopify gid of fulfillment location |
| location.legacyResourceId | order.fulfillments.location.legacyResourceId | Facility | externalId | Legacy ID of fulfillment location |
| fulfillmentLineItems.quantity | order.fulfillments.fulfillmentLineItems.quantity | OrderItemShipGrpInvRes | quantity | Quantity fulfilled for this line item |
| fulfillmentLineItems.lineItem.id | order.fulfillments.fulfillmentLineItems.lineItem.id | OrderItem | externalId | Shopify gid of the line item being fulfilled |

## **11\. order.shippingLines**

| Shopify Field (leaf) | Shopify Path (dotted) | HotWax Entity / Table | HotWax Field | Description |
| :---- | :---- | :---- | :---- | :---- |
| title | order.shippingLines.title | OrderAdjustment | description | Shipping method title (e.g. Standard Shipping) |
| code | order.shippingLines.code | OrderAdjustment | orderAdjustmentTypeId | Maps to SHIPPING\_CHARGES |
| originalPriceSet.shopMoney.amount | order.shippingLines.originalPriceSet.shopMoney.amount | OrderAdjustment | amount | Original shipping amount before discounts |
| originalPriceSet.shopMoney.currencyCode | order.shippingLines.originalPriceSet.shopMoney.currencyCode | OrderAdjustment | currencyUomId | Currency for original shipping amount |
| originalPriceSet.presentmentMoney.amount | order.shippingLines.originalPriceSet.presentmentMoney.amount | OrderAdjustment | amount | Presentment original shipping amount |
| originalPriceSet.presentmentMoney.currencyCode | order.shippingLines.originalPriceSet.presentmentMoney.currencyCode | OrderAdjustment | currencyUomId | Presentment shipping currency |
| discountedPriceSet.shopMoney.amount | order.shippingLines.discountedPriceSet.shopMoney.amount | OrderAdjustment | amount | Shipping amount after discount |
| discountedPriceSet.shopMoney.currencyCode | order.shippingLines.discountedPriceSet.shopMoney.currencyCode | OrderAdjustment | currencyUomId | Currency for discounted shipping |
| discountedPriceSet.presentmentMoney.amount | order.shippingLines.discountedPriceSet.presentmentMoney.amount | OrderAdjustment | amount | Presentment discounted shipping amount |
| discountedPriceSet.presentmentMoney.currencyCode | order.shippingLines.discountedPriceSet.presentmentMoney.currencyCode | OrderAdjustment | currencyUomId | Presentment discounted shipping currency |
| taxLines.title | order.shippingLines.taxLines.title | OrderAdjustment | description | Tax line title for shipping tax |
| taxLines.rate | order.shippingLines.taxLines.rate | OrderAdjustment | sourcePercentage | Tax rate applied to shipping |
| taxLines.priceSet.shopMoney.amount | order.shippingLines.taxLines.priceSet.shopMoney.amount | OrderAdjustment | amount | Tax amount on shipping |
| taxLines.priceSet.shopMoney.currencyCode | order.shippingLines.taxLines.priceSet.shopMoney.currencyCode | OrderAdjustment | currencyUomId | Currency of shipping tax |
| taxLines.priceSet.presentmentMoney.amount | order.shippingLines.taxLines.priceSet.presentmentMoney.amount | OrderAdjustment | amount | Presentment tax amount on shipping |
| taxLines.priceSet.presentmentMoney.currencyCode | order.shippingLines.taxLines.priceSet.presentmentMoney.currencyCode | OrderAdjustment | currencyUomId | Presentment tax currency |
| discountAllocations.allocatedAmountSet.shopMoney.amount | order.shippingLines.discountAllocations.allocatedAmountSet.shopMoney.amount | OrderAdjustment | amount | Discount allocated to shipping |
| discountAllocations.allocatedAmountSet.shopMoney.currencyCode | order.shippingLines.discountAllocations.allocatedAmountSet.shopMoney.currencyCode | OrderAdjustment | currencyUomId | Currency of shipping discount allocation |
| discountAllocations.allocatedAmountSet.presentmentMoney.amount | order.shippingLines.discountAllocations.allocatedAmountSet.presentmentMoney.amount | OrderAdjustment | amount | Presentment shipping discount amount |
| discountAllocations.allocatedAmountSet.presentmentMoney.currencyCode | order.shippingLines.discountAllocations.allocatedAmountSet.presentmentMoney.currencyCode | OrderAdjustment | currencyUomId | Presentment shipping discount currency |
| discountAllocations.discountApplication.\_\_typename | order.shippingLines.discountAllocations.discountApplication.\_\_typename | OrderAdjustment | orderAdjustmentTypeId | Type of discount applied to shipping |
| discountAllocations.discountApplication.code | order.shippingLines.discountAllocations.discountApplication.code | OrderAdjustment | description | Discount code applied to shipping |

## **12\. order.lineItems**

| Shopify Field (leaf) | Shopify Path (dotted) | HotWax Entity / Table | HotWax Field | Description |
| :---- | :---- | :---- | :---- | :---- |
| \_\_typename | order.lineItems.\_\_typename | OrderItem | orderItemTypeId | Type of order item |
| id | order.lineItems.id | OrderItem | externalId | Shopify gid of the line item |
| title | order.lineItems.title | OrderItem | itemDescription | Product title on the line item |
| name | order.lineItems.name | OrderItem | itemDescription | Full variant name (product \+ variant title) |
| quantity | order.lineItems.quantity | OrderItem | quantity | Ordered quantity |
| currentQuantity | order.lineItems.currentQuantity | OrderItem | quantity | Current quantity after cancellations/returns |
| unfulfilledQuantity | order.lineItems.unfulfilledQuantity | OrderItem | cancelQuantity | Quantity not yet fulfilled |
| nonFulfillableQuantity | order.lineItems.nonFulfillableQuantity | OrderItem | cancelQuantity | Quantity that cannot be fulfilled |
| requiresShipping | order.lineItems.requiresShipping | OrderItem | isPromo | Whether item needs physical shipment |
| isGiftCard | order.lineItems.isGiftCard | OrderItem | orderItemTypeId | Maps to DIGITAL\_ITEM if true |
| sku | order.lineItems.sku | OrderItem | externalId | SKU used to look up product in HotWax |
| taxable | order.lineItems.taxable | OrderItem | isItemTaxable | Whether tax applies to this item |
| customAttributes.key | order.lineItems.customAttributes.key | OrderItemAttribute | attrName | Custom attribute key on line item |
| customAttributes.value | order.lineItems.customAttributes.value | OrderItemAttribute | attrValue | Custom attribute value on line item |
| originalUnitPriceSet.shopMoney.amount | order.lineItems.originalUnitPriceSet.shopMoney.amount | OrderItem | unitPrice | Original unit price before discounts |
| originalUnitPriceSet.shopMoney.currencyCode | order.lineItems.originalUnitPriceSet.shopMoney.currencyCode | OrderHeader | currencyUomId | Currency of original unit price |
| originalUnitPriceSet.presentmentMoney.amount | order.lineItems.originalUnitPriceSet.presentmentMoney.amount | OrderItem | unitPrice | Presentment original unit price |
| originalUnitPriceSet.presentmentMoney.currencyCode | order.lineItems.originalUnitPriceSet.presentmentMoney.currencyCode | OrderHeader | currencyUomId | Presentment currency of unit price |
| discountedUnitPriceSet.shopMoney.amount | order.lineItems.discountedUnitPriceSet.shopMoney.amount | OrderItem | unitPrice | Unit price after discount |
| discountedUnitPriceSet.shopMoney.currencyCode | order.lineItems.discountedUnitPriceSet.shopMoney.currencyCode | OrderHeader | currencyUomId | Currency of discounted unit price |
| discountedUnitPriceSet.presentmentMoney.amount | order.lineItems.discountedUnitPriceSet.presentmentMoney.amount | OrderItem | unitPrice | Presentment discounted unit price |
| discountedUnitPriceSet.presentmentMoney.currencyCode | order.lineItems.discountedUnitPriceSet.presentmentMoney.currencyCode | OrderHeader | currencyUomId | Presentment currency of discounted unit price |
| taxLines.title | order.lineItems.taxLines.title | OrderAdjustment | description | Tax line title for this item |
| taxLines.rate | order.lineItems.taxLines.rate | OrderAdjustment | sourcePercentage | Tax rate for this line item |
| taxLines.priceSet.shopMoney.amount | order.lineItems.taxLines.priceSet.shopMoney.amount | OrderAdjustment | amount | Tax amount for this line item |
| taxLines.priceSet.shopMoney.currencyCode | order.lineItems.taxLines.priceSet.shopMoney.currencyCode | OrderAdjustment | currencyUomId | Currency of tax amount |
| taxLines.priceSet.presentmentMoney.amount | order.lineItems.taxLines.priceSet.presentmentMoney.amount | OrderAdjustment | amount | Presentment tax amount |
| taxLines.priceSet.presentmentMoney.currencyCode | order.lineItems.taxLines.priceSet.presentmentMoney.currencyCode | OrderAdjustment | currencyUomId | Presentment currency of tax |
| discountAllocations.allocatedAmountSet.shopMoney.amount | order.lineItems.discountAllocations.allocatedAmountSet.shopMoney.amount | OrderAdjustment | amount | Discount allocated to this line item |
| discountAllocations.allocatedAmountSet.shopMoney.currencyCode | order.lineItems.discountAllocations.allocatedAmountSet.shopMoney.currencyCode | OrderAdjustment | currencyUomId | Currency of line item discount |
| discountAllocations.allocatedAmountSet.presentmentMoney.amount | order.lineItems.discountAllocations.allocatedAmountSet.presentmentMoney.amount | OrderAdjustment | amount | Presentment discount amount on item |
| discountAllocations.allocatedAmountSet.presentmentMoney.currencyCode | order.lineItems.discountAllocations.allocatedAmountSet.presentmentMoney.currencyCode | OrderAdjustment | currencyUomId | Presentment currency of item discount |
| discountAllocations.discountApplication.\_\_typename | order.lineItems.discountAllocations.discountApplication.\_\_typename | OrderAdjustment | orderAdjustmentTypeId | Discount type on line item |
| discountAllocations.discountApplication.code (DiscountCode) | order.lineItems.discountAllocations.discountApplication.code | OrderAdjustment | description | Discount code on line item (DiscountCode type) |
| discountAllocations.discountApplication.index (DiscountCode) | order.lineItems.discountAllocations.discountApplication.index | OrderAdjustment | orderItemSeqId | Discount application index |
| discountAllocations.discountApplication.title (Automatic) | order.lineItems.discountAllocations.discountApplication.title | OrderAdjustment | description | Discount title (Automatic/Manual type) |
| discountAllocations.discountApplication.index (Automatic) | order.lineItems.discountAllocations.discountApplication.index | OrderAdjustment | orderItemSeqId | Discount application index |
| discountAllocations.discountApplication.index (Manual) | order.lineItems.discountAllocations.discountApplication.index | OrderAdjustment | orderItemSeqId | Discount application index |
| discountAllocations.discountApplication.description (Manual) | order.lineItems.discountAllocations.discountApplication.description | OrderAdjustment | comments | Manual discount description on line item |
| discountAllocations.discountApplication.title (Manual) | order.lineItems.discountAllocations.discountApplication.title | OrderAdjustment | description | Discount title (Automatic/Manual type) |
| variant.legacyResourceId | order.lineItems.variant.legacyResourceId | Product | productId | Shopify legacy variant ID used to match HotWax product |
| variant.id | order.lineItems.variant.id | Product | externalId | Shopify variant gid |
| variant.title | order.lineItems.variant.title | Product | productName | Variant title (e.g. Red / Large) |
| variant.sku | order.lineItems.variant.sku | Product | internalName | Variant SKU |
| variant.barcode | order.lineItems.variant.barcode | GoodIdentification | idValue | Barcode stored with UPCA or similar type |
| fulfillmentService.serviceName | order.lineItems.fulfillmentService.serviceName | OrderItem | externalFulfillmentOrderId | Name of the fulfillment service handling this item |

## **13\. order.transactions**

| Shopify Field (leaf) | Shopify Path (dotted) | HotWax Entity / Table | HotWax Field | Description |
| :---- | :---- | :---- | :---- | :---- |
| id | order.transactions.id | PaymentGatewayResponse | referenceNum | Shopify transaction ID |
| kind | order.transactions.kind | PaymentGatewayResponse | transactionCode | Transaction kind (SALE, REFUND, AUTHORIZATION, etc.) |
| status | order.transactions.status | PaymentGatewayResponse | resultCode | Transaction status (SUCCESS, FAILURE, PENDING) |
| gateway | order.transactions.gateway | PaymentGatewayResponse | paymentServiceTypeEnumId | Payment gateway name (e.g. shopify\_payments, paypal) |
| paymentDetails.company (CardPaymentDetails) | order.transactions.paymentDetails.company | PaymentGatewayResponse | gatewayMessage | Card brand (Visa, Mastercard) from CardPaymentDetails |
| amountSet.shopMoney.amount | order.transactions.amountSet.shopMoney.amount | OrderPaymentPreference | maxAmount | Transaction amount in shop currency |
| amountSet.shopMoney.currencyCode | order.transactions.amountSet.shopMoney.currencyCode | OrderPaymentPreference | currencyUomId | Currency of transaction |
| amountSet.presentmentMoney.amount | order.transactions.amountSet.presentmentMoney.amount | OrderPaymentPreference | maxAmount | Transaction amount in presentment currency |
| amountSet.presentmentMoney.currencyCode | order.transactions.amountSet.presentmentMoney.currencyCode | OrderPaymentPreference | currencyUomId | Presentment currency of transaction |
| receiptJson | order.transactions.receiptJson | PaymentGatewayResponse | responseCode | Raw JSON receipt from gateway |
| settlementCurrency | order.transactions.settlementCurrency | PaymentGatewayResponse | currencyUomId | Currency in which payment settled |
| parentTransaction.id | order.transactions.parentTransaction.id | PaymentGatewayResponse | referenceNum | Parent transaction ID (e.g. auth for a capture) |
| parentTransaction.paymentDetails.company | order.transactions.parentTransaction.paymentDetails.company | PaymentGatewayResponse | gatewayMessage | Card brand from parent transaction |
| processedAt | order.transactions.processedAt | PaymentGatewayResponse | transactionDate | Timestamp when transaction was processed |

## **14\. order.refundAgreements (agreements)**

| Shopify Field (leaf) | Shopify Path (dotted) | HotWax Entity / Table | HotWax Field | Description |
| :---- | :---- | :---- | :---- | :---- |
| \_\_typename | order.refundAgreements.\_\_typename | ReturnHeader | returnHeaderTypeId | Type of agreement (RefundAgreement) |
| id (RefundAgreement) | order.refundAgreements.id | ReturnHeader | externalId | Shopify refund agreement ID |
| app.id | order.refundAgreements.app.id | ReturnHeader | createdByUserLoginId | App gid that initiated the refund |
| app.title | order.refundAgreements.app.title | ReturnHeader | createdByUserLoginId | App name that initiated the refund |
| refund.id | order.refundAgreements.refund.id | ReturnHeader | returnId | Associated refund ID |

## **15\. order.refunds**

| Shopify Field (leaf) | Shopify Path (dotted) | HotWax Entity / Table | HotWax Field | Description |
| :---- | :---- | :---- | :---- | :---- |
| id | order.refunds.id | ReturnHeader | externalId | Shopify refund gid |
| legacyResourceId | order.refunds.legacyResourceId | ReturnHeader | externalId | Shopify legacy integer refund ID |
| note | order.refunds.note | ReturnHeader | description | Staff note on the refund |
| createdAt | order.refunds.createdAt | ReturnHeader | entryDate | Timestamp when refund was created |
| updatedAt | order.refunds.updatedAt | ReturnHeader | lastUpdatedTxStamp | Timestamp of last update to refund |
| totalRefundedSet.shopMoney.amount | order.refunds.totalRefundedSet.shopMoney.amount | ReturnHeader | needsInventoryReceive | Total amount refunded in shop currency |
| totalRefundedSet.shopMoney.currencyCode | order.refunds.totalRefundedSet.shopMoney.currencyCode | ReturnHeader | currencyUomId | Currency of total refunded amount |

## **15a. order.refunds.refundLineItems**

| Shopify Field (leaf) | Shopify Path (dotted) | HotWax Entity / Table | HotWax Field | Description |
| :---- | :---- | :---- | :---- | :---- |
| id | order.refunds.refundLineItems.id | ReturnItem | externalId | Shopify refund line item ID |
| lineItem.id | order.refunds.refundLineItems.lineItem.id | ReturnItem | orderItemSeqId | Shopify gid of the original line item being refunded |
| lineItem.sku | order.refunds.refundLineItems.lineItem.sku | ReturnItem | externalId | SKU of the refunded item |
| lineItem.isGiftCard | order.refunds.refundLineItems.lineItem.isGiftCard | ReturnItem | returnItemTypeId | Whether the refunded item was a gift card |
| lineItem.quantity | order.refunds.refundLineItems.lineItem.quantity | ReturnItem | returnQuantity | Original ordered quantity of refunded item |
| lineItem.unfulfilledQuantity | order.refunds.refundLineItems.lineItem.unfulfilledQuantity | ReturnItem | returnQuantity | Unfulfilled quantity at time of refund |
| lineItem.variant.id | order.refunds.refundLineItems.lineItem.variant.id | ReturnItem | externalId | Variant gid of the refunded product |
| lineItem.discountAllocations.allocatedAmountSet.shopMoney.amount | order.refunds.refundLineItems.lineItem.discountAllocations.allocatedAmountSet.shopMoney.amount | ReturnAdjustment | amount | Discount amount allocated to the refunded line item |
| taxLines.priceSet.shopMoney.amount | order.refunds.refundLineItems.taxLines.priceSet.shopMoney.amount | ReturnAdjustment | amount | Tax amount refunded on this line |
| taxLines.rate | order.refunds.refundLineItems.taxLines.rate | ReturnAdjustment | amount | Tax rate on the refunded line item |
| taxLines.title | order.refunds.refundLineItems.taxLines.title | ReturnAdjustment | description | Tax name on the refunded line item |
| location.id | order.refunds.refundLineItems.location.id | Facility | externalId | Shopify gid of the return destination facility |
| location.legacyResourceId | order.refunds.refundLineItems.location.legacyResourceId | Facility | externalId | Legacy ID of return destination facility |
| priceSet.shopMoney.amount | order.refunds.refundLineItems.priceSet.shopMoney.amount | ReturnItem | returnPrice | Price of item being refunded |
| restockType | order.refunds.refundLineItems.restockType | ReturnItem | returnItemResponse | How item is restocked (RETURN, NO\_RESTOCK, CANCEL) |
| quantity | order.refunds.refundLineItems.quantity | ReturnItem | returnQuantity | Quantity of items being refunded |
| subtotalSet.shopMoney.amount | order.refunds.refundLineItems.subtotalSet.shopMoney.amount | ReturnItem | returnPrice | Subtotal refunded for this line (qty \* price) |
| totalTaxSet.shopMoney.amount | order.refunds.refundLineItems.totalTaxSet.shopMoney.amount | ReturnAdjustment | amount | Total tax refunded for this line item |

## **15b. order.refunds.refundShippingLines**

| Shopify Field (leaf) | Shopify Path (dotted) | HotWax Entity / Table | HotWax Field | Description |
| :---- | :---- | :---- | :---- | :---- |
| id | order.refunds.refundShippingLines.id | ReturnAdjustment | returnAdjustmentTypeId | ID of the refunded shipping line |
| subtotalAmountSet.shopMoney.amount | order.refunds.refundShippingLines.subtotalAmountSet.shopMoney.amount | ReturnAdjustment | amount | Subtotal of shipping amount being refunded |
| taxAmountSet.shopMoney.amount | order.refunds.refundShippingLines.taxAmountSet.shopMoney.amount | ReturnAdjustment | amount | Tax on shipping being refunded |

## **15c. order.refunds.transactions**

| Shopify Field (leaf) | Shopify Path (dotted) | HotWax Entity / Table | HotWax Field | Description |
| :---- | :---- | :---- | :---- | :---- |
| id | order.refunds.transactions.id | PaymentGatewayResponse | referenceNum | Shopify refund transaction ID |
| parentTransaction.id | order.refunds.transactions.parentTransaction.id | PaymentGatewayResponse | referenceNum | ID of the original charge transaction |
| status | order.refunds.transactions.status | PaymentGatewayResponse | resultCode | Status of refund transaction |
| amountSet.shopMoney.amount | order.refunds.transactions.amountSet.shopMoney.amount | PaymentGatewayResponse | amount | Amount refunded in shop currency |
| amountSet.presentmentMoney.amount | order.refunds.transactions.amountSet.presentmentMoney.amount | PaymentGatewayResponse | amount | Amount refunded in presentment currency |
| amountSet.presentmentMoney.currencyCode | order.refunds.transactions.amountSet.presentmentMoney.currencyCode | PaymentGatewayResponse | currencyUomId | Presentment currency of refund |
| kind | order.refunds.transactions.kind | PaymentGatewayResponse | transactionCode | Transaction kind (REFUND) |
| gateway | order.refunds.transactions.gateway | PaymentGatewayResponse | paymentServiceTypeEnumId | Gateway that processed the refund |
| paymentDetails.company (CardPaymentDetails) | order.refunds.transactions.paymentDetails.company | PaymentGatewayResponse | gatewayMessage | Card brand used in refund transaction |
| processedAt | order.refunds.transactions.processedAt | PaymentGatewayResponse | transactionDate | Timestamp when refund transaction was processed |

## **15d. order.refunds.orderAdjustments**

| Shopify Field (leaf) | Shopify Path (dotted) | HotWax Entity / Table | HotWax Field | Description |
| :---- | :---- | :---- | :---- | :---- |
| id | order.refunds.orderAdjustments.id | ReturnAdjustment | returnAdjustmentTypeId | ID of order-level adjustment in the refund |
| reason | order.refunds.orderAdjustments.reason | ReturnAdjustment | description | Reason for the order adjustment (e.g. RESTOCK\_FEE) |
| amountSet.shopMoney.amount | order.refunds.orderAdjustments.amountSet.shopMoney.amount | ReturnAdjustment | amount | Amount of order-level adjustment |

## **15e. order.refunds.return**

| Shopify Field (leaf) | Shopify Path (dotted) | HotWax Entity / Table | HotWax Field | Description |
| :---- | :---- | :---- | :---- | :---- |
| id | order.refunds.return.id | ReturnHeader | externalId | Shopify Return gid linked to this refund |
| createdAt | order.refunds.return.createdAt | ReturnHeader | entryDate | Timestamp when return was created |
| status | order.refunds.return.status | ReturnHeader | statusId | Return status (e.g. RETURN\_REQUESTED, RETURN\_COMPLETED) |

## **15f. order.refunds.return.reverseFulfillmentOrders**

| Shopify Field (leaf) | Shopify Path (dotted) | HotWax Entity / Table | HotWax Field | Description |
| :---- | :---- | :---- | :---- | :---- |
| id | order.refunds.return.reverseFulfillmentOrders.id | Shipment | externalId | Shopify reverse fulfillment order ID (inbound return shipment) |
| lineItems.dispositions.id | order.refunds.return.reverseFulfillmentOrders.lineItems.dispositions.id | ShipmentItem | externalId | ID of the return item disposition |
| lineItems.dispositions.location.legacyResourceId | order.refunds.return.reverseFulfillmentOrders.lineItems.dispositions.location.legacyResourceId | Facility | externalId | Legacy ID of return receiving facility |
| lineItems.dispositions.location.id | order.refunds.return.reverseFulfillmentOrders.lineItems.dispositions.location.id | Facility | externalId | Shopify gid of return receiving facility |

## **15g. order.refunds.return.transactions**

| Shopify Field (leaf) | Shopify Path (dotted) | HotWax Entity / Table | HotWax Field | Description |
| :---- | :---- | :---- | :---- | :---- |
| id | order.refunds.return.transactions.id | PaymentGatewayResponse | referenceNum | Return-level transaction ID |
| kind | order.refunds.return.transactions.kind | PaymentGatewayResponse | transactionCode | Kind of return transaction |
| status | order.refunds.return.transactions.status | PaymentGatewayResponse | resultCode | Status of return transaction |
| processedAt | order.refunds.return.transactions.processedAt | PaymentGatewayResponse | transactionDate | When return transaction was processed |
| amountSet.presentmentMoney.amount | order.refunds.return.transactions.amountSet.presentmentMoney.amount | PaymentGatewayResponse | amount | Return transaction amount in presentment currency |
| amountSet.presentmentMoney.currencyCode | order.refunds.return.transactions.amountSet.presentmentMoney.currencyCode | PaymentGatewayResponse | currencyUomId | Presentment currency of return transaction |
| amountSet.shopMoney.amount | order.refunds.return.transactions.amountSet.shopMoney.amount | PaymentGatewayResponse | amount | Return transaction amount in shop currency |
| amountSet.shopMoney.currencyCode | order.refunds.return.transactions.amountSet.shopMoney.currencyCode | PaymentGatewayResponse | currencyUomId | Shop currency of return transaction |
| gateway | order.refunds.return.transactions.gateway | PaymentGatewayResponse | paymentServiceTypeEnumId | Gateway handling the return transaction |
| paymentDetails.company (CardPaymentDetails) | order.refunds.return.transactions.paymentDetails.company | PaymentGatewayResponse | gatewayMessage | Card brand in return transaction |

## **15h. order.refunds.return.returnLineItems**

| Shopify Field (leaf) | Shopify Path (dotted) | HotWax Entity / Table | HotWax Field | Description |
| :---- | :---- | :---- | :---- | :---- |
| id | order.refunds.return.returnLineItems.id | ReturnItem | externalId | Shopify return line item ID |
| returnReason | order.refunds.return.returnLineItems.returnReason | ReturnItem | returnReasonEnumId | Reason code for return (e.g. SIZE\_TOO\_SMALL) |
| quantity | order.refunds.return.returnLineItems.quantity | ReturnItem | returnQuantity | Quantity being returned |
| returnReasonNote | order.refunds.return.returnLineItems.returnReasonNote | ReturnItem | description | Customer note explaining return reason |
| fulfillmentLineItem.lineItem.id | order.refunds.return.returnLineItems.fulfillmentLineItem.lineItem.id | ReturnItem | orderItemSeqId | Original order line item ID being returned |

## **15i. order.refunds.return.exchangeLineItems**

| Shopify Field (leaf) | Shopify Path (dotted) | HotWax Entity / Table | HotWax Field | Description |
| :---- | :---- | :---- | :---- | :---- |
| id | order.refunds.return.exchangeLineItems.id | OrderItem | externalId | Shopify exchange line item ID |
| quantity | order.refunds.return.exchangeLineItems.quantity | OrderItem | quantity | Total quantity in the exchange group |
| lineItems.id | order.refunds.return.exchangeLineItems.lineItems.id | OrderItem | externalId | ID of the new order item created in exchange |
| lineItems.quantity | order.refunds.return.exchangeLineItems.lineItems.quantity | OrderItem | quantity | Quantity of exchange item ordered |
| lineItems.unfulfilledQuantity | order.refunds.return.exchangeLineItems.lineItems.unfulfilledQuantity | OrderItem | cancelQuantity | Unfulfilled quantity of exchange item |
| lineItems.nonFulfillableQuantity | order.refunds.return.exchangeLineItems.lineItems.nonFulfillableQuantity | OrderItem | cancelQuantity | Non-fulfillable quantity of exchange item |
| lineItems.sku | order.refunds.return.exchangeLineItems.lineItems.sku | Product | internalName | SKU of exchange product |
| lineItems.variant.id | order.refunds.return.exchangeLineItems.lineItems.variant.id | Product | externalId | Variant gid of exchange product |
| lineItems.variant.sku | order.refunds.return.exchangeLineItems.lineItems.variant.sku | Product | internalName | Variant SKU of exchange product |
| lineItems.variantTitle | order.refunds.return.exchangeLineItems.lineItems.variantTitle | Product | productName | Variant title of exchange product |
| lineItems.isGiftCard | order.refunds.return.exchangeLineItems.lineItems.isGiftCard | OrderItem | orderItemTypeId | Whether exchange item is a gift card |
| lineItems.product.id | order.refunds.return.exchangeLineItems.lineItems.product.id | Product | externalId | Shopify product gid of exchange item |
| lineItems.product.legacyResourceId | order.refunds.return.exchangeLineItems.lineItems.product.legacyResourceId | Product | productId | Legacy product ID of exchange item |
| lineItems.product.title | order.refunds.return.exchangeLineItems.lineItems.product.title | Product | productName | Product title of exchange item |
| lineItems.originalUnitPriceSet.presentmentMoney.amount | order.refunds.return.exchangeLineItems.lineItems.originalUnitPriceSet.presentmentMoney.amount | OrderItem | unitPrice | Original unit price of exchange item |
| lineItems.originalUnitPriceSet.presentmentMoney.currencyCode | order.refunds.return.exchangeLineItems.lineItems.originalUnitPriceSet.presentmentMoney.currencyCode | OrderHeader | currencyUomId | Currency of exchange item original price |
| lineItems.originalTotalSet.presentmentMoney.amount | order.refunds.return.exchangeLineItems.lineItems.originalTotalSet.presentmentMoney.amount | OrderItem | unitPrice | Original total for exchange line |
| lineItems.originalTotalSet.presentmentMoney.currencyCode | order.refunds.return.exchangeLineItems.lineItems.originalTotalSet.presentmentMoney.currencyCode | OrderHeader | currencyUomId | Currency of exchange original total |
| lineItems.discountedUnitPriceSet.presentmentMoney.amount | order.refunds.return.exchangeLineItems.lineItems.discountedUnitPriceSet.presentmentMoney.amount | OrderItem | unitPrice | Discounted unit price of exchange item |
| lineItems.discountedUnitPriceSet.presentmentMoney.currencyCode | order.refunds.return.exchangeLineItems.lineItems.discountedUnitPriceSet.presentmentMoney.currencyCode | OrderHeader | currencyUomId | Currency of exchange discounted price |
| lineItems.discountedUnitPriceAfterAllDiscountsSet.presentmentMoney.currencyCode | order.refunds.return.exchangeLineItems.lineItems.discountedUnitPriceAfterAllDiscountsSet.presentmentMoney.currencyCode | OrderHeader | currencyUomId | Currency after all discounts on exchange item |
| lineItems.discountedUnitPriceAfterAllDiscountsSet.presentmentMoney.amount | order.refunds.return.exchangeLineItems.lineItems.discountedUnitPriceAfterAllDiscountsSet.presentmentMoney.amount | OrderItem | unitPrice | Final unit price after all discounts on exchange |
| lineItems.discountedTotalSet.presentmentMoney.amount | order.refunds.return.exchangeLineItems.lineItems.discountedTotalSet.presentmentMoney.amount | OrderItem | unitPrice | Discounted total for exchange line |
| lineItems.discountedTotalSet.presentmentMoney.currencyCode | order.refunds.return.exchangeLineItems.lineItems.discountedTotalSet.presentmentMoney.currencyCode | OrderHeader | currencyUomId | Currency of exchange discounted total |
| lineItems.discountAllocations.allocatedAmountSet.presentmentMoney.amount | order.refunds.return.exchangeLineItems.lineItems.discountAllocations.allocatedAmountSet.presentmentMoney.amount | OrderAdjustment | amount | Discount amount allocated to exchange item |
| lineItems.discountAllocations.allocatedAmountSet.presentmentMoney.currencyCode | order.refunds.return.exchangeLineItems.lineItems.discountAllocations.allocatedAmountSet.presentmentMoney.currencyCode | OrderAdjustment | currencyUomId | Currency of exchange item discount |
| lineItems.taxLines.priceSet.presentmentMoney.amount | order.refunds.return.exchangeLineItems.lineItems.taxLines.priceSet.presentmentMoney.amount | OrderAdjustment | amount | Tax amount on exchange item |
| lineItems.taxLines.priceSet.presentmentMoney.currencyCode | order.refunds.return.exchangeLineItems.lineItems.taxLines.priceSet.presentmentMoney.currencyCode | OrderAdjustment | currencyUomId | Currency of tax on exchange item |


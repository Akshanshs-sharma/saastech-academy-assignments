# SQL Assignment 1

---

## Q1. New Customers Acquired in June 2023

**Business Problem:**  
The marketing team ran a campaign in June 2023 and wants to see how many new customers signed up during that period.

**Fields to Retrieve:**  
- `PARTY_ID`  
- `FIRST_NAME`  
- `LAST_NAME`  
- `EMAIL`  
- `PHONE`  
- `ENTRY_DATE`

```sql
SELECT pr.party_id,
       per.first_name,
       per.last_name,
       cm_email.info_string AS email,
       tl.contact_number AS phone_number,
       p.created_date AS entry_date
FROM party AS p
JOIN Person AS per
    ON p.party_id = per.party_id
JOIN party_role AS pr
    ON pr.party_id = per.party_id
LEFT JOIN party_contact_mech pcm_email
    ON per.party_id = pcm_email.party_id
LEFT JOIN contact_mech cm_email
    ON pcm_email.CONTACT_MECH_ID = cm_email.contact_mech_id
    AND cm_email.CONTACT_MECH_TYPE_ID = 'EMAIL_ADDRESS'
LEFT JOIN party_contact_mech pcm_phone
    ON pcm_phone.party_id = pr.party_id
LEFT JOIN contact_mech cm_phone
    ON pcm_phone.CONTACT_MECH_ID = cm_phone.CONTACT_MECH_ID
    AND cm_phone.CONTACT_MECH_TYPE_ID = 'TELECOM_NUMBER'
JOIN telecom_number tl
    ON tl.contact_mech_id = cm_phone.CONTACT_MECH_ID
WHERE pr.role_type_id = 'PLACING_CUSTOMER';
```

---

## Q2. List All Active Physical Products

**Business Problem:**  
Merchandising teams often need a list of all physical products to manage logistics, warehousing, and shipping.

**Fields to Retrieve:**  
- `PRODUCT_ID`  
- `PRODUCT_TYPE_ID`  
- `INTERNAL_NAME`

```sql
SELECT p.product_id,
       p.internal_name,
       p.product_type_id
FROM Product p
JOIN product_type pt
    ON p.product_type_id = pt.PRODUCT_TYPE_ID
    AND pt.IS_PHYSICAL = 'Y';
```

---

## Q3. Products Missing NetSuite ID

**Business Problem:**  
A product cannot sync to NetSuite unless it has a valid NetSuite ID. The OMS needs a list of all products that still need to be created or updated in NetSuite.

**Fields to Retrieve:**  
- `PRODUCT_ID`  
- `INTERNAL_NAME`  
- `PRODUCT_TYPE_ID`  
- `NETSUITE_ID` (or similar field; may be `NULL` or empty if missing)

```sql
SELECT p.product_id,
       p.internal_name,
       p.product_type_id
FROM product p
LEFT JOIN good_identification gi
    ON p.product_id = gi.PRODUCT_ID AND gi.GOOD_IDENTIFICATION_TYPE_ID = 'ERP_ID'
WHERE gi.id_value IS NULL ;
```

---

## Q4. Product IDs Across Systems

**Business Problem:**  
To sync an order or product across multiple systems (e.g., Shopify, HotWax, ERP/NetSuite), the OMS needs to know each system's unique identifier for that product. This query retrieves the Shopify ID, HotWax ID, and ERP ID (NetSuite ID) for all products.

**Fields to Retrieve:**  
- `PRODUCT_ID` (internal OMS ID)  
- `SHOPIFY_ID`  
- `HOTWAX_ID`  
- `ERP_ID` / `NETSUITE_ID`

```sql
SELECT p.product_id,
       gis.id_value AS shopify_id,
       gin.id_value AS netsuite_id,
       gih.id_value AS hotwax_id
FROM product p
LEFT JOIN good_identification gin
    ON gin.product_id = p.product_id
    AND gin.GOOD_IDENTIFICATION_TYPE_ID = 'ERP_ID'
LEFT JOIN good_identification gis
    ON gis.product_id = p.product_id
    AND gis.GOOD_IDENTIFICATION_TYPE_ID = 'SHOPIFY_PROD_ID'
LEFT JOIN good_identification gih
    ON gih.product_id = p.product_id
    AND gih.GOOD_IDENTIFICATION_TYPE_ID = 'HC_GOOD_ID_TYPE';
```

---

## Q5. Completed Orders in August 2023

**Business Problem:**  
After running similar reports for a previous month, you now need all completed orders in August 2023 for analysis.

**Fields to Retrieve:**  
- `PRODUCT_ID`  
- `PRODUCT_TYPE_ID`  
- `PRODUCT_STORE_ID`  
- `TOTAL_QUANTITY`  
- `INTERNAL_NAME`  
- `FACILITY_ID`  
- `EXTERNAL_ID`  
- `FACILITY_TYPE_ID`  
- `ORDER_HISTORY_ID`  
- `ORDER_ID`  
- `ORDER_ITEM_SEQ_ID`  
- `SHIP_GROUP_SEQ_ID`

```sql
SELECT oh.order_id,
       oh.external_id,
       oh.product_store_id,
       ohist.order_history_id,
       oi.order_item_seq_id,
       oisg.ship_group_seq_id,
       f.facility_id,
       f.facility_type_id,
       otq.total_quantity,
       p.product_id,
       p.product_type_id,
       p.internal_name
FROM order_header oh
JOIN order_item oi
    ON oh.order_id = oi.order_id
JOIN order_item_ship_group oisg
    ON oh.order_id = oisg.order_id
    AND oi.ship_group_seq_id = oisg.ship_group_seq_id
LEFT JOIN order_history ohist
    ON oh.order_id = ohist.order_id
    AND oi.order_item_seq_id = ohist.order_item_seq_id
    AND oisg.ship_group_seq_id = ohist.ship_group_seq_id
JOIN facility f
    ON oisg.facility_id = f.facility_id
JOIN (
    SELECT order_id, SUM(quantity) AS total_quantity
    FROM order_item
    GROUP BY order_id
) otq
    ON oh.order_id = otq.order_id
JOIN product p
    ON oi.product_id = p.product_id
WHERE oh.status_id = 'ORDER_COMPLETED';
```

---

## Q7. Newly Created Sales Orders and Payment Methods

**Business Problem:**  
Finance teams need to see new orders and their payment methods for reconciliation and fraud checks.

**Fields to Retrieve:**  
- `ORDER_ID`  
- `TOTAL_AMOUNT`  
- `PAYMENT_METHOD`  
- `Shopify Order ID` (if applicable)

```sql
SELECT o.order_id AS ORDER_ID,
       o.grand_total AS TOTAL_AMOUNT,
       o.external_id AS Shopify_Order_ID,
       opp.payment_method_type_id AS PAYMENT_METHOD
FROM order_header o
JOIN order_payment_preference opp USING (order_id);
```

---

## Q8. Payment Captured but Not Shipped

**Business Problem:**  
Finance teams want to ensure revenue is recognized properly. If payment is captured but no shipment has occurred, it warrants further review.

**Fields to Retrieve:**  
- `ORDER_ID`  
- `ORDER_STATUS`  
- `PAYMENT_STATUS`  
- `SHIPMENT_STATUS`

```sql
SELECT oh.order_id,
       oh.status_id AS order_status,
       opp.status_id AS payment_status,
       s.status_id AS shipment_status
FROM order_header oh
LEFT JOIN order_payment_preference opp USING (order_id)
LEFT JOIN shipment s
    ON oh.order_id = s.primary_order_id;
```

---

## Q9. Orders Completed Hourly

**Business Problem:**  
Operations teams may want to see how orders complete across the day to schedule staffing.

**Fields to Retrieve:**  
- `TOTAL ORDERS`  
- `HOUR`

```sql
SELECT HOUR(entry_date) AS order_hour,
       COUNT(DISTINCT order_id) AS total_orders
FROM order_header
WHERE entry_date LIKE '2026-05-01'
  AND status_id = 'ORDER_COMPLETED'
GROUP BY HOUR(entry_date);
```

---

## Q10. BOPIS Orders Revenue (Last Year)

**Business Problem:**  
**BOPIS** (Buy Online, Pickup In Store) is a key retail strategy. Finance wants to know the revenue from BOPIS orders for the previous year.

**Fields to Retrieve:**  
- `TOTAL ORDERS`  
- `TOTAL REVENUE`

```sql
SELECT count(*) as total_orders,
	   sum( oh.grand_total) as total_revenue
FROM order_header oh

JOIN shipment s 
	ON s.primary_order_id = oh.order_id

WHERE oh.sales_channel_enum_id ='WEB_SALES_CHANNEL'
      AND s.shipment_method_type_id ='STOREPICKUP'
      AND oh.order_date >= '2025-01-01 00:00:00' AND oh.order_date <='2025-12-01 00:00:00';
```

---

## Q11. Canceled Orders (Last Month)

**Business Problem:**  
The merchandising team needs to know how many orders were canceled in the previous month and their reasons.

**Fields to Retrieve:**  
- `TOTAL ORDERS`  
- `CANCELATION REASON`

```sql
SELECT COUNT(order_id) AS total_count,
       change_reason AS cancellation_reason
FROM order_status os
GROUP BY change_reason
HAVING status_id = 'ORDER_CANCELLED'
    OR status_id = 'ITEM_CANCELLED';
```

---

## Q12. Product Threshold Value

**Business Problem:**  
The retailer has set a threshold value for products that are sold online, in order to avoid overselling.

**Fields to Retrieve:**  
- `PRODUCT_ID`  
- `THRESHOLD`

```sql
SELECT product_id,
       CASE
           WHEN SUM(minimum_stock) IS NULL THEN 0
           ELSE SUM(minimum_stock)
       END AS threshold
FROM product_facility
GROUP BY product_id;
```

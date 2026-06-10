# SQL Assignment 3

---

## 1. Completed Sales Orders (Physical Items)

**Business Problem:**  
Merchants need to track only physical items (requiring shipping and fulfillment) for logistics and shipping-cost analysis.

**Fields to Retrieve:**  
- `ORDER_ID`
- `ENTRY_DATE`
- `ORDER_DATE`
- `STATUS_ID`
- `PRODUCT_STORE_ID`
- `SALES_CHANNEL_ENUM_ID`
- `ORDER_TYPE_ID`
- `PRODUCT_ID`
- `PRODUCT_TYPE_ID`

```sql
SELECT oh.order_id,
       oh.entry_date,
       oh.order_date,
       oh.status_id,
       oh.product_store_id,
       oh.sales_channel_enum_id ,
       oh.order_type_id,
       oi.order_id,
       p.product_id,
       p.product_type_id
FROM order_header oh

JOIN order_item oi
ON  oh.order_id = oi.order_id

JOIN product p
ON oi.product_id = p.product_id

JOIN product_type pt
ON p.product_type_id = pt.product_type_id and pt.IS_PHYSICAL = 'Y';
```

---

## 2. Completed Return Items

**Business Problem:**  
Customer service and finance often need insights into returned items to manage refunds, replacements, and inventory restocking.

**Fields to Retrieve:**  
- `RETURN_ID`
- `RETURN_CHANNEL_ENUM_ID`
- `RETURN_DATE`
- `ENTRY_DATE`
- `FROM_PARTY_ID`
- `ORDER_ID`
- `ORDER_NAME`
- `PRODUCT_STORE_ID`

```sql
SELECT rh.return_id,
       rh.return_channel_enum_id,
       rh.return_date,
       rh.entry_date,
       rh.from_party_id,
       ri.order_id,
       oh.order_name,
       oh.product_store_id
FROM return_header rh

JOIN return_item ri 
ON ri.return_id = rh.return_id

JOIN order_header oh
ON ri.order_id = oh.order_id ;
```

---

## 3. Single-Return Orders (Last Month)

**Business Problem:**  
The merchandising team needs a list of orders that only have one return.

**Fields to Retrieve:**  
- `RETURN_ID`
- `PARTY_ID`
- `ORDER_ID`
- `FULL_NAME`

```sql
SELECT rh.return_id,
       rh.from_party_Id ,
       single_return.order_id,
       concat(per.first_name,' ',per.last_name) AS full_name
FROM 
	(   SELECT oh.order_id,
				ri.return_id
		from order_header oh
		join return_item ri
        on oh.order_id =ri.order_id
		group by oh.order_Id 
		having count( ri.return_id) = 1 ) single_return
        
JOIN return_header rh
ON rh.return_id = single_return.return_id 

JOIN person per
ON per.party_id = rh.from_party_id ;
```

---

## 4. Detailed Return Information

**Business Problem:**  
Certain teams need granular return data (reason, date, refund amount) for analyzing return rates, identifying recurring issues, or updating policies.

**Fields to Retrieve:**  
- `RETURN_ID`
- `ENTRY_DATE`
- `RETURN_ADJUSTMENT_TYPE_ID`
- `AMOUNT`
- `COMMENTS`
- `ORDER_ID`
- `ORDER_DATE`
- `RETURN_DATE`
- `PRODUCT_STORE_ID`

```sql
SELECT ri.return_id ,
       rh.entry_date,
       radj.return_adjustment_type_id,
       radj.amount,
       radj.comments,
       ri.order_id,
       oh.order_date,
       rh.return_date,
       oh.product_store_id
FROM return_item ri
JOIN return_header rh
ON ri.return_id = rh.return_id

Left JOIN return_adjustment radj
ON radj.return_id = ri.return_id AND radj.return_item_seq_id = ri.return_item_seq_id

JOin order_header oh
ON ri.order_id = oh.order_id;
```

---

## 5. Returns and Appeasements

**Business Problem:**  
The retailer needs the total amount of items that were returned as well as how many appeasements were issued.

**Fields to Retrieve:**  
- `TOTAL_RETURNS`
- `RETURN_TOTAL`
- `TOTAL_APPEASEMENT`
- `TOTAL_APPEASEMENT_AMOUNT`

```sql
SELECT IFNULL(ret.total_returned_item ,0) as total_returns,
       IFNULL(ret.total_return_dollar, 0) as return_total,
       IFNULL(app.total_appeasement , 0 ) as tota_appeasment , 
       IFNULL(app.total_appeasement_amount,0) as total_appeasment_amount
FROM 
       ( SELECT 1 as join_key,
                SUM(return_quantity) as total_returned_item,
                SUM(return_quantity * return_price) as total_return_dollar
		FROM return_item ) as ret 
JOIN 
       ( SELECT 1 as join_key,
              SUM(return_adjustment_id) as total_appeasement , 
              SUM(amount) as total_appeasement_amount
		FROM return_adjustmenet 
        WHERE return_adjustment_type_id ="APPEASEMENT" ) as app 
on ret.join_key = app.join_key ;
```

---

## 6. Orders with Multiple Returns

**Business Problem:**  
Analyzing orders with multiple returns can identify potential fraud, chronic issues with certain items, or inconsistent shipping processes.

**Fields to Retrieve:**  
- `ORDER_ID`
- `RETURN_ID`
- `RETURN_DATE`
- `RETURN_REASON_ID`
- `RETURN_QUANTITY`

```sql
SELECT oh.order_id,
	   ri.return_id,
       rh.return_date,
       ri.return_reason_id,
       ri.return_quantity
FROM order_header oh
JOIN return_item ri
ON oh.order_id = ri.order_id

JOIN return_header rh
ON rh.return_id = ri.return_id ;
```

---

## 7. Store with Most One-Day Shipped Orders (Last Month)

**Business Problem:**  
Identify which facility (store) handled the highest volume of "one-day shipping" orders in the previous month, useful for operational benchmarking.

**Fields to Retrieve:**  
- `FACILITY_ID`
- `FACILITY_NAME`
- `TOTAL_ONE_DAY_SHIP_ORDERS`
- `REPORTING_DATE`

```sql
SELECT oisg.facility_id,
       f.facility_name,
       count( distinct order_id ) as total_order_one_day_shipping ,
       DATE_FORMAT(oh.order_date ,'%Y-%m') as reporting_date 
FROM order_item_ship_group oisg 
JOIN facility f 
ON f.facility_id = oisg.facility_id 

JOIN order_header oh
ON oh.order_id = oisg.order_id

JOIN facility_type ft
ON ft.facility_type_id = f.facility_type_id 

WHERE ft.parent_type_id <> 'VIRTUAL_FACILITY' 
      AND oh.status_id ='ORDER_COMPLETED'
      AND oisg.shipment_method_type_id='NEXT_DAY'
      
      AND oh.order_date >= DATE_FORMAT(DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH), '%Y-%m-01')
      AND oh.order_date < DATE_FORMAT(CURRENT_DATE(), '%Y-%m-01')
      
GROUP BY oisg.facility_id,
       f.facility_name,
       DATE_FORMAT(oh.order_date ,'%Y-%m') ;
```

---

## 8. List of Warehouse Pickers

**Business Problem:**  
Warehouse managers need a list of employees responsible for picking and packing orders to manage shifts, productivity, and training needs.

**Fields to Retrieve:**  
- `PARTY_ID`
- `FACILITY_ID`
- `ROLE_TYPE_ID`
- `FULL_NAME`
- `DISABLED`

```sql
SELECT fp.party_id,
       fp.facility_id,
       fp.role_type_id,
       concat(per.first_name,' ',per.last_name) as full_name,
       p.disabled
FROM facility_party fp
JOIN party p 
ON p.party_id = fp.party_id

JOIN person per
ON per.party_id = fp.party_id;
```

---

## 9. Total Facilities That Sell the Product

**Business Problem:**  
Retailers want to see how many (and which) facilities (stores, warehouses, virtual sites) currently offer a product for sale.

**Fields to Retrieve:**  
- `PRODUCT_ID`
- `NUMBER_OF_FACILITIES`
- `PRODUCT_NAME`

```sql
SELECT invi.product_id,
	   count( invi.facility_id ) as number_Of_faciltiy,
       p.product_name
FROM inventory_item invi

JOIN product p
ON invi.product_id = p.product_id

GROUP BY invi.product_id,
         p.product_name;
```

---

## 10. Total Items in Various Virtual Facilities

**Business Problem:**  
Retailers need to study the relation of inventory levels of products to the type of facility it's stored at. Retrieve all inventory levels for products at locations and include the facility type ID. Do not retrieve facilities that are of type Virtual.

**Fields to Retrieve:**  
- `PRODUCT_ID`
- `FACILITY_ID`
- `FACILITY_TYPE_ID`
- `TOTAL_QUANTITY_ON_HAND`
- `TOTAL_AVAILABLE_TO_PROMISE`

```sql
SELECT invi.product_id,
	   invi.facility_id,
       f.facility_type_id,
       invi.total_quantity_on_hand,
       invi.total_available_to_promise
FROM inventory_item invi
JOIN facility f 
ON f.facility_id = invi.facility_id

JOIN facility_type ft
ON ft.facility_type_id = f.facility_type_id 

WHERE ft.parent_type_id <> 'VIRTUAL_FACILITY' ;
```

---

## 11. Transfer Orders Without Inventory Reservation

**Business Problem:**  
When transferring stock between facilities, the system should reserve inventory. If it isn't reserved, the transfer may fail or oversell.

**Fields to Retrieve:**  
- `ORDER_ID`
- `FROM_FACILITY_ID`
- `ORDER_ITEM_SEQ_ID`
- `TO_FACILITY_ID`
- `PRODUCT_ID`
- `REQUESTED_QUANTITY`
- `RESERVED_QUANTITY`
- `STATUS_ID`
- `TRANSFER_DATE`

```sql
SELECT oh.order_id,
	   oh.origin_facility_id as from_facility_id,
       oi.order_item_seq_id,
       oisg.facility_id as to_facility_id,
       oi.product_id,
       oi.quantity as requested_quantity,
       oisginvres.quantity as reserved_quantity,
       oi.status_id,
       oh.order_date as transfer_date
FROM order_header oh
JOIN order_item oi 
ON oh.order_id = oi.order_id 

JOIN order_item_ship_group oisg 
ON oi.order_id = oisg.order_id AND oi.ship_group_seq_id = oisg.ship_group_seq_id

JOIN order_item_ship_grp_inv_res oisginvres
ON oi.order_id = oisginvres.order_id 
AND oi.order_item_seq_id = oisginvres.order_item_seq_id
AND oi.ship_group_seq_Id = oisginvres.ship_group_seq_id

WHERE oh.order_type_id ='TRANSFER_ORDER';
```

---

## 12. Orders Without Picklist

**Business Problem:**  
A picklist is necessary for warehouse staff to gather items. Orders missing a picklist might be delayed and need attention.

**Fields to Retrieve:**  
- `ORDER_ID`
- `ORDER_DATE`
- `STATUS_ID`
- `ORDER_ITEM_SEQ_ID`
- `FACILITY_ID`
- `DURATION`

```sql
select oh.order_id,
       oh.order_date,
       oh.status_id,
       oi.order_item_seq_id,
       oisg.facility_id,
       DATE_DIFF(CURRENT_TIMESTAMP  ,oisginvres.reserved_datetime ) as duration 
FROM order_header oh
JOIN order_item oi 
ON oh.order_id = oi.order_id 

JOIN order_item_ship_group oisg 
ON oi.order_id = oisg.order_id AND oi.ship_group_seq_id = oisg.ship_group_seq_id

JOIN order_item_ship_grp_inv_res oisginvres
ON oi.order_id = oisginvres.order_id 
AND oi.order_item_seq_id = oisginvres.order_item_seq_id
AND oi.ship_group_seq_Id = oisginvres.ship_group_seq_id

LEFT JOIN shipment s 
ON oi.order_id = s.primary_order_id 
AND oi.ship_group_seq_Id = s.ship_group_seq_id

WHERE s.shipment_id IS NULL ;
```

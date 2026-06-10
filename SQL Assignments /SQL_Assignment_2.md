# SQL Assignment 2

---

## 5.1 Shipping Addresses for October 2023 Orders

**Business Problem:**  
Customer Service might need to verify addresses for orders placed or completed in October 2023. This helps ensure shipments are delivered correctly and prevents address-related issues.

**Fields to Retrieve:**  
- `ORDER_ID`
- `PARTY_ID`
- `CUSTOMER_NAME`
- `STREET_ADDRESS`
- `CITY`
- `STATE_PROVINCE`
- `POSTAL_CODE`
- `COUNTRY_CODE`
- `ORDER_STATUS`
- `ORDER_DATE`

```sql
select oh.ORDER_ID,
		odr.PARTY_ID,
		concat(per.first_name,' ',per.last_name),
		padd.address1,
		padd.city,
		padd.state_province_geo_id,
		padd.postal_code,
		padd.country_geo_id,
		oh.status_id,
		oh.order_date
FROM order_header oh
JOIN order_role odr 
ON oh.order_id = odr.order_id and odr.ROLE_TYPE_ID = "SHIP_TO_CUSTOMER"

JOIN person per 
on odr.party_id =per.party_id  

JOIN order_contact_mech ocm 
on ocm.order_id = oh.order_id and ocm.contact_mech_purpose_type_id="SHIPPING_LOCATION"

join postal_address padd
on padd.CONTACT_MECH_ID = ocm.CONTACT_MECH_ID
where  (oh.order_date >= '2023-10-01' 
  AND oh.order_date < '2023-11-01' )
  AND (oh.STATUS_ID = "ORDER_CREATED" or oh.STATUS_ID = "ORDER_COMPLETED");
```

---

## 5.2 Orders from New York

**Business Problem:**  
Companies often want region-specific analysis to plan local marketing, staffing, or promotions in certain areas—here, specifically, New York.

**Fields to Retrieve:**  
- `ORDER_ID`
- `CUSTOMER_NAME`
- `STREET_ADDRESS`
- `CITY`
- `STATE_PROVINCE`
- `POSTAL_CODE`
- `TOTAL_AMOUNT`
- `ORDER_DATE`
- `ORDER_STATUS`

```sql
select oh.ORDER_ID,
		concat(per.first_name,' ',per.last_name),
		padd.address1,
		padd.city,
		padd.state_province_geo_id,
		padd.postal_code,
		padd.country_geo_id,
		oh.status_id,
		oh.order_date,
        oh.grand_total as total_amount 
        
--         GET THE ORDER ROLE OF SHIP TO CUSTOMER 
FROM order_header oh
JOIN order_role odr 
ON oh.order_id = odr.order_id and odr.ROLE_TYPE_ID = "PLACING_CUSTOMER"
         
--          FIND THE PARTY TO WE ARE SHIPPING TO , TO GET THE FIRST NAME AND LAST NAME
JOIN person per 
on odr.party_id =per.party_id  

-- GET THE SHIPPING LOCATION CONTACT MECH 
JOIN order_contact_mech ocm 
on ocm.order_id = oh.order_id and ocm.contact_mech_purpose_type_id="SHIPPING_LOCATION"

-- GET new yorks address 
join postal_address padd
on padd.CONTACT_MECH_ID = ocm.CONTACT_MECH_ID and city ="New York";
```

---

## 5.3 Top-Selling Product in New York

**Business Problem:**  
Merchandising teams need to identify the best-selling product(s) in a specific region (New York) for targeted restocking or promotions.

**Fields to Retrieve:**  
- `PRODUCT_ID`
- `INTERNAL_NAME`
- `TOTAL_QUANTITY_SOLD`
- `CITY`
- `STATE`

```sql
select p.product_id,
            p.internal_name,
            sum(oi.QUANTITY) as total_quantity,
            padd.city as city,
            padd.STATE_PROVINCE_GEO_ID as state
	from order_header oh
    join order_item oi
    on oi.order_id = oh.order_id
    
    join product p  
    on p.product_id = oi.product_id
    
    left join order_contact_mech ocm
    on ocm.order_id = oh.order_id and ocm.CONTACT_MECH_PURPOSE_TYPE_ID="SHIPPING_LOCATION"
    
    join postal_address padd
    on padd.CONTACT_MECH_ID = ocm.CONTACT_MECH_ID 
    AND ( padd.city="New York" or padd.STATE_PROVINCE_GEO_ID="NY")
    
    where oh.ORDER_TYPE_ID="SALES_ORDER"
    and oh.status_id="ORDER_COMPLETED"
    AND oi.status_id="ITEM_COMPLETED"
    group by p.product_id,p.internal_name, padd.STATE_PROVINCE_GEO_ID , padd.city
```

---

## 7.3 Store-Specific (Facility-Wise) Revenue

**Business Problem:**  
Different physical or online stores (facilities) may have varying levels of performance. The business wants to compare revenue across facilities for sales planning and budgeting.

**Fields to Retrieve:**  
- `FACILITY_ID`
- `FACILITY_NAME`
- `TOTAL_ORDERS`
- `TOTAL_REVENUE`

```sql
select f.facility_id ,
       f.facility_name,
       count( distinct oisg.order_id),
       sum(oi.QUANTITY * oi.UNIT_PRICE)
from order_header oh 
	 join order_item oi 
     on oi.order_id = oh.order_id
     join order_item_ship_group oisg 
     on oisg.ship_group_seq_id = oi.ship_group_seq_id AND oisg.order_id = oi.ORDER_ID 
     join facility f 
     on f.facility_id = oisg.facility_id
     where oh.status_id="ORDER_COMPLETED" AND oi.status_id="ITEM_COMPLETED"
     group by f.facility_id , f.facility_name ;
```

---

## 8.1 Lost and Damaged Inventory

**Business Problem:**  
Warehouse managers need to track "shrinkage" such as lost or damaged inventory to reconcile physical vs. system counts.

**Fields to Retrieve:**  
- `INVENTORY_ITEM_ID`
- `PRODUCT_ID`
- `FACILITY_ID`
- `REASON_CODE`
- `QUANTITY_LOST_OR_DAMAGED`

```sql
select inv.inventory_item_id,
           inv.product_id,
           inv.facility_id,
           invd.reason_enum_id,
          sum( invd.quantity_on_hand_diff) as QUANTITY_LOST_OR_DAMAGED
from inventory_item inv
join inventory_item_detail invd
group by inv.inventory_item_id, inv.product_id,inv.facility_id,invd.reason_enum_id
having invd.reason_enum_id="VAR_DAMAGED"
 or invd.reason_enum_id="VAR_LOST"
 or invd.reason_enum_id="VAR_STOLEN";
```

---

## 8.2 Low Stock or Out of Stock Items Report

**Business Problem:**  
Avoiding out-of-stock situations is critical. This report flags items that have fallen below a certain reorder threshold or have zero available stock.

**Fields to Retrieve:**  
- `PRODUCT_ID`
- `PRODUCT_NAME`
- `FACILITY_ID`
- `QOH`
- `ATP`
- `REORDER_THRESHOLD`

```sql
select invi.product_id,
       p.product_name,
       ivni.facility_id,
       invi.QUANTITY_ON_HAND_TOTAL as qoh,
       invi.AVAILABLE_TO_PROMISE_TOTAL as atp,
       pf.minimum_stock
from inventory_item invi
join product p 
on p.product_id = invi.product_id 
join product_facility pf
on invi.product_id =  pf.PRODUCT_ID AND  invi.FACILITY_ID = invi.facility_id
where invi.QUANTITY_ON_HAND_TOTAL < pf.minimum_stock OR pf.minimum_stock = 0;
```

---

## 8.3 Retrieve the Current Facility (Physical or Virtual) of Open Orders

**Business Problem:**  
The business wants to know where open orders are currently assigned, whether in a physical store or a virtual facility (e.g., a distribution center or online fulfillment location).

**Fields to Retrieve:**  
- `ORDER_ID`
- `ORDER_ITEM_SEQ_ID`
- `SHIP_GROUP_SEQ_ID`
- `FACILITY_ID`
- `FACILITY_NAME`
- `FACILITY_TYPE_ID`
- `PARENT_TYPE_ID`

```sql
select oh.order_id,
       oi.order_item_seq_id,
       oi.ship_group_seq_id,
       f.facility_id,
       f.facility_name,
       f.facility_type_id,
       ft.parent_type_id
from order_header oh 
join order_item oi
on oh.order_id = oi.order_id
join order_item_ship_group oisg
on oi.SHIP_GROUP_SEQ_ID = oisg.SHIP_GROUP_SEQ_ID  AND oi.order_id = oisg.order_id 
join facility f 
on oisg.facility_id = f.facility_id
left join facility_type ft
on ft.facility_type_id = f.facility_type_id
where oh.status_id <> "ORDER_COMPLETED" AND Oh.STATUS_ID <> "ORDER_CANCELLED";
```

---

## 8.4 Items Where QOH and ATP Differ

**Business Problem:**  
Sometimes the **Quantity on Hand (QOH)** doesn't match the **Available to Promise (ATP)** due to pending orders, reservations, or data discrepancies. This needs review for accurate fulfillment planning.

**Fields to Retrieve:**  
- `PRODUCT_ID`
- `FACILITY_ID`
- `QOH`
- `ATP`
- `DIFFERENCE`

```sql
select invi.product_id,
	    invi.facility_id,
        invi.QUANTITY_ON_HAND_TOTAL as qoh,
       invi.AVAILABLE_TO_PROMISE_TOTAL as atp,
      ( invi.QUANTITY_ON_HAND_TOTAL -
       invi.AVAILABLE_TO_PROMISE_TOTAL )   as difference 
from inventory_item invi ; 
```

---

## 8.5 Order Item Current Status Changed Date-Time

**Business Problem:**  
Operations teams need to audit when an order item's status (e.g., from "Pending" to "Shipped") was last changed, for shipment tracking or dispute resolution.

**Fields to Retrieve:**  
- `ORDER_ID`
- `ORDER_ITEM_SEQ_ID`
- `CURRENT_STATUS_ID`
- `STATUS_ID`
- `CHANGED_BY`
- `STATUS_CHANGE_DATETIME`

```sql
select os.order_id,
       os.order_item_seq_id,
       os.status_id, 
       osj.status_id,
       osj.STATUS_USER_LOGIN as changed_by,
       osj.status_datetime 
from order_status os
join order_status osj
on os.order_id = osj.order_id AND os.order_item_seq_id = osj.order_item_seq_id  
where os.order_item_seq_id IS NOT NULL 
AND os.status_id="ITEM_APPROVED"
AND osj.status_id="ITEM_COMPLETED";
```

---

## 8.6 Total Orders by Sales Channel

**Business Problem:**  
Marketing and sales teams want to see how many orders come from each channel (e.g., web, mobile app, in-store POS, marketplace) to allocate resources effectively.

**Fields to Retrieve:**  
- `SALES_CHANNEL`
- `TOTAL_ORDERS`
- `TOTAL_REVENUE`
- `REPORTING_PERIOD`

```sql
SELECT sales_channel_enum_id,
        count(order_id) as total_orders,
         sum(grand_total) as total_revenue,
         DATE_FORMAT( entry_date ,' %Y - %m' ) as reporting_period
from order_header
group by date_format(entry_date,' %Y - %m ') ,sales_channel_enum_id;
```

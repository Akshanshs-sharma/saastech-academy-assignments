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
  
  
  
--   5.2 second assignment 
  
  
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


-- 5.3 from sql assignment 
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
             
--              7.3 from sql assignment 2
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
     
     -- 8.1 Lost and Damaged Inventory

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
 
--   8.2

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


-- 8.3  

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


     
     
        
        
        
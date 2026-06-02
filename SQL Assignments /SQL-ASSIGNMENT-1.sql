-- first query
SELECT pr.party_id ,
       per.first_name,
       per.last_name,
       cm_email.info_string as email,
       tl.contact_number as phone_number,
       p.created_date as entry_date
FROM party as p
Join Person AS per
ON p.party_id = per.party_id
JOIN party_role AS pr
ON pr.party_id = per.party_id

LEFT JOIN party_contact_mech pcm_email
ON per.party_id = pcm_email.party_id
Left JOIN contact_mech cm_email
ON pcm_email.CONTACT_MECH_ID = cm_email.contact_mech_id 
   AND cm_email.CONTACT_MECH_TYPE_ID = "EMAIL_ADDRESS"
   
Left JOIN party_contact_mech pcm_phone 
on pcm_phone.party_id = pr.party_id 
LEFT JOIN contact_mech cm_phone
on pcm_phone.CONTACT_MECH_ID = cm_phone.CONTACT_MECH_ID AND cm_phone.CONTACT_MECH_TYPE_ID="TELECOM_NUMBER"
Join telecom_number tl
ON tl.contact_mech_id = cm_phone.CONTACT_MECH_ID 
WHERE pr.role_type_id ="PLACING_CUSTOMER";

-- SECOND QUERY 
SELECT p.product_id,
       p.internal_name,
       p.product_type_id
FROM Product p 
Join product_type pt 
on p.product_type_id = pt.PRODUCT_TYPE_id 
   and pt.IS_PHYSICAL='Y';
   
--    THIRD QUERY 
SELECT p.product_id,
       p.internal_name,
       p.product_type_id
from product p 
join good_identification gi 
on p.product_id = gi.PRODUCT_ID 
where gi.GOOD_IDENTIFICATION_TYPE_ID <> 'ERP_ID';

-- FOURTH QUERY 

SELECT p.product_id,
       gis.id_value as shopify_id,
       gin.id_value as nitsuite_id,
       gih.id_value as hotwax_id
from product p

left JOIN good_identification gin
on gin.product_id = p.product_id 
AND gin.GOOD_IDENTIFICATION_TYPE_ID = "ERP_ID"

left JOIN good_identification gis
on gis.product_id = p.product_id 
AND gis.GOOD_IDENTIFICATION_TYPE_ID = "SHOPIFY_PROD_ID"

left JOIN good_identification gih
on gih.product_id = p.product_id 
AND gih.GOOD_IDENTIFICATION_TYPE_ID = "HC_GOOD_ID_TYPE";


-- fifth query 


select oh.order_id,
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
from order_header oh
join order_item oi
	on oh.order_id = oi.order_id 
join order_item_ship_group oisg 
	on oh.order_id = oisg.order_id AND oi.ship_group_seq_id = oisg.ship_group_seq_id
left join order_history ohist
    on oh.order_id = ohist.order_id AND oi.order_item_seq_id = ohist.order_item_seq_id AND oisg.ship_group_seq_id = ohist.ship_group_seq_id
join facility f
    on oisg.facility_id = f.facility_id 
join ( select order_id , sum(Quantity) AS TOTAL_QUANTITY
	   from order_item
	   GROUP BY order_id ) otq
on oh.order_id = otq.order_id
join product p 
on oi.product_id = p.product_id
where oh.status_id = "ORDER_COMPLETED";


-- sixth query

select o.order_id as ORDER_ID,
       o.grand_total as TOTAL_AMOUNT,
       o.external_id as Shopify_Order_ID,
       opp.payment_method_type_id as PAYMENT_METHOD
from order_header o
join order_payment_preference opp using( order_id) ;

-- seventh query 

select oh.order_id ,
        oh.status_id as order_status ,
        opp.status_id as PAYMENT_STATUS ,
        s.status_id as SHIPMENT_STATUS
from order_header oh
left join order_payment_preference opp using( order_id) 
left join shipment s 
on oh.order_id = s.primary_order_id;

-- eight query 

select hour(ENTRY_DATE) as order_hour,
	    count( distinct order_id) as total_orders
from order_header
where entry_date like '2026-05-01' and status_id = "ORDER_COMPLETED"
group by HOUR(ENTRY_DATE);
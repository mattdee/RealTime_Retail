select count(*),region_name from store_locations_global
group by region_name;


select 
trx.trx_id,
trx.trx_date,
trx.trx_amt,
trx.store_id,
s.store_name
from transactions trx
inner join stores s
on trx.store_id=s.store_id
;
 


select 
format(sum(trx.trx_amt),0) StoreTotal,
trx.store_id,
s.store_name
from transactions trx
inner join stores s
on trx.store_id=s.store_id
group by s.store_id
order by 3 desc
 ;


select * from transactions trx 
join
stores s
on
trx.store_id = s.store_id;


select * from transactions trx 
join
stores s
on
trx.store_id = s.store_id
join
states st
on
s.store_state_id=st.state_id;


select * from transactions trx 
join
stores s
on
trx.store_id = s.store_id
join
states st
on
s.store_state_id=st.state_id
join
tender t
on
trx.tender_id=t.tender_id;


/* Get everything */
select * from transactions trx 
inner join
stores s
on
trx.store_id = s.store_id
inner join
states st
on
s.store_state_id=st.state_id
inner join
tender t
on
trx.tender_id=t.tender_id
inner join
items i
on
i.item_id=trx.item_id;








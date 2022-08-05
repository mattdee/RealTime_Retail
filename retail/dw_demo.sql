drop database if exists dw_demo;
create database if not exists dw_demo;
	
use dw_demo;

drop view if exists all_store_performance;
drop view if exists live_store_performance;
drop view if exists all_sales;
drop view if exists historical_sales;
drop view if exists live_sales_status;
drop view if exists store_locations;
drop view if exists store_locations_global;


drop table if exists transactions;
create table transactions
	(
		trx_id		int auto_increment,
		trx_date	timestamp DEFAULT NOW(),
		trx_amt		decimal,
		store_id	int,
		tender_id	int,
		item_id		int,
		shard key(trx_id,store_id,item_id,tender_id)
	);

drop table if exists historical_transactions;
create table historical_transactions
	(
		trx_id		int,
		trx_date	timestamp DEFAULT NOW(),
		trx_amt		decimal,
		store_id	int,
		tender_id	int,
		item_id		int,
		key (trx_id, store_id,item_id,tender_id) USING CLUSTERED COLUMNSTORE,
		shard key(trx_id,store_id,item_id,tender_id)
	);

drop table if exists tender;
create reference table tender
	(
		tender_id	int primary key,
		tender_type varchar(25),
		tender 		varchar(25)
	);

insert into tender (tender_id,tender_type,tender)
	values
	(1,'Credit','MasterCard'),
	(2,'Credit','Visa'),
	(3,'Credit','American Express'),
	(4,'Credit','Discover'),
	(5,'Credit','Diners Club'),
	(6,'Cash','Cash'),
	(7,'Debit','Bank of America'),
	(8,'Debit','USAA'),
	(9,'Check','Check');

drop table if exists regions;
create reference table regions
	(
		region_id	int primary key,
		region_name	varchar(20)
	);


drop table if exists items;
create reference table items
	(
		item_id	int auto_increment primary key,
		item_name  varchar(100)
	);
insert into items (item_id,item_name)
	values
	(1,'Sony Television'),
	(2,'Sony PlayStation 4'),
	(3,'Sony Vaio Laptop'),
	(4,'Samsung Television'),
	(5,'Samsung Galaxy S7'),
	(6,'Apple MacBook Pro 15inch'),
	(7,'Apple iPad Pro-12.9-inch-display-256gb-silver-wifi-cellular'),
	(8,'Apple iPhone 6s-5.5-inch-display-128gb-rose-gold-att'),
	(9,'Apple TV-apple-tv-64gb'),
	(10,'Apple MacBook-rose-gold-512gb'),
	(11,'HD 9.1GB @10000'),
	(12,'HD 9.1GB @10000 I'),
	(13,'HD 9.1GB @7200'),
	(14,'32MB Cache M'),
	(15,'32MB Cache NM'),
	(16,'64MB Cache M'),
	(17,'64MB Cache NM'),
	(18,'8MB Cache NM'),
	(19,'8MB EDO Memory'),
	(20,'DIMM - 128 MB');

insert into regions (region_id,region_name)
	values
	(1,'North America'),
	(2,'South America'),
	(3,'Australia'),
	(4,'Europe'),
	(5,'Asia'),
	(6,'Africa'),
	(7,'Antarctica');

drop table if exists stores;
create reference table stores
	(
		store_id		int primary key,
		store_name		varchar(50),
		store_region_id	int,
		store_state_id	int
	);


insert into stores (store_id,store_name,store_region_id,store_state_id)
 	values
	(1,'Store1',1,1),
	(2,'Store2',1,2),
	(3,'Store3',1,3),
	(4,'Store4',1,4),
	(5,'Store5',1,5),
	(6,'Store6',1,6),
	(7,'Store7',1,7),
	(8,'Store8',1,8),
	(9,'Store9',1,9),
	(10,'Store10',1,10),
	(11,'Store11',1,11),
	(12,'Store12',1,12),
	(13,'Store13',1,13),
	(14,'Store14',1,14),
	(15,'Store15',1,15),
	(16,'Store16',1,16),
	(17,'Store17',1,17),
	(18,'Store18',1,18),
	(19,'Store19',1,19),
	(20,'Store20',1,20),
	(21,'Store21',1,21),
	(22,'Store22',1,22),
	(23,'Store23',1,23),
	(24,'Store24',1,24),
	(25,'Store25',1,25),
	(26,'Store26',1,26),
	(27,'Store27',1,27),
	(28,'Store28',1,28),
	(29,'Store29',1,29),
	(30,'Store30',1,30),
	(31,'Store31',1,31),
	(32,'Store32',1,32),
	(33,'Store33',1,33),
	(34,'Store34',1,34),
	(35,'Store35',1,35),
	(36,'Store36',1,36),
	(37,'Store37',1,37),
	(38,'Store38',1,38),
	(39,'Store39',1,39),
	(40,'Store40',1,40),
	(41,'Store41',1,41),
	(42,'Store42',1,42),
	(43,'Store43',1,43),
	(44,'Store44',1,44),
	(45,'Store45',1,45),
	(46,'Store46',1,46),
	(47,'Store47',1,47),
	(48,'Store48',1,48),
	(49,'Store49',1,49),
	(50,'Store50',1,50),
	(51,'Store51',1,51),
	(52,'StoreSouthAmerica',2,''),
	(53,'StoreAustralia',3,''),
	(54,'StoreEurope',4,''),
	(55,'StoreAsia',5,''),
	(56,'StoreAfrica',6,''),
	(57,'StoreAntarctica',7,'');

drop table if exists states;
CREATE reference TABLE states (
state_id int auto_increment primary key,
state varchar(100),
abbreviation  varchar(10)
)
;

drop table if exists zipcode;
create  table zipcode
  (
    zip int primary key,
    type varchar(100),
    primary_city varchar(100),
    acceptable_cities longtext,
    unacceptable_cities longtext,
    state varchar(5),
    county varchar(100),
    timezone varchar(100),
    area_codes varchar(1000),
    latitude bigint,
    longitude bigint,
    world_region varchar(100),
    country varchar(50),
    decommissioned varchar(10),
    estimated_population int,
    notes varchar(100)
  )
  ;


/* Where are the stores? */
drop view if exists store_locations;
create view store_locations as
select * from stores,regions,states	
where 
stores.store_region_id=regions.region_id
and 
stores.store_state_id=states.state_id
;

drop view if exists store_locations_global;
create view store_locations_global as
select * from stores,regions
where 
stores.store_region_id=regions.region_id;


/* Get current everything */
drop view if exists live_sales_status;
create view live_sales_status as
select
trx.trx_id,
trx.trx_date,
trx.trx_amt,
trx.store_id trx_store_id,
trx.tender_id trx_tender_id,
trx.item_id trx_item_id,
s.store_id s_store_id,
s.store_name,
s.store_region_id,
s.store_state_id,
st.state,
st.abbreviation,
t.tender_id t_tender_id,
t.tender_type,
t.tender,
i.item_id i_item_id,
i.item_name
from transactions trx 
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



/* Get historial everything */
drop view if exists historical_sales;
create view historical_sales as
select
trx.trx_id,
trx.trx_date,
trx.trx_amt,
trx.store_id trx_store_id,
trx.tender_id trx_tender_id,
trx.item_id trx_item_id,
s.store_id s_store_id,
s.store_name,
s.store_region_id,
s.store_state_id,
st.state,
st.abbreviation,
t.tender_id t_tender_id,
t.tender_type,
t.tender,
i.item_id i_item_id,
i.item_name
from historical_transactions trx 
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

/* Mash up everything...cuz why not */
drop view if exists all_sales;
create view all_sales 
as
select * from live_sales_status
union all
select * from historical_sales
;

/* Get live store performance */
drop view if exists live_store_performance;
create view live_store_performance
as
select
format(sum(trx_amt),0) StoreTotal,
store_name
from live_sales_status
group by 2
order by 1;

/* Get store performance from live and historical sources */
drop view if exists all_store_performance;
create view all_store_performance
as
select
format(sum(trx_amt),0) StoreTotal,
store_name
from all_sales
group by 2
order by 1;


analyze table transactions;
analyze table historical_transactions;
analyze table tender;
analyze table regions;
analyze table items;
analyze table stores;
analyze table states;
analyze table zipcode;






	

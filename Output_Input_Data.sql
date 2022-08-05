use dw_demo;


/* system sudo rm /tmp/transactions.csv */


/* Output to a csv file */
select trx_date,trx_amt,store_id,tender_id,item_id 
into outfile '/tmp/transactions.csv'  fields terminated by ',' optionally enclosed by '"' lines terminated by '\n'
from transactions ;


truncate table transactions;



/* sudo chown -v admin:admin /tmp/transactions.csv */
/* sudo chmod ugo=rw /tmp/transactions.csv */



/* Import transactions data */
LOAD DATA INFILE '/tmp/transactions.csv'
ignore INTO TABLE transactions  FIELDS TERMINATED BY ','  OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' ignore 1 lines (trx_date,trx_amt,store_id,tender_id,item_id);


select format(count(*),0) from transactions;

#!/bin/bash

# ILM For dw_demo database
# Move transactions records from rowstore (memory) to columnstore (disk)
# Run every 5 minutes


# Move everything into the columnstore from the rowstore
while :
do
export RUNTIME=`date +%m_%d_%y_%H%M`
mysql -P3306 -uroot -h0 -e "select 'Number of records to move from transactions table:', format(count(*),0) Count from dw_demo.transactions INTO OUTFILE '/tmp/ILM_TRANSACTIONS_${RUNTIME}.txt'"

mysql -u root -h 127.0.0.1 -P 3306 <<EOF
use dw_demo;
start transaction;
insert into historical_transactions select * from transactions;
truncate table transactions;
analyze table transactions;
analyze table historical_transactions;
commit;

EOF

# sleep for 5 minutes
sleep 300
done


# # Move things that aren't from today into the columnstore from the rowstore
# while :
# do
# export RUNTIME=`date +%m_%d_%y_%H%M`
# mysql -P3306 -uroot -h0 -e "select 'Number of records to move from phone_number table:', format(count(*),0) Count from phones.phone_number INTO OUTFILE '/tmp/Phones_ILM_${RUNTIME}.txt'"

# mysql -u root -h 127.0.0.1 -P 3306 <<EOF
# use phones;
# start transaction;
# insert into old_phone_number (phone_number_to,phone_number_from,indate) select phone_number_from,phone_number_to, indate from phone_number where indate < CURRENT_DATE();

# truncate table phone_number;
# commit;

# EOF

# # sleep for 5 minutes
# sleep 300
# done




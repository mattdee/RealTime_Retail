import random
import sys
import multiprocessing
import os
import re
import csv
from memsql.common import database
import time

host = '127.0.0.1'

conn = database.connect(host=host, user='root', database='dw_demo')

start_time = time.time()

startcount = ("select format(count(*),0) from transactions")
thecount=conn.execute(startcount)
print(thecount)


for x in range(100000000):
    try:
        trx_list = []
        for i in range(10000):
            new_data=  (random.randint(-99,9999),random.randint(1,56),random.randint(1,8),random.randint(1,20))
            trx_list.append(new_data)
            #print(trx_list)
            query = 'insert into transactions (trx_amt,store_id,tender_id,item_id) values ' + ','.join(map(str, trx_list))
            #print (query)
            conn.execute(query)

    except Exception as e:
        sys.exit("nope...something broke")



import random
import sys
import multiprocessing
import os
import re
import csv
from memsql.common import database
import time
import requests


host = '127.0.0.1'

conn = database.connect(host=host, user='root', database='dw_demo')

word_site = "http://svnweb.freebsd.org/csrg/share/dict/words?view=co&content-type=text/plain"
response = requests.get(word_site)
WORDS = response.content.splitlines()
#print (WORDS)

wordlist = []

wordlist.append(WORDS)

print (wordlist)

cleanlist =  str(wordlist).strip('[]')

# try:
#     insert_query = 'insert into items (item_name) values ' + ','.join(map(str,wordlist))
#     conn.execute(insert_query)
#     count_query = 'select format(count(*),0) from items'
#     dacount=conn.execute(count_query)
#     print (dacount)

# except Exception as e:
#         sys.exit("nope")

#insert_query = 'insert into items (item_name) values ' + ','.join(map(str, wordlist))

insert_query = 'insert into items (item_name) values ' +  (cleanlist)



conn.execute(insert_query)
count_query = 'select format(count(*),0) from items'
dacount=conn.execute(count_query)
print (dacount)


print (insert_query)

# End
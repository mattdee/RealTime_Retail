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

cleanup = ("delete from transactions")
conn.execute(cleanup)


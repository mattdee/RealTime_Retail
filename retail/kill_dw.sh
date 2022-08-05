#!/bin/bash
echo "Found the following python processes"
echo "-----------------------------"
ps -ef | grep python|awk '{print $2}'

kill -9 `ps -ef | grep python|awk '{print $2}'`

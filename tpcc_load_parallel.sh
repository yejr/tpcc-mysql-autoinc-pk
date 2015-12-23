#!/bin/bash

##
## parallel initial tpcc data
## forked by yejr(imysql@imysql.com, http://imysql.com, QQ: 4700963, QQ群: 125572178、272675472)
## MySQL中文网: http://imysql.com
## 叶金荣(yejr)
## 小叶子她爹,装过Linux,写过PHP,优化过MySQL,目前围绕运维领域打杂
## 新浪微博: @叶金荣, 微信公众号: MYSQL中文网
## QQ群: 125572178、272675472
## 原项目地址：https://gist.github.com/sh2/3458844

# Configration

MYSQL=/usr/bin/mysql
TPCCLOAD=./tpcc_load
TABLESQL=./create_table.sql
CONSTRAINTSQL=./add_fkey_idx.sql
DEGREE=`getconf _NPROCESSORS_ONLN`

SERVER=localhost
DATABASE=tpcc
USER=tpcc
PASS=tpcc
WAREHOUSE=10

# Load

set -e
$MYSQL -u $USER -p$PASS -e "DROP DATABASE IF EXISTS $DATABASE"
$MYSQL -u $USER -p$PASS -e "CREATE DATABASE $DATABASE"
$MYSQL -u $USER -p$PASS $DATABASE < $TABLESQL
$MYSQL -u $USER -p$PASS $DATABASE < $CONSTRAINTSQL

echo 'Loading item ...'
$TPCCLOAD $SERVER $DATABASE $USER $PASS $WAREHOUSE 1 1 $WAREHOUSE > /dev/null

set +e
STATUS=0
trap 'STATUS=1; kill 0' INT TERM

for ((WID = 1; WID <= WAREHOUSE; WID++)); do
    echo "Loading warehouse id $WID ..."
    
    (
        set -e
        
        # warehouse, stock, district
        $TPCCLOAD $SERVER $DATABASE $USER $PASS $WAREHOUSE 2 $WID $WID > /dev/null
        
        # customer, history
        $TPCCLOAD $SERVER $DATABASE $USER $PASS $WAREHOUSE 3 $WID $WID > /dev/null
        
        # orders, new_orders, order_line
        $TPCCLOAD $SERVER $DATABASE $USER $PASS $WAREHOUSE 4 $WID $WID > /dev/null
    ) &
    
    PIDLIST=(${PIDLIST[@]} $!)
    
    if [ $((WID % DEGREE)) -eq 0 ]; then
        for PID in ${PIDLIST[@]}; do
            wait $PID
            
            if [ $? -ne 0 ]; then
                STATUS=1
            fi
        done
        
        if [ $STATUS -ne 0 ]; then
            exit $STATUS
        fi
        
        PIDLIST=()
    fi
done

for PID in ${PIDLIST[@]}; do
    wait $PID
    
    if [ $? -ne 0 ]; then
        STATUS=1
    fi
done

if [ $STATUS -eq 0 ]; then
    echo 'Completed.'
fi

exit $STATUS

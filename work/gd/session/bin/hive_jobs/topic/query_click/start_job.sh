#!/bin/bash
# -*- coding: utf-8 -*-

#===============================================================================
#            File:  start_job.sh [sp]
#           Usage:  
#     Description:  query_click表启动程序
#    LastModified:
#         Created:  2014-6-3 14:46 PM
#          AUTHOR:  warren(warren@autonavi.com)
#===============================================================================

#8个参数 /home/devuse/bin/hadoop/bin/hadoop /home/devuse/bin/hadoop/bin/hive /user/hive/warehouse/logamap.db/log_rc/dt=20140301/000000_0 log_sp ./ 20140301 start_20140301_log_sp 20140616
#:<<note
set -x
if [ $# -ne 8 ]; then
	echo "[$0] [ERROR] [`date "+%Y-%m-%d %H:%M:%S"`] [query_click] input error ! \$#=$# not 8"
	exit -1
fi
hadoop=$1;hive=$2;input_ready=$3;jobname=$4;main_dir=$5;date=$6;task_prefix=$7;now=$8
#note

echo "参数($#):$*"
:<<note
hive="/home/devuse/bin/hadoop/bin/hive"
date='20140601'
note

database='log_session'
table='query_click'
path="hive_jobs/topic/$table"
sql="$path/query_click.sql"
date1="${date:0:4}/${date:4:2}/${date:6:2}"
# 启动hive任务
${hive} -hivevar path=$path -hivevar date=$date -hivevar date1=$date1  -f $sql
if [ $? -ne 0 ];then
    echo "[$0] [ERROR] [`date "+%Y-%m-%d %H:%M:%S"`] [sp] Fail to execute hive job !"
    exit -1
else
    echo "[$0] [INFO] [`date "+%Y-%m-%d %H:%M:%S"`] [sp] Success to execute hive job !"
fi

:<<note
path="/user/hive/warehouse/${database}.db/${table}/dt=${date}"
# 生成ready文件
${hadoop} fs -test -e $path 
if [ $? -ne 0 ];then
    ${hadoop} fs -touchz ${path}/ready.done
fi
note

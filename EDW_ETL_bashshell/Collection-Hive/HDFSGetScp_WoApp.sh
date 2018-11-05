#!/bin/bash
##---------------------------------------------
## 创建时间:20180307
## 创建人: 徐长亮
## 功能:get hivefile from hdfs to local,scp data to DXP
# 测试 1月份
#sh HDFSGetScp_WoApp.sh 201801 20180131
# 测试 2 月份
# sh HDFSGetScp_WoApp.sh 2018-02-01 2018-02-28
##---------------------------------------------

## 输入参数: HIVE的dt分区
if [ ! -n "$1" ]
        then
                dt=$(date -d last-month +%Y%m)
        else
                i_dt=$(echo $1 | sed 's/-//g')
                dt=${i_dt:0:6}
fi

## 输人参数: 文件的日期
if [ ! -n "$2" ]
        then
                v_date=$(date +%Y%m%d)
        else
        		i_date=$(echo $2 | sed 's/-//g')
                v_date=${i_date:0:8}
fi


## 生产环境开发环境开关 v_mod='pro'
# v_mod='pro'
if [[ ${v_mod} = 'pro' ]]
        then
                v_hdfs_dir=/user/hive/warehouse/webtrends.db/wopayapp_final/dt=${dt}
                v_local_dir=/app/hive/hiveData/dt=${dt}
                v_remote_path="/DXP/DATA/HDFS"
                scp_user=''
                scp_pass=''
                scp_server=''
        else
                v_hdfs_dir=/user/hive/warehouse/unicom.db/wopayapp
                v_local_dir=/app/hive/hiveData/dt=${dt}
                v_remote_path="/DXP/DATA/HDFS"
                scp_user=''
                scp_pass=''
                scp_server=''
fi

## 创建local目录
if [ ! -d "${v_local_dir}" ];then
        mkdir -p ${v_local_dir}
fi

# 利用ssh在DXP创建v_remote_path
# ssh ${scp_user}@${scp_server} "mkdir -p $v_remote_path" <<EOF
# $scp_pass
# EOF


## 文件名称定义
v_file_prefix='PHONE_APP_INFO_'${v_date}
v_file=${v_file_prefix}'.txt'
v_file_done=${v_file_prefix}'.txt.done'
v_file_log=${v_file_prefix}'.log'
v_file_locate=${v_local_dir}/${v_file}
v_file_done_locate=${v_local_dir}/${v_file_done}
v_file_log_locate=${v_local_dir}/${v_file_log}

## 执行HDFS导出,文件合并
hadoop fs -get ${v_hdfs_dir}/* ${v_local_dir}/ 1>>${v_file_log_locate} 2>&1
v_result_x=$?

if [[ ${v_result_x} = 0 ]]
        then
                ## alias ll='ls -l --color=auto'
                ls -l ${v_local_dir}/* | grep -v '.log' | cat ${v_local_dir}/* > ${v_file_locate} 2>>${v_file_log_locate}
                v_result_y=$?
        else
                echo "[Error] $(date +'%Y-%m-%d %T') execute hadoop fs -get ${v_hdfs_dir}/* ${v_local_dir}/ error \n" >> ${v_file_log_locate}
fi

## 执行scp加载
if [[ $v_result_y = 0 ]]
        then
                touch $v_file_done_locate
                expect scp.sh ${scp_server} ${scp_user} ${scp_pass} ${v_file_locate} ${v_remote_path}/
                v_result_z=$?
                expect scp.sh ${scp_server} ${scp_user} ${scp_pass} ${v_file_done_locate} ${v_remote_path}/
                v_result_u=$?
        else
                echo "[Error] $(date +'%Y-%m-%d %T') execute ll ${v_local_dir}/* | grep -v '.log' | cat ${v_local_dir}/* > ${v_file_locate} error \n" >> ${v_file_log_locate}
fi

# 程序结束,记录成功日志
if [ $v_result_z = 0 -a $v_result_u = 0 ]
        then
                echo "[info] $(date +'%Y-%m-%d %T') execute scp successful \n" >> ${v_file_log_locate}
        else
                echo "[Error] $(date +'%Y-%m-%d %T') execute expect scp.sh ${scp_server} ${scp_user} ${scp_pass} ${v_file_locate} ${v_remote_path} Error \n" >> ${v_file_log_locate}
fi

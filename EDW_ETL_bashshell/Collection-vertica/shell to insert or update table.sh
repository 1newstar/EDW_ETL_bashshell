## user defined variable
## connection info for database
v_dbip=""
v_dbname=""
v_dbusr=""
v_dbpass=""
v_dbport=""

## bash script input var 
#$# 是传给脚本的参数个数
#$@ 是传给脚本的所有参数的列表
#$0 是脚本本身的名字
#$1 是传递给该shell脚本的第一个参数
#$2 是传递给该shell脚本的第二个参数
v_inptparmnbr=$#
if [ $v_inptparmnbr -ne 4 ] || [ `echo "$1"|grep "^[a-zA-Z]\{3\}_[a-zA-Z]\{3\}$"|wc -l` -ne 7 ]
then	echo "ERROR: wrong parameter count! The first parameter is table_schema and the length is 7,the second parameter is table_name! \n"
			exit -1
fi 

## 参数大小写处理
v_bdlschema=`echo $1|tr 'a-z' 'A-Z'`
v_fdlschema=`echo $3|tr 'a-z' 'A-Z'`
v_bdltable=`echo $2|tr 'a-z' 'A-Z'`
v_fdltable=`echo $4|tr 'a-z' 'A-Z'`


##处理临时文件,临时文件置空
cat /dev/null > $v_pk       #存放主键文件
cat /dev/null > $v_pk_b           #存放bdl主键文件
cat /dev/null > $v_allcolumn #存放所有字段列名称文件



##$v_pk
/opt/vertica/bin/vsql -d $v_dbname -h $v_dbip -X -a -U $v_dbusr -w $v_dbpass -p $v_dbport -c "select column_name from primary_keys where upper(table_name)='$v_fdltable' and upper(table_schema)='$v_fdlschema';" > $v_temppk
#去除最后两行(最后两行为(n rows)、空行)
#只取中间主键列(第四行到倒数第三行)
v_length=`cat $v_temppk |wc -l`
cat $v_temppk|sed -n "4,$v_length-2"p > $v_pk

##v_pk_b
/opt/vertica/bin/vsql -d $v_dbname -h $v_dbip -X -a -U $v_dbusr -w $v_dbpass -p $v_dbport -c "select column_name from primary_keys where upper(table_name)='$v_bdltable' and upper(table_schema)='$v_bdlschema';" > $v_temppk
#去除最后两行(最后两行为(n rows)、空行)
#只取中间主键列(第四行到倒数第三行)
v_length=`cat $v_temppk |wc -l`
cat $v_temppk|sed -n "4,$v_length-2"p > $v_pk_b

#找出对应表名下所有的列字段，并且拼接出需要处理的形式
v_allcolumn_tr=`/opt/vertica/bin/vsql -d $v_dbname -h $v_dbip -At -U $v_dbusr -w $v_dbpass -p $v_dbport -c "select column_name from columns where upper(table_schema) = '$v_fdlschema' and upper(table_name) = '$v_fdltable' order by ordinal_position;"|xargs|tr " " ","`

##v_allcolumn bdl字段
/opt/vertica/bin/vsql -d $v_dbname -h $v_dbip -At -U $v_dbusr -w $v_dbpass -p $v_dbport -c "select column_name from columns where upper(table_schema) = '$v_bdlschema' and upper(table_name) = '$v_bdltable' order by ordinal_position;">$v_allcolumn


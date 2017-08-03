### 01 转换编码
cd /app/etl_usr/PhoneNumber02
ll input/ | awk '{print $9}' | sed -n '2,23p'

iconv -f gbk -t utf-8 -c 上海_2G_yw_scores_users.txt    -o ../filter/上海_2G_yw_scores_users.out
iconv -f gbk -t utf-8 -c 上海_3G_yw_scores_users.txt    -o ../filter/上海_3G_yw_scores_users.out
iconv -f gbk -t utf-8 -c 上海_4G_yw_scores_users.txt    -o ../filter/上海_4G_yw_scores_users.out
iconv -f gbk -t utf-8 -c 四川_2G_yw_scores_users.txt    -o ../filter/四川_2G_yw_scores_users.out
iconv -f gbk -t utf-8 -c 四川_3G_yw_scores_users.txt    -o ../filter/四川_3G_yw_scores_users.out
iconv -f gbk -t utf-8 -c 四川_4G_yw_scores_users.txt    -o ../filter/四川_4G_yw_scores_users.out
iconv -f gbk -t utf-8 -c 新疆_2G_yw_scores_users.txt    -o ../filter/新疆_2G_yw_scores_users.out
iconv -f gbk -t utf-8 -c 新疆_3G_yw_scores_users.txt    -o ../filter/新疆_3G_yw_scores_users.out
iconv -f gbk -t utf-8 -c 新疆_4G_yw_scores_users.txt    -o ../filter/新疆_4G_yw_scores_users.out
iconv -f gbk -t utf-8 -c 河北_2G_yw_scores_users.txt    -o ../filter/河北_2G_yw_scores_users.out
iconv -f gbk -t utf-8 -c 河北_3G_yw_scores_users.txt    -o ../filter/河北_3G_yw_scores_users.out
iconv -f gbk -t utf-8 -c 河北_4G_yw_scores_users.txt    -o ../filter/河北_4G_yw_scores_users.out
iconv -f gbk -t utf-8 -c 浙江_2G_yw_scores_users.txt    -o ../filter/浙江_2G_yw_scores_users.out
iconv -f gbk -t utf-8 -c 浙江_3G_yw_scores_users.txt    -o ../filter/浙江_3G_yw_scores_users.out
iconv -f gbk -t utf-8 -c 浙江_4G_yw_scores_users.txt    -o ../filter/浙江_4G_yw_scores_users.out
iconv -f gbk -t utf-8 -c 湖北_2G_yw_scores_users.txt    -o ../filter/湖北_2G_yw_scores_users.out
iconv -f gbk -t utf-8 -c 湖北_3G_yw_scores_users.txt    -o ../filter/湖北_3G_yw_scores_users.out
iconv -f gbk -t utf-8 -c 湖北_4G_yw_scores_users.txt    -o ../filter/湖北_4G_yw_scores_users.out
iconv -f gbk -t utf-8 -c 黑龙江_2G_yw_scores_users.txt  -o ../filter/黑龙江_2G_yw_scores_users.out
iconv -f gbk -t utf-8 -c 黑龙江_3G_yw_scores_users.txt  -o ../filter/黑龙江_3G_yw_scores_users.out
iconv -f gbk -t utf-8 -c 黑龙江_4G_yw_scores_users.txt  -o ../filter/黑龙江_4G_yw_scores_users.out

## 02核对数量
wc -l `ll ../input/ | awk '{print $9}' | sed -n '2,23p'`
wc -l `ll ../filter/ | awk '{print $9}' | sed -n '2,23p'`

  #  154834 上海_2G_yw_scores_users.txt		 154834 上海_2G_yw_scores_users.out
  #  206549 上海_3G_yw_scores_users.txt		 206549 上海_3G_yw_scores_users.out
  # 1243241 上海_4G_yw_scores_users.txt		1243241 上海_4G_yw_scores_users.out
  #   79712 四川_2G_yw_scores_users.txt		  79712 四川_2G_yw_scores_users.out
  #  290204 四川_3G_yw_scores_users.txt		 290204 四川_3G_yw_scores_users.out
  #  859298 四川_4G_yw_scores_users.txt		 859298 四川_4G_yw_scores_users.out
  #   88838 新疆_2G_yw_scores_users.txt		  88838 新疆_2G_yw_scores_users.out
  #  300752 新疆_3G_yw_scores_users.txt		 300752 新疆_3G_yw_scores_users.out
  #  644005 新疆_4G_yw_scores_users.txt		 644005 新疆_4G_yw_scores_users.out
  #  551183 河北_2G_yw_scores_users.txt		 551183 河北_2G_yw_scores_users.out
  #  297823 河北_3G_yw_scores_users.txt		 297823 河北_3G_yw_scores_users.out
  # 1842816 河北_4G_yw_scores_users.txt		1842816 河北_4G_yw_scores_users.out
  #  292514 浙江_2G_yw_scores_users.txt		 292514 浙江_2G_yw_scores_users.out
  #  286620 浙江_3G_yw_scores_users.txt		 286620 浙江_3G_yw_scores_users.out
  #  678829 浙江_4G_yw_scores_users.txt		 678829 浙江_4G_yw_scores_users.out
  #  300636 湖北_2G_yw_scores_users.txt		 300636 湖北_2G_yw_scores_users.out
  #  244964 湖北_3G_yw_scores_users.txt		 244964 湖北_3G_yw_scores_users.out
  # 1538567 湖北_4G_yw_scores_users.txt		1538567 湖北_4G_yw_scores_users.out
  #  281448 黑龙江_2G_yw_scores_users.txt		 281448 黑龙江_2G_yw_scores_users.out
  #  198133 黑龙江_3G_yw_scores_users.txt		 198133 黑龙江_3G_yw_scores_users.out
  #  979068 黑龙江_4G_yw_scores_users.txt		 979068 黑龙江_4G_yw_scores_users.out

  ## 03文件增加一列
sed 's/$/\t2G/g' 上海_2G_yw_scores_users.out > test.out
## 直接修改 sed -i 's/$/\t2G/g'
sed -i 's/$/\t2G/g' 上海_2G_yw_scores_users.out
sed -i 's/$/\t3G/g' 上海_3G_yw_scores_users.out
sed -i 's/$/\t4G/g' 上海_4G_yw_scores_users.out
sed -i 's/$/\t2G/g' 四川_2G_yw_scores_users.out
sed -i 's/$/\t3G/g' 四川_3G_yw_scores_users.out
sed -i 's/$/\t4G/g' 四川_4G_yw_scores_users.out
sed -i 's/$/\t2G/g' 新疆_2G_yw_scores_users.out
sed -i 's/$/\t3G/g' 新疆_3G_yw_scores_users.out
sed -i 's/$/\t4G/g' 新疆_4G_yw_scores_users.out
sed -i 's/$/\t2G/g' 河北_2G_yw_scores_users.out
sed -i 's/$/\t3G/g' 河北_3G_yw_scores_users.out
sed -i 's/$/\t4G/g' 河北_4G_yw_scores_users.out
sed -i 's/$/\t2G/g' 浙江_2G_yw_scores_users.out
sed -i 's/$/\t3G/g' 浙江_3G_yw_scores_users.out
sed -i 's/$/\t4G/g' 浙江_4G_yw_scores_users.out
sed -i 's/$/\t2G/g' 湖北_2G_yw_scores_users.out
sed -i 's/$/\t3G/g' 湖北_3G_yw_scores_users.out
sed -i 's/$/\t4G/g' 湖北_4G_yw_scores_users.out
sed -i 's/$/\t2G/g' 黑龙江_2G_yw_scores_users.out
sed -i 's/$/\t3G/g' 黑龙江_3G_yw_scores_users.out
sed -i 's/$/\t2G/g' 黑龙江_4G_yw_scores_users.out

### 04 核对增加的一列的情况

awk -F "\t" '{print $7}' 上海_2G_yw_scores_users.out   | sed -n '1p'
awk -F "\t" '{print $7}' 上海_3G_yw_scores_users.out   | sed -n '1p'
awk -F "\t" '{print $7}' 上海_4G_yw_scores_users.out   | sed -n '1p'
awk -F "\t" '{print $7}' 四川_2G_yw_scores_users.out   | sed -n '1p'
awk -F "\t" '{print $7}' 四川_3G_yw_scores_users.out   | sed -n '1p'
awk -F "\t" '{print $7}' 四川_4G_yw_scores_users.out   | sed -n '1p'
awk -F "\t" '{print $7}' 新疆_2G_yw_scores_users.out   | sed -n '1p'
awk -F "\t" '{print $7}' 新疆_3G_yw_scores_users.out   | sed -n '1p'
awk -F "\t" '{print $7}' 新疆_4G_yw_scores_users.out   | sed -n '1p'
awk -F "\t" '{print $7}' 河北_2G_yw_scores_users.out   | sed -n '1p'
awk -F "\t" '{print $7}' 河北_3G_yw_scores_users.out   | sed -n '1p'
awk -F "\t" '{print $7}' 河北_4G_yw_scores_users.out   | sed -n '1p'
awk -F "\t" '{print $7}' 浙江_2G_yw_scores_users.out   | sed -n '1p'
awk -F "\t" '{print $7}' 浙江_3G_yw_scores_users.out   | sed -n '1p'
awk -F "\t" '{print $7}' 浙江_4G_yw_scores_users.out   | sed -n '1p'
awk -F "\t" '{print $7}' 湖北_2G_yw_scores_users.out   | sed -n '1p'
awk -F "\t" '{print $7}' 湖北_3G_yw_scores_users.out   | sed -n '1p'
awk -F "\t" '{print $7}' 湖北_4G_yw_scores_users.out   | sed -n '1p'
awk -F "\t" '{print $7}' 黑龙江_2G_yw_scores_users.out | sed -n '1p'
awk -F "\t" '{print $7}' 黑龙江_3G_yw_scores_users.out | sed -n '1p'
awk -F "\t" '{print $7}' 黑龙江_4G_yw_scores_users.out | sed -n '1p'

# echo `awk -F "\t" '{print $7}' 上海_2G_yw_scores_users.out   | sed -n '1p'`+`ls 上海_2G_yw_scores_users.out | awk -F "_" '{print $2}'`

## 04导入数据
vsql -U  -w  -h  -d  -c "copy  TEMP.test FROM LOCAL '/app/etl_usr/PhoneNumber02/filter/上海_2G_yw_scores_users.out'   DELIMITER '  ' DIRECT SKIP 0 REJECTED DATA '/app/etl_usr/PhoneNumber02/output/上海_2G_yw_scores_users.bad';"
vsql -U  -w  -h  -d  -c "copy  TEMP.test FROM LOCAL '/app/etl_usr/PhoneNumber02/filter/上海_3G_yw_scores_users.out'   DELIMITER '  ' DIRECT SKIP 0 REJECTED DATA '/app/etl_usr/PhoneNumber02/output/上海_3G_yw_scores_users.bad';"
vsql -U  -w  -h  -d  -c "copy  TEMP.test FROM LOCAL '/app/etl_usr/PhoneNumber02/filter/上海_4G_yw_scores_users.out'   DELIMITER '  ' DIRECT SKIP 0 REJECTED DATA '/app/etl_usr/PhoneNumber02/output/上海_4G_yw_scores_users.bad';"
vsql -U  -w  -h  -d  -c "copy  TEMP.test FROM LOCAL '/app/etl_usr/PhoneNumber02/filter/四川_2G_yw_scores_users.out'   DELIMITER '  ' DIRECT SKIP 0 REJECTED DATA '/app/etl_usr/PhoneNumber02/output/四川_2G_yw_scores_users.bad';"
vsql -U  -w  -h  -d  -c "copy  TEMP.test FROM LOCAL '/app/etl_usr/PhoneNumber02/filter/四川_3G_yw_scores_users.out'   DELIMITER '  ' DIRECT SKIP 0 REJECTED DATA '/app/etl_usr/PhoneNumber02/output/四川_3G_yw_scores_users.bad';"
vsql -U  -w  -h  -d  -c "copy  TEMP.test FROM LOCAL '/app/etl_usr/PhoneNumber02/filter/四川_4G_yw_scores_users.out'   DELIMITER '  ' DIRECT SKIP 0 REJECTED DATA '/app/etl_usr/PhoneNumber02/output/四川_4G_yw_scores_users.bad';"
vsql -U  -w  -h  -d  -c "copy  TEMP.test FROM LOCAL '/app/etl_usr/PhoneNumber02/filter/新疆_2G_yw_scores_users.out'   DELIMITER '  ' DIRECT SKIP 0 REJECTED DATA '/app/etl_usr/PhoneNumber02/output/新疆_2G_yw_scores_users.bad';"
vsql -U  -w  -h  -d  -c "copy  TEMP.test FROM LOCAL '/app/etl_usr/PhoneNumber02/filter/新疆_3G_yw_scores_users.out'   DELIMITER '  ' DIRECT SKIP 0 REJECTED DATA '/app/etl_usr/PhoneNumber02/output/新疆_3G_yw_scores_users.bad';"
vsql -U  -w  -h  -d  -c "copy  TEMP.test FROM LOCAL '/app/etl_usr/PhoneNumber02/filter/新疆_4G_yw_scores_users.out'   DELIMITER '  ' DIRECT SKIP 0 REJECTED DATA '/app/etl_usr/PhoneNumber02/output/新疆_4G_yw_scores_users.bad';"
vsql -U  -w  -h  -d  -c "copy  TEMP.test FROM LOCAL '/app/etl_usr/PhoneNumber02/filter/河北_2G_yw_scores_users.out'   DELIMITER '  ' DIRECT SKIP 0 REJECTED DATA '/app/etl_usr/PhoneNumber02/output/河北_2G_yw_scores_users.bad';"
vsql -U  -w  -h  -d  -c "copy  TEMP.test FROM LOCAL '/app/etl_usr/PhoneNumber02/filter/河北_3G_yw_scores_users.out'   DELIMITER '  ' DIRECT SKIP 0 REJECTED DATA '/app/etl_usr/PhoneNumber02/output/河北_3G_yw_scores_users.bad';"
vsql -U  -w  -h  -d  -c "copy  TEMP.test FROM LOCAL '/app/etl_usr/PhoneNumber02/filter/河北_4G_yw_scores_users.out'   DELIMITER '  ' DIRECT SKIP 0 REJECTED DATA '/app/etl_usr/PhoneNumber02/output/河北_4G_yw_scores_users.bad';"
vsql -U  -w  -h  -d  -c "copy  TEMP.test FROM LOCAL '/app/etl_usr/PhoneNumber02/filter/浙江_2G_yw_scores_users.out'   DELIMITER '  ' DIRECT SKIP 0 REJECTED DATA '/app/etl_usr/PhoneNumber02/output/浙江_2G_yw_scores_users.bad';"
vsql -U  -w  -h  -d  -c "copy  TEMP.test FROM LOCAL '/app/etl_usr/PhoneNumber02/filter/浙江_3G_yw_scores_users.out'   DELIMITER '  ' DIRECT SKIP 0 REJECTED DATA '/app/etl_usr/PhoneNumber02/output/浙江_3G_yw_scores_users.bad';"
vsql -U  -w  -h  -d  -c "copy  TEMP.test FROM LOCAL '/app/etl_usr/PhoneNumber02/filter/浙江_4G_yw_scores_users.out'   DELIMITER '  ' DIRECT SKIP 0 REJECTED DATA '/app/etl_usr/PhoneNumber02/output/浙江_4G_yw_scores_users.bad';"
vsql -U  -w  -h  -d  -c "copy  TEMP.test FROM LOCAL '/app/etl_usr/PhoneNumber02/filter/湖北_2G_yw_scores_users.out'   DELIMITER '  ' DIRECT SKIP 0 REJECTED DATA '/app/etl_usr/PhoneNumber02/output/湖北_2G_yw_scores_users.bad';"
vsql -U  -w  -h  -d  -c "copy  TEMP.test FROM LOCAL '/app/etl_usr/PhoneNumber02/filter/湖北_3G_yw_scores_users.out'   DELIMITER '  ' DIRECT SKIP 0 REJECTED DATA '/app/etl_usr/PhoneNumber02/output/湖北_3G_yw_scores_users.bad';"
vsql -U  -w  -h  -d  -c "copy  TEMP.test FROM LOCAL '/app/etl_usr/PhoneNumber02/filter/湖北_4G_yw_scores_users.out'   DELIMITER '  ' DIRECT SKIP 0 REJECTED DATA '/app/etl_usr/PhoneNumber02/output/湖北_4G_yw_scores_users.bad';"
vsql -U  -w  -h  -d  -c "copy  TEMP.test FROM LOCAL '/app/etl_usr/PhoneNumber02/filter/黑龙江_2G_yw_scores_users.out' DELIMITER ' ' DIRECT SKIP 0 REJECTED DATA '/app/etl_usr/PhoneNumber02/output/黑龙江_2G_yw_scores_users.bad';"
vsql -U  -w  -h  -d  -c "copy  TEMP.test FROM LOCAL '/app/etl_usr/PhoneNumber02/filter/黑龙江_3G_yw_scores_users.out' DELIMITER ' ' DIRECT SKIP 0 REJECTED DATA '/app/etl_usr/PhoneNumber02/output/黑龙江_3G_yw_scores_users.bad';"
vsql -U  -w  -h  -d  -c "copy  TEMP.test FROM LOCAL '/app/etl_usr/PhoneNumber02/filter/黑龙江_4G_yw_scores_users.out' DELIMITER ' ' DIRECT SKIP 0 REJECTED DATA '/app/etl_usr/PhoneNumber02/output/黑龙江_4G_yw_scores_users.bad';"

### 分析随机的数据
create table x_table as 
with randint_table as
(
  select a.*,randomint(1000000) as random_id from TEMP.test a 
  where prov_name='XX'
  and (scores between 1000 and 2000)
and network_types='4G'
and age<40)
select
count(PHONE_NUMBER) over(order by ID rows  between unbounded preceding and current row ) as row_num,randint_table.* 
from randint_table where random_id between 0 and 10000
order by 1 desc;

##100W用户中随机的1万个
select count(distinct PHONE_NUMBER) from  TEMP.x_table  where row_num>=1 and row_num<=10000




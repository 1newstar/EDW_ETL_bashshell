
# date
-d, --date=STRING
display time described by STRING, not ‘now’
       FORMAT controls the output.  Interpreted sequences are:
              %%     a literal %
              %a     locale’s abbreviated weekday name (e.g., Sun)
              %A     locale’s full weekday name (e.g., Sunday)
              %b     locale’s abbreviated month name (e.g., Jan)
              %B     locale’s full month name (e.g., January)
              %c     locale’s date and time (e.g., Thu Mar  3 23:05:25 2005)
              %C     century; like %Y, except omit last two digits (e.g., 20)
              %d     day of month (e.g, 01)
              %D     date; same as %m/%d/%y
              %e     day of month, space padded; same as %_d
              %F     full date; same as %Y-%m-%d
              %g     last two digits of year of ISO week number (see %G)
              %G     year of ISO week number (see %V); normally useful only with %V
              %h     same as %b
              %H     hour (00..23)
              %I     hour (01..12)
              %j     day of year (001..366)
              %k     hour ( 0..23)
              %l     hour ( 1..12)
              %m     month (01..12)
              %M     minute (00..59)
              %n     a newline
              %N     nanoseconds (000000000..999999999)
              %p     locale’s equivalent of either AM or PM; blank if not known
              %P     like %p, but lower case
              %r     locale’s 12-hour clock time (e.g., 11:11:04 PM)
              %R     24-hour hour and minute; same as %H:%M
              %s     seconds since 1970-01-01 00:00:00 UTC
              %S     second (00..60)
              %t     a tab
              %T     time; same as %H:%M:%S
              %u     day of week (1..7); 1 is Monday
              %U     week number of year, with Sunday as first day of week (00..53)
              %V     ISO week number, with Monday as first day of week (01..53)
              %w     day of week (0..6); 0 is Sunday
              %W     week number of year, with Monday as first day of week (00..53)
              %x     locale’s date representation (e.g., 12/31/99)
              %X     locale’s time representation (e.g., 23:13:48)
              %y     last two digits of year (00..99)
              %Y     year
              %z     +hhmm numeric timezone (e.g., -0400)
              %:z    +hh:mm numeric timezone (e.g., -04:00)
              %::z   +hh:mm:ss numeric time zone (e.g., -04:00:00)
              %:::z  numeric time zone with : to necessary precision (e.g., -04, +05:30)
              %Z     alphabetic time zone abbreviation (e.g., EDT)

# 日期显示
[etl_usr@bjgg-sjjh ~]$ date -d '20171220' +%%
%
[etl_usr@bjgg-sjjh ~]$ date -d '20171220' +%a
Wed
[etl_usr@bjgg-sjjh ~]$ date -d '20171220' +%A
Wednesday
[etl_usr@bjgg-sjjh ~]$ date -d '20171220' +%b
Dec
[etl_usr@bjgg-sjjh ~]$ date -d '20171220' +%B
December
[etl_usr@bjgg-sjjh ~]$ date -d '20171220' +%d
20
[etl_usr@bjgg-sjjh ~]$ date -d '20171220' +%F
2017-12-20
[etl_usr@bjgg-sjjh ~]$ date -d '20171220' +%j
354
%s     seconds since 1970-01-01 00:00:00 UTC

[etl_usr@bjgg-sjjh ~]$ date -d '20171220' +%s
1513699200
[etl_usr@bjgg-sjjh ~]$ date -d '20171220' +%u
3
[etl_usr@bjgg-sjjh ~]$ date -d '20171220' +%U
51
[etl_usr@bjgg-sjjh ~]$ date -d '20171220' +%w
3
[etl_usr@bjgg-sjjh ~]$ date -d '20171220' +%W
51
[etl_usr@bjgg-sjjh ~]$ date -d '20171220' +%V
51


# 加减运算
# day
date -d '20170101 +7 day' +%Y%m%d
20170108
date -d '+7 days 20170101' +%Y%m%d
20170108
# week
date -d '20170101 +1 week' +%Y%m%d
date -d '2017-01-01 +1 week' +%Y%m%d
20170108

date -d '+1 weeks 20170101' +%Y%m%d
20170108
date -d '+1 weeks 20170101' +%Y-%m-%d
2017-01-08

date -d '+1 weeks 2017-01-01' +%Y-%m-%d
2017-01-08
date -d '+1 weeks 2017-01-01' +%Y%m%d
20170108

# 星期判断
date -d '20170101' +%w
0 --周日
date -d '20170102' +%w
1 --周一

#其他星期
date -d '20171220' +%%


# expr - evaluate expressions Print the value of EXPRESSION to standard output

# declare 设置变量和属性
# declare: usage: declare [-aAfFilrtux] [-p] [name[=value] ...]
       -a  表示Name为一个索引数组
       -A  表示Name为一个关系数组
       -i  表述Name为一个整数
       -l  将Name的值转换为小写
       -u  将Name的值转换为大写
       -r  表示Name为一个只读变量
       -x  表示Name为输出变量(输出为全局变量)
       -t  表示Name具有'trace'属性

declare -i date_start=`date -d '+1 weeks 20170101' +%w`
 


 # ((表达式))或[表达式]
 # $()的作用是优先执行括号内的命令，并将命令的执行结果保存在内存中（而不是直接输出）

# 取整
# ${value//pattern/string}

[etl_usr@bjgg-sjjh ~]$ a=66.1234
[etl_usr@bjgg-sjjh ~]$ echo $((${a//.*/}))
66


# 截取
v_tablename=a_d
v_frequent=`echo ${v_tablename: -1}`
echo $v_frequent

v_tablename=a_d
v_frequent=${v_tablename: -1}
echo $v_frequent




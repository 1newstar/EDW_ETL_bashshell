--正则表达式
--扩展元字符附录:
–\d 一个数字字符 
–\D 一个非数字字符 
–\w 一个字母字符 
–\W 一个非字母字符 
–\s 一个空白字符 
–\S 一个非空白字符 
–+   匹配1或者更多次 
–{n} 匹配n次 
–{n，m} 匹配大于n次，小于M次

--匹配至少多位数字
--ture,false,true,false
select 1 from dual WHERE regexp_like('210000000000000000','\d{18}');
select 1 from dual WHERE regexp_like('21000000000000000X','\d{18}');
select 1 from dual WHERE regexp_like('21000000000000000X','\d{17,18}');
select 1 from dual WHERE regexp_like('2100000000000000XX','\d{17,18}');
--匹配至少多位非数字字符
--ture,false,true,false
select 1 from dual WHERE regexp_like('#$$','\D{3}');
select 1 from dual WHERE regexp_like('111','\D{3}');
select 1 from dual WHERE regexp_like('1$$','\D{2,3}');
select 1 from dual WHERE regexp_like('11$','\D{2,3}');
--匹配至少多位字目
--true
select 1 from dual WHERE regexp_like('abc','\w{3}');
--匹配至少多位非字母
--true,true
select 1 from dual WHERE regexp_like('#$$','\W{3}');
--匹配空白字符
--ture,false
select 1 from dual WHERE regexp_like('#$$ ','\s+');
select 1 from dual WHERE regexp_like('#$   ','\S{3}');

--函数:
regexp_like       逻辑函数
regexp_inst       返回位置
regexp_replace    返回新字符串
regexp_substr     返回匹配字符串

--match_option: 
–‘c’,区分大小写(默认) 
–‘i’,不区分大小写； 
–‘n’,允许匹配任意字符匹配换行符 
–‘m’,处理元字符串多行情况

--POSIX 元字符
(X|Y) 交替匹配
(^X) 匹配行开始
($Y)匹配行结束
[(exp),(exp),(exp)]匹配列表中任何一个表达式
[^exp] 匹配括号中正则表达式的否定表达
{m}精确匹配m次
[::] 指定一个字符类，匹配该类中任意字符






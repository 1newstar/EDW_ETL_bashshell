--������ʽ
--��չԪ�ַ���¼:
�C\d һ�������ַ� 
�C\D һ���������ַ� 
�C\w һ����ĸ�ַ� 
�C\W һ������ĸ�ַ� 
�C\s һ���հ��ַ� 
�C\S һ���ǿհ��ַ� 
�C+   ƥ��1���߸���� 
�C{n} ƥ��n�� 
�C{n��m} ƥ�����n�Σ�С��M��

--ƥ�����ٶ�λ����
--ture,false,true,false
select 1 from dual WHERE regexp_like('210000000000000000','\d{18}');
select 1 from dual WHERE regexp_like('21000000000000000X','\d{18}');
select 1 from dual WHERE regexp_like('21000000000000000X','\d{17,18}');
select 1 from dual WHERE regexp_like('2100000000000000XX','\d{17,18}');
--ƥ�����ٶ�λ�������ַ�
--ture,false,true,false
select 1 from dual WHERE regexp_like('#$$','\D{3}');
select 1 from dual WHERE regexp_like('111','\D{3}');
select 1 from dual WHERE regexp_like('1$$','\D{2,3}');
select 1 from dual WHERE regexp_like('11$','\D{2,3}');
--ƥ�����ٶ�λ��Ŀ
--true
select 1 from dual WHERE regexp_like('abc','\w{3}');
--ƥ�����ٶ�λ����ĸ
--true,true
select 1 from dual WHERE regexp_like('#$$','\W{3}');
--ƥ��հ��ַ�
--ture,false
select 1 from dual WHERE regexp_like('#$$ ','\s+');
select 1 from dual WHERE regexp_like('#$   ','\S{3}');

--����:
regexp_like       �߼�����
regexp_inst       ����λ��
regexp_replace    �������ַ���
regexp_substr     ����ƥ���ַ���

--match_option: 
�C��c��,���ִ�Сд(Ĭ��) 
�C��i��,�����ִ�Сд�� 
�C��n��,����ƥ�������ַ�ƥ�任�з� 
�C��m��,����Ԫ�ַ����������

--POSIX Ԫ�ַ�
(X|Y) ����ƥ��
(^X) ƥ���п�ʼ
($Y)ƥ���н���
[(exp),(exp),(exp)]ƥ���б����κ�һ�����ʽ
[^exp] ƥ��������������ʽ�ķ񶨱��
{m}��ȷƥ��m��
[::] ָ��һ���ַ��࣬ƥ������������ַ�






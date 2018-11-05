# -*- coding: utf-8 -*-
import sys
reload(sys)
sys.setdefaultencoding('utf-8')
import os
import time
import datetime
import SQL_Class
import send_mail
import platform
import csv
import xls_operation

os.environ['NLS_LANG'] = 'SIMPLIFIED CHINESE_CHINA.UTF8'

if platform.system() == 'Windows':
	split_char = '\\'
else:
	split_char = '/'

def read_txt(file_name):
	f = open(file_name, 'r')
	txt_str = f.read()
	f.close()
	return txt_str


def write_to_txt(file_name, str_in):
	f = open(file_name, 'w')
	f.write(str_in)
	f.close()
	return True

def main():
	print '---------------------------'
	os.chdir('/app/')
	db_id = 'XXXX'
	db_pwd = '***********'

	from_addr = '185xxxxxxx@wo.cn'
	password = '*********'
	mail_files_list = []

	today_date = datetime.date.today()
	days_ago_date = today_date - datetime.timedelta(days=10)
	print '====================='
	print str(days_ago_date)

	date_str = time.strftime('%Y-%m-%d')
	print date_str
	sql_files_path = os.getcwd() + split_char + 'sql_file'

	end_list = [[u'手机号']]

	print '------------ecp------------'
	sql_str = "select b.usr_mbl_no from  xxxx order by b.iss_dt desc"
	print time.strftime('%Y-%m-%d  %H:%M:%S'),
	result, cursor, db, conn = SQL_Class.log_in_db(db_id,db_pwd,'STD_XXX')
	if result==True:
		try:
			#查询数据库
			get_list = SQL_Class.get_db_list(db, conn, cursor, sql_str, [])
			print time.strftime('%Y-%m-%d  %H:%M:%S'),
			print len(get_list)
		finally:
			print time.strftime('%Y-%m-%d  %H:%M:%S'),
			SQL_Class.close_db(db, conn, cursor)

	print '------------bcmc------------'
	bcmc_sql_str = "select * from l where l.login_id = "
	print time.strftime('%Y-%m-%d  %H:%M:%S'),
	result, cursor, db, conn = SQL_Class.log_in_db(db_id,db_pwd,'STD_XXX')
	no = 1
	end_no = 1
	if result==True:
		for i in get_list:
			if no%5000==0:
				print time.strftime('%Y-%m-%d  %H:%M:%S'),
				print no,
				print end_no
			if end_no>600000:
				break
			try:
				temp_bcmc_sql_str = bcmc_sql_str + "'" + str(i[0]) + "'"
				get_bcmc_list = SQL_Class.get_db_list(db, conn, cursor, temp_bcmc_sql_str, [])
				if get_bcmc_list[0][0]=='no_data':
					end_list.append([str(i[0])])
					end_no = end_no + 1
				no = no + 1
			except:
				print i[0]
				print '***error***'

	file_name = os.getcwd() + split_char + 'files' + split_char + 'ecp_weibangka_' + time.strftime('%Y%m%d') + '.xls'
	mail_files_list = xls_operation.write_to_xls_split(end_list, file_name, sheet_name='Sheet1')

	#发送邮件
	mail_subject = u'话费红包未绑卡用户'
	mail_text = u'本邮件为自动发送'
	#to_addr_list = read_txt('to_addr.txt').split('\n')
	to_addr_list = ['XXXX@XXXX.cn']
	to_addr_str = send_mail.get_more_to_addr_str_by_list(to_addr_list)

	server = send_mail.log_in(from_addr, password)
	print time.strftime('%Y-%m-%d  %H:%M:%S'),
	print u'登陆邮箱成功'
	try:
		from_addr_str = send_mail.get_from_addr_str(from_addr, u'XXX')
		msg = send_mail.make_mail(mail_text, mail_subject, from_addr_str, to_addr_str, file_list=mail_files_list)
		send_mail.send_mail(server, from_addr, to_addr_list, msg)

		print time.strftime('%Y-%m-%d  %H:%M:%S'),
		print u'邮件发送成功，附件如下：'
		for mail_file in mail_files_list:
			print mail_file
		print u'接收人如下：'
		for to_addr in to_addr_list:
			print to_addr
	finally:
		send_mail.log_out(server)
		print time.strftime('%Y-%m-%d  %H:%M:%S'),
		print u'邮箱退出成功'


if __name__=='__main__':
	main()

# -*- coding: utf-8 -*-

from email import encoders
from email.header import Header
from email.mime.text import MIMEText
from email.mime.base import MIMEBase
from email.mime.multipart import MIMEMultipart
from email.utils import parseaddr, formataddr
import platform
import smtplib

if platform.system() == 'Windows':
	split_char = '\\'
else:
	split_char = '/'


def _format_addr(s):
	name, addr = parseaddr(s)
	return formataddr((\
		Header(name, 'utf-8').encode(), \
		addr.encode('utf-8') if isinstance(addr, unicode) else addr))

def get_from_addr_str(from_addr, from_name=''):
	if from_addr !='':
		from_addr = from_name + ' <' + from_addr + '>'
	end_str = _format_addr(from_addr)
	return end_str

def get_to_addr_str_by_one(to_addr, to_name=''):
	if to_addr !='':
		to_addr = to_name + ' <' + to_addr + '>'
	end_str = _format_addr(to_addr)
	return end_str

def get_more_to_addr_str_by_list(to_addr_list, to_name_list=[]):
	end_list = []
	if len(to_name_list)==0 or len(to_addr_list)!=len(to_name_list):
		for i in to_addr_list:
			end_list.append(_format_addr(i))
	else:
		for i in range(0, len(to_addr_list)):
			end_list.append(get_to_addr_str_by_one(to_addr_list[i], to_name_list[i]))
	end_str = ','.join(end_list)
	return end_str

def get_more_to_addr_str_by_str(to_addr_str):
	to_addr_list = []
	if ';' in to_addr_str:
		if ',' in to_addr_str:
			for i in to_addr_str.split(';'):
				for j in i.split(','):
					to_addr_list.append(j.strip())
		else:
			for i in to_addr_str.split(';'):
				to_addr_list.append(i.strip())
	else:
		for i in to_addr_str.split(','):
			to_addr_list.append(i.strip())
	end_list = []
	for i in to_addr_list:
		end_list.append(_format_addr(i))
	end_str = ','.join(end_list)
	return end_str

def make_mail(mail_text, mail_subject='', from_addr_str='', to_addr_str='', main_encode='plain', file_list=[], cc_addr_str=''):
	if len(file_list) == 0:#无附件
		msg = MIMEText(mail_text, main_encode, 'utf-8')
	else:#有附件
		msg = MIMEMultipart()
		msg.attach(MIMEText(mail_text, main_encode, 'utf-8'))
		for i in range(0, len(file_list)):
			print u'加载第%d个附件，共计%d个附件' % (i+1, len(file_list))
			file_name = file_list[i].split(split_char)[-1]
			file_type = file_list[i].split('.')[-1]
			with open(str(file_list[i]), 'rb') as f:
				mime = MIMEBase('application', file_type, filename=file_name)
				mime.add_header('Content-Disposition', 'attachment', filename=file_name)
				mime.add_header('Content_ID', '<0>')
				mime.add_header('X-Attachment-ID', '0')

				mime.set_payload(f.read())
				encoders.encode_base64(mime)
				msg.attach(mime)
	if from_addr_str != '':
		msg['From'] = from_addr_str
	if to_addr_str != '':
		msg['To'] = to_addr_str
	if cc_addr_str != '':
		msg['Cc'] = cc_addr_str
	if mail_subject != '':
		msg['Subject'] = Header(mail_subject, 'utf-8').encode()
	return msg

def log_in(from_addr, password):
	stmp = from_addr.split('@')
	smtp_server = 'smtp.' + stmp[1]
	print u'连接邮箱服务器'
	server = smtplib.SMTP(smtp_server, 25)
	#server.set_debuglevel(1)
	print u'登录邮箱'
	server.login(from_addr, password)
	return server

def log_out(server):
	server.quit()
	print u'所有任务发送完毕，退出邮箱'
	return True

def send_mail(server, from_addr, to_addr, msg):
	to_addr_list = []
	if isinstance(to_addr, list):
		to_addr_list = to_addr
	else:
		if ';' in to_addr:
			for i in to_addr.split(';'):
				if ',' in i:
					for j in i.split(','):
						to_addr_list.append(j)
				else:
					to_addr_list.append(i)
		else:
			if ',' in to_addr:
				for i in to_addr.split(','):
					to_addr_list.append(i)
			else:
				to_addr_list.append(to_addr)
	server.sendmail(from_addr, to_addr_list, msg.as_string())
	return True




if __name__ == '__main__':
	from_addr = '185XXXXXXXX@wo.cn'
	password = 'XXXXX'
	send_str = 'XXXXX@wo.cn;XXXXX@qq.com;XXXX@qq.com;XXXX@126.com'
	to_addr_list = ['XXXXXX@wo.cn', 'XXXX@qq.com', 'XXXX@qq.com', 'XXX@126.com']
	to_name_list = [u'一', u'二', u'三', u'四']
	mail_text = '<h1>h1</h1><h2>h2</h2><h3>h3</h3><h4>h4</h4><h5>h5</h5>'
	mail_subject = 'test1'
	#file_list = ['D:\\python\\weekly_report\\programme\\1111.xls', 'D:\\python\\weekly_report\\programme\\2222.xls']
	server = log_in(from_addr, password)
	try:
		from_addr_str = get_from_addr_str(from_addr, u'XXXX')
		to_addr_str = get_more_to_addr_str_by_list(to_addr_list, to_name_list)
		cc_addr_str = get_from_addr_str(from_addr, u'XXXX')
		msg = make_mail(mail_text, mail_subject, from_addr_str, to_addr_str, main_encode='html', cc_addr_str=cc_addr_str)
		send_mail(server, from_addr, to_addr_list, msg)
	finally:
		log_out(server)

	



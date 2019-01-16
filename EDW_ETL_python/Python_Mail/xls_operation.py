# -*- coding: utf-8 -*-
import xlrd
import xlwt
import os
import platform
import time

if platform.system() == 'Windows':
	split_char = '\\'
else:
	split_char = '/'


def write_to_xls_split(get_list, file_name, sheet_name='Sheet1'):
	file_name_list = []
	if len(get_list)>=60000:
		title_list = get_list[0]
		base_file_name = '.'.join(file_name.split('.')[:-1])
		no = 1
		get_list = get_list[1:]
		while True:
			if len(get_list)>60000:
				file_name = base_file_name + '_' + str(no) + '.xls'
				end_temp_list = get_list[:60000]
				get_list = get_list[60000:]
				write_to_xls([title_list]+end_temp_list, file_name, sheet_name='Sheet1')
				print time.strftime('%Y-%m-%d  %H:%M:%S'),
				print file_name
				no = no + 1
				file_name_list.append(file_name)
			else:
				file_name = base_file_name + '_' + str(no) + '.xls'
				end_temp_list = get_list[:]
				write_to_xls([title_list]+end_temp_list, file_name, sheet_name='Sheet1')
				print time.strftime('%Y-%m-%d  %H:%M:%S'),
				print file_name
				file_name_list.append(file_name)
				break
	else:
		write_to_xls(get_list, file_name, sheet_name='Sheet1')
		print time.strftime('%Y-%m-%d  %H:%M:%S'),
		print file_name
		file_name_list.append(file_name)
	return file_name_list
	

def write_to_xls(get_list, file_name, sheet_name='Sheet1'):
	data = xlwt.Workbook(encoding='utf-8', style_compression=0)  
	table = data.add_sheet(sheet_name, cell_overwrite_ok=True)
	for i in range(0, len(get_list)):
		for j in range(0, len(get_list[i])):
			if isinstance(get_list[i][j], int) or isinstance(get_list[i][j], float):
				table.write(i, j, get_list[i][j])
			elif get_list[i][j]==None:
				table.write(i, j, '')
			else:
				try:
					get_list[i][j].decode('utf-8')
					table.write(i, j, get_list[i][j].decode('utf-8'))
				except Exception,e:
					try:
						get_list[i][j].decode('gb2312')
						table.write(i, j, get_list[i][j].decode('gb2312'))
					except Exception,e:
						table.write(i, j, get_list[i][j])
	data.save(file_name)
	return True


def get_xls_list_by_name(file_name, sheet_name='Sheet1'):
	data = xlrd.open_workbook(file_name)
	table = data.sheet_by_name(sheet_name)
	xls_list = []
	nrows = table.nrows
	for i in range(0, nrows):
		xls_list.append(table.row_values(i))
	return xls_list


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

def write_to_csv(file_name, get_list):
	with open(file_name, 'wb') as csvfile:
		spamwriter = csv.writer(csvfile,dialect='excel')
		for i in get_list:

			row = []
			for j in i:
				if isinstance(j, int) or isinstance(j, float):
					row.append(str(j))
				elif j==None:
					row.append('')
				else:

					try:
						j.decode('gbk16')
						row.append(j.decode('gbk16').encode('gb2312'))
					except Exception,e:
						try:
							j.decode('utf-8')
							row.append(j.decode('utf-8').encode('gb2312'))
						except Exception,e:
							try:
								j.decode('gb2312')
								row.append(j.decode('gb2312').encode('gb2312'))
							except Exception,e:
								try:
									j.decode('gbk')
									row.append(j.decode('gbk').encode('gb2312'))
								except Exception,e:
									try:
										j.decode('ascii')
										row.append(j.decode('ascii').encode('gb2312'))
									except Exception,e:
										row.append(u'编码错误')

			spamwriter.writerow(row)


if __name__ == '__main__':
	path = 'H:\\python\\test_files'
	xls_list = get_xls_list_by_name(u'H:\\python\\test_files\\生日151025.xlsx', '0')
	write_to_xls_after(xls_list, u'H:\\python\\test_files\\生日151025_1.xls', '0', True)

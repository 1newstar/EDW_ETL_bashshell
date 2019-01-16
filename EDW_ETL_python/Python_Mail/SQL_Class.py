# -*- coding: utf-8 -*-
#########################################
#                                       #
#  Class SQL_Class 功能 实现数据库查询  #
#                                       #
#                                       #
#                                       #
#########################################

import cx_Oracle

__metaclass__ = type #确定使用的新式类

class SQL_class: #数据库查询
    #初始化
    def __int__(self):
        self.username = None
        self.password = None
        self.sid = None
        self.str_sql = None
    #连接数据库
    def SQL_connect(self,username,password,sid):
        self.username = username
        self.password = password
        self.sid = sid
        conn = cx_Oracle.connect(self.username,self.password,self.sid)
        return conn
    #创建游标
    def SQL_cursor(self,conn):
        return conn.cursor()
    #关闭游标
    def SQL_cursor_close(self,cursor):
        cursor.close()
    #关闭数据库
    def SQL_connect_close(self,conn):
        conn.close()
    #获取版本号
    def SQL_version(self,conn):
        return conn.version
    #执行语句
    def SQL_cursor_execute(self,cursor,str_sql):
        self.str_sql = str_sql
        cursor.execute(self.str_sql)
    #读取一条记录
    def SQL_fetchone(self,cursor_fetchone):
        return cursor_fetchone.fetchone()
    #读取所有记录
    def SQL_fetchall(self,cursor_fetchall):
        return cursor_fetchall.fetchall()

def log_in_db(username,password,sid):
    #创建db对象
    db = SQL_class()
    print u'创建db对象完成'
    #连接数据库
    try:
        conn = db.SQL_connect(username,password,sid)
        print u'连接数据库完成',
        print db.SQL_version(conn) 
        #创建游标
        cursor = db.SQL_cursor(conn)
        print u'创建游标完成'
        return True, cursor, db, conn
    except Exception,e:
        print u'连接数据库异常:' + str(e)
        return False, 0, 0, 0

def close_db(db, conn, cursor):
    db.SQL_cursor_close(cursor)
    db.SQL_connect_close(conn)
    print u'断开数据库连接'
    return True

def get_db_list(db, conn, cursor, sql_str,ori_list=[]):
    try:
        #print u'开始查询'
        db.SQL_cursor_execute(cursor,sql_str)
        #查找结果
        r = db.SQL_fetchall(cursor)
        if r == None or r == () or len(r) == 0:
            ori_list.append(['no_data'])
        #将结果放入结果池中
        else:
            for i in r:
                temp_list = []
                for j in i:
                    temp_list.append(j)
                ori_list.append(temp_list)
        #print u'查询完成'
        return ori_list
    except Exception,e:
        print u'数据库异常:' + str(e)
        return False


def main():
    str_sql = "select mername from t_pay_order_info_his where id = "
    str_sql = str_sql + "''"
    print str_sql
    db = SQL_class()
    print u"连接数据库"
    conn = db.SQL_connect("","","")
    print u"获取数据库版本号"
    print db.SQL_version(conn)
    print u"创建游标"
    cursor = db.SQL_cursor(conn)
    print u"执行脚本"
    db.SQL_cursor_execute(cursor,str_sql)
    print u"输出查询结果"
    m = db.SQL_fetchone(cursor)
    print m
    print u"关闭游标"
    db.SQL_cursor_close(cursor)
    print u"关闭数据库"
    db.SQL_connect_close(conn)

if __name__ == '__main__' : main()

##charecterset
echo 'LANG="en_US.UTF-8"'>>/etc/sysconfig/i18n
source /etc/sysconfig/i18n

##PermitUserEnvironment
echo 'PermitUserEnvironment yes' >>/etc/ssh/sshd_config

##install perl
yum install -y perl-ExtUtils-MakeMaker perl-Test-Simple perl-Pod-Coverage perl-Test-Pod-Coverage perl-Test-Pod-Coverage


##install odbc

tar -zxvf unixODBC-2.3.2.tar.gz 
./configure --prefix=/usr/local/unixODBC --sysconfdir=/etc
make
make install

export ODBCHOME=/usr/local/unixODBC
echo 'ODBCHOME=/usr/local/unixODBC' >> /etc/profile

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/unixODBC/lib
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/unixODBC/lib' >> /etc/profile


## config odbc dsn

#odbc database driver: ODBCInstLib=/usr/local/lib/libodbcinst.so
## for example vertica database
vi /etc/vertica.ini
[Driver]
DriverManagerEncoding=UTF-8
ODBCInstLib=/usr/local/lib/libodbcinst.so
#ODBCInstLib=/usr/local/unixODBC/lib/libodbcinst.so
ErrorMessagesPath=/opt/vertica/lib64
LogLevel=1
LogPath=/tmp

#odbc user dsn(USER DATA SOURCES)
vi ~/.odbc.ini
[dws]
Description = dws Database
Driver = /opt/vertica/lib64/libverticaodbc.so
Database = dws
Servername = 127.0.0.1
UID = dbadmin
PWD = 
Port = 5433
ConnSettings =

#odbc system dsn(SYSTEM DATA SOURCES)

vi /etc/odbc.ini
[dws]
Description = dws Database
Driver = /opt/vertica/lib64/libverticaodbc.so
Database = dws
Servername = 172.16.40.11
UID = dbadmin
PWD = dbadmin 
Port = 5433
ConnSettings =

#odbc drivers
vi /etc/odbcinst.ini
# Example driver definitions
# Driver from the mysql-connector-odbc package
# Setup from the unixODBC package
[MySQL]
Description     = ODBC for MySQL
Driver          = /usr/lib/libmyodbc5.so
Setup           = /usr/lib/libodbcmyS.so
Driver64        = /usr/lib64/libmyodbc5.so
Setup64         = /usr/lib64/libodbcmyS.so
FileUsage       = 1

[VerticaDSN]
Description 	= HP Vertica ODBC Driver
Driver 			= /opt/vertica/lib64/libverticaodbc.so


#unixODBC isql
[root@ ~]# isql -v dws
SQL> select sysdate;
+---------------------------+
| sysdate                   |
+---------------------------+
| 2017-05-08 18:24:59.743761|
+---------------------------+


## install perl dbi
/app/etl_adm/DBI-1.631

perl Makefile.PL
make
make test
make install

perl -e "use DBI;"

#### instal perl dbi dbd
/app/etl_adm/DBD-ODBC-1.50

perl Makefile.PL
make
make test
make install

unixODBC 2.3.2
DRIVERS............: /etc/odbcinst.ini
SYSTEM DATA SOURCES: /etc/odbc.ini
FILE DATA SOURCES..: /etc/ODBCDataSources
USER DATA SOURCES..: /root/.odbc.ini

or 

unixODBC 2.3.2
DRIVERS............: /usr/local/etc/odbcinst.ini
SYSTEM DATA SOURCES: /usr/local/etc/odbc.ini
FILE DATA SOURCES..: /usr/local/etc/ODBCDataSources
USER DATA SOURCES..: /root/.odbc.ini


## test dbi:ODBC:dws  (/etc/odbc.ini & ODBCInstLib=/usr/local/unixODBC/lib/libodbcinst.so)
use strict;
use DBI;
my $dbh = DBI->connect("dbi:ODBC:dws");
unless (defined $dbh) {
    die "Failed to connect: $DBI::errstr";
}
print "Connected!\n";
my $sth = $dbh->prepare("select sysdate;");
my $rv = $sth->execute;
print "$rv \n";
my $ary_ref  = $sth->fetchall_arrayref;
print $ary_ref->[0][0],"\n";
$dbh->disconnect();

## test dbi:ODBC:DRIVER=VerticaDSN  (/etc/odbcinst.ini)
## hp vertica loadbalence:SELECT NODE_NAME FROM V_MONITOR.CURRENT_SESSION
use strict;
use DBI;
my $server='172.16.40.11';
my $port = '5433';
my $database = 'dws';
my $user = 'dbadmin';
my $password = 'dbadmin';
my $dbh = DBI->connect("dbi:ODBC:DRIVER=VerticaDSN;Server=$server;ConnectionLoadBalance=1;" .
        "Port=$port;Database=$database;UID=$user;PWD=$password")
        or die "Could not connect to database: " . DBI::errstr; print "Connected!\n"; 

my $sth = $dbh->prepare("SELECT NODE_NAME FROM V_MONITOR.CURRENT_SESSION;"); $sth->execute();

while(my @row = $sth->fetchrow)
{
print "@row\n";
}

#################################################################
## ssh call perl dbi dbd:odbc
#################################################################
# PermitUserEnvironment
#              指定是否允许 sshd(8) 处理 ~/.ssh/environment 以及 ~/.ssh/authorized_keys 中的 environment= 选项。
#              默认值是"no"。如果设为"yes"可能会导致用户有机会使用某些机制(比如 LD_PRELOAD)绕过访问控制，造成安全漏洞。

##PermitUserEnvironment
echo 'PermitUserEnvironment yes' >>/etc/ssh/sshd_config

vi ~/.ssh/environment
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/unixODBC/lib
LANG=en_US.UTF-8

##test perl dbi
ssh etl_usr@127.0.0.1 'perl /app/perl_dbi_loadbalance_test.pl'
# install_driver(ODBC) failed: Can not load '/usr/local/lib64/perl5/auto/DBD/ODBC/ODBC.so' 
# for module DBD::ODBC: libodbc.so.2: cannot open shared object file: 
# No such file or directory at /usr/lib64/perl5/DynaLoader.pm line 200. at (eval 4) line 3 Compilation failed in require at (eval 4) line 3.
sudo perl /app/perl_dbi_loadbalance_test.pl
# install_driver(ODBC) failed: Can't load '/usr/local/lib64/perl5/auto/DBD/ODBC/ODBC.so' 
# for module DBD::ODBC: libodbc.so.2: cannot open shared object file: 
# No such file or directory at /usr/lib64/perl5/DynaLoader.pm line 200. at (eval 4) line 3



### known issue is  
### libodbc.so.2 => not found  
### Can t load '/usr/local/lib64/perl5/auto/DBD/ODBC/ODBC.so' for module DBD::ODBC: libodbc.so.2

[root@bjgg-sjjh ~]# sudo ldd /usr/local/lib64/perl5/auto/DBD/ODBC/ODBC.so

	linux-vdso.so.1 =>  (0x00007ffc05cdb000)
	libodbc.so.2 => not found
	libc.so.6 => /lib64/libc.so.6 (0x00007f4763741000)
	/lib64/ld-linux-x86-64.so.2 (0x00007f4763d08000)

[root@bjgg-sjjh ~]# ldd /usr/local/lib64/perl5/auto/DBD/ODBC/ODBC.so

	linux-vdso.so.1 =>  (0x00007ffe27d70000)
	libodbc.so.2 => /usr/local/lib/libodbc.so.2 (0x00007fbbdde10000)
	libc.so.6 => /lib64/libc.so.6 (0x00007fbbdda73000)
	libdl.so.2 => /lib64/libdl.so.2 (0x00007fbbdd86f000)
	libpthread.so.0 => /lib64/libpthread.so.0 (0x00007fbbdd652000)
	/lib64/ld-linux-x86-64.so.2 (0x00007fbbde2a6000)


### handle the issue
### 01:succeed
	### ldconfig and ldd
	### cache: /etc/ld.so.cache
	### /etc/ld.so.conf: include ld.so.conf.d/*.conf
echo '/usr/local/unixODBC/lib' > /etc/ld.so.conf.d/perl-odbc.conf
or
echo '/usr/local/unixODBC/lib' >> /etc/ld.so.conf

### 02:failed
	#LD_LIBRARY_PATH
	vi ~/.ssh/environment
	LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/unixODBC/lib
	LANG=en_US.UTF-8
### 03:


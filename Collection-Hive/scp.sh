man #!/usr/bin/expect
set timeout 100
set host [lindex $argv 0]
set username [lindex $argv 1]
set password [lindex $argv 2]
set src_file [lindex $argv 3]
set dest_file [lindex $argv 4]

spawn scp $src_file $username@$host:$dest_file
expect "*password:"
send "$password\n"
expect "100%"
expect eof

# expect scp.sh '192.168.7.78' 'etl_adm' '123' '/DXP/DATA/EDW/ROUT/BEIJING_WO_USER_ADD_2016-11-02.DAT' '/app/sftp/wzhdataftp/beijing/BEIJING_WO_USER_ADD_2016-11-02.DAT'

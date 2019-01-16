#!/usr/bin/expect
set timeout 10
set host [lindex $argv 0]
set username [lindex $argv 1]
set password [lindex $argv 2]
set src_file [lindex $argv 3]
set dest_file [lindex $argv 4]


spawn sftp $username@$host
expect "*password:"
send "$password\n"
expect ">"
send "put $src_file $dest_file \r"
expect ">"
send "bye\r"
expect eof

 # expect sftp.sh '' '' '' '/DXP/DATA/EDW/ROUT/BEIJING_WO_USER_ADD_2016-11-02.DAT' '/app/sftp/wzhdataftp/beijing/BEIJING_WO_USER_ADD_2016-11-02.DAT'
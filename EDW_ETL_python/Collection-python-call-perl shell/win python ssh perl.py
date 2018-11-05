#!/usr/bin/python   
import paramiko

server_ip = '0.0.0.0';
server_user = 'etl_adm';
server_passwd = r'etl_adm123!@#';
server_port = 22  
  
def ssh_connect():  
    ssh = paramiko.SSHClient()  
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy());
    ssh.connect(server_ip, server_port,server_user, server_passwd);
    return ssh ;
      
def ssh_disconnect(client):  
    client.close();
      
def exec_cmd(command,ssh):
    stdin, stdout, stderr = ssh.exec_command(command);
    err = stderr.readline();
    out = stdout.readline();
    if "" != err:  
        print("command: " + command+ out + " exec failed!\nERROR :" + err);
        #return true, err
    else:  
        print("command: " + command + " exec success.");


my_cmmand=r'perl /app/etlscript/BDW_FDL/bdwfdletl.pl 2016-11-29 BDW_FDL fdl_t02_pos_refund';
#my_demo=r'perl /app/testscript/book_1.pl';
my_ssh=ssh_connect();
#exec_cmd(my_demo,my_ssh);
exec_cmd(my_cmmand,my_ssh);

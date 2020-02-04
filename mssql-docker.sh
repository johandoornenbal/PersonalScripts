#!/bin/bash
echo -n "Enter container name  > "
read container_name

if docker ps -a | grep -q $container_name; then
   msg="container was already there; trying to start container"
   echo $msg $container_name
   docker start $container_name
else 
   msg="creating and starting new container" 
   echo $msg $container_name
   docker run -d --name $container_name -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=reallyStrongPwd123' -e MSSQL_COLLATION='Latin1_General_CI_AS' -p 1433:1433 mcr.microsoft.com/mssql/server:2017-latest
fi

echo -n "Enter backup file path (end with '/' )> "
read backup_file_path
echo -n "Enter backup file name (without .bak extention)  > "
read backup_file_name
echo -n "Enter desired new db name > "
read new_db_name
extension='.bak'
full_bu_file_name=$backup_file_name$extension

echo "creating backup dir in container"
docker exec -it $container_name mkdir /var/opt/mssql/backup

echo "trying to copy backup file"
bak=$backup_file_path$full_bu_file_name
echo $bak
docker cp $bak $container_name:/var/opt/mssql/backup

q_str_1=" 'RESTORE DATABASE "
q_str_2=' FROM DISK = "/var/opt/mssql/backup/'
q_str_3='" WITH MOVE "'
q_str_4='" TO "/var/opt/mssql/data/'
q_str_5='.mdf", MOVE "'
q_str_6='_log" TO "/var/opt/mssql/data/'
q_str_7=".ldf\"'"

q_string=$q_str_1$new_db_name$q_str_2$full_bu_file_name$q_str_3$backup_file_name$q_str_4$new_db_name$q_str_5$backup_file_name$q_str_6$new_db_name$q_str_7

# For some reason the following is not working
# docker exec -it $container_name /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P 'reallyStrongPwd123' -Q$q_string

echo "***********************"
echo "The following restore command is not working form the script. Please copy and run manually"
s1='docker exec -it '
s2=' /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P 'reallyStrongPwd123' -Q '
echo $s1$container_name$s2$q_string



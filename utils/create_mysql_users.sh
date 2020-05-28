#!/bin/bash
# create with good vibes by: @chaconmelgarejo
# description: create users in mysql servers
# usage: ./create_mysql_users.sh [user] [endpoint] [SELECT,INSERT,DELETE, UPDATE] [db]
echo "Creating User MySQL"

# create random password
user_pass="$(openssl rand -base64 16)"

#database username
user=$1

#rds_endpoint
rds_endpoint=$2

#privileges  SELECT,INSERT,DELETE, UPDATE
privileges=$3

#database name
db=$4
root_pass=$5

dump="<< MYSQL_SCRIPT
CREATE USER '$user'@'%' IDENTIFIED BY '$user_pass';
GRANT $privileges ON $db.* TO '$user'@'%';
FLUSH PRIVILEGES;
MYSQL_SCRIPT"

error_cf2=$(mysql -u dba -h $rds_endpoint -D $db -p $dump 2>&1 1>/dev/null)

if [ $? -eq 0 ]; then
   echo "good job, go ahead!"
   echo " user: $user pass:$user_pass on $rds_endpoint"
else
   echo "opsss, we got an error:--> $error"
   echo "usage: ./create_mysql_users.sh [user] [endpoint] [SELECT,INSERT,DELETE, UPDATE] [db]"
fi

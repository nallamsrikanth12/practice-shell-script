#!/bin/bash

USERID=$(id -u)
TIMESTAND=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 |cut -d "."  -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAND.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

echo "Please enter DB password:"
read -s mysql_root_password

if [ $USERID -ne 0 ]
then
    echo -e "$R you are not root user $N"
else
    echo -e "$G you are a super user $N"
fi

VALIDATE (){
    if [ $1 -ne 0 ] 
    then
        echo -e " $R $2 is failure $N "
    else
        echo -e  " $G $2 is sucuess $N"
    fi
}       

dnf install mysql-server -y
VALIDATE $? "installl mysql"

systemctl enable mysqld
VALIDATE $? "enable mysqld"

systemctl start mysqld
VALIDATE $? "start mysqld"

mysql -h db.srikantheswar.online -uroot -p${mysql_root_password} -e 'show databases;' &>>$LOGFILE

if [ $? -ne 0 ]
then 
    echo "mysql_secure_installation --set-root-pass ${mysql_root_password}
    VALIDATE $? "set root password sucuessfully"
else 
    echo  -e "root password is already set up $Y skipping $N"
fi




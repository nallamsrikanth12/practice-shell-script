#!/bin/bash

USERID=$(id -u)
TIMESTAND=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 |cut -d "."  -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAND.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


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

mysql_secure_installation --set-root-pass ExpenseApp@1
VALIDATE $? "set root password sucuessfully"


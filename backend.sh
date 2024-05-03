#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

echo "enter the password"
read -s sql_root_password

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
if [ $USERID -ne 0 ]
then 
    echo -e " $R you are not super user $N"
else
    echo -e  "$G you are a super user $N"
fi

VALIDATE (){
    if [ $1 -ne 0 ]
    then
        echo -e " $R $2 is failure $N"
    else
        echo -e  "$G $2 is succuess $N"
    fi    
}

dnf module disable nodejs -y
VALIDATE $? "disable nodejs"

dnf module enable nodejs:20 -y
VALIDATE $? "enable nodejs"

dnf install nodejs -y
VALIDATE $? "install nodejs"

id  expense

if [ $? -ne 0 ]
then    
    echo -e "useradd expense"
else
    echo -e "alreay user is created is $Y skkiping $N"
fi

mkdir -p /app
VALIDATE $? "create app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip
VALIDATE $? "download the backend code"
cd /app
rm -rf /app/*

unzip /tmp/backend.zip
VALIDATE $? "unzip the code"

cd /app
npm install
VALIDATE $? "install npm"


cp /home/ec2-user/practice-shell-script/backend.service /etc/systemd/system/backend.service
VALIDATE $? "copy the backend.service"

systemctl daemon-reload
VALIDATE $? "daemon reload"

systemctl start backend
VALIDATE $? "start backend"

systemctl enable backend
VALIDATE $? "enable backend"

dnf install mysql -y
VALIDATE $? "install the mysql"

mysql -h <db.srikantheswar.online> -uroot -p${sql_root_password} < /app/schema/backend.sql &>>LOGFILE




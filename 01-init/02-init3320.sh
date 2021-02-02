. ./comm.sh

#************************************************
#* This is to initialize mysql data directory
#* 	for 3320
#* It is --initialize-insecure
#* root has no password
#************************************************

if [ -r /home/mysql/data/3320 ]
then
	rm -rf /home/mysql/data/3320
fi

if [ $USER != "mysql" ]
then
	exit 1
fi


mysqld --defaults-file=config/my2.cnf --initialize-insecure

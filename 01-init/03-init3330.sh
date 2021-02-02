. ./comm.sh

#************************************************
#* This is to initialize mysql data directory
#* 	for 3330
#* It is --initialize-insecure
#* root has no password
#************************************************

if [ -r /home/mysql/data/3330 ]
then
	rm -rf /home/mysql/data/3330
fi

if [ $USER != "mysql" ]
then
	exit 1
fi


mysqld --defaults-file=config/my3.cnf --initialize-insecure

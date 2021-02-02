. ./comm.sh

#************************************************
#* This is to initialize mysql data directory
#* 	for 3310
#* It is --initialize-insecure
#* root has no password
#************************************************

if [ -r /home/mysql/data/3310 ]
then
	rm -rf /home/mysql/data/3310
fi

if [ $USER != "mysql" ]
then
	exit 1
fi


mysqld --defaults-file=config/my1.cnf --initialize-insecure

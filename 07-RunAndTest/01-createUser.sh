mysql -uroot -h127.0.0.1 -P3310 -e "
create user demo@'%' identified by 'demo';
grant all on *.* to demo@'%';
"


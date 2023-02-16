mysqlsh -e "
dba.checkInstanceConfiguration('gradmin:grpass:@localhost:3310')
dba.checkInstanceConfiguration('gradmin:grpass:@localhost:3320')
dba.checkInstanceConfiguration('gradmin:grpass:@localhost:3330')
"


 mysqlsh --uri gradmin:grpass@`hostname`:3310 --sql -e "select @@gtid_executed;"
 mysqlsh --uri gradmin:grpass@`hostname`:3320 --sql -e "select @@gtid_executed;"
 mysqlsh --uri gradmin:grpass@`hostname`:3330 --sql -e "select @@gtid_executed;"

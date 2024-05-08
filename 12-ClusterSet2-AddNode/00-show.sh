. ./comm.sh

mysqlsh --js --uri gradmin:grpass@`hostname`:3310 -e "
y = dba.getClusterSet();
print(y.status({extended:1}))
"






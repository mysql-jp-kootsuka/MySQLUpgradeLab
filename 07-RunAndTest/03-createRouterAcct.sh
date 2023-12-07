mysqlsh --uri gradmin:grpass@`hostname`:3310 -e "
var x = dba.getCluster()
x.setupRouterAccount('routeruser', {password:'routerpass'})
"



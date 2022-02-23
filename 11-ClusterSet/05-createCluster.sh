. ./comm.sh

mysqlsh --uri gradmin:grpass@`hostname`:3310 -e "

x = dba.getCluster()
x.createClusterSet('myclusterset')
"

mysqlsh --uri gradmin:grpass@`hostname`:3310 -e "
y = dba.getClusterSet()
y.createReplicaCluster('`hostname`:3340', 'mycluster2', {
	consistency:'BEFORE_ON_PRIMARY_FAILOVER',
	expelTimeout:30,
	memberSslMode:'REQUIRED',
	ipAllowlist:'10.0.0.0/16',
	interactive:false,
	localAddress:'`hostname`:13340',
	autoRejoinTries:120,
	memberWeight:80,
	recoveryMethod:'incremental'
	})
y = dba.getCluster('mycluster2')
print(y.status())
"

sleep 5

mysqlsh --uri gradmin:grpass@`hostname`:3340 -e "
x = dba.getCluster()
x.addInstance('gradmin:grpass@`hostname`:3350', {exitStateAction:'OFFLINE_MODE', 
	ipAllowlist:'10.0.0.0/16',
	recoveryMethod:'incremental', 
	localAddress:'`hostname`:13350',
	autoRejoinTries:120,
	memberWeight:70
	})
print(x.status())
"

sleep 5

mysqlsh --uri gradmin:grpass@`hostname`:3340 -e "
x = dba.getCluster()
x.addInstance('gradmin:grpass@`hostname`:3360', {exitStateAction:'OFFLINE_MODE', 
	ipAllowlist:'10.0.0.0/16',
	recoveryMethod:'incremental', 
	localAddress:'`hostname`:13360',
	autoRejoinTries:120,
	memberWeight:60
	})
print(x.status())
"


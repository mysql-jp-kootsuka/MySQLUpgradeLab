. ./comm.sh

mysqlsh --uri gradmin:grpass@`hostname`:3310 -e "
y = dba.getClusterSet()
y.removeCluster('mycluster2')
print(y.status())
"

mysqlsh --uri gradmin:grpass@`hostname`:3310 -e "
c1 = dba.getCluster('mycluster');
c1.addInstance('gradmin:grpass@`hostname`:3340', {exitStateAction:'OFFLINE_MODE', 
	recoveryMethod:'incremental', 
	autoRejoinTries:120,
	localAddress:'workshop23:3340',
	memberWeight:70
	})
print(c1.status())
"

mysqlsh --uri gradmin:grpass@`hostname`:3310 -e "
y = dba.getCluster('mycluster')
y.removeInstance('`hostname`:3330')
print(dba.getClusterSet().status({extended:1}))
"

mysqlsh --uri gradmin:grpass@`hostname`:3310 -e "
y = dba.getClusterSet()
y.createReplicaCluster('`hostname`:3330', 'mycluster2', {
	consistency:'BEFORE_ON_PRIMARY_FAILOVER',
	expelTimeout:30,
	memberSslMode:'REQUIRED',
	interactive:false,
	autoRejoinTries:120,
	memberWeight:80,
	localAddress:'workshop23:3330',
	recoveryMethod:'incremental'
	})
y = dba.getCluster('mycluster2')
print(dba.getClusterSet().status({extended:1}))
"






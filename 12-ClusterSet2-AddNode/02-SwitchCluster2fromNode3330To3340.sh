. ./comm.sh

mysqlsh --js --uri gradmin:grpass@`hostname`:3310 -e "
y = dba.getClusterSet()
y.removeCluster('mycluster2')
print(y.status())
"

mysqlsh --js --uri gradmin:grpass@`hostname`:3310 -e "
c1 = dba.getCluster('mycluster');
c1.addInstance('gradmin:grpass@`hostname`:3330', {exitStateAction:'OFFLINE_MODE', 
	recoveryMethod:'incremental', 
	autoRejoinTries:120,
	localAddress:'workshop23:3330',
	memberWeight:70
	})
print(c1.status())
"

mysqlsh --js --uri gradmin:grpass@`hostname`:3310 -e "
y = dba.getCluster('mycluster')
y.removeInstance('`hostname`:3340')
print(dba.getClusterSet().status({extended:1}))
"

mysqlsh --js --uri gradmin:grpass@`hostname`:3310 -e "
y = dba.getClusterSet()
y.createReplicaCluster('`hostname`:3340', 'mycluster2', {
	consistency:'BEFORE_ON_PRIMARY_FAILOVER',
	expelTimeout:30,
	memberSslMode:'REQUIRED',
	interactive:false,
	autoRejoinTries:120,
	memberWeight:80,
	localAddress:'workshop23:3340',
	recoveryMethod:'incremental'
	})
y = dba.getCluster('mycluster2')
print(dba.getClusterSet().status({extended:1}))
"






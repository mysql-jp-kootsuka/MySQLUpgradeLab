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





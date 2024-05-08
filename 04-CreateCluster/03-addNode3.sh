mysqlsh --js --uri gradmin:grpass@`hostname`:3310 -e " 
x = dba.getCluster()
x.addInstance('gradmin:grpass@`hostname`:3330', {exitStateAction:'OFFLINE_MODE', 
	recoveryMethod:'clone', 
	autoRejoinTries:120,
	memberWeight:60
	})

print( x.status())
"


mysqlsh --js --uri gradmin:grpass@`hostname`:3310 -e " 
x = dba.getCluster()
x.addInstance('gradmin:grpass@`hostname`:3320', {exitStateAction:'OFFLINE_MODE',
        recoveryMethod:'incremental',
        autoRejoinTries:120,
        memberWeight:70
        })
print(x.status())
"


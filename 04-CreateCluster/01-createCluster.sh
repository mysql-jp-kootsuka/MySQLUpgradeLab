mysqlsh --uri gradmin:grpass@`hostname`:3310 -e " 
var x = dba.createCluster('mycluster' ,  \
	{exitStateAction:'OFFLINE_MODE',\
        consistency:'BEFORE_ON_PRIMARY_FAILOVER',\
        expelTimeout:30,\
        memberSslMode:'REQUIRED',\
        clearReadOnly:true,\
        autoRejoinTries:120,\
        memberWeight:80\
        })
print(x.status())
"

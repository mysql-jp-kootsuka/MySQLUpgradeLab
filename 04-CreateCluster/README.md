# This is to create a Cluster using MySQL Shell
#
1. connect to MySQL SHell
```
mysqlsh --uri gradmin:grpass@`hostname`:3310 

```

2. Create a Cluster with options and show the cluster status with 1 member node
```
var x = dba.createCluster('mycluster')
x.status()
x.options()
```

The following is the sample output :
```
 MySQL  ##hostname##:3310 ssl  JS > x.options()
{
    "clusterName": "mycluster",
    "defaultReplicaSet": {
        "globalOptions": [
            {
                "option": "groupName",
                "value": "5da2b9ac-6546-11eb-8893-0200170ae159",
                "variable": "group_replication_group_name"
            },
            {
                "option": "memberSslMode",
                "value": "REQUIRED",
                "variable": "group_replication_ssl_mode"
            },
            {
                "option": "disableClone",
                "value": false
            }
        ],
        "tags": {
            "global": [],
            "##hostname##:3310": []
        },
        "topology": {
            "##hostname##:3310": [
                {
                    "option": "autoRejoinTries",
                    "value": "3",
                    "variable": "group_replication_autorejoin_tries"
                },
                {
                    "option": "consistency",
                    "value": "EVENTUAL",
                    "variable": "group_replication_consistency"
                },
                {
                    "option": "exitStateAction",
                    "value": "READ_ONLY",
                    "variable": "group_replication_exit_state_action"
                },
                {
                    "option": "expelTimeout",
                    "value": "5",
                    "variable": "group_replication_member_expel_timeout"
                },
                {
                    "option": "groupSeeds",
                    "value": "",
                    "variable": "group_replication_group_seeds"
                },
                {
                    "option": "ipAllowlist",
                    "value": "AUTOMATIC",
                    "variable": "group_replication_ip_allowlist"
                },
                {
                    "option": "ipWhitelist",
                    "value": "AUTOMATIC",
                    "variable": "group_replication_ip_whitelist"
                },
                {
                    "option": "localAddress",
                    "value": "##hostname##:33101",
                    "variable": "group_replication_local_address"
                },
                {
                    "option": "memberWeight",
                    "value": "50",
                    "variable": "group_replication_member_weight"
                },
                {
                    "value": "WRITESET",
                    "variable": "binlog_transaction_dependency_tracking"
                },
                {
                    "value": "LOGICAL_CLOCK",
                    "variable": "slave_parallel_type"
                },
                {
                    "value": "4",
                    "variable": "slave_parallel_workers"
                },
                {
                    "value": "ON",
                    "variable": "slave_preserve_commit_order"
                },
                {
                    "value": "XXHASH64",
                    "variable": "transaction_write_set_extraction"
                }
            ]
        }
    }
}
```

3. Check the options for the cluster and mark down the options for the following :
..* "consistency"
..* "expelTimeout"
..* "ipAllowlist"
..* "memberWeight"
..* "autoRejoinTries"
..* "exitStateAction"


3. Destroy (Dissolve) the cluster (answer "Y" to confirm)

```
var x = dba.getCluster()
x.dissolve()
```


4. Recreate the cluster again by defining option (please change the hostname ('##hostname##') to your hostname accordingly)
```
mysqlsh --uri gradmin:grpass@`hostname`:3310 -e " 
var x = dba.createCluster('mycluster' ,  \
	{exitStateAction:'OFFLINE_MODE',\
        consistency:'BEFORE_ON_PRIMARY_FAILOVER',\
        expelTimeout:30,\
        memberSslMode:'REQUIRED',\
        ipAllowlist:'10.0.0.0/16',\
        clearReadOnly:true,\
        localAddress:'`hostname`:13310',\
        autoRejoinTries:120,\
        memberWeight:80\
        })
print(x.status())
"

```


5. Adding node2 (3320) to the cluster using Incremental.   This is possible only because the server is clean where all servers were empty GTID.  Please change the hostname <##hostname##> to your hostname accordingly

```
mysqlsh --uri gradmin:grpass@`hostname`:3310 -e " 
x = dba.getCluster()
x.addInstance('gradmin:grpass@`hostname`:3320', {exitStateAction:'OFFLINE_MODE',
        recoveryMethod:'incremental',
        ipAllowlist:'10.0.0.0/16',
        localAddress:'`hostname`:13320',
        autoRejoinTries:120,
        memberWeight:70
        })
print(x.status())
"
```


6. Adding node3 (3330) to the cluster using CLONE (note : change hostname<##hostname##> with your hostname
```
mysqlsh --uri gradmin:grpass@`hostname`:3310 -e " 
x = dba.getCluster()
x.addInstance('gradmin:grpass@`hostname`:3330', {exitStateAction:'OFFLINE_MODE', 
	recoveryMethod:'clone', 
	ipAllowlist:'10.0.0.0/16',
	localAddress:'`hostname`:13330',
	autoRejoinTries:120,
	memberWeight:60
	})

print( x.status())
"
```


# MySQL InnoDB ClusterSet
## Pre-requisit
### 1. Running MySQL Cluster with 3310,3320,330

## Step 1
### Creating 3 Instances - 3340, 3350 and 3360
```
	mysqld --defaults-file=config/my4.cnf --initialize-insecure
	mysqld --defaults-file=config/my5.cnf --initialize-insecure
	mysqld --defaults-file=config/my6.cnf --initialize-insecure
```

## Step 2
### Starting up 3 instances
```
	mysqld_safe --defaults-file=config/my4.cnf &
	mysqld_safe --defaults-file=config/my5.cnf &
	mysqld_safe --defaults-file=config/my6.cnf &
```

## Step 3
### Configuring the 3 instances with cluster Admin User
```
mysqlsh -e "
dba.configureInstance('root:@localhost:3340',{clusterAdmin:'gradmin',clusterAdminPassword:'grpass'});
dba.configureInstance('root:@localhost:3350',{clusterAdmin:'gradmin',clusterAdminPassword:'grpass'});
dba.configureInstance('root:@localhost:3360',{clusterAdmin:'gradmin',clusterAdminPassword:'grpass'});
"
```

## Step 4
###  Creating ClusterSet ('myclusterset') on existing running cluster 3310,3320,330
```
mysqlsh --uri gradmin:grpass@`hostname`:3310 -e "

x = dba.getCluster()
x.createClusterSet('myclusterset')
"
```

## Step 5
### Creating Replicated Cluster from the clusterset "myclusterset"

```
mysqlsh --uri gradmin:grpass@`hostname`:3310 -e "
y = dba.getClusterSet()
y.createReplicaCluster('`hostname`:3340', 'mycluster2', {
	consistency:'BEFORE_ON_PRIMARY_FAILOVER',
	expelTimeout:30,
	memberSslMode:'REQUIRED',
	interactive:false,
	autoRejoinTries:120,
	memberWeight:80,
	recoveryMethod:'incremental'
	})
x = dba.getCluster('mycluster2')
print(x.status())
"
```

## Step 6
### Adding the 2 instances to the cluster "mycluster2"

```
mysqlsh --uri gradmin:grpass@`hostname`:3340 -e "
x = dba.getCluster()
x.addInstance('gradmin:grpass@`hostname`:3350', {exitStateAction:'OFFLINE_MODE', 
	recoveryMethod:'incremental', 
	autoRejoinTries:120,
	memberWeight:70
	})
print(x.status())
"


mysqlsh --uri gradmin:grpass@`hostname`:3340 -e "
x = dba.getCluster()
x.addInstance('gradmin:grpass@`hostname`:3360', {exitStateAction:'OFFLINE_MODE', 
	recoveryMethod:'incremental', 
	autoRejoinTries:120,
	memberWeight:60
	})
print(x.status())
"
```

## Step 7
###  Checking status

```
mysqlsh --uri gradmin:grpass@`hostname`:3310 -e "
x = dba.getClusterSet()
print(x.status())
print(dba.getCluster('mycluster').status())
print(dba.getCluster('mycluster2').status())
"
```


## Step 8
### Switching Cluster from mycluster to mycluster2 and back.

```
mysqlsh --uri gradmin:grpass@`hostname`:3310 -e "
x = dba.getClusterSet()
print(x.status())

x.setPrimaryCluster('mycluster2')
print(x.status())
x.setPrimaryCluster('mycluster')
print(x.status())

"
```



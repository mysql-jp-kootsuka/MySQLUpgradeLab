# This lab exercise is to provide administration of InnoDB Cluster
## Remember to change all 'workshop8' in this README.md to your hostname
##
1. Showing cluster status with options
2. Setting and showing cluster options
3. Shutdown MySQL Server and Restart individual Server
4. Shutdown all server and reboot whole InnoDB Cluster


## Login to InnoDB Cluster node with MySQL Shell
```
mysqlsh --uri gradmin:grpass@workshop8:3310

```

## Showing cluster status with options
  * Getting help info for a object function

```
mysqlsh JS> var x = dba.getCluster()
mysqlsh JS> x.status()
mysqlsh JS> x.help('status')
```

  * The "extended" option provides more details about the InnoDB Cluster.  Value can be 0,1,2 and 3.

```
mysqlsh JS> x.status({extended:1})
mysqlsh JS> x.status({extended:2})
mysqlsh JS> x.status({extended:3})
```

## Setting and showing cluster options
  * setting the tags  (Change workshop8 to your hostname)
```
mysqlsh JS> x.options()
mysqlsh JS> x.setInstanceOption('workshop8:3330', 'tag:_hidden', 'true')
```

  * Showing the tags  (Change workshop8 to your hostname)
```
mysqlsh JS> var theoptions = x.options()
mysqlsh JS> theoptions.defaultReplicaSet.tags
mysqlsh JS> theoptions.defaultReplicaSet.topology['workshop8:3310']
mysqlsh JS> theoptions.defaultReplicaSet.topology['workshop8:3320']
mysqlsh JS> theoptions.defaultReplicaSet.topology['workshop8:3330']
```

  * Combine the command in one line
```
mysqlsh JS> x.options().defaultReplicaSet.tags

```


## Shutdown MySQL Server and Restart individual Server

  * Shutdown node 3310 and check the status to see which server is to be Primary node (R/W)

```
mysql -uroot -h127.0.0.1 -P3310 -e "shutdown;"
```

  * Now Check the InnoDB Cluster status (using mysqlsh to login to available node)
```
mysqlsh --uri gradmin:grpass@workshop8:3320 -e "print(dba.getCluster().status())"
```

  * Startup MySQL node for 3310 
```
/usr/local/mysql/bin/mysqld_safe --defaults-file=config/my1.cnf &
```

  * Now Check the InnoDB Cluster status - Check if node 3310 is ONLINE
```
mysqlsh --uri gradmin:grpass@workshop8:3320 -e "print(dba.getCluster().status())"
```

  * Login to node (any available node) using MySQL Shell and set Primary Node 
```
mysqlsh --uri gradmin:grpass@workshop8:3320
mysqlsh JS> var x = dba.getCluster()
mysqlsh JS> x.setPrimaryInstance('workshop8:3310')
mysqlsh JS> x.status()

```
  * Configure Applier threads to 3 for node 3320
```
mysqlsh JS> dba.configureInstance("gradmin:grpass@workshop8:3320", {applierWorkerThreads: 3})
mysqlsh JS> x.options().defaultReplicaSet.topology['workshop8:3320']

```

## Shutdown all servers and reboot whole InnoDB Cluster

  * Shutdown all servers
```
mysql -uroot -h127.0.0.1 -P3330 -e "shutdown;"
mysql -uroot -h127.0.0.1 -P3320 -e "shutdown;"
mysql -uroot -h127.0.0.1 -P3310 -e "shutdown;"
```
and make sure no more mysqld is running
```
ps -ef|grep mysqld
```


Wait for a moment to make sure all servers are cleanly shutdown and exit.

  * Startup  all servers

```
/usr/local/mysql/bin/mysqld_safe --defaults-file=config/my1.cnf &
/usr/local/mysql/bin/mysqld_safe --defaults-file=config/my2.cnf &
/usr/local/mysql/bin/mysqld_safe --defaults-file=config/my3.cnf &
```

  * Connect to available node using MySQL Shell
```
mysqlsh --uri gradmin:grpass@workshop8:3310
```

  * Getting Cluster object fails and reports error
```
mysqlsh JS> var x = dba.getCluster()
```

  * Getting error  message as shown :
```
Dba.getCluster: This function is not available through a session to a standalone instance (metadata exists, instance belongs to that metadata, but GR is not active) (MYSQLSH 51314)
```

  * Reboot InnoDB Cluster and confirm rejoin for all nodes
```
mysqlsh JS> dba.rebootClusterFromCompleteOutage()
mysqlsh JS> var x = dba.getCluster()
mysqlsh JS> x.status()
```

  * Same output as follows : 
```
Restoring the default cluster from complete outage  .

The instance 'workshop8:3320' was part of the cluster configuration.
Would you like to rejoin it to the cluster? [y/N]: y

The instance 'workshop8:3330' was part of the cluster configuration.
Would you like to rejoin it to the cluster? [y/N]: y

workshop8:3310 was restored.
Rejoining 'workshop8:3320' to the cluster.
Rejoining instance 'workshop8:3320' to cluster 'mycluster'  .
The instance 'workshop8:3320' was successfully rejoined to the cluster.

Rejoining 'workshop8:3330' to the cluster.
Rejoining instance 'workshop8:3330' to cluster 'mycluster'  .
The instance 'workshop8:3330' was successfully rejoined to the cluster.

The cluster was successfully rebooted.

<Cluster:mycluster>
```



# InnoDBClusterLab
## This is the Lab exercise about building InnoDB Cluster
##
## Environment 
	MySQL Home   : /usr/local/mysql
	MySQL Shell  : /usr/local/shell
	MySQL Router : /usr/local/router
## Data
	3310 : /home/mysql/data/3310
	3320 : /home/mysql/data/3310
	3330 : /home/mysql/data/3310

## Preparation
### Ensure there are no mysqld service running
1. login as opc
2. Stop the services
```
sudo systemctl stop mysqld@mysql01
sudo systemctl stop mysqld@mysql02
sudo systemctl stop mysqld@mysql03
sudo systemctl stop mysqld
```

3. Check if any mysqld is running
```
ps -ef|grep mysqld
```

4. Change user to mysql
```
sudo su mysql
```

5. Using git to clone InnoDB Cluster environment (mysql as user)
```
cd  /home/mysql
mkdir lab
cd lab
git clone https://github.com/ivanxma/InnoDBClusterLab
cd InnoDBClusterLab
```


## The exercise includes



1. Initialize 3 servers on the same VM
2. Configuration for GTID
3. Using MySQL Shell and  Configure Group Replication Admin User & settings 
4. Creating InnoDB Cluster - 1 member, and add 2nd node using Incremental, and add 3rd node usign Clone
5. Administrate InnoDB Cluster
7. Adding a member node to the InnoDB Cluster using Incremental Replication
8. Checking InnoDB Cluster Status
9. Bootstrap MySQL Router and Test running mysql client to the Router
10. Backing up MySQL InnoDB Cluster using MySQL Enterprise Backup
11. Creating NEW server for Replca from the InnoDB Cluster
12. Creating Replication User on InnoDB Cluster
13. Adding the New Server to the InnoDB Cluster and remove the node
14. Creating Replication Channel on the Replica


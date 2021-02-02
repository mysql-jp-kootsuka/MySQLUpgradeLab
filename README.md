# InnoDBClusterLab
## This is the Lab exercise about building InnoDB Cluster
##
## Environment 
###	MySQL Home   : /usr/local/mysql
###	MySQL Shell  : /usr/local/shell
###	MySQL Router : /usr/local/router
## Data
###	3310 : /home/mysql/data/3310
###	3320 : /home/mysql/data/3310
###	3330 : /home/mysql/data/3310

## Preparation
### Ensure there are no mysqld service running

1. login as opc
2. Stop the services
```
sudo systemctl stop mysqld@mysql01
sudo systemctl stop mysqld@mysql02
sudo systemctl stop mysqld@mysql03
sudo systemctl stop mysqld


## The exercise includes



1. Initialize 3 servers on the same VM
2. Configuration for GTID
3. Using MySQL Shell
4. Configure Group Replication Admin User and settings 
5. Creating InnoDB Cluster - 1 member
6. Adding a member node to the InnoDB Cluster using Clone
7. Adding a member node to the InnoDB Cluster using Incremental Replication
8. Checking InnoDB Cluster Status
9. Bootstrap MySQL Router and Test running mysql client to the Router
10. Backing up MySQL InnoDB Cluster using MySQL Enterprise Backup
11. Creating NEW server for Replca from the InnoDB Cluster
12. Creating Replication User on InnoDB Cluster
13. Adding the New Server to the InnoDB Cluster and remove the node
14. Creating Replication Channel on the Replica


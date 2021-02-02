# Using MySQL Shell

1. Starting MySQL shell and connect to localhost:3310 (note : root has no password)
```
mysqlsh --uri root@localhost:3310
```
2. Getting help on MySQL Shell
```
mysqlsh> \h
mysqlsh> \h shell
mysqlsh> \h shell.status
mysqlsh> \h dba
mysqlsh> \h dba.createCluster
mysqlsh> \h dba.getClusuter
```

3. Getting MySQL Shell Status and Showing options
```
mysqlsh> shell.status()
mysqlsh> shell.options
mysqlsh> shell.options["history.autoSave"] = true
mysqlsh> shell.options

```

4. Swithing to SQL mode & JS mode &Python mode
```
mysqlsh JS> \sql
mysqlsh SQL> SELECT 1;
mysqlsh SQL > \py
mysqlsh Py>
mysqlsh Py> \js
mysqlsh JS> \sql SELECT 1;
mysqlsh JS> \quit
```


5. Configure Group Replication Administrator
```
mysqlsh -e "
dba.configureInstance('root:@localhost:3310',{clusterAdmin:'gradmin',clusterAdminPassword:'grpass'});
dba.configureInstance('root:@localhost:3320',{clusterAdmin:'gradmin',clusterAdminPassword:'grpass'});
dba.configureInstance('root:@localhost:3330',{clusterAdmin:'gradmin',clusterAdminPassword:'grpass'});
"
```

Please note : you may see certain configurations not setup correctly and it requires fixes.  Follow the instruction.  And type "Y" to apply configuration changes.

```
Configuring local MySQL instance listening at port 3310 for use in an InnoDB cluster...

This instance reports its own address as workshop8:3310
Clients and other cluster members will communicate with it through this address by default. If this is not correct, the report_host MySQL system variable should be changed.
Assuming full account name 'gradmin'@'%' for gradmin

applierWorkerThreads will be set to the default value of 4.

NOTE: Some configuration options need to be fixed:
+----------------------------------------+---------------+----------------+----------------------------+
| Variable                               | Current Value | Required Value | Note                       |
+----------------------------------------+---------------+----------------+----------------------------+
| binlog_transaction_dependency_tracking | COMMIT_ORDER  | WRITESET       | Update the server variable |
| slave_parallel_type                    | DATABASE      | LOGICAL_CLOCK  | Update the server variable |
| slave_preserve_commit_order            | OFF           | ON             | Update the server variable |
+----------------------------------------+---------------+----------------+----------------------------+

Do you want to perform the required configuration changes? [y/n]:
```

6. Check configuration if it is valid
```
mysqlsh -e "
dba.checkInstanceConfiguration('gradmin:grpass:@localhost:3310')
dba.checkInstanceConfiguration('gradmin:grpass:@localhost:3320')
dba.checkInstanceConfiguration('gradmin:grpass:@localhost:3330')
"
```

7. Check the GTID for all nodes.  At this point, the server(nodes) are all newly created and with command to create Admin User.  The GTID should all be empty.  That means ALL servers are the same with same data.   
```
 mysqlsh --uri gradmin:grpass@`hostname`:3310 --sql -e "select @@gtid_executed;"
 mysqlsh --uri gradmin:grpass@`hostname`:3320 --sql -e "select @@gtid_executed;"
 mysqlsh --uri gradmin:grpass@`hostname`:3330 --sql -e "select @@gtid_executed;"
```


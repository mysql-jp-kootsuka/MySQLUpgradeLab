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

Please note : you may see certain configurations not setup correctly and it requires fixes.  Follow the instruction.

```
applierWorkerThreads will be set to the default value of 4.

NOTE: Some configuration options need to be fixed:
+----------------------------------------+---------------+----------------+--------------------------------------------------+
| Variable                               | Current Value | Required Value | Note                                             |
+----------------------------------------+---------------+----------------+--------------------------------------------------+
| binlog_transaction_dependency_tracking | COMMIT_ORDER  | WRITESET       | Update the server variable                       |
| server_id                              | 1             | <unique ID>    | Update read-only variable and restart the server |
| slave_parallel_type                    | DATABASE      | LOGICAL_CLOCK  | Update the server variable                       |
| slave_preserve_commit_order            | OFF           | ON             | Update the server variable                       |
+----------------------------------------+---------------+----------------+--------------------------------------------------+
```

6. Check 
```
mysqlsh -e "
dba.checkInstanceConfiguration('gradmin:grpass:@localhost:3310')
"
```


mysqlsh << EOL
x = shell.connect("root:@127.0.0.1:3310");
print("\n3310", x.runSql(" show variables like 'group_replication%consist%'").fetchAll());
x.close();
x = shell.connect("root:@127.0.0.1:3320");
print("\n3320", x.runSql(" show variables like 'group_replication%consist%'").fetchAll());
x.close();
x = shell.connect("root:@127.0.0.1:3330");
print("\n3330", x.runSql(" show variables like 'group_replication%consist%'").fetchAll());
x.close();

EOL

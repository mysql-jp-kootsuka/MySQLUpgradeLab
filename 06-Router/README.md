# MySQL Router allows client application to connect to the InnoDB Cluster transparently
#
1. Bootstrap configuration
2. Startup MySQL Router
3. Connecting to Primary Node via MySQL Router
4. Connecting to Secondary Node(s) via MySQL Router

## Bootstrap configuration

```
/usr/local/router/bin/mysqlrouter --bootstrap gradmin:grpass@workshop8:3310 --force --directory myrouter
```


## Startup MySQL Router
```
cd myrouter
./start.sh
ps -ef|grep mysqlrouter
```

## Connecting to Primary Node via MySQL Router

```
mysql -ugradmin -pgrpass -h127.0.0.1 -P6446
select @@hostname, @@port;
```

## Connecting to Secondary Node via MySQL Router

```
mysql -ugradmin -pgrpass -h127.0.0.1 -P6447 -e " select @@hostname, @@port;"
mysql -ugradmin -pgrpass -h127.0.0.1 -P6447 -e " select @@hostname, @@port;"
mysql -ugradmin -pgrpass -h127.0.0.1 -P6447 -e " select @@hostname, @@port;"
mysql -ugradmin -pgrpass -h127.0.0.1 -P6447 -e " select @@hostname, @@port;"
mysql -ugradmin -pgrpass -h127.0.0.1 -P6447 -e " select @@hostname, @@port;"
```









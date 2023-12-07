echo routerpass | mysqlrouter --conf-base-port=7446 --bootstrap gradmin:grpass@`hostname`:3310 --https-port=9443 --account=routeruser --force --directory myrouter-acct
cd myrouter-acct
./start.sh



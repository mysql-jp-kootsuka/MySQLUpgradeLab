mysql -udemo -pdemo -h127.0.0.1 -P7450 -e "

begin;
select 'in transaction', @@port;
commit;

select 'outside transaction', @@port;

select 'create temporary table...';
create temporary table mydb.mytmptable(f1 int not null primary key, f2 varchar(20));

select 'insert into temporary table';

insert into mydb.mytmptable values (1, @@port);

select 'from temp table', @@port, mytmptable.* from mydb.mytmptable;
"

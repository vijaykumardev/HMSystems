/*drop DB objects*/
drop table if exists messages;
drop table if exists tasks;
drop table if exists notes;
drop table if exists expenses;
drop table if exists member_groups;
drop table if exists groups;
drop table if exists members;

drop sequence if exists member_id_seq;
drop sequence if exists member_groups_id_seq;
drop sequence if exists group_id_seq;
drop sequence if exists transaction_id_seq;
drop sequence if exists note_id_seq;
drop sequence if exists task_id_seq;
drop sequence if exists message_id_seq;

/*Table creation*/
create table Members(
member_ID varchar(6),
member_name varchar(30),
Email varchar(30),
Phone numeric(10,0),
primary key (member_id));

create table groups(
group_ID varchar(6), /*Group ID will be null to represent member independent of any group*/
group_name varchar(30),
primary key(group_ID));

create table member_groups(
member_group_ID varchar(8),
group_ID varchar(6),
member_ID varchar(30),
member_value integer, /*Test how to set or manipulate value */
primary key (member_group_ID),
foreign key (member_ID) references members(member_ID),
foreign key (group_id) references groups(group_id));

create table expenses(
transaction_ID varchar(8),
group_id varchar(6),
item varchar(30),
cost integer,
expenses_shared_with integer,
primary key (transaction_ID),
foreign key (group_id) references groups(group_id)
/*implement check for expenses_shared_with*/);

create table tasks(
list_ID varchar(6),
group_id varchar(6),
list varchar(30),
status integer,
primary key(list_ID),
foreign key (group_id) references groups(group_id));

create table notes(
note_ID varchar(6),
group_id varchar(6),
text varchar(3000),
share_with integer,
pin integer,
primary key(note_ID),
foreign key (group_id) references groups(group_id)
/*implement check for share_with and pin*/);

/*create table member_activity(
member_activity_id varchar(8),
activity_id varchar(6),
member_group_ID varchar(8))
*/

create table messages(
message_ID varchar(6),
to_ID varchar(6),
from_ID varchar(8),
message varchar(800),
time timestamp,
privacy boolean,
tags varchar(30),
primary key(message_ID),
foreign key (to_ID) references groups(group_ID),
foreign key (from_ID) references members(member_ID));

/*Sequence creation*/
create sequence member_id_seq increment by 1 start with 1 no cycle;
create sequence member_groups_id_seq increment by 1 start with 1 no cycle;
create sequence group_id_seq increment by 1 start with 1 no cycle;
create sequence transaction_id_seq increment by 1 start with 1 no cycle;
create sequence task_id_seq increment by 1 start with 1 no cycle;
create sequence note_id_seq increment by 1 start with 1 no cycle;
create sequence message_id_seq increment by 1 start with 1 no cycle;
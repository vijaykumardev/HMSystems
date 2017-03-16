/*drop DB objects*/
drop table if exists messages;
drop table if exists tasks;
drop table if exists lists;
drop table if exists expenses;
drop table if exists groups;
drop table if exists member_groups;
drop table if exists members;

drop sequence if exists seq_member_id;
drop sequence if exists seq_member_groups_id;
drop sequence if exists seq_group_id;
drop sequence if exists seq_transaction_id;
drop sequence if exists seq_list_id;
drop sequence if exists seq_task_id;
drop sequence if exists seq_message_id;

/*Table creation*/
create table Members(
member_ID varchar(6),
member_name varchar(30),
Email varchar(30),
Phone numeric(10,0),
primary key (member_id));

/*Decompose the table*/
create table member_groups(
member_group_ID varchar(8),
group_ID varchar(6),
member_ID varchar(30),
member_value bytea, /*Test how to set or manipulate value */
primary key (member_group_ID),
foreign key (member_ID) references members(member_ID),
foreign key (member_ID) references members(member_ID));

create table groups(
group_ID varchar(6), /*Group ID will be null to represent member independent of any group*/
member_ID varchar(30),
group_name varchar(30),
primary key(group_ID),
unique(group_ID,member_ID),
foreign key (group_ID) references groups(group_ID),
foreign key (member_ID) references members(member_ID));

/*Instead of member_ID and share_type use a single column which signifies to which member in the group expense applied to*/
create table expenses(
transaction_ID varchar(8),
member_group_ID varchar(8),
item varchar(30),
cost integer,
share_type integer,
primary key (transaction_ID),
foreign key (member_group_ID) references member_groups(member_group_ID));

create table lists(
list_ID varchar(6),
member_group_ID varchar(8),
list varchar(30),
status integer,
primary key(list_ID),
foreign key (member_group_ID) references member_groups(member_group_ID));

create table tasks(
task_ID varchar(6),
member_group_ID varchar(8),
task varchar(30),
status integer,
primary key(task_ID),
foreign key (member_group_ID) references member_groups(member_group_ID));


create table messages(
message_ID varchar(6),
toID varchar(30),
fromID varchar(30),
message varchar(800),
time timestamp,
privacy boolean,
tags varchar(30),
primary key(message_ID),
foreign key (toID) references member_groups(member_group_ID),
foreign key (fromID) references member_groups(member_group_ID));

/*Sequence creation*/
create sequence seq_member_id increment by 1 start with 1 no cycle;
create sequence seq_member_groups_id increment by 1 start with 1 no cycle;
create sequence seq_group_id increment by 1 start with 1 no cycle;
create sequence seq_transaction_id increment by 1 start with 1 no cycle;
create sequence seq_list_id increment by 1 start with 1 no cycle;
create sequence seq_task_id increment by 1 start with 1 no cycle;
create sequence seq_message_id increment by 1 start with 1 no cycle;
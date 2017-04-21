/*drop DB objects*/
drop function members_func(varchar,members);
drop function login_func(varchar,login);
drop function expenses_func(varchar,varchar,expenses_in_t[],varchar[]);
drop function member_groups_func(varchar,member_groups[]);
drop function groups_func(character varying,groups);
drop function expenses_func(expenses_func_parameter);
drop function notes_func(varchar,varchar);
drop function notes_func(varchar,notes[],varchar[],varchar[]);
drop function tasks_func(varchar,varchar,int);
drop function tasks_func(varchar,tasks[],varchar[]);
drop function expenses_func(varchar,varchar,expenses_in_t[],varchar[]);

/*drop type interval_type;*/
drop type expenses_in_t;
drop type expenses_func_parameter;

drop table if exists schedules;
drop table if exists messages;
drop table if exists tasks;
drop table if exists notes;
drop table if exists expenses;
drop table if exists member_groups;
drop table if exists groups;
drop table if exists members;
drop table if exists login;

drop sequence if exists member_id_seq;
drop sequence if exists member_groups_id_seq;
drop sequence if exists group_id_seq;
drop sequence if exists transaction_id_seq;
drop sequence if exists note_id_seq;
drop sequence if exists task_id_seq;
drop sequence if exists message_id_seq;
drop sequence if exists schedule_id_seq;

/*User defined type*/

create type expenses_in_t as (
expense_id varchar(6),
itemname varchar(30),
date_time varchar,
costs int);

create type expenses_func_parameter as(
member_id varchar,
group_id varchar,
time_interval varchar,
start_time varchar,
end_time varchar
);

/*Table creation*/
create table login(
username varchar(15) not null,
password varchar(20) not null,
primary key (username)
);

create table Members(
member_ID varchar(6),
username varchar(15) not null,
member_name varchar(30) not null,
Email varchar(30),
Phone numeric(10,0),
primary key (member_id),
foreign key (username) references login(username));

create table groups(
group_ID varchar(6), /*Group ID will be null to represent member independent of any group*/
group_name varchar(30) not null,
primary key(group_ID));

create table member_groups(
member_group_ID varchar(8),
group_ID varchar(6),
member_ID varchar(30),
member_value bit varying, /*Test how to set or manipulate value */
primary key (member_group_ID),
foreign key (member_ID) references members(member_ID),
foreign key (group_id) references groups(group_id));

create table expenses(
transaction_ID varchar(8),
group_id varchar(6),
item varchar(30) not null,
cost integer,
expenditure_date timestamp,
expenses_shared_with bit varying,
primary key (transaction_ID),
foreign key (group_id) references groups(group_id)
/*implement check for expenses_shared_with*/);

create table tasks(
task_ID varchar(6),
group_id varchar(6),
task varchar(30) not null,
status integer,
assigned_to bit varying,
primary key(task_ID),
foreign key (group_id) references groups(group_id));

create table notes(
note_ID varchar(6),
group_id varchar(6),
text varchar(3000) not null,
share_with bit varying,
pin_to bit varying,
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
reference_ID varchar(8),
to_ID bit varying,
from_ID bit varying,
message varchar(800) not null,
time timestamp,
privacy boolean,
tags varchar(30),
primary key(message_ID),
/* this should refer to the member_group value */
foreign key (reference_ID) references member_groups(member_group_ID),
foreign key (reference_ID) references groups(group_ID),
foreign key (reference_ID) references tasks(task_ID),
foreign key (reference_ID) references expenses(transaction_ID),
foreign key (reference_ID) references notes(note_id)
/*foreign key (to_ID) references member_groups(member_value),
foreign key (from_ID) references member_groups(member_value)*/);

create table schedules(
schedule_id varchar(6),
schedule_activity varchar(6),
start_date date,
schedule_interval interval_type,
iterations int);

/*Sequence creation*/
create sequence member_id_seq increment by 1 start with 1 no cycle;
create sequence member_groups_id_seq increment by 1 start with 1 no cycle;
create sequence group_id_seq increment by 1 start with 1 no cycle;
create sequence transaction_id_seq increment by 1 start with 1 no cycle;
create sequence task_id_seq increment by 1 start with 1 no cycle;
create sequence note_id_seq increment by 1 start with 1 no cycle;
create sequence message_id_seq increment by 1 start with 1 no cycle;
create sequence schedule_id_seq increment by 1 start with 1 no cycle;
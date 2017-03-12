/*Table creation*/
create table Members(
member_ID varchar(6),
member_name varchar(30),
Email varchar(30),
Phone numeric(10,0),
primary key(member_id));

/*Decompose the table*/
create table groups(
group_ID varchar(6),
member_ID varchar(30),
group_name varchar(30),
primary key(group_ID),
unique(group_ID,member_ID),
foreign key (member_ID) references members(member_ID));

/*Instead of member_ID and share_type use a single column which signifies to which member in the group expense applied to*/
create table expenses(
transaction_ID varchar(8),
group_ID varchar(6),
member_ID varchar(30),
item varchar(30),
cost integer,
share_type integer,
primary key(transaction_ID)
foreign key (group_ID) references groups(group_ID),
foreign key (member_ID) references members(member_ID));

create table lists(
list_ID varchar(6),
group_ID varchar(6),
member_ID varchar(30),
list varchar(30),
status integer,
primary key(list_ID),
foreign key (group_ID) references groups(group_ID),
foreign key (member_ID) references members(member_ID));

create table tasks(
task_ID varchar(6),
group_ID varchar(6),
member_ID varchar(30),
task varchar(30),
status integer,
primary key(task_ID),
foreign key (group_ID) references groups(group_ID),
foreign key (member_ID) references members(member_ID));


create table messages(
message_ID varchar(6),
toID varchar(30),
fromID varchar(30),
message varchar(800),
time timestamp,
privacy boolean,
tags varchar(30),
primary key(message_ID),
check (toID in groups(group_ID) or toID in members(member_ID),
check (fromID in groups(group_ID) or toID in members(member_ID));

/*Sequence creation*/
create sequence seq_member_id increment by 1 start with 1 no cycle;
create sequence seq_group_id increment by 1 start with 1 no cycle;
create sequence seq_transaction_id increment by 1 start with 1 no cycle;
create sequence seq_list_id increment by 1 start with 1 no cycle;
create sequence seq_task_id increment by 1 start with 1 no cycle;
create sequence seq_message_id increment by 1 start with 1 no cycle;
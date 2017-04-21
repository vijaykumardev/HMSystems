/*
Function name:login_func parameter number:two
Input:
parameter 1: parameter name:'action' Parameter type:varchar 
parameter 2: parameter name:login parameter type:login
Output:
boolean type
Description: Perform operations on login table. Inserts a tuple into the table by using parameter 1 as 'insert'. Verifies the username and password by using parameter 1 as 'select'.
Function call:
login_func('insert',('Mark','markthegreat'))
login_func('select',('Mark','markthegreat'))
*/
CREATE OR REPLACE FUNCTION login_func(varchar,login) RETURNS boolean AS $$
DECLARE
v_action alias for $1;
v_user_details alias for $2;
return_val boolean:=false;
BEGIN
if v_action = 'insert' then
insert into login(username,password) values(lower(v_user_details.username),v_user_details.password);
return_val:=true;
elsif v_action = 'select' then
select case when count(*)=1 then true else false end into return_val from login where username=lower(v_user_details.username) and password=v_user_details.password;
end if;
return return_val;
END;
$$ LANGUAGE 'plpgsql' STRICT;

/*
Function name:members_func parameter number:two
Input:
parameter 1: parameter name:'action' Parameter type:varchar 
parameter 2: parameter name:members parameter type:members
Output:
boolean type
Description: Perform operations on members table. Inserts a tuple into the table by using parameter 1 as 'insert'. Updates member_name,email,phone either one or all for the member table.
Function call:
members_func('signup',('M00001','mark','Mark','mark@email.com',9876543210))
members_func('update',('M00001','mark','','',9876543215))
*/
create or replace function members_func(varchar,members) returns boolean as $$
declare
v_action alias for $1;
v_member_details alias for $2;
v_return_val boolean:=false;
begin
if v_action = 'signup' then
insert into members(member_ID,username,member_name,Email,phone) values
(concat(rpad('M',5-length(nextval('member_id_seq')::text),'0'),currval('member_id_seq')),v_member_details.username,v_member_details.member_name,v_member_details.Email,v_member_details.phone);
v_return_val:=true;
elsif v_action = 'update' then
update members set member_name=(case when length(v_member_details.member_name)=0 then member_name else v_member_details.member_name end),email=(case when length(v_member_details.email)=0 then email else v_member_details.email end),phone=(case when v_member_details.phone!=0 then v_member_details.phone else phone end) where member_ID=v_member_details.member_ID;
v_return_val:=true;
end if;
return v_return_val;
end;
$$ LANGUAGE 'plpgsql' STRICT;

/*
Function name:groups_func parameter number:two
Input:
parameter 1: parameter name:'action' Parameter type:varchar 
parameter 2: parameter name:groups parameter type:groups
Output:
boolean type
Description: Perform operations on groups table. Inserts a tuple into the table by using parameter 1 as 'insert'. Updates group_name when parameter 1 is 'update'. Delete, clears the value of the member_value for that group, making that group useless for further operations.
Function call:
groups_func('insert',('','Fake Patty''s day'))
groups_func('update',('G00001','Fake Pattys day'))
groups_func('delete',('G00001',''))
*/
create or replace function groups_func(varchar,groups) returns boolean as $$
declare
v_action alias for $1;
v_group_details alias for $2;
v_return_val boolean:=false;
begin
if v_action = 'insert' then
insert into groups(group_ID,group_name) values
(concat(rpad('G',5-length(nextval('group_id_seq')::text),'0'),currval('group_id_seq')),v_group_details.group_name);
v_return_val:=true;
elsif v_action = 'update' then
update groups set group_name=(case when length(v_group_details.group_name)=0 then group_name else v_group_details.group_name end) where group_ID=v_group_details.group_ID;
v_return_val:=true;
elsif v_action = 'delete' then
update member_groups set member_value=member_value&(~member_value) where group_id=v_group_details.group_ID;
v_return_val:=true;
end if;
return v_return_val;
end;
$$ LANGUAGE 'plpgsql' STRICT;


/*
Function name:member_groups_func parameter number:two
Input:
parameter 1: parameter name:'action' Parameter type:varchar 
parameter 2: parameter name:member_groups parameter type:member_groups
Output:
boolean type
Description: Perform operations on member_groups table. Inserts a tuple into the table by using parameter 1 as 'insert'. Updates group_name when parameter 1 is 'update'. Delete, clears the value of the member_value for that group, making that group useless for further operations.
Function call:
member_groups_func('insert'::varchar,'{"(0,G00001,M00003,0)","(0,G00001,M00004,0)"}')
member_groups_func('add','{"(0,G00001,M00014,0)","(0,G00001,M00015,0)"}')
member_groups_func('delete','{"(0,G00001,M00014,0)","(0,G00001,M00015,0)"}')
*/
create or replace function member_groups_func(varchar,member_groups[]) returns boolean as $$
declare
v_action alias for $1;
v_member_groups_details alias for $2;
v_length integer:=array_length(v_member_groups_details,1);
v_return_val boolean:=false;
v_existing_len integer:=0;
begin
/*Check and change if the existing group_id already present and 'insert' action is passed instead of 'add' by mistake
select case when count(*)>0 and v_action='insert' then 'add' end into v_action from member_groups where group_id=v_member_groups_details[1].group_id;*/
if v_action = 'insert' then
for v_index in 1..v_length loop
execute 'insert into member_groups(member_group_id,group_id,member_id,member_value) values(concat(rpad(''MG'',8-length(nextval(''member_groups_id_seq'')::text),''0''),currval(''member_groups_id_seq''))'||','''||v_member_groups_details[v_index].group_id||''','''||v_member_groups_details[v_index].member_id||''',cast(cast(power(2,'||v_index-1||') as int) as bit('||v_length||')))';
end loop;
v_return_val:=true;
elsif v_action = 'add' and v_length>1 then
select count(*) into v_existing_len from member_groups where group_id=v_member_groups_details[1].group_id;
execute 'update member_groups set member_value=cast(0 as bit('||v_existing_len||'))||member_value where group_id='''||v_member_groups_details[1].group_id||'''';
for v_index in 1..v_length loop
execute 'insert into member_groups(member_group_id,group_id,member_id,member_value) values(concat(rpad(''MG'',8-length(nextval(''member_groups_id_seq'')::text),''0''),currval(''member_groups_id_seq''))'||','''||v_member_groups_details[v_index].group_id||''','''||v_member_groups_details[v_index].member_id||''',cast(cast(power(2,'||v_existing_len+v_index-1||') as int) as bit('||v_length+v_existing_len||')))';
end loop;
v_return_val:=true;
elsif v_action = 'delete' then
select count(*) into v_existing_len from member_groups where group_id=v_member_groups_details[1].group_id;
for v_index in 1..v_length loop
execute 'update member_groups set member_value=member_value&cast(0 as bit('||v_existing_len||')) where group_id='''||v_member_groups_details[1].group_id||''' and member_id='''||v_member_groups_details[v_index].member_id||'''';
end loop;
v_return_val:=true;
end if;
return v_return_val;
end;
$$ LANGUAGE 'plpgsql' STRICT;


/*
in: GroupID,item,cost,date,member_id[]
out: result
Function name:expenses_func parameter number:two
Input:
parameter 1: parameter name:'action' Parameter type:varchar
parameter 2: parameter name:expense_in_t parameter type:expense_in(group_id,expense_sub_t(item,cost,date)[],member_id[]) 
Output:
return value 1:boolean type
Description: Perform operations add,remove,modify on expenses table. Inserts a tuple into the table by using parameter 1 as 'insert' while parameter 2 will have group_id, paramenter 3 will have one or more list of item,cost,date and parameter 4 contains member_ids this expense is shared with. Modify will change the values inserted earlier with parameter 1 as 'modify' updates cost,itemname or expenditurename and parameter 4 contains list of member_id which is added or removed. If value is unchanged then it is empty for string and 0 for integer values. member_id will be empty if no changes in them else will overwrite the list of member_id which will part of the  expense. Delete will remove the expenses based on expense_id.
Function call:
expenses_func('insert'::varchar,('G00002','{"(dosa,04-14-2017,20)","(tea,04-13-2017,10)"}','{"M00001","M00002","M00003"}'))
expenses_func('add'::varchar,'G00002','{"(,dosa,04-14-2017,20)","(,tea,04-13-2017,10)"}','{"M00008","M00004","M00005"}')
expenses_func('modify'::varchar,'G00002','{"(E00001,set dosa,04-14-2017 11:11:11,27)","(E00002,tea,04-13-2017 11:11:11,10)"}','{"M00008","M00004"}')
expenses_func('delete'::varchar,'G00002','{"(E00001,,,)","(E00002,,,)"}','{}')
*/
create or replace function expenses_func(varchar,varchar,expenses_in_t[],varchar[]) returns boolean as $$
declare
v_action alias for $1;
v_expenses_sub alias for $3;
v_group_id alias for $2;
v_member_id alias for $4;
v_mem_length integer:=array_length(v_member_id,1);
v_length integer:=array_length(v_expenses_sub,1);
v_return_val boolean:=false;
v_existing_len integer:=0;
v_share_value varchar:='1111';
begin
if v_action = 'add' then

select count(*) into v_existing_len from member_groups where group_id=v_group_id;
execute 'select 0::bit('||v_existing_len||')::varchar' into v_share_value;
for v_index in 1..v_mem_length loop
execute 'select member_value|('||v_share_value||'::bit('||v_existing_len||')) from member_groups where group_id='''||v_group_id||''' and member_id='''||v_member_id[v_index]||'''' into v_share_value;
end loop;

for v_index in 1..v_length loop
execute 'insert into expenses(transaction_ID,group_id,item,cost,expenditure_date,expenses_shared_with) values(concat(rpad(''E'',6-length(nextval(''transaction_id_seq'')::text),''0''),currval(''transaction_id_seq''))'||','''||v_group_id||''','''||v_expenses_sub[v_index].itemname||''','''||v_expenses_sub[v_index].costs||''','''||to_timestamp (v_expenses_sub[v_index].date_time,'mm-dd-yyyy HH24:MI:ss')||''','''||v_share_value||''')';
end loop;
v_return_val:=true;
elsif v_action = 'modify' and v_length>1 then

if v_mem_length > 0 then
select count(*) into v_existing_len from member_groups where group_id=v_group_id;
execute 'select 0::bit('||v_existing_len||')::varchar' into v_share_value;
for v_index in 1..v_mem_length loop
execute 'select member_value|('||v_share_value||'::bit('||v_existing_len||')) from member_groups where group_id='''||v_group_id||''' and member_id='''||v_member_id[v_index]||'''' into v_share_value;
end loop;
end if;

for v_index in 1..v_length loop
execute 'update expenses set item=(case when length('''||v_expenses_sub[v_index].itemname||''')=0 then item else '''||v_expenses_sub[v_index].itemname||''' end),cost=(case when '||v_expenses_sub[v_index].costs||'=0 then cost else '||v_expenses_sub[v_index].costs||' end),expenditure_date=(case when length('''||v_expenses_sub[v_index].date_time||''')=0 then expenditure_date else to_timestamp('''||v_expenses_sub[v_index].date_time||''',''mm-dd-yyyy HH24:MI:ss'') end),expenses_shared_with=(case when '||v_mem_length||'>0 then '||v_share_value||'::bit('||v_existing_len||') else expenses_shared_with end)  where transaction_id='''||v_expenses_sub[v_index].expense_id||''' and group_id='''||v_group_id||'''';
end loop;
v_return_val:=true;
elsif v_action = 'delete'  and v_length>1 then
for v_index in 1..v_length loop
delete from expenses where transaction_id=v_expenses_sub[v_index].expense_id and group_id=v_group_id;
end loop;
v_return_val:=true;
end if;
return v_return_val;
end;
$$ LANGUAGE 'plpgsql' STRICT;

/*
in: (member_id::varchar,group_id::varchar,interval::varchar,start_time::varchar,end_time::varchar)
out: expenses%rowtype
Function name:expenses_func parameter number:one
Input:
parameter 1: parameter name:expenses_func_parameter Parameter type:expenses_func_parameter
Output:
return value 1:expenses%rowtype
Description: Returns expenses row based on the parameter filter. The filter on expenses table can be on member_id,group_id,expenditure_date
Function call:
select expenses_func(('','G00001','','2017-02-21','2017-04-21'));
select expenses_func(('M00001','G00001','','2017-02-21','2017-04-21'));
select expenses_func(('M00001','G00001','36 days','',''));
select expenses_func(('M00001','G00001','1 year','',''));
select expenses_func(('M00001','G00002','','',''));
select expenses_func(('M00001','','2 month','',''));
select expenses_func(('','G00002','2 month','',''));
select expenses_func(('M00001','','','',''));
*/
create or replace function expenses_func(expenses_func_parameter) returns SETOF expenses as $$
DECLARE
expenses_values alias for $1;
BEGIN
if length(expenses_values.member_id) > 0 and length(expenses_values.group_id) > 0 and length(expenses_values.time_interval) > 0 then
return query execute 'select expenses.*h from expenses,member_groups where expenses.group_id=member_groups.group_id and member_groups.member_value&expenses.expenses_shared_with=member_groups.member_value and member_id='''||expenses_values.member_id||''' and member_groups.group_id='''||expenses_values.group_id||''' and expenses.expenditure_date > now() - interval '''||expenses_values.time_interval||''' order by expenses.group_id';
elsif length(expenses_values.member_id) > 0 and length(expenses_values.time_interval) > 0 then
return query execute 'select expenses.*h from expenses,member_groups where expenses.group_id=member_groups.group_id and member_groups.member_value&expenses.expenses_shared_with=member_groups.member_value and member_id='''||expenses_values.member_id||'''  and expenses.expenditure_date > now() - interval '''||expenses_values.time_interval||''' order by expenses.group_id';
elsif  length(expenses_values.member_id) > 0 and length(expenses_values.group_id) > 0 and length(expenses_values.start_time) > 0 and length(expenses_values.end_time) > 0 then
return query execute 'select expenses.*h from expenses,member_groups where expenses.group_id=member_groups.group_id and member_groups.member_value&expenses.expenses_shared_with=member_groups.member_value and member_id='''||expenses_values.member_id||''' and member_groups.group_id='''||expenses_values.group_id||''' and expenses.expenditure_date between '''||expenses_values.start_time||''' and '''||expenses_values.end_time||''' order by expenses.group_id';
elsif  length(expenses_values.member_id) > 0 and length(expenses_values.start_time) > 0 and length(expenses_values.end_time) > 0 then
return query execute 'select expenses.*h from expenses,member_groups where expenses.group_id=member_groups.group_id and member_groups.member_value&expenses.expenses_shared_with=member_groups.member_value and member_id='''||expenses_values.member_id||'''  and expenses.expenditure_date between '''||expenses_values.start_time||''' and '''||expenses_values.end_time||''' order by expenses.group_id';
elsif  length(expenses_values.member_id) > 0 and length(expenses_values.group_id) > 0 then
return query select expenses.*h from expenses,member_groups where expenses.group_id=member_groups.group_id and member_groups.member_value&expenses.expenses_shared_with=member_groups.member_value and member_id=expenses_values.member_id and member_groups.group_id=expenses_values.group_id order by expenses.group_id;
elsif  length(expenses_values.member_id) > 0  then
return query select expenses.*h from expenses,member_groups where expenses.group_id=member_groups.group_id and member_groups.member_value&expenses.expenses_shared_with=member_groups.member_value and member_id=expenses_values.member_id order by expenses.group_id;
elsif  length(expenses_values.group_id) > 0 then
return query select expenses.*h from expenses,member_groups where expenses.group_id=member_groups.group_id and member_groups.member_value&expenses.expenses_shared_with=member_groups.member_value and member_groups.group_id=expenses_values.group_id order by expenses.group_id;
end if;
END;
$$ LANGUAGE 'plpgsql' STRICT;

/*
in: action,tasks,member_id[]
out: result
Function name:tasks_func parameter number:two
Input:
parameter 1: parameter name:'action' Parameter type:varchar
parameter 2: parameter name:tasks parameter type:tasks(task_id,group_id,task,status,assigned_to) 
parameter 3: parameter name:members parameter type:varchar[]
Output:
return value 1:boolean type
Description: Perform operations add,remove,modify on expenses table. Inserts a tuple into the table by using parameter 1 as 'insert' while parameter 2 will have lists containing group_id,task,status,assigned_to and parameter 3 contains member_ids this tasks is shared with. Modify will change the values inserted earlier with parameter 1 as 'modify' updates task,status,assigned_to and parameter 4 contains list of member_id which is added or removed. If value is unchanged then it is empty for string and 0 for integer values. member_id will be empty if no changes in them else will overwrite the list of member_id which will part of the  expense. Delete will remove the expenses based on task_id and group_id.
Function call:
tasks_func('add'::varchar,'{"(,G00002,fill car fuel,0,)","(,G00002,purchase new sofa,0,)"}','{"M00008","M00004","M00005"}')
tasks_func('modify'::varchar,'{"(T00001,G00002,change wiper liquid,0,)","(T00002,G00002,purchase new sofa,0,)"}','{"M00008","M00004","M00005"}') - using M00005 other members also get attached check and verify
tasks_func('delete'::varchar,'{"(T00001,G00002,,,)","(T00002,G00002,,,)"}','{}')
*/
create or replace function tasks_func(varchar,tasks[],varchar[]) returns boolean as $$
declare
v_action alias for $1;
v_tasks alias for $2;
v_member_id alias for $3;
v_mem_length integer:=array_length(v_member_id,1);
v_length integer:=array_length(v_tasks,1);
v_return_val boolean:=false;
v_existing_len integer:=0;
v_share_value varchar:='1111';
begin
if v_action = 'add' and v_length > 0 then

select count(*) into v_existing_len from member_groups where group_id=v_tasks[1].group_id;
execute 'select 0::bit('||v_existing_len||')::varchar' into v_share_value;
for v_index in 1..v_mem_length loop
execute 'select member_value|('||v_share_value||'::bit('||v_existing_len||')) from member_groups where group_id='''||v_tasks[1].group_id||''' and member_id='''||v_member_id[v_index]||'''' into v_share_value;
end loop;

for v_index in 1..v_length loop
execute 'insert into tasks(task_id,group_id,task,status,assigned_to) values(concat(rpad(''T'',6-length(nextval(''task_id_seq'')::text),''0''),currval(''task_id_seq''))'||','''||v_tasks[1].group_id||''','''||v_tasks[v_index].task||''','''||v_tasks[v_index].status||''','''||v_share_value||''')';
end loop;
v_return_val:=true;
elsif v_action = 'modify' and v_length>1 then

if v_mem_length > 0 then
select count(*) into v_existing_len from member_groups where group_id=v_tasks[1].group_id;
execute 'select 0::bit('||v_existing_len||')::varchar' into v_share_value;
for v_index in 1..v_mem_length loop
execute 'select member_value|('||v_share_value||'::bit('||v_existing_len||')) from member_groups where group_id='''||v_tasks[1].group_id||''' and member_id='''||v_member_id[v_index]||'''' into v_share_value;
end loop;
end if;

for v_index in 1..v_length loop
execute 'update tasks set task=(case when length('''||v_tasks[v_index].task||''')=0 then task else '''||v_tasks[v_index].task||''' end),status=(case when '||v_tasks[v_index].status||'=0 then status else '||v_tasks[v_index].status||' end),assigned_to=(case when '||v_mem_length||'>0 then '||v_share_value||'::bit('||v_existing_len||') else assigned_to end)  where task_id='''||v_tasks[v_index].task_id||''' and group_id='''||v_tasks[v_index].group_id||'''';
end loop;
v_return_val:=true;
elsif v_action = 'delete'  and v_length>1 then
for v_index in 1..v_length loop
delete from tasks where task_id=v_tasks[v_index].task_id and group_id=v_tasks[v_index].group_id;
end loop;
v_return_val:=true;
end if;
return v_return_val;
end;
$$ LANGUAGE 'plpgsql' STRICT;

/*
in: group_id,status
out: tasks
Function name:notes_func parameter number:one
Input:
parameter 1: parameter name:member_id Parameter type:varchar
parameter 1: parameter name:group_id Parameter type:varchar
parameter 1: parameter name:status Parameter type:int
Output:
return value 1:tasks
Description: Returns the tasks rows using filter on group_id,member_id and status.
Function call:
tasks_func('M00003','G00002',-1)
tasks_func('','G00002',-1)
tasks_func('M00003','G00001',-1)
*/
create or replace function tasks_func(varchar,varchar,int) returns SETOF tasks as $$
declare
v_member_id alias for $1;
v_group_id alias for $2;
v_status alias for $3;
begin
if length(v_member_id)>0 and length(v_group_id)>0 and v_status>=0 then
return query select tasks.* from tasks,member_groups where member_groups.group_id=v_group_id and tasks.status=v_status and member_groups.group_id=tasks.group_id and member_groups.member_id=v_member_id;
elsif length(v_member_id)>0 and v_status>=0 then
return query select tasks.* from tasks,member_groups where tasks.status=v_status and member_groups.group_id=tasks.group_id and member_groups.member_id=v_member_id;
elsif length(v_group_id)>0 and v_status>=0 then
return query select tasks.* from tasks where group_id=v_group_id and status=v_status;
elsif length(v_member_id)>0 and length(v_group_id)>0 then
return query select tasks.* from tasks,member_groups where member_groups.group_id=v_group_id and member_groups.group_id=tasks.group_id and member_groups.member_id=v_member_id;
elsif length(v_member_id)>0 then
return query select tasks.* from tasks,member_groups where member_groups.group_id=tasks.group_id and member_groups.member_id=v_member_id;
elsif length(v_group_id)>0 then
return query select tasks.* from tasks where group_id=v_group_id;
end if;
end;
$$ LANGUAGE 'plpgsql' STRICT;

/*
in: action,tasks,member_id[]
out: result
Function name:expenses_func parameter number:two
Input:
parameter 1: parameter name:'action' Parameter type:varchar
parameter 2: parameter name:tasks parameter type:tasks(task_id,group_id,task,status,assigned_to) 
parameter 3: parameter name:members parameter type:varchar[]
Output:
return value 1:boolean type
Description: Perform operations add,remove,modify on expenses table. Inserts a tuple into the table by using parameter 1 as 'insert' while parameter 2 will have lists containing group_id,task,status,assigned_to and parameter 3 contains member_ids this tasks is shared with. Modify will change the values inserted earlier with parameter 1 as 'modify' updates task,status,assigned_to and parameter 4 contains list of member_id which is added or removed. If value is unchanged then it is empty for string and 0 for integer values. member_id will be empty if no changes in them else will overwrite the list of member_id which will part of the  expense. Delete will remove the expenses based on task_id and group_id.
Function call:
notes_func('add'::varchar,'{"(,G00002,Every sunday kitche will be closed,,)","(,G00002,Friday will be special dinner dont miss,,)"}','{"M00008","M00004","M00007"}','{"M00008"}')
notes_func('modify'::varchar,'{"(N00009,G00002,Every sunday kitchen will be closed,,)","(N00010,G00002,Friday will be special dinner dont miss,,)"}','{"M00008","M00004","M00005"}','{"M00008"}') - using M00005 other members also get attached check and verify
- Will fail with the null exception is the values are not passed for pin_to or member_id at line 45
notes_func('delete'::varchar,'{"(N00009,G00002,,,)","(N00010,G00002,,,)"}','{}','{}')
*/
create or replace function notes_func(varchar,notes[],varchar[],varchar[]) returns boolean as $$
declare
v_action alias for $1;
v_notes alias for $2;
v_member_id alias for $3;
v_pin_to alias for $4;
v_mem_length integer:=array_length(v_member_id,1);
v_pin_length integer:=array_length(v_pin_to,1);
v_length integer:=array_length(v_notes,1);
v_return_val boolean:=false;
v_existing_len integer:=0;
v_share_value varchar:='1111';
v_pin_share_value varchar:='1111';
begin
if v_action = 'add' and v_length > 0 then

select count(*) into v_existing_len from member_groups where group_id=v_notes[1].group_id;
execute 'select 0::bit('||v_existing_len||')::varchar' into v_share_value;
for v_index in 1..v_mem_length loop
execute 'select member_value|('||v_share_value||'::bit('||v_existing_len||')) from member_groups where group_id='''||v_notes[1].group_id||''' and member_id='''||v_member_id[v_index]||'''' into v_share_value;
end loop;

for v_index in 1..v_length loop
execute 'insert into notes(note_id,group_id,text,share_with,pin_to) values(concat(rpad(''N'',6-length(nextval(''note_id_seq'')::text),''0''),currval(''note_id_seq''))'||','''||v_notes[v_index].group_id||''','''||v_notes[v_index].text||''','''||v_share_value||''','''||v_share_value||''')';
end loop;
v_return_val:=true;
elsif v_action = 'modify' and v_length>1 then

select count(*) into v_existing_len from member_groups where group_id=v_notes[1].group_id;
execute 'select 0::bit('||v_existing_len||')::varchar,0::bit('||v_existing_len||')::varchar' into v_share_value,v_pin_share_value;

if v_mem_length > 0 then
for v_index in 1..v_mem_length loop
execute 'select member_value|('||v_share_value||'::bit('||v_existing_len||')) from member_groups where group_id='''||v_notes[1].group_id||''' and member_id='''||v_member_id[v_index]||'''' into v_share_value;
end loop;
end if;

if v_pin_length > 0 then
for v_index in 1..v_pin_length loop
execute 'select member_value|('||v_pin_share_value||'::bit('||v_existing_len||')) from member_groups where group_id='''||v_notes[v_index].group_id||''' and member_id='''||v_pin_to[v_index]||'''' into v_pin_share_value;
end loop;
end if;

for v_index in 1..v_length loop
execute 'update notes set text=(case when length('''||v_notes[v_index].text||''')=0 then text else '''||v_notes[v_index].text||''' end),share_with=(case when '||v_mem_length||'>0 then '||v_share_value||'::bit('||v_existing_len||') else share_with end),pin_to=(case when '||v_pin_length||'>0 then '||v_pin_share_value||'::bit('||v_existing_len||') else pin_to end)  where note_id='''||v_notes[v_index].note_id||''' and group_id='''||v_notes[v_index].group_id||'''';
end loop;
v_return_val:=true;
elsif v_action = 'delete'  and v_length>1 then
for v_index in 1..v_length loop
delete from notes where note_id=v_notes[v_index].note_id and group_id=v_notes[v_index].group_id;
end loop;
v_return_val:=true;
end if;
return v_return_val;
end;
$$ LANGUAGE 'plpgsql' STRICT;

/*
in: member_id,group_id
out: tasks
Function name:notes_func parameter number:one
Input:
parameter 1: parameter name:member_id Parameter type:varchar
parameter 1: parameter name:group_id Parameter type:varchar
Output:
return value 1:notes
Description: Returns the notes rows using filter on group_id,member_id.
Function call:
notes_func('M00003','G00006')
notes_func('','G00010')
notes_func('M00003','G00017')
*/
create or replace function notes_func(varchar,varchar) returns SETOF notes as $$
declare
v_member_id alias for $1;
v_group_id alias for $2;
begin
if length(v_member_id)>0 and length(v_group_id)>0 then
return query select notes.* from notes,member_groups where member_groups.group_id=v_group_id and member_groups.group_id=notes.group_id and member_groups.member_id=v_member_id;
elsif length(v_member_id)>0 then
return query select notes.* from notes,member_groups where member_groups.group_id=notes.group_id and member_groups.member_id=v_member_id;
elsif length(v_group_id)>0 then
return query select notes.* from notes where group_id=v_group_id;
end if;
end;
$$ LANGUAGE 'plpgsql' STRICT;
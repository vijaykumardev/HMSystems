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
insert into login(username,password) values(v_user_details.username,v_user_details.password);
return_val:=true;
elsif v_action = 'select' then
select case when count(*)=1 then true else false end into return_val from login where username=v_user_details.username and password=v_user_details.password;
end if;
return return_val;
END;
$$ LANGUAGE 'plpgsql' STRICT;

/*
Function name:login_func parameter number:two
Input:
parameter 1: parameter name:'action' Parameter type:varchar 
parameter 2: parameter name:members parameter type:members
Output:
boolean type
Description: Perform operations on members table. Inserts a tuple into the table by using parameter 1 as 'insert'.
Function call:
member_func('signup',('M00001','mark','Mark','mark@email.com',9876543210))
*/
create or replace function members_func(varchar,members) returns boolean as $$
declare
v_member_details alias for $2;
v_action alias for $1;
v_return_val boolean:=false;
begin
if v_action = 'insert' then
insert into members(member_ID,username,member_name,Email,phone) values
(concat(rpad('M',5-length(nextval('seq_member_id')::text),'0'),currval('seq_member_id')),v_member_details.username,v_member_details.member_name,v_member_details.Email,v_member_details.phone);
v_return_val:=true;
end if;
return v_return_val;
end;
$$ LANGUAGE 'plpgsql' STRICT;
insert into members(member_ID,member_name,Email,phone) values
(concat(rpad('M',5-length(nextval('seq_member_id')::text),'0'),currval('seq_member_id')),'Vijay','vijay@email.com',9876543210),
(concat(rpad('M',5-length(nextval('seq_member_id')::text),'0'),currval('seq_member_id')),'Akash','akash@email.com',9876543211),
(concat(rpad('M',5-length(nextval('seq_member_id')::text),'0'),currval('seq_member_id')),'Siddharth','siddharth@email.com',9876543212),
(concat(rpad('M',5-length(nextval('seq_member_id')::text),'0'),currval('seq_member_id')),'Sandeep','sandeep@email.com',9876543213),
(concat(rpad('M',5-length(nextval('seq_member_id')::text),'0'),currval('seq_member_id')),'Raja','raja@email.com',9876543214),
(concat(rpad('M',5-length(nextval('seq_member_id')::text),'0'),currval('seq_member_id')),'Nithin','nithin@email.com',9876543215);

insert into groups(group_ID,member_ID,group_name) values
select concat(rpad('G',5-length(nextval('seq_group_id')::text),'0'),currval('seq_group_id')),member_id,'Claflin Appartment' from members;

insert into expenses(transaction_ID,group_ID,member_ID,item,cost,share_type)
select concat(rpad('T',7-length(nextval('seq_transaction_id')::text),'0'),currval('seq_transaction_id')),group_id,member_id,'eggs',4,null from 
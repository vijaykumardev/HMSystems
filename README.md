# HMSystems
##Introduction
Home management portal to track home related activity such as expenses, grocery purchases, who is cooking next, whose turn is in cleaning trash using a combination of functions like expense manager, to do list, note taking utilities along with a instant messenger for member communication regarding the activity.

##Users
Each project(name for new profile) consists of groups. Group can be created by one or more individual members. The portal consists of three abstract activity.

##Activity
Task, Notes and Expense. Task involves work which will consume time of the activity based on the type of work, example Trash cleaning or cooking. Notes used to communicate message as a announcement or remainder and pin the message to the user dashboard. Expense activity will involve the money component in it, grocery purchases, refueling vehicle. The groups will encompass members. The task alone group will be cooking turns. Expense activity will involve trips.

##Scheduling
Time component is attached to the activity or a group for scheduling purpose. Activity can be independent of the time. It can be either one time activity or recurring activity for a particular hour of day or day of the week or day in a month or year. For example, expense activity involving every Saturday grocery shopping. Get together at a one time in a month.

| Item | Cost | Paid by |
| :---         |     ---:       |:---           |
| Rice   | $20     | Ram    |
| Wheat Flour   | $20     | Diya    |
| Tortilla   | $5     | John    |
| Milk   | $2.5     |     |
| Eggs   | $4     |     |


| Cooking     | Status    |
| ---         | ---       |
| Bob         | [x]       |
| Ram         | [x]       |
| Jay         | [x]       |
| Diya        |           |
| Robert      |           |
| Linda       |           |
| John        |           |


| Item         | Quantity   | Status  |
| :---         |     ---:   |:---     |
| Rice         | 10kg       | [x]     |
| Wheat Flour  | 10kg       | [x]     |
| Tortilla     | 10 pc      | [x]     |
| Milk         | 3 Gallons  |         |
| Eggs         | 18         |         |

##Scope
Each users in the given project will have equal access. The groups can be created with the registered mem-
bers or non-registered members. Registered members can create new groups, add, delete or modify items.
Non-registered members can add, delete or modify items. Non-registered members entry will be added into
Members with partial access.

##Tables
Login(**username**,password) <br />
Members(**member_id**,username,member_name,email,phone) <br />
Groups(**group_id**,group_name) <br />
Member_groups(**member_group_id**,group_id,member_id,member_value) <br />
Expenses(**transaction_id**,group_id,item,cost,expenses_shared_with) <br />
Notes(**note_id**,group_id,list,status,pin\_to) <br />
Tasks(**task_id**,group_id,task,status) <br />
Messages(**message_id**,to_id,from_id,message,time) <br />
Schedules(**schedule_id**,schedule_activity,start_date,schedule_interval,iterations) <br />

##Implementation
Database implementation is using PostgreSQL and MongoDB(Messaging and Member_groups table alone). User interface is
either using html/php or AngularJS or JSP.

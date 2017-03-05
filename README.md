# HMSystems
##Introduction
Home management portal to track home related activity such as expenses, grocery purchases, who is cooking next, whose turn is in cleaning trash using a combination of functions like expense manager, to do list, note taking utilities along with a instant messenger for member communication regarding the activity.

##Users
Each project(name for new profile) consists of groups. Group can be created by one or more individual members. The portal consists of three abstract activity.

##Activity
Task, List and Expense. Task involves work which will consume time of the activity based on the type of work, example Trash cleaning or cooking. List is a way to specify items in a order or unordered form, grocery
listing for next week or things to repair in house. Expense activity will involve the money component in it, grocery purchases, refueling vechile. One or more combination can be used to create groups. The groups
will encompass members. The task alone group will be cooking turns. Expense activity will involve trips. List activity will involve. Below is the example of each.

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
Members(**MemberID**,MemberName,Email,Phone) <br />
Groups(**GroupID**,**MemberID**,GroupName) <br />
Expenses(**TransactionID**,GroupID,MemberID,TransactionItem,Cost,ShareType) <br />
Listing(**ListingID**,GroupID,MemberID,List,Status) <br />
Task(**TaskID**,GroupID,MemberID,Task,Status) <br />
InstantMessage(**MessageID**,ToID,FromID,Message,Time,Privacy,tags) <br />

##Implementation
Database implementation is using PostgreSQL and MongoDB(Messaging table alone). User interface is
either using html/php or AngularJS.

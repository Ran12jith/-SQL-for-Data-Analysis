
/*END TO END SQL PROJECT "parch_and_posey" DATA. Below are the table and qustions that covers END TO END SQL CONCEPTS*/


Create database parch_and_posey
use parch_and_posey


Create table accounts (
Id int not null primary key,
`name` varchar(30) not null,
website varchar(30) unique,
lat decimal(30,10),
`long` decimal(30,10),
primary_poc varchar(30) unique,
sales_rep_id int);

create table orders(
Id int not null,
account_id int not null,
occured timestamp not null,
standard_quantity int,
gloss_quantity int,
poster_quantity int,
total int,
standard_amount_usd int,
gloss_amount_usd int,
poster_amount_usd int,
total_amount_usd int
);

create table region(
id int not null primary key,
`name` varchar(30) not null);


create table sales_rep(
id int,
`name` varchar(30) not null,
region_id Int not null,
foreign key (region_id)  references region(ID) );

  create table web_events(
  id int,
  account_id int not null,
  occured_at datetime,
  `channel` varchar(30));
 
alter table sales_rep 
add constraint salesrep_pkey primary key (id)

alter table accounts
add constraint accountsf_key foreign key (sales_rep_id) references  sales_rep (id)



set session sql_mode = ''
load data infile
'E:/web_events.csv'
INTO TABLE web_events
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows

select * from orders;
select * from accounts;
select * from region;
select * from sales_rep;
select * from web_events;
////////////////////////////////////////////////////////////////////////////////// Basic SQL.sql

/*Try writing your own query to select only the id, account_id, and occurred_at columns for all orders in the orders table.*/
select id,account_id,occured from orders

/*Try using LIMIT yourself below by writing a query that displays all the data in the occurred, account_id, and channel columns of the web_events table, and limits the output to only the first 15 rows.*/
select * from web_events limit 15orders

/*10 earliest orders in the orders table. Include the id, occurred at, and total_amt_usd.*/
select id,occured,total_amount_usd from orders order by occured desc

/*Use the web_events table to find all information regarding individuals who were contacted via the channel of organic or adwords.*/
select web_events.`channel`,accounts.id,accounts.`name` from accounts left outer join web_events 
on accounts.id = web_events.account_id where channel in ('organic','adwords')

/*top 5 orders in terms of largest total_amt_usd. Include the id, account_id, and total_amt_usd*/
select id,account_id,total_amount_usd from orders order by total_amount_usd desc limit 5

/*the lowest 20 orders in terms of smallest total_amt_usd. Include the id, account_id, and total_amt_usd*/
select id,account_id,total_amount_usd from orders order by total_amount_usd  limit 30

/*Write a query that displays the order ID, account ID, and total dollar amount for all the orders, sorted first by the account ID (in ascending order), and then by the total dollar amount (in descending order).*/
select id,account_id,total_amount_usd from orders
 order by account_id, total_amount_usd desc

/*displays order ID, account ID, and total dollar amount for each order, but this time sorted first by total dollar amount (in descending order), and then by account ID (in ascending order).*/
SELECT id, account_id, total_amount_usd
FROM orders
ORDER BY total_amount_usd DESC, account_id;

/*Compare the results of these two queries above. How are the results different when you switch the column you sort on first*/
/*Ans:In query #1, all of the orders for each account ID are grouped together, and then within each of those groupings, the orders appear from the greatest order amount to the least. In query #2, since you sorted by the total dollar amount first, the orders appear from greatest to least regardless of which account ID they were from. Then they are sorted by account ID next. (The secondary sorting by account ID is difficult to see here, since only if there were two orders with equal total dollar amounts would there need to be any sorting by account ID.)*/


/*Pulls the first 5 rows and all columns from the orders table that have a dollar amount of gloss_amt_usd greater than or equal to 1000.*/
select * from orders where gloss_amount_usd > 100


/*Filter the accounts table to include the company name, website, and the primary point of contact (primary_poc) just for the Exxon Mobil company in the accounts table.*/
select `name`,website,primary_poc from accounts where name = 'Exxon Mobil'

/*Create a column that divides the standard_amt_usd by the standard_qty to find the unit price for standard paper for each order. Limit the results to the first 10 orders, and include the id and account_id fields.*/
select id,account_id, round(standard_amount_usd / standard_quantity,2) as unit_price from orders limit 10

/*finds the percentage of revenue that comes from poster paper for each order. You will need to use only the columns that end with _usd. (Try to do this without using the total column.) Display the id and account_id fields also.*/
select id,account_id,poster_amount_usd / (standard_amount_usd + gloss_amount_usd + poster_amount_usd) as poster_amt_percentage from orders limit 10

/*All the companies whose names start with 'C'.*/
select * from accounts 
where `name` like 'C%' 

/*All companies whose names contain the string 'one' somewhere in the name.*/
select * from accounts
where `name` like '% one %'

---below is for with space
select * from accounts
where `name` like '%one%'

/*All companies whose names end with 's'.*/
select * from accounts
where `name` like '%s'

/*Use the accounts table to find the account name, primary_poc, and sales_rep_id for Walmart, Target, and Nordstrom.*/
select `name`,primary_poc,sales_rep_id from accounts where `name` in ('Walmart', 'Target', 'Nordstrom')

/*Use the web_events table to find all information regarding individuals who were contacted via the channel of organic or adwords.*/
select accounts.`name` , web_events.`channel` from accounts left outer join web_events on accounts.id = web_events.account_id 
where `channel` in ( 'organic','adwords')

/*Use the accounts table to find the account name, primary poc, and sales rep id for all stores except Walmart, Target, and Nordstrom.*/
select `name`,primary_poc,sales_rep_id from accounts where `name` not in ('Walmart','Target','Nordstrom')

/*Use the web_events table to find all information regarding individuals who were contacted via any method except using organic or adwords methods.*/
select accounts.`name` , web_events.`channel` from accounts left outer join web_events on accounts.id = web_events.account_id 
where `channel` not in ( 'organic','adwords')

/*all the orders where the standard_qty is over 1000, the poster_qty is 0, and the gloss_qty is 0.*/
select * from orders where standard_quantity > 1000 and 
poster_quantity = 0 and
gloss_quantity = 0

/*Using the accounts table, find all the companies whose names do not start with 'C' and end with 's'.*/
select * from accounts 
where `name` not like 'c%' and `name` like '%s'

/*When you use the BETWEEN operator in SQL, do the results include the values of your endpoints, or not? Figure out the answer to this important question by writing a query that displays the order date and gloss_qty data for all orders where gloss_qty is between 24 and 29. Then look at your output to see if the BETWEEN operator included the begin and end values or not.*/
select * from orders where gloss_quantity   between 22 and 47


/*Use the web_events table to find all information regarding individuals who were contacted via the organic or adwords channels, and started their account at any point in 2016, sorted from newest to oldest.*/
select * from web_events
select * from web_events where channel in ('organic','adwords')
and 
occured_at between '2016-01-01 17:13:58' and '2016-12-31 17:13:58' order by occured_at desc


/*Find list of orders ids where either gloss_qty or poster_qty is greater than 4000. Only include the id field in the resulting table.*/
select id from orders where gloss_quantity > 4000 or poster_quantity > 4000

/*Write a query that returns a list of orders where the standard_qty is zero and either the gloss_qty or poster_qty is over 1000.*/
select * from orders 
where standard_quantity = 0 
and 
(gloss_quantity > 1000 or poster_quantity > 1000)
	
---/*Find all the company names that start with a 'C' or 'W', and the primary contact contains 'ana' or 'Ana', but it doesn't contain 'eana'.*/

select * from accounts where (`name` like 'c%' or `name` like 'w%')
and 
(primary_poc like '%ana%' or primary_poc like '%Ana%') and primary_poc not like '%eana'

//////////////////////////------ JOINS --------//////////////////////////
LEFT OUTER JOIN, RIGHT OUTER JOIN, INNER JOIN, FULL OUTER JOIN


/*Try pulling all the data from the accounts table, and all the data from the orders table.*/
 select accounts.* ,orders.* from accounts join orders on accounts.id = orders.account_id

/*Try pulling standard_qty, gloss_qty, and poster_qty from the orders table, and the website and the primary_poc from the accounts table.*/
select orders.standard_quantity,orders.poster_quantity,accounts.website,accounts.primary_poc from accounts join orders 
on accounts.id = orders.account_id

/*Provide a table for all web_events associated with account name of Walmart. There should be three columns. Be sure to include the primary_poc, time of the event, and the channel for each event. 
Additionally, you might choose to add a fourth column to assure only Walmart events were chosen.*/

select accounts.`name`,accounts.primary_poc,web_events.occured_at, web_events.`channel` from accounts join web_events on accounts.id = web_events.account_id where `name` = 'walmart'

/*Provide a table that provides the region for each sales_rep along with their associated accounts. Your final table should include three columns: the region name, the sales rep name, and the account name. 
Sort the accounts alphabetically (A-Z) according to account name.*/

select sales_rep.`name` as sales_rep_name,accounts.`name` as accounts_name , region.`name` as region_name from accounts 
join sales_rep  on accounts.sales_rep_id = sales_rep.id
join region on sales_rep.region_id = region.id order by accounts.`name`


/*Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) 
for the order.  Your final table should have 3 columns: region name, account name, and unit price. A few accounts have 0 for total, 
so I divided by (total + 0.01) to assure not dividing by zero.*/

select orders.id,(orders.total_amount_usd / total + 0.01) as per_unit, accounts.`name`, region.`name` as region_name from accounts 
join orders on accounts.id = orders.account_id
join sales_rep on sales_rep.id = accounts.sales_rep_id
join region on region.id = sales_rep.region_id
order by 1;

/*--------------------------------------------*/

/*Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.*/
select sales_rep.`name` as sales_rep_name,accounts.`name` as accounts_name , region.`name` as region_name from accounts 
join sales_rep  on accounts.sales_rep_id = sales_rep.id
join region on sales_rep.region_id = region.id where region.`name` = 'midwest' order by accounts.`name` 

/*Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for accounts where the sales rep has a first name starting with S and in the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.*/

select sales_rep.`name` as sales_rep_name,accounts.`name` as accounts_name , region.`name` as region_name from accounts 
join sales_rep  on accounts.sales_rep_id = sales_rep.id
join region on sales_rep.region_id = region.id 
having sales_rep.`name` like 's%' and lower(region.`name`) like 'midwest'
order by accounts.`name` 


/*Provide a table that provides the region for each sales_rep along with their associated accounts. 
This time only for accounts where the sales rep has a last name starting with K and in the Midwest region. 
Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.*/
select sales_rep.`name` as sales_rep_name,accounts.`name` as accounts_name , region.`name` as region_name from accounts 
join sales_rep  on accounts.sales_rep_id = sales_rep.id
join region on sales_rep.region_id = region.id 
having lower(sales_rep.`name`) like '% k%' and lower(region.`name`) like 'midwest'
order by accounts.`name` 



/*Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) 
for the order. However, you should only provide the results if the standard order quantity exceeds 100. 
Your final table should have 3 columns: region name, account name, and unit price. 
In order to avoid a division by zero error, adding .01 to the denominator here is helpful total_amt_usd/(total+0.01).*/

select accounts.`name`, region.`name`,(orders.total_amount_usd/total + 0.1) as unit_price from accounts join orders on 
accounts.id = orders.account_id
join sales_rep on sales_rep.id = accounts.sales_rep_id
join region on region.id = sales_rep.region_id
where standard_quantity > 100


/*Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) 
for the order. However, you should only provide the results if the standard order quantity exceeds 100 and 
the poster order quantity exceeds 50. Your final table should have 3 columns: region name, account name, and unit price. 
Sort for the smallest unit price first. In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).
*/
select accounts.`name`, region.`name`,(orders.total_amount_usd/total + 0.1) as unit_price from accounts join orders on 
accounts.id = orders.account_id
join sales_rep on sales_rep.id = accounts.sales_rep_id
join region on region.id = sales_rep.region_id
where standard_quantity > 100 and poster_quantity > 50
order by 3



/*Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) 
for the order. However, you should only provide the results if the standard order quantity exceeds 100 and the 
poster order quantity exceeds 50. Your final table should have 3 columns: region name, account name, and unit price. 
Sort for the largest unit price first. In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).*/

select accounts.`name`, region.`name`,(orders.total_amount_usd/total + 0.1) as unit_price from accounts join orders on 
accounts.id = orders.account_id
join sales_rep on sales_rep.id = accounts.sales_rep_id
join region on region.id = sales_rep.region_id
where standard_quantity > 100 and poster_quantity > 50
order by 3 desc

/*What are the different channels used by account id 1001? Your final table should have only 2 columns: account name and the 
different channels. You can try SELECT DISTINCT to narrow down the results to only the unique values.*/

select distinct accounts.id,web_events.`channel` from accounts join web_events on accounts.id = web_events.account_id
where accounts.id = '1001'

Or 

select accounts.id,web_events.`channel` from accounts join web_events on accounts.id = web_events.account_id
where accounts.id = '1001' group by web_events.channel


/*Find all the orders that occurred in 2015. Your final table should have 4 columns: occurred_at, account name, order total, and order total_amt_usd.*/

select a.`name`,o.total,o.total_amount_usd ,o.occured from accounts a join orders o on a.id = o.account_id
where o.occured between '2015-01-01 17:13:58' and '2016-01-01 17:13:58'
order by 4 desc
/////////////////////////////////////-----AGGREGATION FUNCTIONS----////////////////////////////////////////////////
AVG - COUNT - MAX - MIN - SUM - STD - STDDEV
MEAN, MEDIAN, MODE calculation along WITH percentile_cont

/*Find the total amount of poster_qty paper ordered in the orders table.*/
select sum(gloss_quantity) as total_amount_of_posters_qty from orders

/*Find the total amount of standard_qty paper ordered in the orders table.*/
select sum(standard_quantity) as total_amount_of_posters_qty from orders

/*Find the total dollar amount of sales using the total_amt_usd in the orders table.*/
select sum(total_amount_usd) as total_amount_of_posters_qty from orders

/*Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in the orders table. 
This should give a dollar amount for each order in the table.*/
select id, standard_amount_usd + gloss_amount_usd as Total_amount from orders

/*Find the standard_amt_usd per unit of standard_qty paper. Your solution should use both an aggregation 
and a mathematical operator.*/
select id, standard_amount_usd / standard_quantity as amount_per_unit from orders

/*When was the earliest order ever placed? You only need to return the date.*/

SELECT MIN(occured) FROM orders

/*Try performing the same query as above 1 without using an aggregation function.*/
select occured from orders order by occured  limit 1

/*When did the most recent (latest) web_event occur?*/
select max(occured_at) from web_events

/*Try to perform the result of the previous query without using an aggregation function.*/
select id, occured_at from web_events order by occured_at desc limit 1

/*Find the mean (AVERAGE) amount spent per order on each paper type, as well as 
the mean amount of each paper type purchased per order. 
Your final answer should have 6 values - one for each paper type for the average number of sales, 
as well as the average amount//*/

select avg(standard_quantity) as avg_std_qty,avg(gloss_quantity) as avg_gloss_qty,avg(poster_quantity) as avg_poster_qty, avg(standard_amount_usd)
as standard_amount_usd, avg(gloss_amount_usd) as gloss_amount_usd,avg(poster_amount_usd) as poster_amount_usd from orders

///* Find median for Total_amount_usd/
Below is correct but not working in mysql*/

with CTE as(
select total_amount_usd, row_number() over (order by total_amount_usd) as RN_asc,
row_number() over (order by total_amount_usd desc) as RN_desc from orders)
select * from cte where abs (RN_asc - RN_desc) <= 1

select * , percentile_cont(0.5) within group (order by total_amount_usd) over() as median from orders


/*below is the table created and claculated median in 2 methods in snowflake*/

create database median_calculation
use median_calculation

create or replace table numbers(
Number integer)

Insert into numbers values(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11)

select percentile_cont(0.5) within group (order by number) over() as `median` from numbers

with CTE as(
select number, row_number() over (order by number) as RN_asc,
row_number() over (order by number desc) as RN_desc from numbers)
select * from cte where abs (RN_asc - RN_desc) <= 1

///////////////////

/*Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order.*/
select accounts.name,orders.occured from accounts join orders on accounts.id = orders.account_id  order by occured limit 1


/*Find the total sales in usd for each account. You should include two columns - the total sales for each company's orders in usd  */
select accounts.name,sum(orders.total_amount_usd) as total_usd from accounts join orders on accounts.id = orders.account_id group by accounts.name



/*Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event? 
Your query should return only three values - the date, channel, and account name.*/
select accounts.name,web_events.channel,web_events.occured_at from accounts join web_events on accounts.id  = web_events.account_id
order by web_events.occured_at desc

/*Find the total number of times each type of channel from the web_events was used. 
Your final table should have two columns - the channel and the number of times the channel was used.*/
select channel, count(channel) as total_number_of_times from web_events group by channel order by total_number_of_times desc

/*Who was the Sales Rep associated with the earliest web_event?*/
select accounts.sales_rep_id,web_events.occured_at, sales_rep.name from accounts join web_events on accounts.id = web_events.account_id
join sales_rep on sales_rep.id = accounts.sales_rep_id order by web_events.occured_at limit 1


/////////////////--- USE OF AGGREGATIONS ALONG WITH ADVANCE JOIN CONCEPT -----//////////////////////

/*Who was the primary contact associated with the earliest web_event?*/

select accounts.sales_rep_id,web_events.occured_at, sales_rep.name, accounts.primary_poc as primary_contact from accounts join web_events on accounts.id = web_events.account_id
join sales_rep on sales_rep.id = accounts.sales_rep_id order by web_events.occured_at limit 1

/*What was the smallest order placed by each account in terms of total usd. 
Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest.*/
select accounts.name,min(orders.total_amount_usd) as min_amount from accounts join orders on accounts.id = orders.account_id group by accounts.name order by min_amount


/*Find the number of sales reps in each region. 
Your final table should have two columns - the region and the number of sales_reps. Order from fewest reps to most reps.*/

select region.name,count(sales_rep.name) as total_sales_rep from sales_rep left join region on sales_rep.region_id = region.id 
group by region.name order by total_sales_rep


/*For each account, determine the average amount of each type of paper they purchased across their orders. 
Your result should have four columns - one for the account name and one for the average quantity purchased 
for each of the paper types for each account.*/

select accounts.name, avg(gloss_quantity) as avg_gloss_qty, avg(poster_quantity) as poster_quantity, avg(standard_quantity) as avg_standard_quantity
from orders join accounts on accounts.id = orders.account_id group by accounts.name



/*For each account, determine the average amount spent per order on each paper type. 
Your result should have four columns - one for the account name and one for the average amount spent on each paper type.*/

select accounts.name, avg(standard_amount_usd) as avg_std_amt, avg(gloss_amount_usd) as avg_gloss_amt,avg(poster_amount_usd) as avg_std_amt
from orders join accounts on accounts.id=orders.account_id group by accounts.name


/*Determine the number of times a particular channel was used in the web_events table for each sales rep. 
Your final table should have three columns - the name of the sales rep, the channel, and the number of occurrences. 
Order your table with the highest number of occurrences first.*/

select sales_rep.name,web_events.channel as channel , count(web_events.channel) as count_of_channel_per_re from web_events 
 left join accounts on accounts.id = web_events.account_id join sales_rep on accounts.sales_rep_id = sales_rep.id 
group by sales_rep.name order by 3 desc


/*Determine the number of times a particular channel was used in the web_events table for each region. 
Your final table should have three columns - the region name, the channel, and the number of occurrences. 
Order your table with the highest number of occurrences first.*/

select region.name,web_events.channel,count(web_events.channel) from web_events left join accounts on web_events.account_id = accounts.id
 join sales_rep on accounts.sales_rep_id = sales_rep.id  join region on region.id = sales_rep.region_id group by region.name,channel
order by 3 desc


/*Use DISTINCT to test if there are any accounts associated with more than one region.*/



/*The below two queries have the same number of resulting rows (351), 
so we know that every account is associated with only one region. 
If each account was associated with more than one region, the first query should have returned more rows than the second query.
*/

with cte as (select a.id as account_id, r.id as region_id,a.name as account_name,r.name as region_name from accounts a join sales_rep s on
a.sales_rep_id = s.id join region r  on s.region_id = r.id)
select count(*) from cte
 
 and 
 
select count(distinct (id)), name from accounts


/*Have any sales reps worked on more than one account?*/
select sales_rep.name,sales_rep.id, count(*) from sales_rep join accounts on accounts.sales_rep_id = sales_rep.id
group by 1,2
order by 3



/*How many of the sales reps have more than 5 accounts that they manage?*/

select sales_rep.name,count(accounts.name) as count_of_account_holding from accounts join sales_rep on accounts.sales_rep_id = sales_rep.id
group by 1
having count(accounts.name) > 5 


/*How many accounts have more than 20 orders?*/
select accounts.name as account_name, count(*) as count_of_orders from accounts join orders on accounts.id = orders.account_id
group by 1
having count_of_orders > 20

/*Which account has the most orders?*/
select accounts.name as account_name, count(*) as count_of_orders from accounts join orders on accounts.id = orders.account_id
group by 1
order by count_of_orders desc
limit 1


/*Which accounts spent more than 30,000 usd total across all orders?*/

select accounts.name as account_name,sum(total_amount_usd) as total_usd from accounts join orders on 
accounts.id = orders.account_id group by 1
having total_usd > 30000

/*Which accounts spent less than 1,000 usd total across all orders?*/

select accounts.name as account_name,sum(total_amount_usd) as total_usd from accounts join orders on 
accounts.id = orders.account_id group by 1
having total_usd < 1000

/*Which account has spent the most with us?*/

select accounts.name as account_name,sum(total_amount_usd) as total_usd from accounts join orders on 
accounts.id = orders.account_id group by 1
order by total_usd desc
limit 1


/*Which account has spent the least with us?*/
select accounts.name as account_name,sum(total_amount_usd) as total_usd from accounts join orders on 
accounts.id = orders.account_id group by 1
order by total_usd
limit 1

/*Which accounts used facebook as a channel to contact customers more than 6 times?*/

select accounts.name as account_name, count(channel) as count_of_facebook from accounts join web_events on 
accounts.id = web_events.account_id
where channel = 'facebook'
group by 1
having count_of_facebook > 6
order by count_of_facebook desc


/*Which channel was most frequently used by most accounts?*/
select channel, count(*) as 'usage' from web_events group by channel order by 'usage' desc limit 1


/*Which channel was most frequently used by most accounts? (including account name)*/

select accounts.name, channel, count(*) as 'usage' from web_events join accounts on accounts.id = web_events.account_id
group by 1,2 order by 3 desc 

---if i dont give 1,2 here and if i give 1, it will group count of usage by channel name, so we may get 
                        count of all channel. in order to get count of 1 particular channel (direct,indirect etc, we should group by
						1,2)


/////////////////---- USE OF DATE FUNCTION ALONG WITH AGGREGATE AND JOINS ----////////////////
EXTRACT  -  MONTH , YEAR , DATE

/*Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. 
Do you notice any trends in the yearly sales totals?*/
/*Answer: When we look at the yearly totals, you might notice that 2013 and 2017 have much smaller totals than all other years. 
If we look further at the monthly data, we see that for 2013 and 2017 there is only one month of sales 
for each of these years (12 for 2013 and 1 for 2017). Therefore, neither of these are evenly represented. 
Sales have been increasing year over year, with 2016 being the largest sales to date. 
At this rate, we might expect 2017 to have the largest sales.*/

select extract(year FROM occured) as 'year', sum(total_amount_usd) as total_sales from orders group by 1 order by 1 desc


/*Which month did Parch & Posey have the greatest sales in terms of total dollars? 
Are all months evenly represented by the dataset?*/
/*Answer: In order for this to be 'fair', we should remove the sales from 2013 and 2017. 
For the same reasons as discussed above.
The greatest sales amounts occur in December (12).
*/

select extract(year FROM occured) as 'year', sum(total_amount_usd) as total_sales from orders 
where occured between '2014-1-01' and '2017-01-01'
group by 1 order by 1 desc


/*Which year did Parch & Posey have the greatest sales in terms of total number of orders? 
Are all years evenly represented by the dataset?*/
/*Answer: 2016 by far has the most amount of orders, 
but again 2013 and 2017 are not evenly represented to the other years in the dataset.*/

select extract(year FROM occured) as 'year', count(*) as total_orders from orders group by 1 order by 2 desc limit 1


/*Which month did Parch & Posey have the greatest sales in terms of total number of orders? 
Are all months evenly represented by the dataset?*/

select extract(month FROM occured) as 'year', count(*) as total_orders from orders group by 1 order by 2 desc limit 1


/*In which month of which year did Walmart spend the most on gloss paper in terms of dollars?*/

with cte as (SELECT accounts.name as account_name, EXTRACT(YEAR FROM occured) AS year, EXTRACT(MONTH FROM occured) AS month, sum(gloss_amount_usd)
as total_gloss_amount FROM orders join accounts on accounts.id = orders.account_id 
group by 2,3 
order by 2,3 desc)
select account_name,year,month,total_gloss_amount from cte where account_name = 'walmart' order by 4 desc limit 1



/*Write a query to display for each order, the account ID, total amount of the order, and the level of the order - â€˜Largeâ€™ or â€™Smallâ€™
- depending on if the order is $3000 or more, or smaller than $3000.*/

select account_id,total_amount_usd,

case when total_amount_usd >3000 then 'large' else 'small'
end as remark 
from orders


/*Write a query to display the number of orders in each of three categories, based on the total number of items in each order. 
The three categories are: 'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.*/

select
         case 
         when total >= 2000 then 'at_least_2000'
		 when total >=1000  and total < 2000 then 'between_1000_and_2000'
		 when total < 1000 then 'less_than_1000'
end as order_remark,
count(*) as total_number_of_orders from orders group by 1

//////////////////////-----    USE OF CASE STATEMENT    --------//////////////////////  -  DATE FUNCTIONS

/*We would like to understand 3 different levels of customers based on the amount associated with their purchases. 
The top level includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd. 
The second level is between 200,000 and 100,000 usd. 
The lowest level is anyone under 100,000 usd. 
Provide a table that includes the level associated with each account. 
You should provide the account name, the total sales of all orders for the customer, and the level. 
Order with the top spending customers listed first.*/

select accounts.name, sum(total_amount_usd) as total,
case 
	when sum(total_amount_usd) >= 200000 then 'Top'
    when sum(total_amount_usd) < 200000 and sum(total_amount_usd) >= 100000 then 'middle'
    else 'low'
    end as remarks from orders join accounts on accounts.id = orders.account_id group by 1 order by 2 desc
  

/*We would now like to perform a similar calculation to the first, 
but we want to obtain the total amount spent by customers only in 2016 and 2017. 
Keep the same levels as in the previous question. Order with the top spending customers listed first.*/

select accounts.name, sum(total_amount_usd) as total,
case 
	when sum(total_amount_usd) >= 200000 then 'Top'
    when sum(total_amount_usd) < 200000 and sum(total_amount_usd) >= 100000 then 'middle'
    else 'low'
    end as remarks from orders join accounts on accounts.id = orders.account_id 
    where extract(year from occured) between 2016 and 2017
    group by 1 order by 2 desc
    


/*We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders. 
Create a table with the sales rep name, the total number of orders, 
and a column with top or not depending on if they have more than 200 orders. Place the top sales people first in your final table.*/

select sales_rep.name, count(orders.id) as total_count_of_orders,

case
	when count(orders.id) > 200 then 'top'
    else 'low'
    end as remark
    from sales_rep join accounts on sales_rep.id = accounts.sales_rep_id
	join orders on accounts.id = orders.account_id group by 1 order by 2 desc



/*The previous didn't account for the middle, nor the dollar amount associated with the sales. 
Management decides they want to see these characteristics represented as well. 
We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders 
or more than 750000 in total sales. The middle group has any rep with more than 150 orders or 500000 in sales. 
Create a table with the sales rep name, the total number of orders, total sales across all orders, 
and a column with top, middle, or low depending on this criteria. 
Place the top sales people based on dollar amount of sales first in your final table. 
You might see a few upset sales people by this criteria!*/



select sales_rep.name, count(orders.id) as total_count_of_orders,sum(total_amount_usd) as total_usd,

case
	when count(orders.id) > 200 then 'top'
    else 'low'
    end as remark,

    case 
    when sum(total_amount_usd) > 750000 or count(orders.id) > 200 then 'top'
    when sum(total_amount_usd) > 50000 or count(orders.id) > 150 then 'middle'
    else 'low'
    end as remark_2_on_value
    from sales_rep join accounts on sales_rep.id = accounts.sales_rep_id
	join orders on accounts.id = orders.account_id group by 1 order by 2 desc
    ////////////////////////////////////////////////////////////////////////////////
    
    Sub Queries & Temporary Tables.sql//// *//
    
    
    /*number of events that occur for each day for each channel*/


select DAYNAME(occured_at) as 'daynumber',channel, count(*) as count_of_events from web_events group by 1,2 order by 1 desc;


/*find the average number of events for each channel. Average per day*/

select channel, avg(count_of_events) as AVG_COUNT from 
(select DAYNAME(occured_at) as 'daynumber',channel, count(*) as count_of_events from web_events group by 1,2 order by 1 desc) as test
group by 1
order by 2 desc

/*list of orders happended at the first month in P&P history , ordered by occurred_at */

select * from orders where extract(month from occured) =  (select extract(month from min(occured)) from orders)
Having extract(year from occured) = 2013;


******************************************************************************/
////////////////////////////////-------   ADVANCED JOINS CONCEPT  -------------------//////////////////////
ALONG WITH UPPER, LOWER, RIGHT, LEFT , LOCATE, CONCATE, TRIM, LENGTH and Others



select * from orders;
select * from accounts;
select * from region;
select * from sales_rep;
select * from web_events;
/*sales rep total sales for each region*/

	select s.`name` as sales_rep_name, r.`name` as region_name, sum(o.total_amount_usd) as total_sales from orders o 
    left outer join accounts a on o.account_id = a.id
	left outer join sales_rep s on s.id = a.sales_rep_id
    left outer join region r on r.id = s.region_id
    group by 1,2
///////////////////////////////////////

/*maximum total sales in each region*/

	select s.`name` as sales_rep_name, r.`name` as region_name, max(o.total_amount_usd) as max_total_sales from orders o 
    left outer join accounts a on o.account_id = a.id
	left outer join sales_rep s on s.id = a.sales_rep_id
    left outer join region r on r.id = s.region_id
    group by 1,2

////////////////////////////////
/*1) Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.*/

select region_name, sales_rep_name, total_max_sales from 
(select r.id as region_id, r.`name` as region_name, sr.id as sales_rep_id, sr.`name` as sales_rep_name, sum(o.total_amount_usd)
as total_sales_per_rep from
orders o left join accounts a on o.account_id = a.id
left join sales_rep sr on a.sales_rep_id = sr.id
left join region r on sr.region_id =  r.id
group by 1,2,3,4) as temp1
join (select temp2.region_id as region_id, max(total_sales_per_rep) as total_max_sales from

(select r.id as region_id, r.`name` as region_name, sr.id as sales_rep_id, sr.`name` as sales_rep_name, sum(o.total_amount_usd)
as total_sales_per_rep from
orders o left join accounts a on o.account_id = a.id
left join sales_rep sr on a.sales_rep_id = sr.id
left join region r on sr.region_id =  r.id
group by 1,2,3,4) as temp2
group by 1) as temp3
on temp3.region_id = temp1.region_id
and temp1.total_sales_per_rep = temp3.total_max_sales

//////////////////
/*For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?*/

select count(*) as total_orders, r.`name` from orders o left join accounts a on a.id = o.account_id
left join sales_rep sr on a.sales_rep_id = sr.id
left join region r on r.id = sr.region_id where r.name = (
select region_name from (
select r.`name` as region_name,sum(o.total_amount_usd) total_sales from
orders o left join accounts a on o.account_id = a.id
left join sales_rep sr on a.sales_rep_id = sr.id
left join region r on sr.region_id =  r.id
group by 1 order by 2 desc limit 1) as temp)

//////////////////////////////////////////////////////////////////

/**** CTE Common Table Expressions ****/

/*find the average number of events for each channel per day.*/

with CTE as (select date(occured_at) as `day`, `channel`, count(*) as total_event
from web_events
group by 1,2)
select `channel`, avg(total_event) as avg_total_event from CTE
........................................................

/* CLEANING AND EXTRACTING DATA/*/
/*Check how many distinct domains were there in the websites under accounts data/*/

select right(website,3), count(*) from accounts
group by 1
order by 2 desc

..........................................

/*2) There is much debate about how much the name (or even the first letter of a company name) matters. 
Use the accounts table to pull the first letter of each company name to see 
the distribution of company names that begin with each letter (or number).*/

select upper(left(name,1)) as letter, count(*) as total from accounts group by 1 order by 2 desc;

..................................................................

/*3) Use the accounts table and a CASE statement to create two groups: 
one group of company names that start with a number 
and a second group of those company names that start with a letter. 
What proportion of company names start with a letter?*/

select sum(num) as starts_with_number, sum(let) as starts_with_letters from
(select case when upper(left(`name`,1)) in ('0','2','3','4','5','6','7','8','9') then 1 else 0 end as num,
		case when upper(left(`name`,1)) in ('0','2','3','4','5','6','7','8','9') then 0 else 1 end as let
        from accounts) as temp1

.......................................................

/*4) Consider vowels as a, e, i, o, and u. 
What proportion of company names start with a vowel, and what percent start with anything else?*/

select sum(num) as starts_with_ovels, sum(numv) as starts_with_no_ovels from
(select case when upper(left(`name`,1)) in ('a','e','i','o','u') then 1 else 0 end as num,
		case when upper(left(`name`,1)) in ('a','e','i','o','u') then 0 else 1 end as numv
        from accounts) as temp1
.................................................................


/*1)Use the accounts table to create first and last name columns that hold the first and last names for the primary_poc.*/

select primary_poc, left(primary_poc, locate(' ',primary_poc) -1) as first_name ,
right(primary_poc, locate(' ',primary_poc) +1) as last_name
from accounts;

/****** CONCATE or || *************/

/*1/2)Each company in the accounts table wants to create an email address for each primary_poc. 
The email address should be the first name of the primary_poc . last name primary_poc @ company name .com.*/

with CTE as (select primary_poc, trim(left(primary_poc, locate(' ',primary_poc) -1)) as first_name ,
trim(right(primary_poc, locate(' ',primary_poc) +1)) as last_name, `name`
from accounts)
select concat(first_name,last_name,"@",`name`) as mail_id from CTE


/*We would also like to create an initial password, which they will change after their first log in. 
The first password will be the first letter of the primary_poc's first name (lowercase), 
then the last letter of their first name (lowercase), 
the first letter of their last name (lowercase), 
the last letter of their last name (lowercase), 
the number of letters in their first name, 
the number of letters in their last name, 
and then the name of the company they are working with, 
all capitalized with no spaces.
*/


with CTE as (select trim(left(primary_poc, locate(' ',primary_poc) -1)) as first_name ,
trim(right(primary_poc, locate(' ',primary_poc) +1)) as last_name, primary_poc,`name`
from accounts)
select primary_poc, concat(right(primary_poc,1),left(primary_poc,1),right(last_name,1),left(last_name,1),
length(first_name),length(last_name),upper(`name`)) as `password` from CTE

//////////////////////////////////---------- ADVANCED WINDOW FUNCTIONS -----------//////////////////////////////

CUME_DIST() - DENSE_RANK() - FIRST_VALUE() - LAG() - LAST_VALUE() - LEAD() - NTH_VALUE() 
NTILE() - PERCENT_RANK() - RANK() - ROW_NUMBER()


/*create a running total of standard_amt_usd (in the orders table) over order time with no date truncation. 
Your final table should have two columns: 
one with the amount being added for each new row, and a second with the running total.*/
select * from orders;
select standard_amount_usd, sum(standard_amount_usd) over (order by occured) as running_total from orders;


/*create a running total of total_amount_usd (in the orders table) over order time, 
but this time, date truncate occurred_at by year and partition by that same year-truncated occurred_at variable. 
Your final table should have three columns: One with the amount being added for each row, 
one for the truncated date, and a final column with the running total within each year.*/

select year(occured) as year, total_amount_usd as total_sales, sum(total_amount_usd) over (partition by year(occured) order by
occured) as  running_total from orders

/*Ranking Total Paper Ordered by Account*/

select id, account_id,total, rank() over(partition by account_id order by total desc) as `rank` from orders;

/*-------------- Window Aliases -----------------*/
Create a dense rank, min.max,avg,total using Aliases

select id,
account_id,
standard_quantity,
dense_rank() over main_window as ranking,
count(standard_quantity) over main_window as total_new_orders,
sum(standard_quantity) over main_window as total_new_orders,
avg(standard_quantity) over main_window as total_new_orders,
min(standard_quantity) over main_window as total_new_orders,
max(standard_quantity) over main_window as total_new_orders
from orders
window main_window as (partition by account_id order by year(occured))
.......................
/* ----------------- LEAD and LAG  ------------------------*/
/*LAG */

select account_id,sum(standard_quantity) as standard_sum,
lag(sum(standard_quantity)) over (order by account_id) as `lag`,
sum(standard_quantity)-lag(sum(standard_quantity)) over (order by account_id) as difference 
from orders 
group by 1
................................................

/*you want to determine how the current order's total revenue 
("total" meaning from sales of all types of paper) 
compares to the next order's total revenue.
there should be four columns: occurred_at, total_amt_usd, lead, and lead_difference.*/


select occured,total_amount_usd,
lead(total_amount_usd) over(order by occured) as `lead`, 
(total_amount_usd - lead(total_amount_usd) over(order by occured)) as difference_revenue
from orders
...................................................

SELECT id, account_id, occured,standard_quantity,
	NTILE(4) OVER (ORDER BY standard_quantity) AS quartile,
	NTILE(5) OVER (ORDER BY standard_quantity) AS quintile,
	NTILE(100) OVER (ORDER BY standard_quantity) AS percentile
FROM orders
ORDER BY standard_quantity DESC;

/*Use the NTILE functionality to divide the accounts into 4 levels in terms of the amount of standard_qty 
for their orders. Your resulting table should have the account_id, the occurred_at time for each order, 
the total amount of standard_qty paper purchased, and one of four levels in a standard_quartile column.*/

select account_id, occured,standard_quantity,
ntile(4) over (partition by account_id order by standard_quantity) as tile4,
ntile(5) over (Partition by account_id order by standard_quantity) as tile5,
ntile(100) over(partition by account_id order by standard_quantity) as percentile
from orders

/*Use the NTILE functionality to divide the accounts into two levels in terms of the amount of gloss_qty 
for their orders. Your resulting table should have the account_id, 
the occurred_at time for each order, the total amount of gloss_qty paper purchased, 
and one of two levels in a gloss_half column.
*/

select account_id, occured, gloss_quantity,
ntile(2) over(partition by account_id order by gloss_quantity) as ntile2 from orders;

/*For percentile division use NITILE(100)?*;


//////////////////////////--- ONCE AGAIN ADVANCED JOINS CONCEPT WITH OTHER CONCEPT COMBINED -----////////////////////////


/*Say you're an analyst at Parch & Posey and you want to see:
each account who has a sales rep and each sales rep that has an account 
(all of the columns in these returned rows will be full)

but also each account that does not have a sales rep and each sales rep that does not have an account 
(some of the columns in these returned rows will be empty)*/
SELECT accounts.id, accounts.name, sales_rep.id, sales_rep.`name`
FROM accounts
LEFT OUTER JOIN sales_rep ON accounts.sales_rep_id = sales_rep.id
UNION
SELECT accounts.id, accounts.name, sales_rep.id, sales_rep.`name`
FROM accounts
RIGHT OUTER JOIN sales_rep ON accounts.sales_rep_id = sales_rep.id
WHERE accounts.id IS NULL;

/*above we did (WHERE accounts.id IS NULL) because we are doing full outer join, which is just opposite of inner join*/


SELECT accounts.name,accounts.primary_poc,sales_rep.name
FROM accounts
LEFT JOIN sales_rep
ON accounts.sales_rep_id = sales_rep.id
AND accounts.primary_poc  < sales_rep.name


/*List down all web events one after another datewise ascending  order ,  account id wise*/
select 
we1.id as web_id,
we1.account_id as account_id,
we1.occured_at as occured_at,
we1.`channel` as `channel`,
we2.id as web_id,
we2.account_id as account_id,
we2.occured_at as occured_at,
we2.`channel` as `channel`
from web_events we1 left outer join web_events we2 on
we1.account_id = we2.account_id
and
we1.occured_at > we2.occured_at
and
we1.occured_at <= we2.occured_at + interval 1 day
ORDER BY we1.account_id, we2.occured_at;


////////////////////////////////////////------    /* UNION ALL vs UNION */   --------////////////////////////////////////////


/*Nice! UNION only appends distinct values. 
More specifically, when you use UNION, the dataset is appended, and any rows in the appended table 
that are exactly identical to rows in the first table are dropped. 

If youâ€™d like to append all the values from the second table, use UNION ALL. 
Youâ€™ll likely use UNION ALL far more often than UNION.*/

SELECT * FROM accounts a1
WHERE name LIKE 'Walmart'
UNION ALL
SELECT * FROM accounts a2
WHERE name LIKE 'Disney'

/*Perform the union in your first query (under the Appending Data via UNION header) in a common table expression and 
name it double_accounts. Then do a COUNT the number of times a name appears in the double_accounts table. 
If you do this correctly, your query results should have a count of 2 for each name.*/
WITH double_accounts AS(
	SELECT * FROM accounts a1
	UNION ALL
	SELECT * FROM accounts a2)

SELECT name, COUNT(*)
FROM double_accounts
GROUP BY name;

/* PERFORMANCE TUNING */
EXPLAIN
SELECT *
FROM web_events
WHERE occured_at >= '2016-01-01'
AND occured_at < '2016-02-01'
LIMIT 100;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



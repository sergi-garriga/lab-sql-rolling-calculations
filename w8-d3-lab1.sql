use sakila;



-- 1. Get number of monthly active customers.
select * from customer;
select * from rental;

create or replace view monthly_active_customers as
select count(distinct customer_id) active_customers, 
		date_format(convert(rental_date, date), '%M') as activity_month,
        date_format(convert(rental_date, date), '%Y') as activity_year
from rental
group by activity_month, activity_year
order by activity_year;

select * from monthly_active_customers;



-- 2. Active users in the previous month.
create or replace view monthly_compare_ac as
select active_customers,
lag(active_customers) over() as previous_month_customers,
activity_month,
activity_year
from monthly_active_customers
order by activity_year, activity_month desc;
select * from monthly_compare_ac;



-- 3. Percentage change in the number of active customers.
select active_customers, previous_month_customers, round(active_customers/previous_month_customers*100, 2) as 'increment(%)', activity_month, activity_year
from monthly_compare_ac;



-- 4. Retained customers every month.
select distinct customer_id as active_customers, 
		date_format(convert(rental_date, date), '%m') as activity_month,
        date_format(convert(rental_date, date), '%Y') as activity_year
from rental;

create or replace view ac_from_05_2005 as -- distinct customers for May 2005
select * from(
	select distinct customer_id as active_customers, 
			date_format(convert(rental_date, date), '%m') as activity_month,
			date_format(convert(rental_date, date), '%Y') as activity_year
	from rental)sub1
where activity_month = 05 and activity_year = 2005
order by active_customers;
select * from ac_from_05_2005;

create or replace view ac_from_06_2005 as -- distinct customers for June 2005
select * from(
	select distinct customer_id as active_customers, 
			date_format(convert(rental_date, date), '%m') as activity_month,
			date_format(convert(rental_date, date), '%Y') as activity_year
	from rental)sub1
where activity_month = 06 and activity_year = 2005
order by active_customers;
select * from ac_from_06_2005;

create or replace view ac_from_07_2005 as -- distinct customers for July 2005
select * from(
	select distinct customer_id as active_customers, 
			date_format(convert(rental_date, date), '%m') as activity_month,
			date_format(convert(rental_date, date), '%Y') as activity_year
	from rental)sub1
where activity_month = 07 and activity_year = 2005
order by active_customers;
select * from ac_from_07_2005;

create or replace view ac_from_08_2005 as -- distinct customers for August 2005
select * from(
	select distinct customer_id as active_customers, 
			date_format(convert(rental_date, date), '%m') as activity_month,
			date_format(convert(rental_date, date), '%Y') as activity_year
	from rental)sub1
where activity_month = 08 and activity_year = 2005
order by active_customers;
select * from ac_from_08_2005;

select -- comparing months...
m5.active_customers as 'Customers May 2005', 
m6.active_customers as 'Customers June 2005',
m7.active_customers as 'Customers July 2005',
m8.active_customers as 'Customers August 2005'
from ac_from_05_2005 m5
right join ac_from_06_2005 m6
on m5.active_customers = m6.active_customers
right join ac_from_07_2005 m7
on m6.active_customers = m7.active_customers
right join ac_from_08_2005 m8
on m7.active_customers = m8.active_customers
order by m8.active_customers;
	-- I didn't know what was the answer, so I provided a table that allows to follow when the customer began to
    -- be active, and if was active in the following months.
    -- I thoght that the best way to do that was with the 'full outer join', but it was giving an error. So I could
    -- perform the 'right join' because the customers were increasing month by month. Otherwise, the results wouldn't 
    -- be right.











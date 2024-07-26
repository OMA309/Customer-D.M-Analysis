# Customer D.M Analysis
## Objective:
Develop an intermediate-level SQL project to manage and analyze 
customer data. The project will focus on advanced querying techniques, 
data manipulation, and generating insights from the dataset provided.
## Dataset:
The dataset includes comprehensive customer demographic 
information, purchasing behavior, and responses to marketing 
campaigns.
## Tool:
SQL 
## Tasks:
1. Database Setup:
 - Create a new database to store the customer data.
```SQL
CREATE DATABASE IF NOT EXISTS DLITES_DB;
```
- Load the dataset into the database.
```SQL
LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\marketing_data.csv"
INTO TABLE marketing_data
FIELDS TERMINATED BY ','     -- this approach was imployed in other to get the datafile imported into the database
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES ;
```
 - Define appropriate data types for each column and create tables.
```SQL
Alter table marketing_data
rename column ï»¿ID to ID;
-- modify the income column from text to varchar/int
update marketing_data
set Income = replace(Income,'$','');
alter table marketing_data
    add column age_group varchar(20) after Year_birth;
```
## 2. Data Cleaning and Preparation:
 - Identify and handle missing or null values.
```SQL
 select * from marketing_data
 group by ID
 having count(*)>1; -- this is to check for duplicates if there is any
``` 
 - Correct data types where necessary (e.g., convert `Income` from 
string to numeric).
```SQL
update marketing_data
set Income = replace(Income,',','');

alter table marketing_data
modify column Income Decimal(10,2);

-- modify the Dt-customer to  a date data type
update marketing_data
set Dt_Customer = replace(Dt_Customer,'-','/');

update marketing_data
set Dt_Customer = str_to_date(Dt_Customer,'%m/%d/%Y') ;

alter table marketing_data
modify column Dt_Customer DATE;

alter table marketing_data
modify column AcceptedCmp3 boolean;      

alter table marketing_data
modify column AcceptedCmp2 boolean; 

alter table marketing_data
modify column AcceptedCmp4 boolean; 

alter table marketing_data
modify column AcceptedCmp5 boolean; 

alter table marketing_data
modify column AcceptedCmp1 boolean; 
```
 - Ensure that date fields are in the correct format.
```SQL
 -- to check for missing for null value--alter
delimiter //
create procedure null_value_check()
 begin
 select count(*) `total row`,
 sum(case when ID is null then 1 else 0 end) ID,
 sum(case when Year_Birth is null then 1 else 0 end)yearbirth,
 sum(case when Education is null then 1 else 0 end)education,
 sum(case when Marital_Status is null then 1 else 0 end)Mstatus,
 sum(case when Income is null then 1 else 0 end)income,
 sum(case when Kidhome is null then 1 else 0 end)Kidhome,
 sum(case when Teenhome is null then 1 else 0 end)Teenhome,
 sum(case when Dt_Customer is null then 1 else 0 end)Dt_Customer,
 sum(case when Recency is null then 1 else 0 end)Recency,
 sum(case when MntWines is null then 1 else 0 end)MntWines,
 sum(case when MntFruits is null then 1 else 0 end)MntFruits,
 sum(case when MntMeatProducts is null then 1 else 0 end)MntMeatProducts,
 sum(case when MntFishProducts is null then 1 else 0 end)MntFishProducts,
 sum(case when MntSweetProducts is null then 1 else 0 end)MntSweetProducts,
 sum(case when MntGoldProds is null then 1 else 0 end)MntGoldProds,
 sum(case when NumDealsPurchases is null then 1 else 0 end)NumDealsPurchases,
 sum(case when NumWebPurchases is null then 1 else 0 end) NumWebPurchases,
 sum(case when NumStorePurchases is null then 1 else 0 end)NumStorePurchases ,
 sum(case when NumWebVisitsMonth is null then 1 else 0 end)NumWebVisitsMonth,
 sum(case when AcceptedCmp3 is null then 1 else 0 end)AcceptedCmp3,
 sum(case when AcceptedCmp4 is null then 1 else 0 end)AcceptedCmp4,
 sum(case when AcceptedCmp5 is null then 1 else 0 end)AcceptedCmp5,
 sum(case when AcceptedCmp1 is null then 1 else 0 end)AcceptedCmp1,
 sum(case when AcceptedCmp2 is null then 1 else 0 end)AcceptedCmp2,
 sum(case when Response is null then 1 else 0 end)Response,
 sum(case when Complain is null then 1 else 0 end)Complain,
 sum(case when Country is null then 1 else 0 end)country
from marketing_data;
 end //
 delimiter ;
 call null_value_check();-- it will display 1 for values, also the stored proceedure was engaged in other manage the long query and also for later update

select  
case when (year( current_date())-year_birth)<=39 then '28-39'
    when (year( current_date())-year_birth)<=49 then '40-49'
    when (year( current_date())-year_birth)<=59 then '50-59'
    when (year( current_date())-year_birth)<=69 then '60-69' -- this was imployed in other get the individul year into proper age-group
    when (year( current_date())-year_birth)<=79 then '70-79'
    when (year( current_date())-year_birth)<=89 then '80-89'
    when (year( current_date())-year_birth)<=99 then '90-99'
    when (year( current_date())-year_birth)<=109 then '100-109'
    when (year( current_date())-year_birth)<=119 then '110-119'
    else '120+'
    end as age_group
    from marketing_data;

update marketing_data
set age_group = 
case
    when Year_Birth >= 2000 then 'Gen Z'
    when Year_Birth between 1980 and 1999 then 'Millennials'
    when Year_Birth between 1965 and 1979 then 'Gen X'        -- having done the age grouping, it was later group into segments for a better labelling 
    when Year_Birth between 1946 and 1964 then 'Baby Boomers'
    else 'Silent Generation'
end;
```
## 3. Advanced Querying:
 - summary statistics
```SQL
select concat('$', round(Avg(income),2))avg_income from marketing_data ; -- the average income of everyone included in the dataset is $52247.25
select concat('$', min(Income))minincome,concat('$', max(income))maxincome from marketing_data; -- while the min income is $1730.00 and max is $666666.00
```
```SQL
select age_group, 
count(ID)frequency,
concat('$', round(Avg(income),2))avg_income,    
(select concat('$', min(Income)))minincome,
(select concat('$', max(income)))maxincome
from marketing_data
group by age_group
order by frequency desc;
```
```SQL
select Education, 
count(ID)frequency,
concat('$', round(Avg(income),2))avg_income,
(select concat('$', min(Income)))minincome,
(select concat('$', max(income)))maxincome
from marketing_data
group by Education
order by frequency desc;
```
```SQL
select Marital_Status, 
count(ID)frequency, 
concat('$', round(Avg(income),2))avg_income,
(select concat('$', min(Income)))minincome,
(select concat('$', max(income)))maxincome
from marketing_data
group by Marital_Status
order by frequency desc;
```
```SQL
select Country, 
count(ID)frequency,
concat('$', round(Avg(income),2))avg_income,
(select concat('$', min(Income)))minincome,
(select concat('$', max(income)))maxincome
from marketing_data
group by Country
order by frequency desc;
```
```SQL
select age_group, Education,marital_status,country,
count(ID)frequency,
concat('$', round(Avg(income),2))avg_income,
(select concat('$', min(Income)))minincome,   
(select concat('$', max(income)))maxincome
from marketing_data
group by  Education,marital_status,country
order by frequency desc;
```
```SQL
select country, 
sum(case when kidhome = 1 then 1 else 0 end)kidhome1,
sum(case when kidhome = 2 then 1 else 0 end)kidhome2,
sum(case when Teenhome =1 then 1 else 0 end)teenhome1
from marketing_data group by country;
```
```SQL
select Education, 
sum(case when kidhome = 1 then 1 else 0 end)kidhome1,
 sum(case when kidhome = 2 then 1 else 0 end)kidhome2,
sum(case when Teenhome =1 then 1 else 0 end)teenhome1
from marketing_data group by Education;
```
```SQL
select Marital_Status, 
sum(case when kidhome = 1 then 1 else 0 end)kidhome1,
sum(case when kidhome = 2 then 1 else 0 end)kidhome2,
sum(case when Teenhome =1 then 1 else 0 end)teenhome1
from marketing_data group by Marital_Status;
```
## Utilized common table expressions (CTEs) for more 
advanced data manipulation.
```SQL
with Total_children as 
		(select age_group, Education,marital_status,country,
		count(ID)frequency,
		sum(case when kidhome = 1 then 1 else 0 end)kidhome1,
		sum(case when kidhome = 2 then 1 else 0 end)kidhome2,
		sum(case when Teenhome =1 then 1 else 0 end)teenhome1
		from marketing_data
		group by  Education,marital_status,country
		order by frequency desc)
select *, (kidhome1+(kidhome2*2)+teenhome1)children from Total_children;
```
### Customer Segmentation:
 - segments of customers based on demographics
 ```SQL
update marketing_data
set age_group = 
case
    when Year_Birth >= 2000 then 'Gen Z'
    when Year_Birth between 1980 and 1999 then 'Millennials'
    when Year_Birth between 1965 and 1979 then 'Gen X'         
    when Year_Birth between 1946 and 1964 then 'Baby Boomers'
    else 'Silent Generation'
end;
```
 - segments of customers purchasing behavior
```SQL
alter table marketing_data
add column Total_customer_spending int after MntGoldProds;

update marketing_data
set Total_customer_spending =
       (MntWines + 
       MntFruits + 
       MntMeatProducts +  
       MntFishProducts + 
       MntSweetProducts + 
       MntGoldProds) ;
```
- segments of customers responses to campaigns
```SQL
alter table marketing_data
add column customer_purchase_frequency int after Numstorepurchases;

update marketing_data
set  customer_purchase_frequency =
       (NumWebPurchases + NumCatalogPurchases +  -- customer purchase frequency was also derived fromm all if this
       NumStorePurchases);
```

 - Identify top-performing segments based on total 
spending
```SQL
select age_group,
	concat('$',sum(MntWines + 
       MntFruits + 
       MntMeatProducts + 
       MntFishProducts + 
       MntSweetProducts + 
       MntGoldProds))total_spending 
from marketing_data
		  group by age_group
		  order by total_spending desc;
```
 - Identify top-performing segments based on frequency of purchases
```SQL
Select age_group, 
       SUM(NumWebPurchases + NumCatalogPurchases + 
       NumStorePurchases) total_purchases
from marketing_data
	group by age_group
	order by total_purchases desc;
```

 - Identify top-performing segments based on  campaign responses.
```SQL
 select age_group, 
       sum(AcceptedCmp1 + 
       AcceptedCmp2 + 
       AcceptedCmp3 + 
       AcceptedCmp4 + 
       AcceptedCmp5) total_responses
from marketing_data
		group by age_group
		order by total_responses desc;
```

## Aim of the Analysis
The aim of the analysis is to reveal insight into the acceptance of product by their existing customer and potential customers and also to calculate their RFM analysis, which involve their segmentation and demographic data

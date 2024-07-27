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
    when (year( current_date())-year_birth)<=69 then '60-69' -- this was imployed in other get the individual year into proper age-group
    when (year( current_date())-year_birth)<=79 then '70-79'
    when (year( current_date())-year_birth)<=89 then '80-89'
    when (year( current_date())-year_birth)<=99 then '90-99'
    when (year( current_date())-year_birth)<=109 then '100-109'
    when (year( current_date())-year_birth)<=119 then '110-119'
    else '120+'
    end as age_group
    from marketing_data;

```
## 3. Advanced Querying:
 - summary statistics
```SQL
select concat('$', round(Avg(income),2))avg_income from marketing_data ;
select concat('$', min(Income))minincome,concat('$', max(income))maxincome from marketing_data; 
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
set    customer_purchase_frequency =
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

### Marketing Campaign Analysis:
 - Analyze the effectiveness of different marketing campaigns.
```SQL
Select age_group, Marital_Status,Education,
    sum(case when acceptedCmp3 = 1 then 1 else 0 end ) campaign3,
    sum(case when acceptedCmp4 = 1 then 1 else 0 end ) campaign4,
    sum(case when acceptedCmp5 = 1 then 1 else 0 end ) campaign5,
    sum(case when acceptedCmp1 = 1 then 1 else 0 end ) campaign1,
    sum(case when acceptedCmp2 = 1 then 1 else 0 end ) campaign2
from marketing_data
group by age_group,Marital_Status,Education ;
```
 - Write queries to calculate the response rates for each campaign
```SQL
select 
    sum(AcceptedCmp3) / count(*) as Campaign1_ResponseRate,
    sum(AcceptedCmp4) / count(*) as Campaign2_ResponseRate, 
    sum(AcceptedCmp5) / count(*) as Campaign3_ResponseRate,
    sum(AcceptedCmp1) / count(*) as Campaign4_ResponseRate,
    sum(AcceptedCmp2) / count(*) as Campaign5_ResponseRate
	from marketing_data;
```
 - Identify customers who have accepted multiple campaigns and analyze their behavior
```SQL
select age_group, Marital_Status,
       concat('$',Income)income,Education,Country,(AcceptedCmp1 + 
       AcceptedCmp2 + 
       AcceptedCmp3 + 
       AcceptedCmp4 + 
       AcceptedCmp5) total_cmp_accpt
from marketing_data
	where (AcceptedCmp1 + 
		   AcceptedCmp2 + 
		   AcceptedCmp3 + 
		   AcceptedCmp4 + 
		   AcceptedCmp5) >1 
	 order by Total_cmp_accpt desc;
```
## Utilized common table expressions (CTEs) for more advanced data manipulation.
- (RFM) Analysis: Recency is already included in our table
 For the Frequency and Monetary, we use the following to determinne that
```SQL
select ID, Age_group,Recency,
       (NumWebPurchases + NumCatalogPurchases + NumStorePurchases) frequency,
 concat('$',(MntWines + MntFruits + MntMeatProducts + MntFishProducts +  MntSweetProducts + MntGoldProds)) monetary from marketing_data;
```
### Customers Segmentation  into different RFM categories.
 -  calculate recency, frequency, and monetary value for each customer.
```SQL
with RFM as 
	( select ID,age_group, Recency,
        (NumWebPurchases + NumCatalogPurchases + NumStorePurchases) frequency,
        concat('$',(MntWines + MntFruits + MntMeatProducts + MntFishProducts + 
        MntSweetProducts + MntGoldProds)) monetary from marketing_data)
select *,
	ntile(5) over (order by recency asc)rec_score,
        ntile(5) over (order by frequency desc)freq_score,
        ntile(5) over (order by monetary desc)mon_score
from RFM ;
```
 - Perform an RFM analysis to identify high-value customers.
```SQL
with combined_RFM as 
		(with RFM as ( select ID,age_group, Recency,
		(NumWebPurchases + NumCatalogPurchases + NumStorePurchases) frequency,
       		concat('$',(MntWines + MntFruits + MntMeatProducts + MntFishProducts + 
       		MntSweetProducts + MntGoldProds)) monetary from marketing_data)
select *,
	ntile(5) over (order by recency asc)ref_score,
        ntile(5) over (order by frequency desc)freq_score,
        ntile(5) over (order by monetary desc)mon_score
from RFM)
select age_group,recency,frequency,monetary,
	concat( ref_score,freq_score,mon_score)RFM_score from combined_RFM;
```
 - Segment customers into different RFM categories
```SQL
with RFM_seg as 
              (with combined_RFM as (with RFM as ( select ID,age_group,Recency,
              (NumWebPurchases + NumCatalogPurchases + NumStorePurchases) frequency,
       concat('$',(MntWines + MntFruits + MntMeatProducts + MntFishProducts + 
              MntSweetProducts + MntGoldProds)) monetary from marketing_data)
select *,
        ntile(5) over (order by recency asc)ref_score,
        ntile(5) over (order by frequency desc)freq_score,
        ntile(5) over (order by monetary desc)mon_score
from RFM)
      select age_group,recency,frequency,monetary,
      concat( ref_score,freq_score,mon_score)RFM_score from combined_RFM)
select age_group,recency,frequency,monetary,
case
        when RFM_score = '555' then 'Champions'
        when RFM_score like '55%' then'Loyal Customers'
        when rfm_score like '5%' then 'Potential Loyalists'
        when rfm_score like '%5' then 'Big Spenders'
        else 'Others'
    END AS rfm_segment
    from RFM_seg;
```
##  Optimization and Indexing:
### Optimize SQL queries for performance.
To perform this, we had to create another table to mirror the existing table in order to Optimize SQL queries for performance.
```SQL
create table marketing_copi as
			with RFM_seg as 
			              (with combined_RFM as (with RFM as ( select ID,age_group,Recency,
			              (NumWebPurchases + NumCatalogPurchases + NumStorePurchases) frequency,
			       concat('$',(MntWines + MntFruits + MntMeatProducts + MntFishProducts + 
			              MntSweetProducts + MntGoldProds)) monetary from marketing_data)
			select *,
			        ntile(5) over (order by recency asc)ref_score,
			        ntile(5) over (order by frequency desc)freq_score,
			        ntile(5) over (order by monetary desc)mon_score
			from RFM)
			      select age_group,recency,frequency,monetary,
			      concat( ref_score,freq_score,mon_score)RFM_score from combined_RFM)
			select age_group,recency,frequency,monetary,
			case
			        when RFM_score = '555' then 'Champions'
			        when RFM_score like '55%' then'Loyal Customers'
			        when rfm_score like '5%' then 'Potential Loyalists'
			        when rfm_score like '%5' then 'Big Spenders'
			        else 'Others'
			    END AS rfm_segment
			    from RFM_seg;
   ```
- Implement indexing strategies to speed up query execution.
```SQL
create index idx_ID_agegroup_RFM_score_rfm_segment on marketing_copi(ID,age_group,rfm_score,rfm_segment);
create index idx_ID on marketing_copi(ID);
create index idx_ID_RFM_score_rfm_segment on marketing_copi(ID);
create index idx_RFM_score on marketing_copi(rfm_score);
create index idx_rfm_segment on marketing_copi(rfm_segment);
create index idx_ID_RFM_score_rfm_segment_agegroup on marketing_copi(ID,rfm_score,rfm_segment,age_group);
create index idx_agegroup on marketing_copi(age_group);
create index idx_age_group on marketing_data(age_group);
create index idx_recency on marketing_copi(recency);
create index idx_NumWebPurchases_NumCatalogPurchases_NumStorePurchases on marketing_copy(NumWebPurchases,NumCatalogPurchases,NumStorePurchases);
```
 - Analyze query execution plans to identify and resolve performance bottlenecks
```SQL
explain select  age_group, RFM_score, rfm_segment from marketing_copi;
```
```SQL
explain
   select age_group,recency,frequency,monetary,RFM_score,rfm_segment 
   from marketing_copi
   where recency < 30 and monetary > concat('$',100);
```
```SQL
Explain
with RFM_seg as 
       (with combined_RFM as (with RFM as ( select ID,age_group,Recency,
       (NumWebPurchases + NumCatalogPurchases + NumStorePurchases) frequency,
  concat('$',(MntWines + MntFruits + MntMeatProducts + MntFishProducts + 
         MntSweetProducts + MntGoldProds)) monetary from marketing_data)
select *,
	  ntile(5) over (order by recency asc)ref_score,
	 ntile(5) over (order by frequency desc)freq_score,
	ntile(5) over (order by monetary desc)mon_score
	from RFM)
select age_group,recency,frequency,monetary,
         concat( ref_score,freq_score,mon_score)RFM_score from combined_RFM)
select age_group,recency,frequency,monetary,
	case
	 when RFM_score = '555' then 'Champions'
	 when RFM_score like '55%' then'Loyal Customers'
	 when rfm_score like '5%' then 'Potential Loyalists'
	 when rfm_score like '%5' then 'Big Spenders'
	else 'Others'
	 END AS rfm_segment
	 from RFM_seg;
```
# Findings and Key Insight
## Demographics:
### Income Analysis
The dataset reveals that the average income of the customers is $52,200, with a range from $1,750 to $666,600.
Notably, married Gen X graduates from Spain have the highest number of children and teenagers at home.

### Age Segmentation
The age distribution of the customers is categorized into four segments:
Generation X: 1,022 individuals
Baby Boomers: 749 individuals
Millennials: 419 individuals
Silent Generation: 29 individuals

### Educational Background
The education levels among the customers are as follows:
Graduates: 1,116 individuals
PhD holders: 481 individuals
Master's degree holders: 365 individuals
2nd Cycle (postgraduate, non-master’s): 200 individuals
Basic education: 54 individuals

### Marital Status
The marital status distribution is:
Married: 857 individuals
Living together: 573 individuals
Single: 471 individuals
Divorced: 232 individuals
Widowed: 76 individuals
Alone: 3 individuals
YOLO: 2 individuals
Absurd: 2 individuals

### Geographical Distribution
The customers are primarily from the following countries:
Spain: 1,093 individuals
South Africa: 337 individuals
Canada: 266 individuals
Australia: 147 individuals
India: 147 individuals
Germany: 116 individuals
United States: 107 individuals
Montenegro: 3 individuals

## Top Segments Analysis
### Total Spending
- Generation X exhibits the highest total spending, amounting to $551,142, followed by Millennials with $240,292.

### Total Purchases
- Generation X leads in total purchases, with 12,162 goods and products purchased, followed by the Silent Generation.

### Campaign Responses
- Generation X also has the highest response rate to campaigns, with 257 responses, followed by the Silent Generation.

### Campaign Effectiveness
- Married Millennials from Spain, who are graduates, demonstrate the highest acceptance of multiple campaigns.
- Divorced Gen X individuals from South Africa, who are graduates, also show a significant acceptance rate for campaigns.

## RFM Analysis
The RFM (Recency, Frequency, Monetary) analysis categorizes customers into five segments: Big Spenders, Potential Loyalists, Loyal Customers, Champions, and Others.
Generation X ranks highest in the Big Spender, Loyal Customer, and Champion categories.
Millennials lead in the Potential Loyalist category.

## Recommendations

### Targeted Marketing Campaigns
- Prioritize marketing efforts towards Generation X, particularly those who are graduates and exhibit high spending behaviors.
- Develop specialized campaigns for married Millennials from Spain due to their high campaign acceptance rates.

### Loyalty Programs
- Implement loyalty programs targeting Generation X to capitalize on their high loyalty and champion potential.
- Create incentives for Millennials to transition from Potential Loyalists to Loyal Customers.

### Product Offerings
- Expand product lines or introduce special offers for high-income segments, focusing on top represented countries like Spain and South Africa.
- Develop family-oriented products and promotions, especially targeting Generation X with children and teenagers.

### Educational-Based Segmentation
- Utilize customers' educational backgrounds to tailor products and services, particularly for graduates and those with advanced degrees.

### Geographical Expansion
- Explore market expansion opportunities and targeted promotions in underrepresented but high-income countries such as Germany and the United States.

### Customer Retention Strategies
- Develop retention strategies addressing the needs of divorced and single individuals.
- Offer personalized support and communication to widowed and isolated individuals to enhance their customer experience.


 


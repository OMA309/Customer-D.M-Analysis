/*1. Database Setup:
 - Create a new database to store the customer data.
 - Define appropriate data types for each column and create tables.
 - Load the dataset into the database.
*/
SET SQL_SAFE_UPDATES=0;
-- Create a new database to store the customer data.--
CREATE DATABASE IF NOT EXISTS DLITES_P;

LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\marketing_data.csv"
INTO TABLE marketing_data
FIELDS TERMINATED BY ','     -- this was imployed in other to get the datafile imported into the database
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES ;

 -- Define appropriate data types for each column and create tables.
 
 /*2. Data Cleaning and Preparation:
 - Identify and handle missing or null values.
 - Correct data types where necessary (e.g., convert `Income` from 
string to numeric).
 - Ensure that date fields are in the correct format.*/


 -- Identify and handle missing or null values.
 select * from marketing_data
 group by ID
 having count(*)>1; -- this is to check for duplicates if there is any 
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
 call null_value_check();-- it indicate that there are no null values

/* first lets:
1. change the ID header properly
2. modify the income column from text to varchar/int
3. modify the Dt-customer to  a date data type*/
-- CHANGE OF ID 
Alter table marketing_data
rename column ï»¿ID to ID;
-- modify the income column from text to varchar/int
update marketing_data
set Income = replace(Income,'$','');

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

select* from marketing_data;

/* 3. Advanced Querying:
 - Write complex queries to extract meaningful insights from the data.
 - Use aggregate functions (SUM, AVG, COUNT, MAX, MIN) to 
calculate summary statistics.
 - Implement JOIN operations to combine data from multiple tables if 
necessary.
 - Utilize subqueries and common table expressions (CTEs) for more 
advanced data manipulation.
*/

select concat('$', round(Avg(income),2))avg_income from marketing_data ; -- the average income of everyonr included in the dataset is $52247.25
select concat('$', min(Income))minincome,concat('$', max(income))maxincome from marketing_data; -- while the min income is $1730.00 and max is $666666.00

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
case when (year( current_date())-year_birth)<=39 then '28-39'
    when (year( current_date())-year_birth)<=49 then '40-49'
    when (year( current_date())-year_birth)<=59 then '50-59'
    when (year( current_date())-year_birth)<=69 then '60-69'
    when (year( current_date())-year_birth)<=79 then '70-79' -- after the grouping, a column named age_group was created in other to store the modification 
    when (year( current_date())-year_birth)<=89 then '80-89'-- so as to represent the individuals correctly.
    when (year( current_date())-year_birth)<=99 then '90-99'
    when (year( current_date())-year_birth)<=109 then '100-109'
    when (year( current_date())-year_birth)<=119 then '110-119'
    else '120+'
    end;
    
    
select age_group, 
count(ID)frequency,
concat('$', round(Avg(income),2))avg_income,    
(select concat('$', min(Income)))minincome,
(select concat('$', max(income)))maxincome
from marketing_data
group by age_group
order by frequency desc; 						-- 	age_group		frequency	avg_income	minincome	maxincome
													-- Gen X			1022	$50599.85	$1730.00	$666666.00
													-- Baby Boomers		749		$57008.40	$4023.00	$156924.00
													-- Millennials		419		$46875.31	$6560.00	$160803.00
												-- Silent Generation	26		$66415.77	$36640.00	$113734.00

select Education, 
count(ID)frequency,
concat('$', round(Avg(income),2))avg_income,
(select concat('$', min(Income)))minincome,
(select concat('$', max(income)))maxincome
from marketing_data
group by Education
order by frequency desc;     -- 	Education	frequency	avg_income	minincome	maxincome
								-- Graduation		1116	$52720.37	$1730.00	$666666.00
								-- PhD				481		$56145.31	$4023.00	$162397.00
								-- Master			365		$52917.53	$6560.00	$157733.00
								-- 2n Cycle			200		$47633.19	$7500.00	$96547.00
								-- Basic			54		$20306.26	$7500.00	$34445.00


select Marital_Status, 
count(ID)frequency, 
concat('$', round(Avg(income),2))avg_income,
(select concat('$', min(Income)))minincome,
(select concat('$', max(income)))maxincome
from marketing_data
group by Marital_Status
order by frequency desc; 		-- 	Marital_Status	frequency	avg_income	minincome	maxincome
									-- Married			857		$51724.98	$2447.00	$160803.00
									-- Together			573		$53245.53	$5648.00	$666666.00
									-- Single			471		$50995.35	$3502.00	$113734.00
									-- Divorced			232		$52834.23	$1730.00	$153924.00
									-- Widow			76		$56481.55	$22123.00	$85620.00
									-- Alone			3		$43789.00	$34176.00	$61331.00
									-- YOLO				2		$48432.00	$48432.00	$48432.00
									-- Absurd			2		$72365.50	$65487.00	$79244.00


select Country, 
count(ID)frequency,
concat('$', round(Avg(income),2))avg_income,
(select concat('$', min(Income)))minincome,
(select concat('$', max(income)))maxincome
from marketing_data
group by Country
order by frequency desc; -- 	Country	frequency	avg_income	minincome	maxincome
								-- SP		1093	$51564.58	$1730.00	$162397.00
								-- SA		337		$54830.82	$4861.00	$666666.00
								-- CA		266		$53050.62	$6835.00	$156924.00
								-- AUS		147		$51804.29	$7500.00	$92344.00
								-- IND		147		$49016.41	$3502.00	$157243.00
								-- GER		116		$52951.09	$14188.00	$92533.00
								-- US		107		$53218.37	$2447.00	$160803.00
								-- ME		3		$57680.33	$49912.00	$70515.00

select age_group, Education,marital_status,country,
count(ID)frequency,
concat('$', round(Avg(income),2))avg_income,
(select concat('$', min(Income)))minincome,     -- 	Gen X--Graduation	--Married	--SP	--212	--$49079.40	--$4428.00	--$94642.00
(select concat('$', max(income)))maxincome
from marketing_data
group by  Education,marital_status,country
order by frequency desc;



select country, 
sum(case when kidhome = 1 then 1 else 0 end)kidhome1,
sum(case when kidhome = 2 then 1 else 0 end)kidhome2,
sum(case when Teenhome =1 then 1 else 0 end)teenhome1
from marketing_data group by country;                 -- 	country	kidhome1	kidhome2	teenhome1
															-- SP		436			15			506
															-- CA		100			6			127
															-- US		39			2			49
															-- AUS		67			3			68
															-- GER		44			0			50
															-- IND		63			7			69
															-- SA		138			13			147
															-- ME		0			0			2

select Education, 
sum(case when kidhome = 1 then 1 else 0 end)kidhome1,
 sum(case when kidhome = 2 then 1 else 0 end)kidhome2,
sum(case when Teenhome =1 then 1 else 0 end)teenhome1
from marketing_data group by Education;					--  	Education	kidhome1	kidhome2	teenhome1
															-- Graduation		446			23			505
															-- PhD				169			11			251
															-- 2n Cycle			89			3			80
															-- Master			149			9			177
															-- Basic			34			0			5

select Marital_Status, 
sum(case when kidhome = 1 then 1 else 0 end)kidhome1,
sum(case when kidhome = 2 then 1 else 0 end)kidhome2,
sum(case when Teenhome =1 then 1 else 0 end)teenhome1
from marketing_data group by Marital_Status; -- 	Marital_Status	kidhome1	kidhome2	teenhome1
												-- Divorced				88			4			125
												-- Single				195			10			171
												-- Married				349			20			394
												-- Together				234			12			277
												-- Widow				18			0			47
												-- YOLO					0			0			2
												-- Alone				3			0			2
												-- Absurd				0			0			0

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



/* 4. Customer Segmentation:
 - Create segments of customers based on demographics, purchasing 
behavior, and responses to campaigns.
 - Write queries to identify top-performing segments based on total 
spending, frequency of purchases, or campaign responses.*/

alter table marketing_data
    add column age_group varchar(20) after Year_birth;

update marketing_data
set age_group = 
case
    when Year_Birth >= 2000 then 'Gen Z'
    when Year_Birth between 1980 and 1999 then 'Millennials'
    when Year_Birth between 1965 and 1979 then 'Gen X'        -- having done the age grouping, it was later group into segments for better labelling 
    when Year_Birth between 1946 and 1964 then 'Baby Boomers'
    else 'Silent Generation'
end;


 /*Write queries to identify top-performing segments based on total 
 spending, frequency of purchases, or campaign responses.
in other to get this done, we need to create column for each total 
 spending, frequency of purchases, or campaign responses */
 
alter table marketing_data
add column Total_customer_spending int after MntGoldProds;

update marketing_data
set Total_customer_spending =
       (MntWines + 
       MntFruits + 
       MntMeatProducts +  -- the total customer spending ws derived with all of this 
       MntFishProducts + 
       MntSweetProducts + 
       MntGoldProds) ;

alter table marketing_data
add column customer_purchase_frequency int after Numstorepurchases;

update marketing_data
set  customer_purchase_frequency =
       (NumWebPurchases + NumCatalogPurchases +  -- customer purchase frequency was also derived fromm all if this
       NumStorePurchases);
  
  
  
-- Identify Top Segments Based on Total Spending
select age_group,
	concat('$',sum(MntWines + 
       MntFruits + 
       MntMeatProducts + 
       MntFishProducts + 
       MntSweetProducts + 
       MntGoldProds))total_spending 
from marketing_data
		  group by age_group
		  order by total_spending desc;  -- 	age_group			total_spending
												-- Gen X				$551142
												-- Baby Boomers			$527645
												-- Silent Generation	$26200
												-- Millennials			240292


		  
  -- : Identify Top Segments Based on Frequency of Purchases
  Select age_group, 
       SUM(NumWebPurchases + NumCatalogPurchases + 
       NumStorePurchases) total_purchases
from marketing_data
	group by age_group
	order by total_purchases desc;     -- 	age_group			total_purchases
											-- Gen X				12162
											-- Baby Boomers			10544
											-- Millennials			4666
											-- Silent Generation	455



 -- Identify Top Segments Based on Campaign Responses
 select age_group, 
       sum(AcceptedCmp1 + 
       AcceptedCmp2 + 
       AcceptedCmp3 + 
       AcceptedCmp4 + 
       AcceptedCmp5) total_responses
from marketing_data
		group by age_group
		order by total_responses desc;    -- 	age_group			total_responses
												-- Gen X				257
												-- Baby Boomers			238
												-- Millennials			155
												-- Silent Generation	11




 /* Write queries to identify top-performing segments based on total 
spending, frequency of purchases, or campaign responses*/

select age_group,
concat('$',sum(MntWines + 
       MntFruits + 
       MntMeatProducts + 
       MntFishProducts + 
       MntSweetProducts + 
       MntGoldProds))total_spending ,
       
SUM(NumWebPurchases + NumCatalogPurchases + 
       NumStorePurchases) total_purchases,
       
 sum(AcceptedCmp1 + 
       AcceptedCmp2 + 
       AcceptedCmp3 + 
       AcceptedCmp4 + 
       AcceptedCmp5) total_responses
from marketing_data       
	group by age_group
	order by total_purchases desc;      -- 	age_group			total_spending	total_purchases	total_responses
											-- Gen X				$551142			12162			257
											-- Baby Boomers			$527645			10544			238
											-- Millennials			$240292			4666			155
											-- Silent Generation	$26200			455				11



/* Marketing Campaign Analysis:
 - Analyze the effectiveness of different marketing campaigns.
 - Write queries to calculate the response rates for each campaign.
 - Identify customers who have accepted multiple campaigns and 
analyze their behavior*/

Select age_group, Marital_Status,Education,
	sum(case when acceptedCmp3 = 1 then 1 else 0 end ) campaign3,
    sum(case when acceptedCmp4 = 1 then 1 else 0 end ) campaign4,
    sum(case when acceptedCmp5 = 1 then 1 else 0 end ) campaign5,
    sum(case when acceptedCmp1 = 1 then 1 else 0 end ) campaign1,
    sum(case when acceptedCmp2 = 1 then 1 else 0 end ) campaign2
from marketing_data
group by age_group,Marital_Status,Education ;   
    
  -- Step 1: Calculate the Response Rates for Each Campaign  
select 
    sum(AcceptedCmp3) / count(*) as Campaign1_ResponseRate,
    sum(AcceptedCmp4) / count(*) as Campaign2_ResponseRate, 
    sum(AcceptedCmp5) / count(*) as Campaign3_ResponseRate,
    sum(AcceptedCmp1) / count(*) as Campaign4_ResponseRate,
    sum(AcceptedCmp2) / count(*) as Campaign5_ResponseRate
	from marketing_data;   -- 	Campaign1_ResponseRate	   0.0736	
							-- 	Campaign2_ResponseRate	   0.0740    this indicate that the first and  second campign yielded a high rate of acceptance 
							-- 	Campaign3_ResponseRate	   0.0731	 that is there is a trend(and inverse proportion) on the acceptance rate from the public
						   -- 	Campaign4_ResponseRate	   0.0641	 and this fall for the baby boomer age_group.
						   -- 	Campaign5_ResponseRate	   0.0135
							

-- Step 2: Identify Customers Who Have Accepted Multiple Campaigns

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
	 order by Total_cmp_accpt desc
	 limit 10; 							    -- 	age_group	Marital_Status		Income		Education	Country	total_cmp_accpt
											-- Millennials	Married				$65169.00	Graduation		SP			4
											-- Gen X		Divorced			$102692.00	Graduation		SA			4
											-- Baby Boomers	Single				$84865.00		PhD			SP			4
											-- Baby Boomers	Divorced			$85683.00	Graduation		SP			4
											-- Baby Boomers	Together			$87771.00	Graduation		CA			4
											-- Millennials	Married				$83512.00	Graduation		SP			4
											-- Millennials	Together			$80134.00	Graduation		SP			4
											-- Baby Boomers	Together			$87771.00	Graduation		SP			4
											-- Baby Boomers	Single				$91249.00	Graduation		SP			4
											-- Baby Boomers	Together			$84460.00		PhD			SP			4
     
     
     
/*  Recency, Frequency, Monetary (RFM) Analysis:
 - Perform an RFM analysis to identify high-value customers.
 - Write queries to calculate recency, frequency, and monetary value 
for each customer.
 - Segment customers into different RFM categories.*/

-- Recency is already included in our table
-- Frequency, we use the following to determinne that
 select ID, Age_group,Recency,
        (NumWebPurchases + NumCatalogPurchases + NumStorePurchases) frequency,
       concat('$',(MntWines + MntFruits + MntMeatProducts + MntFishProducts + 
       MntSweetProducts + MntGoldProds)) monetary from marketing_data limit 10 ; -- ID		Age_group	Recency	frequency	monetary
																				-- 1826			Gen X		0		14		$1190
																				-- 1		Baby Boomers	0		17		$577
																				-- 10476	Baby Boomers	0		10		$251
																				-- 1386			Gen X		0		3		$11
																				-- 5371		Millennials		0		6		$91
																				-- 7348		Baby Boomers	0		16		$1192
																				-- 4073		Baby Boomers	0		27		$1215
																				-- 1991			Gen X		0		6		$96
																				-- 4047		Baby Boomers	0		17		$544
																				-- 9477		Baby Boomers	0		17		$544     

--  - Segment customers into different RFM categories.*/
with RFM as 
		( select ID,age_group, Recency,
        (NumWebPurchases + NumCatalogPurchases + NumStorePurchases) frequency,
       concat('$',(MntWines + MntFruits + MntMeatProducts + MntFishProducts + 
       MntSweetProducts + MntGoldProds)) monetary from marketing_data)
select *,
		ntile(5) over (order by recency desc)rec_score,
        ntile(5) over (order by frequency asc)freq_score,
        ntile(5) over (order by monetary asc)mon_score
from RFM  limit 15; 			-- ID		age_group				Recency	frequency	monetary	rec_score	freq_score	mon_score
							-- 1740		Silent Generation			22		14		$999			2			3			1
							-- 2882		Gen X						31		14		$995			2			3			1
							-- 9353		Baby Boomers				61		14		995				4			3			1
							-- 123		Baby Boomers				92		13		$993			5			3			1
							-- 8534		Baby Boomers				51		24		$992			3			1			1
							-- 10486	Baby Boomers				54		16		$990			3			2			1
							-- 2928		Gen X						63		14		$990			4			3			1
							-- 2920		Gen X						63		14		$990			4			3			1
							-- 6859		Millennials					30		7		$99				2			4			1
							-- 6488		Baby Boomers				86		7		$99				5			4			1
							-- 10967	Baby Boomers				38		6		$99				2			4			1
							-- 2061		Baby Boomers				61		6		$99				4			4			1
							-- 10637	Baby Boomers				77		6		$99				4			4			1
							-- 7631		Gen X						34		22		$989			2			1			1
							-- 5545		Gen X						72		13		$988			4			3			1




with combined_RFM as 
				(  with RFM as ( select ID,age_group, Recency,
                (NumWebPurchases + NumCatalogPurchases + NumStorePurchases) frequency,
       concat('$',(MntWines + MntFruits + MntMeatProducts + MntFishProducts + 
               MntSweetProducts + MntGoldProds)) monetary from marketing_data)
select *,
		ntile(5) over (order by recency desc)rec_score,
        ntile(5) over (order by frequency asc)freq_score,
        ntile(5) over (order by monetary asc)mon_score
from RFM)
select age_group,recency,frequency,monetary,
		concat( ref_score,freq_score,mon_score)RFM_score from combined_RFM
        limit 15;     -- 	age_group			recency	frequency	monetary	RFM_score
							-- Silent Generation	22		14			$999	231
							-- Gen X				31		14			$995	231
							-- Baby Boomers			61		14			$995	431
							-- Baby Boomers			92		13			$993	531
							-- Baby Boomers			51		24			$992	311
							-- Baby Boomers			54		16			$990	321
							-- Gen X				63		14			$990	431
							-- Gen X				63		14			$990	431
							-- Millennials			30		7			$99		241
							-- Baby Boomers			86		7			$99		541
							-- Baby Boomers			38		6			$99		241
							-- Baby Boomers			61		6			$99		441
							-- Baby Boomers			77		6			$99		441
							-- Gen X				34		22			$989	211
							-- Gen X				72		13			$988	431
        
        
        
        
with RFM_seg as 
				(with combined_RFM as (  with RFM as ( select ID,age_group,Recency,
  (NumWebPurchases + NumCatalogPurchases + NumStorePurchases) frequency,
       concat('$',(MntWines + MntFruits + MntMeatProducts + MntFishProducts + 
       MntSweetProducts + MntGoldProds)) monetary from marketing_data)
select *,
        ntile(5) over (order by recency desc)rec_score,
        ntile(5) over (order by frequency asc)freq_score,
        ntile(5) over (order by monetary asc)mon_score
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
    from RFM_seg;       -- 		age_group			recency	frequency	monetary	RFM_score    Rfm_segment
							-- Silent Generation	22		14			$999	231          Others 
							-- Gen X				31		14			$995	231          Others
							-- Baby Boomers			61		14			$995	431			 Others
							-- Baby Boomers			92		13			$993	531          Potential Loyalist
							-- Baby Boomers			51		24			$992	311          Others
							-- Baby Boomers			54		16			$990	321          Others
							-- Gen X				63		14			$990	431          Others
							-- Gen X				63		14			$990	431          Others
							-- Millennials			30		7			$99		241          Others
							-- Baby Boomers			86		7			$99		541          Potential Loyalist
							-- Baby Boomers			38		6			$99		241          Others
							-- Baby Boomers			61		6			$99		441          Others
							-- Baby Boomers			77		6			$99		441          Others
							-- Gen X				34		22			$989	211          Others
							-- Gen X				72		13			$988	431          Others
    
    
    
    /* Optimization and Indexing:
 - Optimize SQL queries for performance.
 - Implement indexing strategies to speed up query execution.
 - Analyze query execution plans to identify and resolve performance 
bottlenecks.*/

-- to perform this , we need to create another table to mirror the exi in order to  Optimize SQL queries for performance.

create table marketing_copi as 
with RFM_seg as 
				(with combined_RFM as (  with RFM as ( select ID,age_group, Recency,
  (NumWebPurchases + NumCatalogPurchases + NumStorePurchases) frequency,
       concat('$',(MntWines + MntFruits + MntMeatProducts + MntFishProducts + 
       MntSweetProducts + MntGoldProds)) monetary from marketing_data)
select *,
		ntile(5) over (order by recency desc)rec_score,
        ntile(5) over (order by frequency asc)freq_score,
        ntile(5) over (order by monetary asc)mon_score
from RFM)
select *,
		concat( ref_score,freq_score,mon_score)RFM_score from combined_RFM)
select *,case
		when RFM_score = '555' then 'Champions'
        when RFM_score like '55%' then'Loyal Customers'
        when rfm_score like '5%' then 'Potential Loyalists'
        when rfm_score like '%5' then 'Big Spenders'
        else 'Others'
    END AS rfm_segment
    from RFM_seg;
    
    
-- CREATING INDEX IN OTHER TO OPTIMIZE SQI QUERY PERFORMANCE--
   
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
explain select  age_group, RFM_score, rfm_segment from marketing_copi;
 
   explain
   select age_group,recency,frequency,monetary,RFM_score,rfm_segment 
   from marketing_copi
   where recency < 30 and monetary > concat('$',100); -- SIMPLE, level of filter used--'10.32' for the extras -- 'using where'
 
 /* OPTIMIZATION AND INDEXES 
 - Optimize SQL queries for performance.
 -Implement indexing strategies to speed up query execution.
 THE EXPLAIN FUNCTION WAS IMPLOYED IN OTHER TO READ THROUGH THE QUERIES AND 
 EXTRACT THE  SELECT TYPE AND ALSO THE POSSIBLE KEYS RANGING FROM SIMPLE,DERIVED AND PRIMARY.
 - Analyze query execution plans to identify and resolve performance 
bottlenecks.
 HAVING OPTIMIZE SQL QUERIES FOR PERFORMANCE, IT INDICATE THAT THERE ARE NO PERFORMANCE BOTTLENECKS AS THE RESPONSE TIME FOR EACH QUERY IS VERY FAST
 AND IT ALSO CONSUME LESS MEMORY SPACE AND LOWER PROCESING TIME.

 
 

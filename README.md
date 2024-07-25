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
 - Load the datafile and import
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


 - Load the dataset into the database.

## Aim of the Analysis
The aim of the analysis is to reveal insight into the acceptance of product by their existing customer and potential customers and also to calculate their RFM analysis, which involve their segmentation and demographic data

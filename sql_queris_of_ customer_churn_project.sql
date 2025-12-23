DROP TABLE customers;

CREATE TABLE customers (
    customerID VARCHAR(50),
    gender VARCHAR(10),
    SeniorCitizen INT,
    Partner VARCHAR(5),
    Dependents VARCHAR(5),
    tenure INT,
    PhoneService VARCHAR(5),
    MultipleLines VARCHAR(30),
    InternetService VARCHAR(30),
    OnlineSecurity VARCHAR(30),
    OnlineBackup VARCHAR(30),
    DeviceProtection VARCHAR(30),
    TechSupport VARCHAR(30),
    StreamingTV VARCHAR(30),
    StreamingMovies VARCHAR(30),
    Contract VARCHAR(30),
    PaperlessBilling VARCHAR(5),
    PaymentMethod VARCHAR(50),
    MonthlyCharges NUMERIC,
    TotalCharges TEXT
    Churn VARCHAR(5)
);

select*from customers;  
select count(*)from customers;

select column_name , data_type from information_schema.columns
where table_name = 'customers';

select churn, count(*)from customers 
group by churn;

select distinct churn from customers;
select count(*) as total_customer from customers;

-- overall churn rate
select count(*) as total_customer,
sum(case when churn = 'No'then 1 else 0 end) as churned_customer,
round(
sum(case when churn = 'No' then 1 else 0 end )::numeric
/ count(*)*100,
2) as_churn_percentage
from customers;

-- Churn by Contract Type
select count(*) as customer,
sum(case when churn = 'Yes' then 1 else 0 end ) as churn_customer,
round(
sum(case  when churn = 'Yes' then 1 else 0 end) :: numeric /count(*)*100,
2) as churn_percntage
from customers
group by contract
order by churn_customer desc;

-- Churn by Tenure (Customer Age)
select case 
 when tenure < 6 then '0 - 6 months'
 when tenure   between 6 and 12 then '6-12 months'
 when tenure   between 13 and 24 then '1-2 years'
 else '2+years'
 end as tenure_group,
 count(*) as customer,
sum(case when churn = 'Yes' then 1 else 0 end ) as churn_customer,
round(
sum(case  when churn = 'Yes' then 1 else 0 end) :: numeric /count(*)*100,
2) as churn_percntage
from customers
group by tenure_group
order by tenure_group;

-- Revenue at Risk
select sum (MonthlyCharges) as sum_monthlycharges,
sum (case when churn = 'Yes' then MonthlyCharges else 0 end ) as revenu_at_risk
from customers;

-- Contract vs Revenue Loss
select contract, count(*) as churned_customer,
round(sum(Monthlycharges),2) as revenu_lost
from customers
where churn = 'Yes'
group by contract
order by revenu_lost;

-- Payment Method Risk
SELECT 
    PaymentMethod,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)::numeric
        / COUNT(*) * 100,
    2) AS churn_rate_percent
FROM customers
GROUP BY PaymentMethod
ORDER BY churn_rate_percent DESC;



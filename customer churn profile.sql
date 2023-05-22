--building churn customer profile
SELECT gender,ROUND(COUNT(Customer_ID) * 100.0 / SUM(COUNT(Customer_ID)) OVER(), 1) AS Churn_Percentage
from telecom_customer_churn$
where customer_status = 'churned'
group by gender
order by Churn_Percentage DESC



SELECT ROUND(COUNT(Customer_ID) * 100.0 / SUM(COUNT(Customer_ID)) OVER(), 1) AS Churn_Percentage,
CASE when age <= 30 then '0-30'
when age > 30 and age <= 50 then '30-50'
when age > 50 and age <= 80 then '50-80'
else null end as 'age group'
from telecom_customer_churn$
where customer_status = 'churned' 
group by 
CASE when age <= 30 then '0-30'
when age > 30 and age <= 50 then '30-50'
when age > 50 and age <= 80 then '50-80'
else null end
order by Churn_Percentage DESC

SELECT Married,ROUND(COUNT(Customer_ID) * 100.0 / SUM(COUNT(Customer_ID)) OVER(), 1) AS Churn_Percentage
from telecom_customer_churn$
where customer_status = 'churned'
group by Married
order by Churn_Percentage DESC

SELECT Number_of_Dependents,ROUND(COUNT(Customer_ID) * 100.0 / SUM(COUNT(Customer_ID)) OVER(), 1) AS Churn_Percentage
from telecom_customer_churn$
where customer_status = 'churned'
group by Number_of_Dependents
order by Churn_Percentage DESC

SELECT city,ROUND(COUNT(Customer_ID) * 100.0 / SUM(COUNT(Customer_ID)) OVER(), 1) AS Churn_Percentage
from telecom_customer_churn$
where customer_status = 'churned'
group by city
order by Churn_Percentage DESC
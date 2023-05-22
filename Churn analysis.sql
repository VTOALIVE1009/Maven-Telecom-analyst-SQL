-- Find total number of customers
SELECT
COUNT(DISTINCT Customer_ID) AS customer_count
FROM
telecom_customer_churn$


-- calculate the Churn rate
SELECT ROUND((COUNT(DISTINCT CASE WHEN customer_status = 'Churned' THEN customer_id END) * 100.0) / COUNT(DISTINCT customer_id),2) AS churn_rate
FROM telecom_customer_churn$

--How much revenue was lost to churned customers?
SELECT customer_status, COUNT(customer_id) As customer_count,
Round((SUM(total_revenue)*100)/(SELECT SUM(total_revenue) from telecom_customer_churn$),3) As Revenue_Percentage
from telecom_customer_churn$
group by customer_status

--What is the impact of contract duration on churn?
SELECT Contract,COUNT(Customer_ID) AS Churned,
    ROUND(COUNT(Customer_ID) * 100.0 / SUM(COUNT(Customer_ID)) OVER(), 1) AS Churn_Percentage
FROM telecom_customer_churn$
WHERE
    Customer_Status = 'Churned'
GROUP BY Contract
ORDER BY 
    Churn_Percentage DESC;

--4. What's the typical tenure for churned customers?
SELECT 
CASE WHEN Tenure_in_months <= 6 then '6 month'
WHEN Tenure_in_months <= 12 then '1 year'
when Tenure_in_months <= 24 then '2 years'
Else '> 2 years'
END AS tenures,
ROUND(COUNT(Customer_ID) * 100.0 / SUM(COUNT(Customer_ID)) OVER(), 1) AS Churn_Percentage
from telecom_customer_churn$
where customer_status = 'churned'
Group by 
CASE WHEN Tenure_in_months <= 6 then '6 month'
WHEN Tenure_in_months <= 12 then '1 year'
when Tenure_in_months <= 24 then '2 years'
Else '> 2 years'
END
order by Churn_Percentage DESC

--6. why does customers leave?
SELECT 
Churn_category, ROUND(COUNT(Customer_ID) * 100.0 / SUM(COUNT(Customer_ID)) OVER(), 1) AS Churn_Percentage
from telecom_customer_churn$
where customer_status = 'churned'
group by Churn_category
order by Churn_Percentage DESC

--what specific reason do they leave?
SELECT 
Churn_reason, ROUND(COUNT(Customer_ID) * 100.0 / SUM(COUNT(Customer_ID)) OVER(), 1) AS Churn_Percentage
from telecom_customer_churn$
where customer_status = 'churned'
group by churn_reason
order by Churn_Percentage DESC

--Did churners have premium tech support?
SELECT
Premium_tech_support, ROUND(COUNT(Customer_ID) * 100.0 / SUM(COUNT(Customer_ID)) OVER(), 1) AS Churn_Percentage
from telecom_customer_churn$
where customer_status = 'churned'
group by Premium_tech_support
order by Churn_Percentage DESC

--What is the impact of phone service on churn?
SELECT
phone_service, ROUND(COUNT(Customer_ID) * 100.0 / SUM(COUNT(Customer_ID)) OVER(), 1) AS Churn_Percentage
from telecom_customer_churn$
where customer_status = 'churned'
group by phone_service
order by Churn_Percentage DESC

--What is the impact of promotional offer on churn?
SELECT
offer, ROUND(COUNT(Customer_ID) * 100.0 / SUM(COUNT(Customer_ID)) OVER(), 1) AS Churn_Percentage
from telecom_customer_churn$
where customer_status = 'churned'
group by offer
order by Churn_Percentage DESC



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




--Are high-value customers at risk of churning?

WITH high_value_customer AS (
    SELECT
        COUNT(customer_id) AS hv_cust_count,
        CASE
            WHEN total_revenue >= 9000 AND tenure_in_months >= 7 AND number_of_referrals > 0 THEN 'High'
            WHEN total_revenue >= 9000 AND tenure_in_months >= 7 THEN 'Medium'
            WHEN total_revenue >= 9000 OR tenure_in_months >= 7 OR number_of_referrals > 0 THEN 'Low'
            ELSE 'Null'
        END AS churn_risk_level
    FROM
        telecom_customer_churn$
    WHERE
        total_revenue > 10000 AND tenure_in_months >= 7 
    GROUP BY
        CASE
            WHEN total_revenue >= 9000 AND tenure_in_months >= 7 AND number_of_referrals > 0 THEN 'High'
            WHEN total_revenue >= 9000 AND tenure_in_months >= 7 THEN 'Medium'
            WHEN total_revenue >= 9000 OR tenure_in_months >= 7 OR number_of_referrals > 0 THEN 'Low'
            ELSE 'Null'
        END
)
SELECT
    churn_risk_level,ROUND(hv_cust_count * 100.0 / SUM(hv_cust_count) OVER (),2) AS churn_risk_percentage
FROM
    high_value_customer;













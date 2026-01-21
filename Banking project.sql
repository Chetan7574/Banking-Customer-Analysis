create database Banking;
use Banking;
select * from Customer;
select @@SERVERNAME

--1) Find the total number of clients in the bank.
select count(*) As Total_clients from  Customer

--2) Calculate the total deposit amount across all customers.
select sum(Bank_Deposits) as total_deposit_amount from Customer

--3) Calculate the total loan amount given by the bank.
select sum(Bank_Loans) as total_loan from Customer

--4) Find the average deposit per customer.
select AVG(Bank_deposits) as avg_deposit from Customer

--5) Count how many customers belong to each gender.
select count(*)as customers,GenderId from Customer
group by GenderId

--6) List customers who have more than one credit card.
select Name, Amount_of_Credit_Cards from Customer
where Amount_of_Credit_Cards > 1

--7) Identify the top 10 customers by total deposit.
select Top 100 Name,Bank_Deposits from Customer
order by Bank_Deposits desc

--8) Identify the top 10 customers by total loan amount.
select top 10 Name,Bank_Loans from Customer
order by Bank_Loans desc;

--9) Find gender-wise distribution of total deposits and loans.
select SUM(Bank_Deposits)as Deposit, SUM(Bank_Loans)as Loans , GenderId from Customer
group by GenderId

--10) Show nationality-wise total business lending.
select nationality,sum(Business_Lending)as Total_business from Customer
group by Nationality;

--11) Find customers whose loan amount is greater than deposit amount.
select Name,Bank_Loans,Bank_Deposits from Customer
where Bank_Loans > Bank_Deposits

--12) Identify customers with credit card balance above average.
select Name, Credit_Card_Balance from Customer
where Credit_Card_Balance > (Select avg(Credit_Card_Balance) from Customer)

--13) Find customers with the highest loan–deposit gap.
select top 10 Name,SUM(Bank_Deposits) as Total_deposit, SUM(bank_Loans) as Total_loan, 
SUM(Bank_Deposits)-SUM(Bank_Loans) as loan_deposit_gap from Customer 
group by Name
order by loan_deposit_gap Desc;

--14) List top 5 high-risk customers based on loan–deposit gap.
select Top 5 Name, Sum(bank_loans) as Loans, SUM(Bank_deposits) as Deopsite, SUM(Bank_Loans)-SUM(Bank_deposits) as Loan_Deposite_gap 
from Customer
group by Name
order by Loan_Deposite_gap desc

--15) Classify customers into Low / Medium / High risk using loan–deposit gap logic.
select Name, SUM(Bank_Loans)-SUM(Bank_deposits) as Loan_Deposite_gap,
case
when SUM(Bank_Loans)-SUM(Bank_deposits) > 1000000 then 'High_Risk_Customer' 
when SUM(Bank_Loans)-SUM(Bank_deposits) > 500000 then 'Medium Risk Customer' 
else 'Low Risk Customer'
end as Gap_band 
from Customer
group by Name

--16) Calculate loan–deposit ratio per customer.
select Name, SUM(Bank_Loans), SUM(Bank_Deposits) , Sum(Bank_Loans)/Nullif(SUM(Bank_Deposits),0) as Loan_Deposite_ratio  
from Customer 
group by Name

--17) Find customers whose loan exceeds deposit by more than 10 lakh.
select name,  SUM(Bank_Loans) as Loans, SUM(Bank_deposits) as Deposits , SUM(Bank_Loans)-SUM(Bank_Deposits) as loan_exceeds 
from Customer
group by Name
having SUM(Bank_Loans)-SUM(Bank_Deposits) > 1000000
order by loan_exceeds desc 

--18) Rank customers by loan amount within each income band.
select name, Bank_loans,
RANK() over (order by Bank_loans desc)
from Customer

--19) Find customers who joined the bank earlier and still hold high balances.
select name,Client_ID , MIN(Joined_Bank), SUM(Bank_Deposits) from Customer
group by name,Client_ID
having Min(Joined_bank) <='2010'  and SUM(Bank_deposits) > (Select AVG(Bank_deposits) from Customer) 
order by Sum(Bank_Deposits) desc 

--20) Create a bank summary view with total clients, deposits, loans, and ratios.
CREATE VIEW Bank_Summary AS
SELECT
    COUNT(DISTINCT Client_ID) AS Total_Clients,
    SUM(Bank_Deposits) AS Total_Deposits,
    SUM(Bank_Loans) AS Total_Loans,
    CAST(SUM(Bank_Loans) AS FLOAT) / NULLIF(SUM(Bank_Deposits), 0) AS Loan_Deposit_Ratio
FROM Customer;

select * from Bank_Summary


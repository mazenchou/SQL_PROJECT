--just the basics TO UNTERSETEND THE DATA

select TOP 5 * 
from dbo.company_divisions

select top 5*
from dbo.company_regions


select top 5*
from dbo.staff


---------- how many total employees in this company-----
select count(*)
from dbo.staff
--we know all the emolyes are distinct 
select distinct count(*)
from dbo.staff

-- now how many employes in each dep 
select department,  count(id) as total_emp
from dbo.staff
group by department
order by department

-- what is the hidhest and lowest salary of emp 
-- let's get more complected :
-- averge betewen the male and female 
select gender ,  MAX(salary) as max_one , MIN(salary) as min_one , 
avg(salary) as avr_salary 
from dbo.staff
group by gender 

--it seems like the averge between male and f group is perrty close

-- i wanna know distrubition of min , max averge salary dy dep
select department
, max(salary) as max_sal, min (salary)as min_sal, avg(salary)as avg_sal
from dbo.staff
group by department
order by 4 desc 


-- let's be clear here in sql server there ins't a built-in function named VAR_POP

-- we will 3 buckets or 3 cases to see the salary earning status for HEALTH dep
 CREATE VIEW  health_dep
 as 
 select 
   case 
      when salary >=100000 then 'high earner'
	  when salary >=50000 and salary <100000 then 'middle earner'
	  else 'low earner'
    end as earning_status

	 
from dbo.staff
where department like 'Health' 


-- and now we can see that there are 24 high earners , 14 middle earner and 8 low 

select earning_status , count (*)
from health_dep
group by earning_status

--drop view
drop view health_dep
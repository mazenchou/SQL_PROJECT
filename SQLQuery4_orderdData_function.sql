------------- ordered bata , functions and windows------


--employee salary vs average salary odf his or her dep 
-- use over(partion by   )
select 
department,last_name ,salary ,
avg(salary)over (partition by department) as average_by_dep
from dbo.staff


--or svg for all
select 
department,last_name ,salary ,
avg(salary)over (order by salary rows between unbounded preceding and unbounded following) as average_by_dep
from dbo.staff


--sum salary (meth croissant)
select 
department,last_name ,salary ,
sum(salary)over (order by salary rows between unbounded preceding and current row) as sum_by_sal
from dbo.staff


--use FIRST_VALUE()
--in this case decending order of salary group by department
SELECT
	department,
	last_name,
	salary,
	FIRST_VALUE(salary) OVER (PARTITION BY department ORDER BY salary DESC)
FROM staff;

--------------- rank() ROW_NUMBER() and DENSE_RANK()-----------------------------------------------
-- give the rank by salary decending oder withint the specific department group
SELECT
	department,
	last_name,
	salary,
	RANK() OVER (PARTITION BY department ORDER BY salary DESC) as rang
FROM staff;

--same as above
--but this particular case cuz all the salary are diff
SELECT
	department,
	last_name,
	salary,
	ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC)
FROM staff;	


--rank all no partition by

SELECT
	department,
	last_name,
	salary,
	ROW_NUMBER() OVER (ORDER BY salary DESC)
FROM staff;	


--dense rank  and rank
--rank leaves gaps in the ranking sequence when there are ties (1 2 2 2 5)
--whereas dense rank assigns the same rank to tied rows and continues with the next rank without gaps(1 2 2 2 3)

SELECT
	department,
	last_name,
	salary,
	DENSE_RANK() OVER (ORDER BY salary DESC) as rang
FROM staff;


SELECT
	department,
	last_name,
	salary,
	RANK() OVER (ORDER BY salary DESC) as rang
FROM staff;

-- avg every two then increase the next 
--just focus
	
select 
department,last_name ,salary ,
avg(salary)over (order by salary rows between 1 preceding and 1 following) as average_by_dep
from dbo.staff
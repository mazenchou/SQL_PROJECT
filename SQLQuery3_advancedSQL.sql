-------filtering , join and aggregration ------

-- we want to know person's salary comparnig to his or her dep averge sal 
select s1.last_name ,
(select avg(salary) from staff s where s.department=s1.department )
as dep_ave_sal
from staff s1 

------- how many ppl are earning above\below ave salay of his or her dep 

-- just to undrestand the problem
select s1.department,  s1.last_name ,  salary , avg(salary) , (select avg(salary) from staff s where s.department=s1.department )
from dbo.staff s1
group by s1.last_name , s1.salary,  s1.department

create view sal_comparision_by_dep as 
select s.last_name ,
        s.department ,
		case
           when (s.salary > (select avg(salary) from staff s2 where s2.department=s.department))
	        then 1
	        else 0
end as higer_than_dep_avg_salary
from dbo.staff s


 --order by s.department

 select *
 from sal_comparision_by_dep

 --higer
 SELECT department, COUNT(*) AS total_employees
FROM sal_comparision_by_dep
where higer_than_dep_avg_salary=1
GROUP BY department 
--lower 
SELECT department, COUNT(*) AS total_employees
FROM sal_comparision_by_dep
where higer_than_dep_avg_salary<>1
GROUP BY department 



--full details info of employees with company div
select s.last_name , s.department , cd.company_division
from staff s
join company_divisions cd
	ON cd.department = s.department;


--who are those people with missing company division
SELECT s.last_name, s.department, cd.company_division
FROM staff s
LEFT JOIN company_divisions cd
	ON cd.department = s.department
WHERE company_division IS NULL;


--conclusion :it seems like all staffs from "books" department have missing company division


-------------------------------------------------------------------------------------------------------------



-- now create view that can satisfy staff , dision and regions
--explain more with code : 
CREATE VIEW vw_staff_div_reg AS
	SELECT s.*, cd.company_division, cr.company_regions
	FROM staff s
	--use the left join to add any additional records in the left table
	LEFT JOIN company_divisions cd ON s.department = cd.department
	LEFT JOIN company_regions cr ON s.region_id = cr.region_id;



	

------------How many staffs are in each company regions 

SELECT company_regions, COUNT(*) AS total_employees
FROM vw_staff_div_reg
GROUP BY company_regions
ORDER BY 1;

--How many staffs are in each company regions and company_division

SELECT company_regions, company_division, COUNT(*) AS total_employees
FROM vw_staff_div_reg
where company_division is not null
GROUP BY company_regions, company_division
ORDER BY 1,2;



-----------------------------------------------------------------------------------------


------------------------use all the grouping stes
----- grouping sets 
select company_regions, company_division, COUNT(*) AS total_employees
FROM vw_staff_div_reg
group by 
     GROUPING sets (company_regions, company_division)
	 order by 1,2


select company_regions, company_division,gender , COUNT(*) AS total_employees
FROM vw_staff_div_reg
group by 
     GROUPING sets (company_regions, company_division , gender)
	 order by 1,2




------------------------------------------------------------------------------

--create new view and add the country 

CREATE VIEW vw_staff_div_reg_country AS
	SELECT s.*, cd.company_division, cr.company_regions, cr.country
	FROM staff s
	LEFT JOIN company_divisions cd ON s.department = cd.department
	LEFT JOIN company_regions cr ON s.region_id = cr.region_id;



	
--- how many ppl in same reg and country 

select company_regions , country , count(*) as total_emp
from vw_staff_div_reg_country
group by company_regions, country
order by company_regions, country


--number of employees per regions & country, Then subtotals per Country, Then total for whole table
-----on gonna use roll up and cube 

select company_regions , country , count(*) as total_emp
from vw_staff_div_reg_country
group by 
rollup (company_regions, country)
order by company_regions, country



select company_division, company_regions , count(*) as total_emp
from vw_staff_div_reg_country
group by 
cube (company_division, company_regions)
order by company_division, company_regions


----------grouping id ----------------------

select company_division, company_regions , count(*) as total_emp ,
case GROUPING_ID(company_division, company_regions)

when 0 then 'company_division_sub_total'
 when 1 then 'company_regions_sub_total'
 when 3 then 'total'

 end as sub_total

from vw_staff_div_reg_country
group by 
rollup (company_division, company_regions)
order by company_division, company_regions

---------------------------
---------rollup and cube

SELECT company_division, company_regions, country, COUNT(*) AS total_employees
FROM vw_staff_div_reg_country
GROUP BY 
	ROLLUP(company_division, company_regions, country)
ORDER BY company_division, company_regions, country;


SELECT company_division, company_regions, country, COUNT(*) AS total_employees
FROM vw_staff_div_reg_country
GROUP BY 
	CUBE(company_division, company_regions, country)
ORDER BY company_division, company_regions, country;






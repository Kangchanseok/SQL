-- 문제 1

select count(manager_id) haveMngCount
from employees
where manager_id is not null;

-- 문제 2

select max(salary) 최고임금, min(salary) 최저임금,
max(salary) - min(salary) "최고임금 - 최저임금"
from employees;

-- 문제 3
select to_Char(max(hire_Date),'yyyy"년" mm"월" dd"일"')
from employees;

-- 문제 4
select department_id, avg(salary), max(salary), min(salary)
from employees
group by department_id
order by department_id desc;

-- 문제 5
select job_id, round(avg(salary)),
min (salary), max(salary)
from employees
group by job_id
order by min(salary) desc, avg(salary) asc;

-- 문제 6
select to_Char(min(hire_date), 'yyyy-mm-dd day')
from employees;

-- 문제 7
select department_id,
avg(salary), min(salary),
avg(salary)-min(salary) 
from employees
group by department_id
having avg(salary) - min(salary) <2000
order by avg(salary) - min(salary) desc;

-- 문제 8 
select job_id,
max(salary) - min(salary) as diff
from employees
group by job_id
order by diff desc;

-- 문제 9
select manager_id, round(avg(salary)),
min(salary), max(Salary)
from employees
where hire_date >= '05/01/01'
group by manager_id
having avg(salary) >= 5000
order by avg(salary)desc; 

-- 문제 10
select employee_id, salary,
case when hire_date <= '02/12/31' then '창립멤버'
when hire_date <= '03/12/31' then '03년 입사'
when hire_date <= '04/12/31' then '04년 입사'
else '상장 이후 입사'
end optDate,
hire_Date
from employees
order by hire_date;
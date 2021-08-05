-- 서브쿼리 문제 1 끝
select count(salary)
from employees
where salary < (select avg(salary)
from employees);

-- 문제 2  평균급여랑 최대급여가 값이 이상하넹..
select employee_id 직원번호,
first_name 이름,
salary 급여,
avg(salary) 평균급여,
max(salary) 최대급여
from employees 
where salary >= (select avg(salary)
from employees) 
and
salary <=(select max(salary) 
from employees)
group by employee_id, first_name,salary
order by salary;


-- 문제 3
select location_id 도시아이디,
street_address 거리명,
postal_code 우편번호,
city 도시명,
state_province 주,
country_id 나라아이디
from locations l join departments d using (location_id) 
where d.department_id in (select first_name, last_name, e.department_id
from employees e
where first_name = 'Steven' and last_name = 'King');

-- 문제 4 끝
select employee_id 사번,
first_name 이름,
salary 급여
from employees
where salary < any (select salary
from employees
where job_id = 'ST_MAN')
order by salary desc;

-- 문제 5 끝
-- 조건절 비교
select employee_id 직원번호,
first_name 이름,
salary 급여,
department_id 부서번호
from employees
where (department_id,salary) in(select department_id,max(salary)
from employees
group by department_id)
order by salary desc;
-- 테이블 조인 -- order by를 어디에 넣지..
select e.employee_id 직원번호,
e.first_name 이름,
e.salary 급여,
e.department_id 부서번호
from employees e,(select department_id, max(salary) salary
from employees
group by department_id) s
where e.department_id = s.department_id 
and
e.salary = s.salary;

-- 문제 6
select j.job_title 업무명,
sum(e.salary) "연봉 총합"
from jobs j, employees e
where (j.job_id, e.salary) in(select j.job_id, sum(e.salary)
from jobs j, employees e 
group by job_id);

-- 문제 7 끝
select e.employee_id,
e.first_name,
e.salary
from employees e
where e.salary > (select avg(salary)
from employees
where department_id = e.department_id);

-- 문제 8 끝
select employee_id,
first_name,
salary,
hire_date,
rownum 
from (select *
from employees
order by hire_date asc)
where rownum <=15
minus
select employee_id,
first_name,
salary,
hire_date,
rownum 
from (select *
from employees
order by hire_date asc)
where rownum <=10;


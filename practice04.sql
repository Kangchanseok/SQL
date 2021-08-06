-- 서브쿼리 문제 1 끝
select count(salary)
from employees
where salary < (select avg(salary)
from employees);

-- 문제 2  평균급여랑 최대급여가 값이 이상하넹..
-- 풀이해주심
select e.employee_id 직원번호,
e.first_name 이름,
e.salary 급여,
t.avgsalary 평균급여,
t.maxsalary 최대급여
from employees e, (select avg(salary) as avgsalary ,
max(salary) as maxsalary
from employees ) t
where e.salary between t.avgsalary and t.maxsalary
order by salary;


-- 문제 3 풀이해주심
-- 쿼리1. steven king이 소속된 부서
select department_id 
from employees
where first_name = 'Steven' and last_name = 'King';
-- 쿼리2. steven king이 소속된 부서가 위치한 location 정보
select location_id 
from departments
where department_id = (select department_id 
from employees
where first_name = 'Steven' and last_name = 'King');
-- 최종 쿼리 
select location_id,
street_address, 
postal_code,
city,
state_province,
country_id
from locations
where location_id = (select location_id 
from departments
where department_id = (select department_id 
from employees
where first_name = 'Steven' and last_name = 'King'));


--select location_id 도시아이디,
--street_address 거리명,
--postal_code 우편번호,
--city 도시명,
--state_province 주,
--country_id 나라아이디
--from locations l join departments d using (location_id) 
--where d.department_id in (select first_name, last_name, e.department_id
--from employees e
--where first_name = 'Steven' and last_name = 'King');


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
-- 테이블 조인 -- 
select e.employee_id 직원번호,
e.first_name 이름,
e.salary 급여,
e.department_id 부서번호
from employees e,(select department_id, max(salary) salary
from employees
group by department_id) s
where e.department_id = s.department_id 
and
e.salary = s.salary
order by e.salary desc;

-- 문제 6 풀어주심

-- 쿼리 1
select job_id, sum(salary) sumsalary
from employees group by job_id;
-- 최종쿼리
select j.job_title,
t.sumsalary
from jobs j, (select job_id, sum(salary) sumsalary
from employees group by job_id) t
where j.job_id = t.job_id
order by t.sumsalary desc;



--
--select j.job_title 업무명,
--sum(e.salary) "연봉 총합"
--from jobs j, employees e
--where (j.job_id, e.salary) in(select j.job_id, sum(e.salary)
--from jobs j, employees e 
--group by job_id);


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


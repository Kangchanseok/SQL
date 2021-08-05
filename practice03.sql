-- 문제 1
select employee_id 사번,
first_name 이름,
last_name 성,
department_name 부서명
from employees e, departments d
where e.department_id = d.department_id
order by department_name, employee_id desc;

-- 문제 2
select employee_id 사번,
first_name 이름,
salary 급여,
department_name 부서명,
job_title 업무명
from employees e, departments d,jobs j
where e.department_id = d.department_id and
e.job_id = j.job_id
order by employee_id;

-- 문제 2-1 3개 테이블 join (left outer join)
select employee_id 사번,
first_name 이름,
salary 급여,
department_name 부서명,
job_title 업무명
from employees e, departments d,jobs j
where e.department_id = d.department_id(+) and
e.job_id = j.job_id
order by employee_id;

-- ansi
select employee_id 사번,
first_name 이름,
salary 급여,
department_name 부서명,
job_title 업무명
from employees e left outer join departments d
on e.department_id = d.department_id,
jobs j
where e.job_id = j.job_id;

-- 문제 3
select loc.location_id, city,
department_name, department_id
from departments d join locations loc
on d.location_id = loc.location_id
order by loc.location_id;

-- 3-1 (부서가 없는 도시)
select loc.location_id, city,
department_name, department_id
from locations loc left outer join departments d
on loc.location_id = d.location_id
order by loc.location_id;

-- 문제 4
select region_name 지역이름,
country_name 나라이름
from regions r, countries c
where r.region_id = c.region_id
order by r.region_name asc, country_name desc;

-- 문제 5 : self join
select e.employee_id,
e.first_name,
e.hire_date,
m.first_name,
m.hire_Date
from employees e, employees m
where e.manager_id = m.employee_id and
e.hire_date < m.hire_date;

-- 문제 6 
select country_name,
c.country_id,
city,
l.location_id,
department_name,
department_id
from countries c, locations l, departments d
where d.location_id = l.location_id and
c.country_id = l.country_id
order by c.country_name;

-- 문제 7
select e.employee_id 사번,
first_name || '' || last_name 이름,
j.job_id 업무아이디,
start_Date 시작일,
end_date 종료일
from employees e, job_history j
where e.employee_id = j.employee_id and
j.job_id = 'AC_ACCOUNT';

-- 문제 8
select d.department_id,
department_name,
first_name 매니저이름,
city 도시명,
country_name 나라명,
region_name 지역명
from departments d, 
employees e,
locations l,
countries c,
regions r
where d.manager_id = e.manager_id and
d.location_id = l.location_id and
l.country_id = c.country_id and
c.region_id = r.region_id
order by d.department_id;

-- 문제 9 
select 
e.employee_id,
e.first_name,
department_name,
m.first_name
from employees e left outer join departments d
on e.department_id = d.department_id,
employees m
where e.manager_id = m.employee_id;

-------------
-- SUBQUERY
------------
-- 하나의 질의문 안에 다른 질의문을 포함하는 형태
-- 전체 사원 중, 급여의 중앙값보다 많이 받는 사원

-- 1. 급여의 중앙값?
SELECT MEDIAN(salary) FROM employees; -- 6200
-- 2. 6200보다 많이 받는 사원 쿼리
SELECT first_name, salary FROM employees WHERE salary > 6200;

-- 3. 두 쿼리를 합친다
SELECT first_name, salary FROM employees
WHERE salary > (SELECT MEDIAN(salary) FROM employees);

-- Den 보다 늦게 입사한 사원들
-- 1. Den 입사일 쿼리
SELECT hire_date FROM employees WHERE first_name = 'Den'; -- 02/12/07
-- 2. 특정 날짜 이후 입사한 사원 쿼리
SELECT first_name, hire_date FROM employees WHERE hire_date >= '02/12/07';
-- 3. 두 쿼리를 합친다.
SELECT first_name, hire_54date FROM employees WHERE hire_date >= 
(SELECT hire_date FROM employees WHERE first_name = 'Den');

--다중행 서브 쿼리
-- 서브 쿼리의 결과 레코드가 둘 이상이 나올 때는 단일행 연산자를 사용할 수 없다
-- IN, ANY, ALL, EXISTS 등 집합 연산자를 활용
SELECT salary FROM employees WHERE department_id = 110; -- 2 ROW

SELECT first_name, salary FROM employees
WHERE salary = (SELECT salary FROM employees WHERE department_id = 110); -- ERROR

--결과가 다중행이면 집합 연산자를 사용
-- salary = 120008 OR salary = 8300
SELECT first_name, salary FROM employees
WHERE salary IN (SELECT salary FROM employees WHERE department_id = 110);

-- ALL(AND)
-- salary > 12008 AND salary > 8300
SELECT first_name, salary FROM employees
WHERE salary > ALL (SELECT salary FROM employees WHERE department_id = 110);

-- ANY(OR)
-- salary > 12008 OR salary > 8300
SELECT first_name, salary FROM employees
WHERE salary > ANY (SELECT salary FROM employees WHERE department_id = 110);

-- 각 부서별로 최고 급여를 받는 사원을 출력
-- 1. 각 부서의 최고 급여 확인 쿼리
select department_id, max(salary)
from employees
group by department_id;
-- 2. 서브 쿼리의 결과 (department_id, MAX(salary))
select department_id, employee_id, first_name, salary
from employees
where (department_id, salary) in (select department_id, max(salary)
from employees
group by department_id)
order by department_id asc;

-- 서브쿼리와 조인
select e.department_id, e.employee_id, e.first_name, e.salary
from employees e,(select department_id, max(salary) salary 
from employees
group by department_id) sal
where e.department_id = sal.department_id and
e.salary = sal.salary
order by department_id;


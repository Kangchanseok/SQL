----------
---JOIN---
----------

-- 먼저 employees와 departments를 확인
desc employees;
desc departments;

-- 두 테이블로부터 모든 레코드를 추출 : Catrision Product or Cross Join
select first_name, emp.department_id, dept.department_id, department_name
from employees emp, departments dept
order by first_name;

-- 테이블 조인을 위한 조건 부여 가능
select first_name, emp.department_id, dept.department_id, department_name
from employees emp, departments dept
where emp.department_id = dept.department_id
order by first_name;

-- 총 몇 명의 사원이 있는가?
select count(*) from employees; -- 107명

select first_name, emp.department_id, department_name
from employees emp, departments dept
where emp.department_id = dept.department_id; -- 106명

-- department_id가 null인 사원?
select * from employees
where department_id is null;

-- USING : 조인할 컬럼을 명시
select first_name, department_name
from employees join departments using(department_id);

-- ON : join의 조건절
select first_name, department_name
from employees emp join departments dept 
on(emp.department_id = dept.department_id); -- join의 조건

-- Natural JOIN 
-- 조건 명시 하지 않고, 같은 이름을 가진 컬럼으로 join
select first_name, department_name
from employees natural join departments; 
-- 잘못된 쿼리 : natural join은 조건을 잘 확인!

-- OUTER JOIN
-- 조건이 만족하는 짝이 없는 튜플도 NULL을 포함하여 결과를 출력
-- 모든 레코드를 출력할 테이블의 위치에 따라 LEFT, RIGHT, FULL OUTER JOIN으로 구분
-- Oracle의 경우 NULL을 출력할 조건 쪽에 (+)를 명시

select first_name,
emp.department_id,
dept.department_id,
department_name
from employees emp, departments dept
where emp.department_id = dept.department_id(+);

-- ANSI SQL
select emp.first_name,
emp.department_id,
dept.department_id,
dept.department_name
from employees emp left outer join departments dept
on emp.department_id = dept.department_id;

-- RIGHT OUTER JOIN : 짝이 없는 오른쪽 레코드도 NULL을 포함하여 출력
-- Oracle SQL
select first_name,
emp.department_id,
dept.department_id,
department_name
from employees emp, departments dept
where emp.department_id(+) = dept.department_id;

-- ANSI SQL
select emp.first_name,
emp.department_id,
dept.department_id,
dept.department_name
from employees emp right outer join departments dept
on emp.department_id = dept.department_id;

-- FULL OUTER JOIN
-- 양쪽 테이블 레코드 전부를 짝이 없어도 출력에 참여
--select emp.first_name,
--emp.department_id,
--dept.department_id,
--dept.department_name
--from employees emp, departments dept
--where emp.department_id (+)= dept.department_id(+);
-- Oracle SQL(+) 방식으로는 불가

-- ANSI SQL
select emp.first_name,
emp.department_id,
dept.department_id,
dept.department_name
from employees emp full outer join departments dept
on emp.department_id = dept.department_id;
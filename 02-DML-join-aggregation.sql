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

------------
--집계 함수
------------
-- 여러 레코드로부터 데이터를 수집, 하나의 결과 행을 반환

--count : 갯수 세기
select count(*) from employees; -- 특절 컬럼이 아닌 레코드의 갯수 센다.

select count (commission_pct) from employees; -- 해당 컬럼이 null이 아닌 갯수
select count (*) from employees
where commission_pct is not null; -- 위랑 같은 의미

-- sum : 합계
-- 급여의 합계
SELECT sum(salary) FROM employees;

-- avg: 평균
-- 급여의 평균
SELECT avg(salary) FROM employees;
-- avg 함수는 null 값은 집계에서 제외

-- 사원들의 평균 커미션 비율
SELECT avg(commission_pct) FROM employees; -- 22%
SELECT avg(nvl(commssion_pct, 0)) FROM employees; -- 7 %

-- min/max: 최소값, 최대값
SELECT MIN(salary), MAX(salary), AVG(salary), MEDIAN(salary)
FROM employees;

-- 오류 ? PDF다시보기
--SELECT deptno, dname, AVG(sal) 
--FROM emp
--GROUP BY deptno
--ORDER BY deptno;

-- 일반적 오류
SELECT department_id, AVG(salary)
FROM employees; -- ERROR

-- 수정 : 집계함수
SELECT department_id, AVG(salary)
FROM employees
GROUP BY department_id
ORDER BY department_id;

-- 집계 함수를 사용한 SELECT 문의 컬럼 목록에는
-- GROUP by에 참여한 필드, 집계 함수만 올 수 있다.

-- 부서별 평균 급여를 출력,
-- 평균 급여가 7000 이상인 부서만 뽑아봅시다.
SELECT department_id, AVG(salary)
FROM employees
WHERE AVG(salary) >= 7000 -- WHERE절 실행시에는 아직 AVG가 집계되지 않음
GROUP BY department_id;
-- 집계함수 실행 이전에 WHERE 절을 검사하기 때문에
-- 집계 함수는 WHERE 절에서 사용할 수 없다

-- 집계 함수 실행 이후에 조건 검사하려면
--HAVING 절을 이용
SELECT department_id, ROUND (AVG(salary), 2)
FROM employees
GROUP BY department_id
        HAVING AVG(salary) >= 7000
ORDER BY department_id;


--------
-- 분석 함수
--------
-- ROLLUP
-- 그룹핑된 결과에 대한 상세 요약을 제공하는 기능
-- 일종의 ITEM Total
SELECT department_id,
    job_id,
    SUM(salary)
FROM employees
GROUP BY ROLLUP(department_id, job_id);

-- CUBE 함수
-- Cross TABLE에 대한 Summary를 함께 추출
-- ROLLUP 함수에서 추출되는 ITem Total과 함께
-- Column Total 값을 함께 추출
SELECT department_id, job_id, SUM(salary)
FROM employees
GROUP BY CUBE (department_id, job_id)
ORDER BY department_id;

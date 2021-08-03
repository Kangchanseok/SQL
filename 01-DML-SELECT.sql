--DML: SELECT

---------------------
-- SELECT ~ FROM
---------------------
-- 전체 데이터의 모든 컬럼 조회
-- 컬럼의 출력 순서는 정의에 따른다
SELECT
    *
FROM
    employees;

SELECT
    *
FROM
    departments;

-- 특정 컬럼만 선별 Projection
-- 사원의 이름, 입사일, 급여 출력
SELECT
    first_name,
    hire_date,
    salary
FROM
    employees;

-- 산술연산: 기본적인 산술연산 가능
--  dual: 오라클의 가상 테이블
-- 특정 테이블에 속한 데이터가 아닌 오라클 시스템에서 값을 구한다
SELECT
    10 * 10 * 3.14159
FROM
    dual; -- 결과 1개
SELECT
    10 * 10 * 3.14159
FROM
    employees;  -- 결과 테이블의 레코드 수만큼

SELECT
    first_name,
    job_id * 12
FROM
    employees;
--ERROR: 수치 데이터 아니면 산술연산 오류
DESC employees;

SELECT
    first_name + ' ' + last_name
FROM
    employees; 
-- first, last 둘다 문자열 
-- 문자열 연결은 ||로 연결
SELECT
    first_name
    || ''
    || last_name
FROM
    employees;


--NULL 
SELECT
    first_name,
    salary,
    salary * 12
FROM
    employees;

SELECT
    first_name,
    salary,
    commission_pct
FROM
    employees;

SELECT
    first_name,
    salary,
    commission_pct,
    salary + salary * commission_pct
FROM
    employees; -- null이 포함된 산술식은 null

-- NVL: 중요!!!!!!
SELECT
    first_name,
    salary,
    commission_pct,
    salary + salary * nvl(commission_pct, 0)
FROM
    employees;
-- commission pct가 null이면 0으로 치환

--ALIAS: 별칭
SELECT
    first_name
    || ''
    || last_name 이름,
    phone_number AS 전화번호,
    salary       "급여" -- 공백, 특수문자가 포함된 별칭은 ""로 묶장~
FROM
    employees;

SELECT
    first_name
    || ''
    || last_name 이름,
    hire_date    입사일,
    phone_number 전화번호,
    salary       급여,
    salary * 12  연봉
FROM
    employees;

--------------
--where
--------------

-- 비교연산
-- 급여가 15000 이상인 사원의 목록
SELECT
    first_name,
    salary
FROM
    employees
WHERE
    salary >= 15000;

-- 날짜도 대소 비교 가능
-- 입사일이 07/01/01 이후인 사원의 목록
SELECT
    first_name,
    hire_date
FROM
    employees
WHERE
    hire_date >= '07/01/01';
    
-- 이름이 Lex인 사원의 이름, 급여, 입사일 출력
SELECT
    first_name,
    salary,
    hire_date
FROM
    employees
WHERE
    first_name = 'Lex';
    
-- 논리연산자
-- 급여가 10000이하이거나 17000 이상인 사원의 목록
SELECT
    first_name,
    salary
FROM
    employees
WHERE
    salary <= 10000
    OR salary >= 17000;
    
-- BETWEEN A and B --> 급여가 14000 이상, 17000 이하인 사원의 목록
SELECT
    first_name,
    salary
FROM
    employees
WHERE
    salary BETWEEN 14000 AND 17000;

-- NULL 체크
-- 자바랑 헷갈려서 = Null 하면안됨!! 무조건 IS NULL
-- 커미션을 받지 않는 사원의 목록 
SELECT
    first_name,
    commission_pct
FROM
    employees
WHERE
    commission_pct IS NULL;

-- 연습문제 : TODO
-- 담당 매니저가 없고, 커미션을 받지 않는 사원의 목록

-- 집합 연산자: IN
-- 부서번호가 10, 20, 30인 사원들의 목록
SELECT
    first_name,
    department_id
FROM
    employees
WHERE
    department_id IN ( 10, 20, 30 );
-- where department_id = 10
-- or department_id = 20 or department_id = 30;

-- ANY
SELECT
    first_name,
    department_id
FROM
    employees
WHERE
    department_id = ANY ( 10,
                          20,
                          30 );

-- ALL: 뒤에 나오는 집합 전부 만족
SELECT
    first_name,
    salary
FROM
    employees
WHERE
    salary > ALL ( 12000,
                   17000 );

-- LIKE 연산자: 부분 검색
-- %: 0글자 이상의 정해지지 않은 문자열
-- _: 1글자(고정) 정해지지 않은 문자
-- 이름에 am을 포함한 사원의 이름과 급여를 출력
SELECT
    first_name,
    salary
FROM
    employees
WHERE
    first_name LIKE '%am%';

-- 연습:
-- 이름의 두번째 글자가 a인 사원의 이름과 연봉

-- oreder by: 정렬
-- 오름차순: 작은 값 -> 큰 값 asc(default)
-- 내림차순: 큰 값 -> 작은 값 desc

-- 부서번호 오름차순 -> 부서번호, 급여, 이름
SELECT
    department_id,
    salary,
    first_name
FROM
    employees
ORDER BY
    department_id; -- 오름차순 정렬
    
-- 급여 10000 이상 직원
-- 정렬: 급여 내림차순
SELECT
    first_name,
    salary
FROM
    employees
WHERE
    salary >= 10000
ORDER BY
    salary DESC;

-- 출력: 부서 번호, 급여, 이름
-- 정렬: 1차정렬 부서번호 오름차순, 2차정렬 급여 내림차순 

SELECT
    department_id,
    salary,
    first_name
FROM
    employees
ORDER BY
    department_id, -- 1차 정렬
    salary DESC; -- 2차정렬

------------------

-----단일행 함수---
-- 한 개의 레코드를 입력으로 받는 함수
-- 문자열 단일행 함수 연습
SELECT
    first_name,
    last_name,
    concat(first_name, concat('', last_name)), -- 연결
    initcap(first_name
            || ''
            || last_name), -- 각 단어의 첫글자만 대문자
    lower(first_name), -- 모두 소문자
    upper(first_name), -- 모두 대문자
    lpad(first_name, 10, '*'), -- 왼쪽 채우기
    rpad(first_name, 10, '*') -- 오른쪽 채우기
FROM
    employees;

SELECT
    ltrim('            Oracle            '),  -- 왼쪽 공백제거
    rtrim('                  Oracle            '), -- 오른쪽 공백 제거
    TRIM('*' FROM '******Database******'), -- 양쪽의 * 제거
    substr('Oracle Database', 8, 4), -- 부분 문자열
    substr('Oracle Database', - 8, 8) -- 부분 문자열
FROM
    dual;

-- 수치형 단일행 함수
SELECT
    abs(- 3.14), -- 절댓값
    ceil(3.14), -- 소수점 올림(천장)
    floor(3.14), -- 소수점 버림(바닥)
    mod(7, 3), -- 나머지
    power(2, 4), -- 제곱: 2의 4승
    round(3.5), -- 소수점 반올림
    round(3.14159, 3), -- 소수점 3자리까지 반올림으로 표현
    trunc(3.5), -- 소수점 버림
    trunc(3.14149, 3), -- 소수점 3자리까지 버림
    sign(- 10) -- 부호 혹은 0
FROM
    dual;
    
   ---------------------
   ----DATE FORMAT------
   ---------------------
   
   -- 현재 날짜와 시간
SELECT
    sysdate
FROM
    dual; -- 1행
SELECT
    sysdate
FROM
    employees; -- employees의 레코드 개수만큼
   
   -- 날짜 관련 단일행 함수
SELECT
    sysdate,
    add_months(sysdate, 2), -- 2개월 후
    last_day(sysdate), -- 이번 달의 마지막 날
    months_between(sysdate, '99/12/31'), -- 1999년 마지막 날 이후 몇 달이 지났는지
    next_day(sysdate, 7),
    round(sysdate, 'month'),
    round(sysdate, 'year'),
    trunc(sysdate, 'month'),
    trunc(sysdate, 'year')
FROM
    dual;
   
   --------------
   ----변환함수---
   --------------
   
  -- TO_NUMBER(S, FMT): 문자열을 포맷에 맞게 수치형으로 변환
  -- TO_DATE(S, FMT): 문자열을 포맷에 맞게 날짜형으로 변환
  -- TO_CHAR(O, FMT): 숫자 OR 날짜를 포맷에 맞게 문자형으로 변환
  
  -- TO_CHAR
SELECT
    first_name,
    hire_date,
    to_char(hire_date, 'yyyy-mm-dd'),
    to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss')
FROM
    employees;

SELECT
    to_char(3000000, 'L999,999,999')
FROM
    dual;

SELECT
    first_name,
    to_char(salary * 12, '$999,999.00') sal
FROM
    employees;
  
  --  TO_NUMBER: 문자형 -> 숫자형
SELECT
    to_number('2021'),
    to_number('$1,450.13', '$999,999.99')
FROM
    dual;
  
  -- TO_DATE: 문자형 -> 날짜형
SELECT
    TO_DATE('1999-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss')
FROM
    dual;
  
  -- 날짜 연산
  -- Date +(-) Number : 날짜에 일수 더하기(빼기)
  -- Date - Date : 두 Date 사이의 차이 일수
  -- Date +(-) Number / 24 : 날짜에 시간 더하기(빼기)
SELECT
    to_char(sysdate, 'yy/mm/dd hh24:mi'),
    sysdate + 1, -- 1일뒤
    sysdate - 1, -- 1일전
    sysdate - to_date('19991231'),
    to_char(sysdate + 13 / 24, 'yy/mm/dd hh24:mi') -- 13시간 후
FROM
    dual;
    
------------
--NULL 관련
------------

-- NVL 함수
select first_name, salary, commission_pct,
salary * nvl(commission_pct,0) as commission
from employees;

-- NVL2 함수
select first_name, salary, commission_pct,
nvl2(commission_pct, salary * commission_pct,0) as commission
from employees;

-- CASE 함수
-- AD 관련 직원에게는 20%, SA 관련 직원에게는 10%,
-- IT 관련 직원에게는 8%, 나머지는 5%
select first_name, job_id, substr(job_id,1,2), salary,
case substr(job_id,1,2) 
when 'ad' then salary * 0.2
when 'sa' then salary * 0.1 
when 'it' then salary * 0.08
else salary * 0.05
end bonus
from employees;

-- DECODE 함수
select first_name, job_id, salary, substr(job_id,1,2),
decode(substr(job_id,1,2),
'ad', salary * 0.2,
'sa', salary * 0.1,
'it', salary * 0.08,
salary * 0.05) -- else
bonus
from employees;

-- 연습문제:
-- 직원의 이름, 부서, 팀을 출력
-- 팀
-- 부서 코드: 10~30 -> A-Group
-- 부서 코드: 40~50 -> B-Group
-- 부서 코드: 60~100 -> C-Group
-- 나머지는 REMAINDER
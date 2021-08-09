---------------
----- DB Objects
---------------

-- VIEW
-- system 계정으로 수행
-- create view 권한 필요

grant create view to c##bituser;


-- c##bituser 로 전환~

--hr.employees 테이블로부터로 department_id = 10 사원의 view 생성
create table emp_123
as select * from hr.employees
where department_id in (10,20,30);

create or replace view emp_20
as select employee_id, first_name, last_name, salary
from emp_123
where department_id = 20;

desc emp_20;
-- 마치 일반 테이블처럼 select 할 수 있음
select employee_id, first_name, salary from emp_20;

-- simple view 는 제약사항에 위배되지 않으면 내용 갱신 가능
update emp_20 set salary = salary * 2;
select first_name, salary from emp_123 where department_id = 20;

-- 가급적 view는 조회 전용으로 사용하기를 권장
-- with read only 옵션
create or replace view emp_10
as select employee_id, first_name, last_name, salary
from emp_123
where department_id = 10
with read only;

select * from emp_10;
update emp_10 set salary = salary * 2;

-- Complex View
create or replace view book_detail
(book_id, title, author_name, pub_Date)
as select book_id, title, author_name, pub_date
from book b, author a
where b.author_id= a.author_id;

select * from book_detail;
select * from author;

desc book;

insert into book(book_id, title, author_id)
values(1,'토지',1);

insert into book(book_id, title, author_id)
values(2, '살인자의 기억법', 2);

commit;

-- complex view로 조회
select * from book_detail;
select * from author;

--complex view는 갱신이 불가 
update book_detail set sthor_name = '소설가' ; -- error

-- view 의 삭제
-- book detail은 book, author 테이블을 기반으로 함
drop view book_Detail; -- view 삭제

select * from tab;

-- viewe 확인을 위한 dictionary
select * from user_views;
select * from user_objects;

select object_name, object_type, status from user_objects
where object_type = 'view';

-- index : 검색 속도 증가
-- insert, update, delete -> 인덱스의 갱신 발생
-- hr.employees 테이블 복사 -> s_emp 테이블 생성
create table s_emp
as select * from hr.employees;

select * from s_emp;

-- s_emp.employee_id 에 unique_index 부여
create unique index s_emp_id
on s_emp (employee_id);

-- index 위한 dictionary
select * from user_indexes;
select * from user_ind_columns;

-- 어느 테이블에 어느 컬럼에 s_emp_id가 부여되었는가?
select t.index_name, t.table_name, c.column_name, c.column_position
from user_indexes t,user_ind_columns c
where t.index_name = c.index_name and
t.table_name = 'S_EMP';

select * from s_emp;

-- 인덱스 삭제
drop index s_emp_id;
select * from user_indexes;

-- 인덱스는 테이블과 독립적: 인덱스 삭제해도 테이블 데이터는 남아있음

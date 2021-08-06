-----------------
----- DCL -------
-----------------

-- CREATE : 데이터베이스 객체 생성
-- ALTER : 데이터베이스 객체 수정
-- DROP : 데이터베이스 객체 삭제

-- System 계정으로 수행

-- 사용자 생성: CREATE USER
create user c##bituser identified by bituser;

-- sqlplus에서 사용자로 접속
-- 사용자 삭제: DROP USER
drop user c##bituser cascade; -- cascade 연결된 모든 것을 함께 삭제

-- 다시 생성
create user c##bituser identified by bituser;

-- 사용자 정보 확인
-- USER_ : 현재 사용자 관련
-- ALL_ : 전체의 객체
-- DBA_ : DBA 전용, 객체의 모든 정보
select * from user_users;
select * from all_users;
select * from dba_users;

-- 새로 만든 사용자 확인
select * from dba_users 
where username = 'C##BITUSER'; -- 이름 분명 위에서 소문자로 만들었는데 무조건 대문자로 해야 오류 안나넹...

-- 권한(Previlege)과 역할(ROLE)
-- 특정 작업 수행을 위해 적절한 권한을 가져야 한다
-- CREATE SESSION

-- 시스템 권한의 부여: GRANT 권한 TO 사용자
-- C##BITUSER에게 create session 권한을 부여
grant create session to c##bituser; -- 여기서는 소문자로 해도되넹???

-- 일반적으로 CONNECT, RESOURCE 롤을 부여하면 일반사용자의 역할 수행 가능
grant connect, resource to c##bituser;

-- Oracle 12 이후로는 임의로 TABLESPACE를 할당 해주어야 한다.
alter user c##bituser -- 사용자 정보 수정
default tablespace users -- 기본 테이블 스페이스를 users 에 지정
quota unlimited on users; -- 사용 용량 지정

-- 객체 권한 부여
-- c##bituser 사용자에게 hr.employees를 select 할 수 있는 권한 부여
grant select on hr.employees to c##bituser;
-- 객체 권한 회수
revoke select on hr.employees from c##bituser;
grant select on hr.employees to c##bituser;

-- 전체 권한 부여시
-- GRANT all previleges ...


----------
---ddl----
--------

-- 이후 c##bituser로 진행

-- 현재 내가 소유한 테이블 목록 확인
select * from tab;
-- 현재 나에게 주어진 role을 조회
select * from user_role_privs;
-- create table: 테이블 생성
create table book(
book_id number(5),
title varchar2(50),
author varchar2(10),
pub_date date default sysdate);

select * from tab;
desc book; 

-- 서브쿼리를 이용한 테이블 생성
-- hr 스키마의 employees 테이블의 일부 데이터를 추출, 새 테이블 생성
select * from hr.employees;

-- job_id 가 it관련 직원들만 뽑아내서 새 테이블 생성
create table it_emps as( select * from hr.employees
where job_id like 'IT_%');

desc it_emps;
select * from it_emps;

-- author 테이블 추가
create table author(
author_id number(10),
author_name varchar2(50) not null,
author_desc varchar2(500),
primary key (author_id)); -- 테이블 제약

desc author;

-- book 테이블의 author 컬럼 지우기
-- 나중에 author 테이블과 fk연결
desc book;
alter table book drop column author;
desc book;

-- author 테이블 참조를 위한 컬럼 author_id 추가
alter table book
add (author_id number(10));

-- book 테이블의 book_id도 number(10)으로 변경
alter table book
modify (book_id number(10));

desc book;

-- book.book_id에 pk 제약조건부여
desc author;
alter table book
add constraint pk_book_id primary key (book_id);

-- book.aurhor_id를 author.author_id를 참조하도록 제약
alter table book
add constraint fk_author_id foreign key( author_id)
references author(author_id)
on delete cascade;


-- data dictionary
-- 전체 데이터 딕셔너리 확인
select * from dictionary;

-- 사용자의 스키마 객체 확인 : user_objects
select * from user_objects;

-- 제약조건의 확인 : user_constraints
select * from user_constraints;


------------------
-------cud--------
------------------

-- insert : 묵시적 방법
desc author;
insert into author
values (1,'박경리', '토지 작가');

-- insert : 명시적 방법(컬럼 명시)
insert into author (author_id, author_name)
values (2, '김영하');

-- 확인
select * from author;

-- dml은 트랜잭션의 대상
-- 취소 : rollback
-- 변경사항 반영 : commit
rollback;
commit;
select * from author;

-- update 
-- 기존 레코드의 내용 변경
update author
set author_desc = '소설가';

select * from author;
rollback;

-- update, delete 쿼리 작성시
-- 조건절을 부여하지 않으면 전체 레코드가 영향 -> 주의!!
update author
set author_desc = '소설가'
where author_name='김영하';

select * from author;

commit; -- 변경사항 반영

-- 연습
-- hr.employees -> department_id 가 10,20,30 
-- 새 테이블 생성
create table emp123 as 
select * from hr.employees;

desc emp123;

-- 부서가 30인 사원들의 급여를 10% 인상
update emp123 
set salary = salary * 1.1
where department_id = 30;

commit;

-- delete : 테이블에서 레코드 삭제
select * from emp123;

-- job_id가 mk_ 사원들 삭제
delete from emp123
where job_id like 'MK_%';

-- 현재 급여 평균보다 높은사람 모두 삭제
delete from emp123
where salary > (select avg(salary) from emp123);
select * from emp123;
commit;

--truncate 와 delete
--delete는 rollback 의 대상
--truncate는 롤백의 대상이 아님
delete from emp123;
select * from emp123;
rollback;
select * from emp123;

truncate table emp123;
rollback;

commit;
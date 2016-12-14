SHOW DATABASES;

CREATE DATABASE IF NOT EXISTS test;

USE test;

#建表
-- 表名丌能超过 30 个字符
-- 表名、列名是自由定义的
-- 所有的 SQL 语句都是以“ ; ”结尾
CREATE TABLE user_test(
									id  int,
									password varchar(6),
									name varchar(20),
									phone varchar(11),
									email varchar(20)
									)
alter table user_test modify email varchar(50);

insert into user_test values(1001,'123456','张三','13468857714','linglongxin24@163.com');

SELECT * from user_test;

desc user_test;

SELECT name FROM user_test where name='张三';



CREATE TABLE dept_test(
dept_id int(2),
dept_name CHAR(20),
dept_location CHAR(20)
);

desc dept_test;



INSERT INTO dept_test VALUES(10,'developer','beijing');

INSERT INTO dept_test VALUES(20,'account','shanghai');

INSERT INTO dept_test VALUES(30,'sales','guangzhou');

INSERT INTO dept_test VALUES(40,'operations','tianjin');

SELECT * FROM dept_test;

CREATE TABLE emp_test(
											emp_id INT(4),
											name VARCHAR(20),
											job VARCHAR(20),
											salary FLOAT(7,2),
											bonus FLOAT(7,2),
											hire_date DATE,
											manager INT(4),
											dept_test_id INT(2)
);

DESC emp_test;

SELECT * FROM EMP_TEST;


#格式化日期用DATE_FORMAT(date,format)和Oracle有区别，Oracle用TO_DATE(ch, fmt)
INSERT INTO emp_test VALUES(1001,'张无忌','Manager','10000','2000',DATE_FORMAT('2010-01-12','%y-%m-%d'),1005,10);
INSERT INTO emp_test VALUES(1002,'刘苍松','Analyst', 8000 , 1000 ,DATE_FORMAT('2011-01-12','%y-%m-%d'),1001,10);
INSERT INTO emp_test VALUES(1003, '李翊' ,'Analyst',9000 , 1000 ,DATE_FORMAT('2010-02-11','%y-%m-%d'),1001,10);
INSERT INTO emp_test VALUES(1004,'郭芙蓉','Programmer',5000, NULL ,DATE_FORMAT('2010-02-11','%y-%m-%d'),1001,10);

INSERT INTO emp_test VALUES(1005 , '张三丰' , 'President' ,15000 , NULL ,DATE_FORMAT('2008-02-15','%y-%m-%d'),NULL,20);
INSERT INTO emp_test VALUES(1006 , '燕小六' , 'Manager' ,5000 ,400 ,DATE_FORMAT('2009-02-12','%y-%m-%d') , 1005 , 20);
insert into emp_test values(1007 , '陆无双' , 'clerk' ,3000 , 500 , DATE_FORMAT('2009-02-01','%y-%m-%d') , 1006 , 20) ;
insert into emp_test values(1008 , '黄蓉' , 'Manager' ,5000 , 500 , DATE_FORMAT('2009-11-01','%y-%m-%d') , 1005 , 30) ;
insert into emp_test values(1009 , '韦小宝' , 'salesman' ,4000 , null , DATE_FORMAT('2009-05-20','%y-%m-%d') , 1008 , 30) ;
insert into emp_test values(1010 , '郭靖' , 'salesman' ,4500 , 500 , DATE_FORMAT('2009-10-10','%y-%m-%d') , 1008 , 30) ;

SELECT * FROM emp_test;
SELECT * FROM dept_test;

SELECT name,salary,salary*12 year_salary
	FROM emp_test;


#非空判断用IFNULL(expr1,expr2)和Oracle有区别，Oracle用NVL(expr1, expr2)
SELECT name,salary,bonus,salary+ IFNULL(bonus,0) month_salary
	FROM emp_test;
	INSERT INTO emp_test (emp_id,name) VALUES(1011,'于泽成');

SELECT name,IFNULL(job,'no positon') job
			FROM emp_test;

SELECT name,IFNULL(hire_date,'2016-12-12') hire_date
			FROM emp_test;

#连接字符串用CONCAT(str1,str2,...)和Oracle有区别，Oracle用||
SELECT emp_id,CONCAT(name,' job is ',job) detail
			FROM emp_test;

#复制表
CREATE TABLE emp_test2 AS SELECT * FROM emp_test;
SELECT * FROM emp_test2;

#DISTINCT
SELECT DISTINCT job FROM emp_test;
SELECT DISTINCT dept_test_id FROM emp_test;
SELECT DISTINCT job,dept_test_id FROM emp_test;

#薪水高亍 10000 元的员工数据？
SELECT * FROM emp_test WHERE salary>10000; 

#职位是 Analyst 的员工数据？SQL 语句大小写丌敏感 , 数据大小写敏感
SELECT * FROM emp_test WHERE LOWER(job)='analyst'; 

#薪水大亍 5000 并且小亍 10000 的员工数据？>=<=；between and
SELECT * FROM emp_test WHERE salary>=5000 AND salary<=10000; 
SELECT * FROM emp_test WHERE salary BETWEEN 5000 AND 10000; 

#入职时间在 2011 年的员工？
SELECT * FROM emp_test WHERE hire_date=DATE_FORMAT('2011','%y'); 
SELECT * FROM emp_test WHERE hire_date BETWEEN DATE_FORMAT('2011-01-01','%y-%m-%d') AND DATE_FORMAT('2011-12-31','%y-%m-%d') ; 

#列出职位是 Manager 或者 Analyst 的员工
SELECT * FROM emp_test WHERE job IN('Manager','Analyst');

#列出职位中包含有 sales 字符的员工数据？
SELECT * FROM emp_test WHERE LOWER(job) LIKE '%sales%'

#列出职位中第二个字符是 a 的员工数据？
SELECT * FROM emp_test WHERE LOWER(job) LIKE '_a%'

#查询数据库中有多少个名字中包含 'EMP' 的表？
#SELECT COUNT(*) FROM USER_TABLES WHERE TABLE_NAME LIKE '%EMP%';

insert into emp_test values(1012 , 'text_test' , 'salesman' ,4500 , 500 , DATE_FORMAT('2009-10-10','%y-%m-%d') , 1008 , 30) ;

SELECT * FROM emp_test;

#mysql-- 如果要查询的数据中有特殊字符( 比如_或% ),
-- 在做模糊查询时 ,
-- 需要加上\符号表示转义 , 如果是Oracle并且用 escape 短语指明转义字符\mysql不用
SELECT name FROM emp_test WHERE name LIKE '%\_%';
DELETE FROM emp_test WHERE emp_id=1012 

#查询哪些员工没有奖金？
SELECT * FROM emp_test WHERE bonus IS NULL;

#薪水丌在 5000 至 8000 的员工？
SELECT * FROM emp_test WHERE salary NOT BETWEEN 5000 AND 8000;

#丌是部门 20 和部门 30 的员工？
SELECT * FROM emp_test WHERE dept_test_id NOT IN(20,30);



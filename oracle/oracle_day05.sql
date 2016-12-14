-- 主键约束：PRIMARY KEY=不重复+不为NULL；
-- (列级约束条件) 
CREATE TABLE dept_dylan (
	dept_id NUMBER (2) PRIMARY KEY,
	dept_name VARCHAR (20),
	dept_location VARCHAR (40)
);

-- 数据准备 
INSERT INTO dept_dylan
VALUES
	(10, 'developer', 'beijing');

INSERT INTO dept_dylan
VALUES
	(10, 'market', 'shenzhen');

-- 表级约束条件:建议约束命名规则：表名_列名_约束条件的类型
CREATE TABLE dept_dylan2(
	dept_id NUMBER (2),
	dept_name VARCHAR (20),
	dept_location VARCHAR (40),
	constraint dept_dylan2_pk PRIMARY KEY (dept_id)
);
-- 数据准备 
INSERT INTO dept_dylan2
VALUES
	(10, 'developer', 'beijing');

INSERT INTO dept_dylan2
VALUES
	(10, 'market', 'shenzhen');

SELECT
	*
FROM
	dept_dylan2;

-- 非空约束( not null , 简称 NN ) ** 非空约束只能定义在列级
CREATE TABLE student_dylan (
	id NUMBER (4) PRIMARY KEY,
	NAME VARCHAR (10) NOT NULL,
	age NUMBER (3)
);

INSERT INTO student_dylan
VALUES
	(1, 'zhangwei', 20);

INSERT INTO student_dylan
VALUES
	(2, 'zhangwei', 19);

INSERT INTO student_dylan
VALUES
	(3, NULL, 19);

SELECT
	*
FROM
	student_dylan;
-- 给非空约束命名
DROP TABLE student_dylan;

CREATE TABLE student_dylan (
	id NUMBER (4) PRIMARY KEY,
	name VARCHAR (10) constraint student_dylan_name_nn NOT NULL,
	age NUMBER (3)
);


-- 视图可以使用 CREATE OR REPLACE 来创建或覆盖,并可查询视图的定义。 
CREATE
OR REPLACE VIEW v_emp_count AS SELECT
	dept_test_id,
	count(*) emp_num,
	sum(salary) sum_s,
	avg(IFNULL(salary, 0)) avg_s,
	max(salary) max_s,
	min(salary) min_s
FROM
	emp_test
GROUP BY
	dept_test_id;

SELECT
	*
FROM
	v_emp_count;

-- 索引 Index *
-- index ：用来提高查询效率的机制
--   全表扫描方式( Full Table Scan )：查询效率极低
--   索引查询：比全表扫描快
--   索引的结构：数据+地址( 如：张三+Room203 )
--   注意：对亍数据变更频繁(DML 操作频繁)的表 , 索引会影响查询性能
--   自劢创建索引：
-- 如果数据表有 PK/Unique 两种约束 , 索引自劢创建 , 除此以外 , 索引必须手劢创建
--   自定义索引语法：
--     create index 索引名 on 表名(列名) ;
-- 表的主键和唯一约束条件 , 会自动创建索引
create table student_ning7(
id INT(4),
name char(20),
email char(40),
constraint stu_n7_id_pk primary key(id),
constraint stu_n7_email_uk unique(email)
) 

create index idx_stu7_name
on student_ning7(name) ;

select * from student_ning7
where name = 'zhangsan' ;



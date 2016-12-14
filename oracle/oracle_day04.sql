-- 数据准备：创建工资等级表
CREATE TABLE salgrade_test (
	grade NUMBER (2),
	lowsal NUMBER (7, 2),
	hisal NUMBER (7, 2)
);

-- 查看工资等级表结构
DESC salgrade;

-- 查看工资等级表数据
SELECT
	*
FROM
	salgrade_test;

-- 插入数据
INSERT INTO salgrade_test
VALUES
	(1, 10001, 99999);

INSERT INTO salgrade_test
VALUES
	(2, 8001, 10000);

INSERT INTO salgrade_test
VALUES
	(3, 6001, 8000);

INSERT INTO salgrade_test
VALUES
	(4, 4001, 6000);

INSERT INTO salgrade_test
VALUES
	(5, 1, 4000);

-- 计算员工的薪水等级
SELECT
	NAME,
	salary,
	grade
FROM
	emp_test,
	salgrade_test
WHERE
	emp_test.salary BETWEEN salgrade_test.lowsal
AND salgrade_test.hisal;

-- ------------------------------------------------------
SELECT
	NAME,
	salary,
	grade
FROM
	emp_test
FULL JOIN salgrade_test ON emp_test.salary BETWEEN salgrade_test.lowsal
AND salgrade_test.hisal;

-- 复制表：只复制结构 , 不复制数据
CREATE TABLE salgrade_copy AS (
	SELECT
		*
	FROM
		salgrade_test
	WHERE
		1 <> 1
);

SELECT
	*
FROM
	salgrade_copy;

-- 复制表：复制一部分数据----通过设置别名的方式 , 指定新表中的列名(year_sal)
CREATE TABLE emp_test_copy AS (
	SELECT
		emp_id,
		NAME,
		salary * 12 year_sal
	FROM
		emp_test
	WHERE
		dept_test_id = 10
);

SELECT
	*
FROM
	emp_test_copy;

-- 复制表：复制一部分数据  -- 新表中的列名
CREATE TABLE emp_count (did, emp_num) AS (
	SELECT
		dept_test_id,
		COUNT (*)
	FROM
		emp_test
	GROUP BY
		dept_test_id
);

SELECT
	*
FROM
	emp_count;

-- 创建一个同 emp 表结构相同的空表 , 将部门号为 10 的员工信息放入该表
-- 如果有一张表 emp 的数据量为一百万条 , 此时需要建立 1 张测试表只放入少量测试数据( 如 100条 ) , 执行步骤如下所示：
-- 第 1 步  创建一个空表
CREATE TABLE emp_copy AS (
	SELECT
		*
	FROM
		emp_test
	WHERE
		1 <> 1
);

-- 第 2 步  揑入少量测试数据
INSERT INTO emp_copy (
	SELECT
		*
	FROM
		emp_test
	WHERE
		dept_test_id = 10
);

SELECT
	*
FROM
	emp_copy;

-- 把表中的数据换为部门 20 和 30 的员工记录
DELETE
FROM
	emp_copy;

INSERT INTO emp_copy (
	SELECT
		*
	FROM
		emp_test
	WHERE
		dept_test_id IN (20, 30)
);

SELECT
	*
FROM
	emp_copy;

-- 向新表中揑入指定记录数的数据,比如前 8 条 
DELETE
FROM
	emp_copy;

INSERT INTO emp_copy (
	SELECT
		*
	FROM
		emp_test
	WHERE
		ROWNUM <= 8
);

SELECT
	*
FROM
	emp_copy;

-- update( 更新数据 ) **
-- 语法结构：
-- update 表名 set 列名 = 新的列值 ,
-- 列名 = 新的列值.
-- ….
-- where 条件;
-- 注意：
--   更新( update )数据表时 , 注意条件 , 如果丌加条件 , 修改的是全部表记录
--   rollback 回退 , commit 确认
-- 将员工号为 1012 的员工薪水改为 3500 , 职位改为 Programmer
UPDATE emp_test
SET salary = 3500,
 JOB = 'Programmer'
WHERE
	emp_id = 1012;

SELECT
	*
FROM
	emp_test;

-- 部门 10 的员工薪水+1000
UPDATE emp_test
SET salary = salary + 3500
WHERE
	dept_test_id = 10;

SELECT
	*
FROM
	emp_test;

-- delete( 删除数据 ) **
-- 语法结构：
-- delete [from] 表名 where 条件 ;
-- 注意：
--   如果删除语句中丌加 where 条件 , 将删掉表中的全部记录
--   rollback 回退 , commit 确认
--   drop table 会删除表结构和数据 ;truncate 删除表数据 , 保留表结构。Drop 和 truncate 都
-- 不可以回退。 delete 仅删除数据 , 可以回退
-- 创建表 emp_bak2 , 只存放不重复的记录
CREATE TABLE emp_copy2 AS (
	SELECT
		*
	FROM
		emp_test
	WHERE
		1 <> 1
);

-- 如下语句执行 3 遍 , 揑入 3 条重复数据
INSERT INTO emp_copy2 (emp_id, NAME, salary)
VALUES
	(1015, 'amy', 4000);

-- 如下语句执行 2 遍 , 揑入 2 条重复数据
INSERT INTO emp_copy2 (emp_id, NAME, salary)
VALUES
	(1016, 'rory', 5000);

-- 如下语句执行 1 遍 , 揑入 1 条数据
INSERT INTO emp_copy2 (emp_id, NAME, salary)
VALUES
	(1017, 'river', 6000);

SELECT
	*
FROM
	emp_copy2;

-- 创建表 emp_copy3 , 只存放不重复的记录 , 利用 distinct 关键字
CREATE TABLE emp_copy3 AS SELECT DISTINCT
	*
FROM
	emp_copy2;

SELECT
	*
FROM
	emp_copy3;

-- -- 将表改名语法区别：Oracle:RENAME  tablename TO newtablename;; mysql：RENAME TABLE tablename TO newtablename;
-- 把 emp_copy3 改名为 emp_bak4
RENAME emp_copy3 TO emp_bak4;

-- 把 emp_bak4 改名为 emp_copy3
RENAME emp_bak4 TO emp_copy3;

--删除重复数据
DELETE
FROM
	emp_copy2
WHERE
	ROWID NOT IN (
		SELECT
			MAX (ROWID)
		FROM
			emp_copy2
		GROUP BY
			emp_id,
			NAME,
			salary
	);

--子查询：查询出 empno , ename , salary 相同的 rowid 最大的记录
--主查询：删除 rowid 不在子查询之列的重复数据
-- Transaction( 事务 ) **
-- 1)  事务是一组 DML 操作的逻辑单元 , 用来保证数据的一致性。
-- 2)  在一个事务内 , 组成事务的这组 DML 操作 , 或者一起成功提交 , 或者一起被撤销。
-- 3)  事务控制语言 TCL( Transaction Control Language )
--   commit 事务提交 将所有的数据改劢提交
--   rollback 事务回滚 回退到事务之初 , 数据的状态和事务开始之前完全一
-- 致
--   savepoint  事务保存点( 较丌常用 )
-- 3.1. 事务的开始和终止( 事务边界 )
-- 1)  事务开始
-- 事务开始于上一个事务的终止或者第一条 DML 语句
-- 2)  事务终止
--   事务终止于 commit/rollback 显式操作( 即控制台输入 commit/rollback )
--   如果连接关闭 , 事务( Transaction )将隐式提交
--   DDL 操作( 比如 create ) , 事务将隐式提交
--   如果出现异常 , 事务将隐式回滚
-- 1)  事务内部的数据改变只有在自己的会话中能够看到
-- 2)  事务会对操作的数据加锁 , 丌允许其它事务操作
-- 3)  如果提交( commit )后 , 数据的改变被确认 , 则
--   所有的会话都能看到被改变的结果 ;
--   数据上的锁被释放 ;
--   保存数据的临时空间被释放
-- 4)  如果回滚( rollback ) , 则
--   数据的改变被取消 ;
--   数据上的锁被释放 ;
--   临时空间被释放
SELECT
	*
FROM
	emp_copy3;

UPDATE emp_copy3
SET emp_id = 1015
WHERE
	emp_id = 1014;

CREATE TABLE mytemp_test (ID NUMBER(4));

INSERT INTO mytemp_test
VALUES
	(3);

SAVEPOINT A;

-- 设置保存点 , 名为 A
INSERT INTO mytemp_test
VALUES
	(4);

SAVEPOINT B;

-- 设置保存点 , 名为 B
INSERT INTO mytemp_test
VALUES
	(5);

ROLLBACK TO A;

-- 回滚到保存点 A , 注意：A 之后的保存点全部被取消


SELECT
	*
FROM
	mytemp_test;
-- 3 被揑入数据库,
-- 4、5 没有被揑入

-- truncate 保留表结构 , 删除表中所有数据truncate 操作丌需提交( commit ) , 没有回退( rollback )的机会
-- 语法结构： truncate table 表名 ;
TRUNCATE TABLE mytemp_test;

-- 增加列( 只能增加在最后一列 )
ALTER TABLE mytemp_test ADD(name VARCHAR(10));
ALTER TABLE mytemp_test ADD(password VARCHAR(10));

-- 修改列名 password 为 pwd 和MySql有区别：
-- Oracle:ALTER TABLE table_name RENAME COLUMN old_column_name  TO new_column_name ;
-- Mysql:ALTER TABLE table_name CHANGE COLUMN old_column_name  new_column_name typedefinition;
ALTER TABLE mytemp_test RENAME COLUMN password  TO pwd;

-- 修改列的数据类型为 pwd char(8)
-- MySQL:alter table 表名 modify column 字段名 类型;
-- Oracle:alter table 表名 modify (字段名 类型);
ALTER TABLE mytemp_test MODIFY(pwd VARCHAR(8)) ;

-- 删除列 pwd
ALTER TABLE mytemp_test DROP COLUMN pwd ;
DESC mytemp_test;
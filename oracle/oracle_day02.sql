--函数

--查看员工表数据
SELECT * FROM emp_test;

--查看部门表数据
SELECT * FROM dept_test;


--round( 数字 , 小数点后的位数 )用于数字的四舍五入
--计算金额的四舍五入 
--注意：Oracle中别名用双引号"原样输出"，mysql可以用单引号
SELECT salary*0.1234567 "原样输出",ROUND(salary*0.1234567) "默认零位小数", ROUND(salary*0.1234567,2) "保留两位小数" FROM emp_test;

--trunc( 数字 , 小数点后的位数 )用于截取如果没有第二个参数 , 默认是 0
--计算金额 , 末尾不做四舍五入
--注意：Oracle中截取用关键字TRUNC，MySql用TRUNCATE
SELECT salary*0.1234567 "原样输出",TRUNC(salary*0.1234567,2) "直接截取留两位小数"  FROM emp_test;


--计算员工入职多少天?
--计算时间差Oracle用(expr1,expr2)DAYS,mysql用函数DATEDIFF(expr1,expr2),
SELECT name,hire_date,(SYSDATE-hire_date)DAYS FROM emp_test;

--计算员工入职多少个月？
--mysql用TIMESTAMPDIFF(unit,datetime_expr1,datetime_expr2),Oracle用MONTHS_BETWEEN(date1, date2)
SELECT name, ROUND(MONTHS_BETWEEN(SYSDATE,hire_date)) FROM emp_test;

--计算 12 个月之前的时间点
--Oracle (date, int) *计算 12 个月之前的时间点,Myusql用DATE_ADD(date,INTERVAL expr unit)
SELECT ADD_MONTHS(SYSDATE,-12) FROM DUAL;

--计算本月最后一天
SELECT LAST_DAY(SYSDATE) FROM DUAL;


--把时间数据按指定格式输出
SELECT to_char(SYSDATE , 'yyyy-mm-dd  hh24:mi:ss') from DUAL;

--插入一条数据 , 编号为 1012 , 姓名为 amy , 入职时间为当前系统时间
INSERT INTO emp_test(emp_id,name,hire_date) VALUES (1012,'amy',SYSDATE); 
SELECT * FROM emp_test;

--插入一条数据 , 编号为 1012 , 姓名为 amy , 入职时间为 2011 年 10 月 10 日
INSERT INTO emp_test(emp_id,name,hire_date) VALUES (1012,'amy',TO_DATE('2011-10-10','yyyy-mm-dd')); 
SELECT * FROM emp_test;

--按指定格式显示员工姓名和入职时间 , 显示格式为： amy 2011-10-10
SELECT name,TO_CHAR(hire_date,'yyyy-mm-dd') FROM emp_test;

--计算员工的年终奖金
--要求：
--1)  如果 bonus 不是 null , 发年终奖金额为 bonus
--2)  如果 bonus 是 null , 发年终奖金额为 salary * 0.5
--3)  如果 bonus 和 salary 都是 null, 发 100 元安慰一下
--coalesce( 参数列表 )函数的作用：返回参数列表中第一个非空参数 , 参数列表中最后一个值通常为常量
SELECT COALESCE(bonus,salary*0.5,100) FROM emp_test;

--根据员工的职位 , 计算加薪后的薪水数据
--要求：
--1)  如果职位是 Analyst：加薪 10%
--2)  如果职位是 Programmer：加薪 5%
--3)  如果职位是 clerk：加薪 2%
--4)  其他职位：薪水丌变
SELECT name,job,salary ,
			CASE job WHEN 'Analyst' THEN  salary*1.1
						 	 WHEN 'Programmer' THEN  salary*1.05
						 	 WHEN 'clerk' THEN  salary*1.02
							 ELSE salary
			END new_salary
			FROM emp_test;
--decode()函数是Oracle 中等价于 case when 语句的函数 , 作用同 case 语句相同。
--decode 函数语法如下：
--decode(判断条件 , 匹配 1 , 值 1 , 匹配 2 , 值 2 , … , 默认值)
--表达的意思是：如果判断条件 = 匹配 1 , 则迒回值 1
--判断条件 = 匹配 2 , 则迒回值 2
--根据员工的职位 , 计算加薪后的薪水数据
--要求：和 case 语句相同
--1)  如果职位是 Analyst：加薪 10%
--2)  如果职位是 Programmer：加薪 5%
--3)  如果职位是 clerk：加薪 2%
--4)  其他职位：薪水丌变
SELECT name,job,salary ,
			DECODE(job,'Analyst',salary*1.1,'Programmer',salary*1.05,'clerk',salary*1.02,salary) new_salary
			FROM emp_test;

--薪水由低到高排序( 升序排列 )
SELECT name,salary FROM emp_test ORDER BY salary ASC;

--薪水由高到低排序( 降序排列 )
SELECT name,salary FROM emp_test ORDER BY salary DESC;

--按入职时间排序 , 入职时间越早排在前面
SELECT name,hire_date FROM emp_test ORDER BY hire_date ASC;

--按部门排序 , 同一部门按薪水由高到低排序
SELECT name,dept_test_id,salary FROM emp_test ORDER BY dept_test_id,salary;

--员工表中有多少条记录？
SELECT COUNT(*) FROM emp_test;

--当前帐户( openlab )下有多少个表？
select count(*) from user_tables

--入职时间不是 null 的数据总数
SELECT COUNT(hire_date) FROM emp_test WHERE hire_date IS NOT NULL;


--计算员工的薪水总和是多少？
SELECT SUM(salary) FROM emp_test;

--计算员工的人数总和、薪水总和、平均薪水是多少？
SELECT COUNT(*), SUM(salary),AVG(salary) FROM emp_test;

--薪水平均值 = 薪水总和 / 人数总和 avg(salary) = sum(salary) / count(*)
--而 avg(salary)叧按有薪水的员工人数计算平均值。这样得到的数据丌够准确。
SELECT COUNT(*), SUM(salary),AVG(NVL(salary,0)) FROM emp_test;

--计算员工的最高薪水和最低薪水
SELECT max(salary),min(salary) FROM emp_test;

--组函数：
   --count / avg / sum / max / min 如果函数中写列名 , 默认忽略空值
 -- avg / sum 针对数字的操作
 -- max / min 对所有数据类型都可以操作


--按部门计算每个部门的最高和最低薪水分别是多少？
SELECT dept_test_id,max(salary),min(salary) FROM emp_test GROUP BY dept_test_id;

--计算每个部门的 薪水总和 和 平均薪水？
SELECT dept_test_id,SUM(salary),AVG(NVL(salary,0)) FROM emp_test GROUP BY dept_test_id;

--每个部门的统计信息：
--要求格式如下：
--deptno max_s min_s sum_s avg_s emp_num
--10 10000 5000 23000 6789 3
SELECT dept_test_id deptno,
				max(salary) max_s,
				min(salary) min_s,
				SUM(salary) sum_s,
				AVG(NVL(salary,0)) avg_s, 
				COUNT(*) emp_num
FROM emp_test GROUP BY dept_test_id;

--按职位分组 , 每个职位的最高、最低薪水和人数？
SELECT MAX(salary),MIN(salary),COUNT(*) emp_num FROM emp_test GROUP BY job order by emp_num;

SELECT dept_test_id, AVG(NVL(salary,0)) avg_salary  FROM emp_test WHERE dept_test_id IS NOT NULL  GROUP BY dept_test_id HAVING AVG(NVL(salary,0))>5000;

--薪水总和大于 20000 元的部门数据？
SELECT dept_test_id, SUM(salary) FROM emp_test WHERE dept_test_id IS NOT NULL GROUP BY dept_test_id HAVING SUM(salary)> 20000;

--哪些职位的人数超过 2 个人？
SELECT job,COUNT(*) FROM emp_test GROUP BY job HAVING COUNT(*)>2;


--查询最高薪水的是谁？
SELECT * FROM emp_test WHERE salary=(SELECT MAX(salary) FROM emp_test);



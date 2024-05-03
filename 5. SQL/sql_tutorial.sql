CREATE TABLE `employee` (
	`emp_id` INT PRIMARY KEY,
	`name` VARCHAR(20),
	`birth_date` DATE,
	`sex` VARCHAR(1),
	`salary` INT,
	`branch_id` INT,
	`sup_id` INT
);

CREATE TABlE `branch`(
	`branch_id` INT PRIMARY KEY,
	`branch_name` VARCHAR(20),
	`manager_id` INT,
	FOREIGN KEY (`manager_id`) REFERENCES `employee`(`emp_id`) ON DELETE SET NULL
);

ALTER TABLE `employee`
ADD FOREIGN KEY(`branch_id`)
REFERENCES `branch`(`branch_id`)
ON DELETE SET NULL;

ALTER TABLE `employee`
ADD FOREIGN KEY(`sup_id`)
REFERENCES `employee`(`emp_id`)
ON DELETE SET NULL;

CREATE TABLE `client`(
`client_id` INT PRIMARY KEY,
`client_name` VARCHAR(20),
`phone` VARCHAR(20)
);

CREATE TABlE `work_with`(
`emp_id` INT,
`client_id` INT,
`total_sales` INT,
FOREIGN KEY (`emp_id`) REFERENCES `employee`(`emp_id`) ON DELETE CASCADE,
FOREIGN KEY (`client_id`) REFERENCES `client`(`client_id`) ON DELETE CASCADE
);

INSERT INTO `branch` VALUES(1,'RD',NULL);
INSERT INTO `branch` VALUES(2,'OP',NULL);
INSERT INTO `branch` VALUES(3,'IT',NULL);
SELECT * FROM `branch`;
DROP TABLE `branch`;


INSERT INTO `employee` VALUES(206,'小黃','1998-10-08','F',50000,1,NULL);
INSERT INTO `employee` VALUES(207,'小綠','1985-09-16','M',29000,2,207);
INSERT INTO `employee` VALUES(208,'小黑','2000-12-19','M',35000,3,206);
INSERT INTO `employee` VALUES(209,'小白','1997-01-22','F',39000,3,207);
INSERT INTO `employee` VALUES(210,'小藍','1925-11-10','F',84000,1,207);
SELECT * FROM `employee`;

UPDATE `branch`
SET `manager_id` = 208
WHERE `branch_id` = 3;

INSERT INTO `client` VALUES(400,'阿狗','254354335');
INSERT INTO `client` VALUES(401,'阿貓','25633899');
INSERT INTO `client` VALUES(402,'旺來','45354345');
INSERT INTO `client` VALUES(403,'露西','54354365');
INSERT INTO `client` VALUES(404,'艾瑞克','18783783');

INSERT INTO `work_with` VALUES(206,400,'70000');
INSERT INTO `work_with` VALUES(207,401,'24000');
INSERT INTO `work_with` VALUES(208,402,'9800');
INSERT INTO `work_with` VALUES(208,403,'24000');
INSERT INTO `work_with` VALUES(210,404,'87940');

SELECT * FROM `work_with`;

-- 取得所有員工資料
select * from employee;
-- 取得所有客戶資料
select * from client;
-- 按薪水低到高取得員工資料
select * from employee
order by salary ASC;
-- 薪水前三高的員工
select * from employee
order by salary DESC
limit 3;
-- 取得所有員工的名字
select distinct name from employee;

--取得員工人數
select count(*) from employee;
--取得出生於某年之後的女生
select count(*) from employee 
where birth_date > '1970-01-01' and sex = 'F';
--取得平均薪水
select avg(salary) from employee;
--取得薪水總和
select sum(salary) from employee;
--取得薪水上下限
select min(salary) from employee;
select max(salary) from employee;

--取得電話尾數335
select *
from client
where phone like '%335';
--取得姓艾的客戶
select * from client
where client_name like '艾%';
--取得生日在12月的員工
select * from employee where birth_date like '_____12%';

-- union
select `name` 
from `employee`
union
select `client_name` 
from `client`
union
select `branch_name`
from `branch`;
-- 員工id+員工名字 union 客戶id+客戶名字
select emp_id as total_id, name as totalname 
from employee
union
select client_id, client_name 
from client;
-- 員工薪水加銷售金額
select salary
from employee
union
select total_sales
from work_with;



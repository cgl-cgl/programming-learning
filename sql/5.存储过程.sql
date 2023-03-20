/*存储过程和函数的参数有三类，分别是IN、OUT、INOUT，其中：
IN是入参，一个IN参数将一个值传递给一个过程，存储过程可能会修改这个值，当存储过程返回时，调用者不会看到这个修改；
OUT是出参；
INOUT由调用者初始化修改，可以被存储过程修改，当存储过程返回时，调用者可以看到存储过程的任何改变
*/

-- 简单存储过程示例：给定一个商品类别，查看该商品类别数量的情况

delimiter //
drop PROCEDURE if EXISTS producttype //
create PROCEDURE producttype(IN product_type_ VARCHAR(20), OUT type_num INT)
BEGIN
	SELECT COUNT(*) INTO type_num
	FROM shop.product
	WHERE product_type = product_type_;
END//
delimiter;

call producttype('厨房用具', @product_type_num);
select @product_type_num;


PREPARE stmt1 FROM 
	'SELECT 
   	    product_id, 
            product_name 
	FROM product
        WHERE product_id = ?';
SET @pcid = '0005';
EXECUTE stmt1 USING @pcid;
DEALLOCATE PREPARE stmt1;


-- 练习题
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_multi_table`()
BEGIN
    #Routine body goes here...
    declare i int;
    set i=1;
    while i<21 do
        IF i<10 THEN
            set @tb = CONCAT('create table table0',i,' like product');
        ELSE
            set @tb = CONCAT('create table table', i,' like product');
        END IF;
        PREPARE create_stmt FROM @tb;
        EXECUTE create_stmt;
        SET i=i+1;
    end while;

END;
call `create_multi_table`();
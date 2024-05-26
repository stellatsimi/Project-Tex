DROP DATABASE IF EXISTS simple;
CREATE DATABASE IF NOT EXISTS simple;
USE simple;

CREATE TABLE user(
	user_id int AUTO_INCREMENT,
	password VARCHAR(100) UNIQUE,
    rights ENUM('employee', 'owner'),
    name VARCHAR(20),
    surname VARCHAR(20),
    
    PRIMARY KEY(user_id)
);

CREATE TABLE owner(
	owner_id int UNIQUE,
	ownershipPercentage float,
    
    PRIMARY KEY(owner_id),
    CONSTRAINT FK_owner_id FOREIGN KEY(owner_id) REFERENCES user(user_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE employee(
	employee_id int UNIQUE,
    afm long,
    phone long,
    address VARCHAR(100),
    salary float,
    
    PRIMARY KEY(employee_id),
    CONSTRAINT FK_employee_id FOREIGN KEY(employee_id) REFERENCES user(user_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE product_Storage(
	prod_id int AUTO_INCREMENT,
    prod_stor_name VARCHAR(100) UNIQUE,
    prod_stor_barcode BIGINT,
    prod_stor_fpa int,
    prod_stor_quantity float,
    prod_stor_quantity_type enum('τεμάχια', 'κουτιά', 'εξάδες', 'κιλά', 'πακέτα', 'γραμμάρια', 'λίτρα'),
	prod_stor_price float,
    
    PRIMARY KEY(prod_id)
);

CREATE TABLE supplier(
	supplier_id int AUTO_INCREMENT,
	supplier_name VARCHAR(50),
    supplier_phone BIGINT,
    supplier_afm BIGINT UNIQUE,
    supplier_email VARCHAR(100),
    supplier_address VARCHAR(100),
    
    PRIMARY KEY(supplier_id)
);

CREATE TABLE invoice(
	invoice_id INT auto_increment,
    inv_supplier_id INT,
    payment_type enum('cash','card'),
    total float,
    date timestamp,
    
    PRIMARY KEY(invoice_id),
    CONSTRAINT FK_inv_supplier_id FOREIGN KEY(inv_supplier_id) REFERENCES supplier(supplier_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE product_Invoice(
	prod_inv_name VARCHAR(200),
	prod_inv_id int,
    prod_inv_fpa int,
    prod_inv_buy_price float,
    prod_inv_quantity int,
    prod_inv_quantity_type enum('τεμάχια', 'κουτιά', 'εξάδες', 'κιλά', 'πακέτα', 'γραμμάρια', 'λίτρα'),
    
    PRIMARY KEY(prod_inv_name, prod_inv_id),
    CONSTRAINT FK_prod_inv_id FOREIGN KEY(prod_inv_id) REFERENCES invoice(invoice_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE customer(
	email VARCHAR(100) UNIQUE,
    points INT,
    voucher_count int,
    
    PRIMARY KEY(email)
);

CREATE TABLE receipt(
	receipt_id INT auto_increment,
    date timestamp,
    sum float,
    res_employee_id int,
    customer_email VARCHAR(100),
    receipt_points int,
    voucher int,
    
    PRIMARY KEY(receipt_id),
    CONSTRAINT FK_costumer_email FOREIGN KEY(customer_email) REFERENCES customer(email)
    ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT FK_res_employee_id FOREIGN KEY(res_employee_id) REFERENCES employee(employee_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE product_Receipt(
	prod_rec_name VARCHAR(200),
    prod_rec_id int,
    prod_rec_quantity int,
    prod_rec_quantity_type enum('τεμάχια', 'κουτιά', 'εξάδες', 'κιλά', 'πακέτα', 'γραμμάρια', 'λίτρα'),
    
    PRIMARY KEY(prod_rec_name, prod_rec_id)
    -- CONSTRAINT FK_prod_rec_id FOREIGN KEY(prod_rec_id) REFERENCES receipt(receipt_id)
    -- ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE orders(
	order_id INT auto_increment,
    order_supplier_id int,
    
    PRIMARY KEY(order_id),
    CONSTRAINT FK_order_supplier_id FOREIGN KEY(order_supplier_id) REFERENCES supplier(supplier_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE product_Order(
	prod_order_name VARCHAR(200),
    prod_order_id int,
    prod_order_quantity int,
    quantity_type enum('τεμάχια', 'κουτιά', 'εξάδες', 'κιλά', 'πακέτα', 'γραμμάρια', 'λίτρα'),
    
    PRIMARY KEY(prod_order_name, prod_order_id),
    CONSTRAINT FK_prod_order_id FOREIGN KEY(prod_order_id) REFERENCES orders(order_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE search_results(
	prod_results_name VARCHAR(200),
    prod_price_1 float,
    prod_price_2 float,
    
    PRIMARY KEY(prod_results_name),
    CONSTRAINT FK_prod_results_name FOREIGN KEY(prod_results_name) REFERENCES product_Storage(prod_stor_name)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE product_search(
	prod_search_name VARCHAR(200),
    
    PRIMARY KEY(prod_search_name)
);

CREATE TABLE Z(
	z_id int AUTO_INCREMENT,
	z_date DATETIME,
    z_total_6 float,
    z_total_13 float,
    z_total_24 float,
	z_total float,
    
    PRIMARY KEY(z_id)
);

CREATE TABLE scanner(
	device_name VARCHAR(200),
    status enum('Success','Fail'),
    current_barcode BIGINT,
    
    PRIMARY KEY(device_name)
);

CREATE TABLE log_insert(
	log_ins_id int AUTO_INCREMENT,
    log_ins_action CHAR(20),
    log_ins_table CHAR(20),
    log_ins_new_record TEXT,
    log_ins_change_time timestamp DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY(log_ins_id)
);

CREATE TABLE log_update(
	log_up_id int AUTO_INCREMENT,
	log_up_action CHAR(20),
	log_up_table CHAR(20),
    log_up_col_name VARCHAR(200),
    log_up_pk_value VARCHAR(100),
    log_up_old_value VARCHAR(30),
    log_up_new_value VARCHAR(30),
    log_up_change_time timestamp DEFAULT CURRENT_TIMESTAMP,

	PRIMARY KEY(log_up_id)
);

CREATE TABLE log_delete(
	log_del_id int AUTO_INCREMENT,
    log_del_action CHAR(20),
    log_del_table CHAR(20),
    log_del_value TEXT,
    log_del_change_time timestamp DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY(log_del_id)
);

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TRIGGERS FOR UPDATE
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DROP TRIGGER IF EXISTS user_update;
DELIMITER $$
CREATE TRIGGER user_update
AFTER UPDATE
ON user
FOR EACH ROW
BEGIN
	IF OLD.password <> NEW.password THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'user', 'password', OLD.user_id, OLD.password, NEW.password, NOW());
	END IF;
    IF OLD.rights <> NEW.rights THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'user', 'rights', OLD.user_id, OLD.rights, NEW.rights, NOW());
	END IF;
    IF OLD.name <> NEW.name THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'user', 'name', OLD.user_id, OLD.name, NEW.name, NOW());
	END IF;
    IF OLD.surname <> NEW.surname THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'user', 'surname', OLD.user_id, OLD.surname, NEW.surname, NOW());
	END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS owner_update;
DELIMITER $$
CREATE TRIGGER owner_update
AFTER UPDATE
ON owner
FOR EACH ROW
BEGIN
	IF OLD.ownershipPercentage <> NEW.ownershipPercentage THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'owner', 'ownershipPercentage', OLD.owner_id, OLD.ownershipPercentage, NEW.ownershipPercentage, NOW());
	END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS employee_update;
DELIMITER $$
CREATE TRIGGER employee_update
AFTER UPDATE
ON employee
FOR EACH ROW
BEGIN
	IF OLD.afm <> NEW.afm THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'employee', 'afm', OLD.employee_id, OLD.afm, NEW.afm, NOW());
	END IF;
    IF OLD.phone <> NEW.phone THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'employee', 'phone', OLD.employee_id, OLD.phone, NEW.phone, NOW());
	END IF;
    IF OLD.address <> NEW.address THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'employee', 'address', OLD.employee_id, OLD.address, NEW.address, NOW());
	END IF;
    IF OLD.salary <> NEW.salary THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'employee', 'salary', OLD.employee_id, OLD.salary, NEW.salary, NOW());
	END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS product_Storage_update;
DELIMITER $$
CREATE TRIGGER product_Storage_update
AFTER UPDATE
ON product_Storage
FOR EACH ROW
BEGIN
	IF OLD.prod_stor_name <> NEW.prod_stor_name THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'product_Storage', 'prod_stor_name', OLD.prod_id, OLD.prod_stor_name, NEW.prod_stor_name, NOW());
	END IF;
    IF OLD.prod_stor_barcode <> NEW.prod_stor_barcode THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'product_Storage', 'prod_stor_barcode', OLD.prod_id, OLD.prod_stor_barcode, NEW.prod_stor_barcode, NOW());
	END IF;
    IF OLD.prod_stor_fpa <> NEW.prod_stor_fpa THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'product_Storage', 'prod_stor_fpa', OLD.prod_id, OLD.prod_stor_fpa, NEW.prod_stor_fpa, NOW());
	END IF;
    IF OLD.prod_stor_quantity <> NEW.prod_stor_quantity THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'product_Storage', 'prod_stor_quantity', OLD.prod_id, OLD.prod_stor_quantity, NEW.prod_stor_quantity, NOW());
	END IF;
    IF OLD.prod_stor_quantity_type <> NEW.prod_stor_quantity_type THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'product_Storage', 'prod_stor_quantity_type', OLD.prod_id, OLD.prod_stor_quantity_type, NEW.prod_stor_quantity_type, NOW());
	END IF;
    IF OLD.prod_stor_price <> NEW.prod_stor_price THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'product_Storage', 'prod_stor_price', OLD.prod_id, OLD.prod_stor_price, NEW.prod_stor_price, NOW());
	END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS supplier_update;
DELIMITER $$
CREATE TRIGGER supplier_update
AFTER UPDATE
ON supplier
FOR EACH ROW
BEGIN
	IF OLD.supplier_name <> NEW.supplier_name THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'supplier', 'supplier_name', OLD.supplier_id, OLD.supplier_name, NEW.supplier_name, NOW());
	END IF;
    IF OLD.supplier_phone <> NEW.supplier_phone THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'supplier', 'supplier_phone', OLD.supplier_id, OLD.supplier_phone, NEW.supplier_phone, NOW());
	END IF;
    IF OLD.supplier_afm <> NEW.supplier_afm THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'supplier', 'supplier_afm', OLD.supplier_id, OLD.supplier_afm, NEW.supplier_afm, NOW());
	END IF;
    IF OLD.supplier_email <> NEW.supplier_email THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'supplier', 'supplier_email', OLD.supplier_id, OLD.supplier_email, NEW.supplier_email, NOW());
	END IF;
    IF OLD.supplier_address <> NEW.supplier_address THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'supplier', 'supplier_address', OLD.supplier_id, OLD.supplier_address, NEW.supplier_address, NOW());
	END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS invoice_update;
DELIMITER $$
CREATE TRIGGER invoice_update
AFTER UPDATE
ON invoice
FOR EACH ROW
BEGIN
	IF OLD.inv_supplier_id <> NEW.inv_supplier_id THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'invoice', 'inv_supplier_id', OLD.invoice_id, OLD.inv_supplier_id, NEW.inv_supplier_id, NOW());
	END IF;
    IF OLD.payment_type <> NEW.payment_type THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'invoice', 'payment_type', OLD.invoice_id, OLD.payment_type, NEW.payment_type, NOW());
	END IF;
    IF OLD.total <> NEW.total THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'invoice', 'total', OLD.invoice_id, OLD.total, NEW.total, NOW());
	END IF;
    IF OLD.date <> NEW.date THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'invoice', 'date', OLD.invoice_id, OLD.date, NEW.date, NOW());
	END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS product_Invoice_update;
DELIMITER $$
CREATE TRIGGER product_Invoice_update
AFTER UPDATE
ON product_Invoice
FOR EACH ROW
BEGIN
	IF OLD.prod_inv_name <> NEW.prod_inv_name THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'product_Invoice', 'prod_inv_name', CONCAT(OLD.prod_inv_name, ', ', OLD.prod_inv_id), OLD.prod_inv_name, NEW.prod_inv_name, NOW());
	END IF;
    IF OLD.prod_inv_id <> NEW.prod_inv_id THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'product_Invoice', 'prod_inv_id', CONCAT(OLD.prod_inv_name, ', ', OLD.prod_inv_id), OLD.prod_inv_id, NEW.prod_inv_id, NOW());
	END IF;
    IF OLD.prod_inv_fpa <> NEW.prod_inv_fpa THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'product_Invoice', 'prod_inv_fpa', CONCAT(OLD.prod_inv_name, ', ', OLD.prod_inv_id), OLD.prod_inv_fpa, NEW.prod_inv_fpa, NOW());
	END IF;
    IF OLD.prod_inv_buy_price <> NEW.prod_inv_buy_price THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'product_Invoice', 'prod_inv_buy_price', CONCAT(OLD.prod_inv_name, ', ', OLD.prod_inv_id), OLD.prod_inv_buy_price, NEW.prod_inv_buy_price, NOW());
	END IF;
    IF OLD.prod_inv_quantity <> NEW.prod_inv_quantity THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'product_Invoice', 'prod_inv_quantity', CONCAT(OLD.prod_inv_name, ', ', OLD.prod_inv_id), OLD.prod_inv_quantity, NEW.prod_inv_quantity, NOW());
	END IF;
    IF OLD.prod_inv_quantity_type <> NEW.prod_inv_quantity_type THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'product_Invoice', 'prod_inv_quantity_type', CONCAT(OLD.prod_inv_name, ', ', OLD.prod_inv_id), OLD.prod_inv_quantity_type, NEW.prod_inv_quantity_type, NOW());
	END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS customer_update;
DELIMITER $$
CREATE TRIGGER customer_update
AFTER UPDATE
ON customer
FOR EACH ROW
BEGIN
	IF OLD.email <> NEW.email THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'customer', 'email', OLD.email, OLD.email, NEW.email, NOW());
	END IF;
    IF OLD.points <> NEW.points THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'customer', 'points', OLD.email, OLD.points, NEW.points, NOW());
	END IF;
    IF OLD.voucher_count <> NEW.voucher_count THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'customer', 'voucher_count', OLD.email, OLD.voucher_count, NEW.voucher_count, NOW());
	END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS receipt_update;
DELIMITER $$
CREATE TRIGGER receipt_update
AFTER UPDATE
ON receipt
FOR EACH ROW
BEGIN
	IF OLD.date <> NEW.date THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'receipt', 'date', OLD.receipt_id, OLD.date, NEW.date, NOW());
	END IF;
    IF OLD.sum <> NEW.sum THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'receipt', 'sum', OLD.receipt_id, OLD.sum, NEW.sum, NOW());
	END IF;
    IF OLD.res_employee_id <> NEW.res_employee_id THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'receipt', 'res_employee_id', OLD.receipt_id, OLD.res_employee_id, NEW.res_employee_id, NOW());
	END IF;
    IF OLD.customer_email <> NEW.customer_email THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'receipt', 'customer_email', OLD.receipt_id, OLD.customer_email, NEW.customer_email, NOW());
	END IF;
    IF OLD.receipt_points <> NEW.receipt_points THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'receipt', 'receipt_points', OLD.receipt_id, OLD.receipt_points, NEW.receipt_points, NOW());
	END IF;
    IF OLD.voucher <> NEW.voucher THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'receipt', 'voucher', OLD.receipt_id, OLD.voucher, NEW.voucher, NOW());
	END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS product_Receipt_update;
DELIMITER $$
CREATE TRIGGER product_Receipt_update
AFTER UPDATE
ON product_Receipt
FOR EACH ROW
BEGIN
	IF OLD.prod_rec_name <> NEW.prod_rec_name THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'product_Receipt', 'prod_rec_name', CONCAT(OLD.prod_rec_name, ', ', OLD.prod_rec_id), OLD.prod_rec_name, NEW.prod_rec_name, NOW());
	END IF;
    IF OLD.prod_rec_id <> NEW.prod_rec_id THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'product_Receipt', 'prod_rec_id', CONCAT(OLD.prod_rec_name, ', ', OLD.prod_rec_id), OLD.prod_rec_id, NEW.prod_rec_id, NOW());
	END IF;
    IF OLD.prod_rec_quantity <> NEW.prod_rec_quantity THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'product_Receipt', 'prod_rec_quantity', CONCAT(OLD.prod_rec_name, ', ', OLD.prod_rec_id), OLD.prod_rec_quantity, NEW.prod_rec_quantity, NOW());
	END IF;
    IF OLD.prod_rec_quantity_type <> NEW.prod_rec_quantity_type THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'product_Receipt', 'prod_rec_quantity_type', CONCAT(OLD.prod_rec_name, ', ', OLD.prod_rec_id), OLD.prod_rec_quantity_type, NEW.prod_rec_quantity_type, NOW());
	END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS orders_update;
DELIMITER $$
CREATE TRIGGER orders_update
AFTER UPDATE
ON orders
FOR EACH ROW
BEGIN
	IF OLD.order_supplier_id <> NEW.order_supplier_id THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'orders', 'order_supplier_id', OLD.order_id, OLD.order_supplier_id, NEW.order_supplier_id, NOW());
	END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS product_Order_update;
DELIMITER $$
CREATE TRIGGER product_Order_update
AFTER UPDATE
ON product_Order
FOR EACH ROW
BEGIN
	IF OLD.prod_order_name <> NEW.prod_order_name THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'product_Order', 'prod_order_name', CONCAT(OLD.prod_order_name, ', ', OLD.prod_order_id), OLD.prod_order_name, NEW.prod_order_name, NOW());
	END IF;
    IF OLD.prod_order_id <> NEW.prod_order_id THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'product_Order', 'prod_order_id', CONCAT(OLD.prod_order_name, ', ', OLD.prod_order_id), OLD.prod_order_id, NEW.prod_order_id, NOW());
	END IF;
    IF OLD.prod_order_quantity <> NEW.prod_order_quantity THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'product_Order', 'prod_order_quantity', CONCAT(OLD.prod_order_name, ', ', OLD.prod_order_id), OLD.prod_order_quantity, NEW.prod_order_quantity, NOW());
	END IF;
    IF OLD.quantity_type <> NEW.quantity_type THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'product_Order', 'quantity_type', CONCAT(OLD.prod_order_name, ', ', OLD.prod_order_id), OLD.quantity_type, NEW.quantity_type, NOW());
	END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS Z_update;
DELIMITER $$
CREATE TRIGGER Z_update
AFTER UPDATE
ON Z
FOR EACH ROW
BEGIN
	IF OLD.z_date <> NEW.z_date THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'Z', 'z_date', OLD.z_id, OLD.z_date, NEW.z_date, NOW());
	END IF;
    IF OLD.z_total_6 <> NEW.z_total_6 THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'Z', 'z_total_6', OLD.z_id, OLD.z_total_6, NEW.z_total_6, NOW());
	END IF;
    IF OLD.z_total_13 <> NEW.z_total_13 THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'Z', 'z_total_13', OLD.z_id, OLD.z_total_13, NEW.z_total_13, NOW());
	END IF;
    IF OLD.z_total_24 <> NEW.z_total_24 THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'Z', 'z_total_24', OLD.z_id, OLD.z_total_24, NEW.z_total_24, NOW());
	END IF;
    IF OLD.z_total <> NEW.z_total THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'Z', 'z_total', OLD.z_id, OLD.z_total, NEW.z_total, NOW());
	END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS scanner_update;
DELIMITER $$
CREATE TRIGGER scanner_update
AFTER UPDATE
ON scanner
FOR EACH ROW
BEGIN
	IF OLD.device_name <> NEW.device_name THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'scanner', 'device_name', OLD.device_name, OLD.device_name, NEW.device_name, NOW());
	END IF;
    IF OLD.status <> NEW.status THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'scanner', 'status', OLD.device_name, OLD.status, NEW.status, NOW());
	END IF;
END $$
DELIMITER ;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TRIGGERS FOR INSERT
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DROP TRIGGER IF EXISTS user_insert;
DELIMITER $$
CREATE TRIGGER user_insert
AFTER INSERT
ON user
FOR EACH ROW
BEGIN
	DECLARE new_record TEXT;
    SET new_record = CONCAT('user_id: ', NEW.user_id, ', password: ', NEW.password, ', rights: ', NEW.rights, ', name: ', NEW.name, ', surname: ', NEW.surname);
    
    INSERT INTO log_insert VALUES (null, 'INSERT', 'user', new_record, NOW());
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS owner_insert;
DELIMITER $$
CREATE TRIGGER owner_insert
AFTER INSERT
ON owner
FOR EACH ROW
BEGIN
	DECLARE new_record TEXT;
    SET new_record = CONCAT('owner_id: ', NEW.owner_id, ', ownershipPercentage: ', NEW.ownershipPercentage);
    
    INSERT INTO log_insert VALUES (null, 'INSERT', 'owner', new_record, NOW());
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS employee_insert;
DELIMITER $$
CREATE TRIGGER employee_insert
AFTER INSERT
ON employee
FOR EACH ROW
BEGIN
	DECLARE new_record TEXT;
    SET new_record = CONCAT('employee_id: ', NEW.employee_id, ', afm: ', NEW.afm, ', phone: ', NEW.phone, ', address: ', NEW.address, ', salary: ', NEW.salary);
    
    INSERT INTO log_insert VALUES (null, 'INSERT', 'employee', new_record, NOW());
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS product_Storage_insert;
DELIMITER $$
CREATE TRIGGER product_Storage_insert
AFTER INSERT
ON product_Storage
FOR EACH ROW
BEGIN
	DECLARE new_record TEXT;
    SET new_record = CONCAT('prod_id: ', NEW.prod_id, ', prod_stor_name: ', NEW.prod_stor_name, ', prod_stor_barcode: ', NEW.prod_stor_barcode, ', prod_stor_fpa: ', NEW.prod_stor_fpa, ', prod_stor_quantity: ', NEW.prod_stor_quantity, ', prod_store_quantity_type: ', NEW.prod_stor_quantity_type, ', prod_stor_price: ', NEW.prod_stor_price);
    
    INSERT INTO log_insert VALUES (null, 'INSERT', 'product_Storage', new_record, NOW());
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS supplier_insert;
DELIMITER $$
CREATE TRIGGER supplier_insert
AFTER INSERT
ON supplier
FOR EACH ROW
BEGIN
	DECLARE new_record TEXT;
    SET new_record = CONCAT('supplier_id: ', NEW.supplier_id, ', supplier_name: ', NEW.supplier_name, ', supplier_phone: ', NEW.supplier_phone, ', supplier_afm: ', NEW.supplier_afm, ', supplier_email: ', NEW.supplier_email, ', supplier_address: ', NEW.supplier_address);
    
    INSERT INTO log_insert VALUES (null, 'INSERT', 'supplier', new_record, NOW());
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS invoice_insert;
DELIMITER $$
CREATE TRIGGER invoice_insert
AFTER INSERT
ON invoice
FOR EACH ROW
BEGIN
	DECLARE new_record TEXT;
    SET new_record = CONCAT('invoice_id: ', NEW.invoice_id, ', inv_supplier_id: ', NEW.inv_supplier_id, ', payment_type: ', NEW.payment_type, ', total: ', NEW.total, ', date: ', NEW.date);
    
    INSERT INTO log_insert VALUES (null, 'INSERT', 'invoice', new_record, NOW());
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS product_Invoice_insert;
DELIMITER $$
CREATE TRIGGER product_Invoice_insert
AFTER INSERT
ON product_Invoice
FOR EACH ROW
BEGIN
	DECLARE new_record TEXT;
    SET new_record = CONCAT('prod_inv_name: ', NEW.prod_inv_name, ', prod_inv_id: ', NEW.prod_inv_id, ', prod_inv_fpa: ', NEW.prod_inv_fpa, ', prod_inv_buy_price: ', NEW.prod_inv_buy_price, ', prod_inv_quantity: ', NEW.prod_inv_quantity, ', prod_inv_quantity_type: ', NEW.prod_inv_quantity_type);
    
    INSERT INTO log_insert VALUES (null, 'INSERT', 'product_Invoice', new_record, NOW());
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS customer_insert;
DELIMITER $$
CREATE TRIGGER customer_insert
AFTER INSERT
ON customer
FOR EACH ROW
BEGIN
	DECLARE new_record TEXT;
    SET new_record = CONCAT('email: ', NEW.email, ', points: ', NEW.points, ', voucher_count: ', NEW.voucher_count);
    
    INSERT INTO log_insert VALUES (null, 'INSERT', 'customer', new_record, NOW());
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS receipt_insert;
DELIMITER $$
CREATE TRIGGER receipt_insert
AFTER INSERT
ON receipt
FOR EACH ROW
BEGIN
	DECLARE new_record TEXT;
    SET new_record = CONCAT('receipt_id: ', NEW.receipt_id, ', date: ', NEW.date, ', sum: ', NEW.sum, ', res_employee_id: ', NEW.res_employee_id, ', customer_email: ', NEW.customer_email, ', receipt_points: ', NEW.receipt_points, ', voucher: ', NEW.voucher);
    
    INSERT INTO log_insert VALUES (null, 'INSERT', 'receipt', new_record, NOW());
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS product_Receipt_insert;
DELIMITER $$
CREATE TRIGGER product_Receipt_insert
AFTER INSERT
ON product_Receipt
FOR EACH ROW
BEGIN
	DECLARE new_record TEXT;
    SET new_record = CONCAT('prod_rec_name: ', NEW.prod_rec_name, ', prod_rec_id: ', NEW.prod_rec_id, ', prod_rec_quantity: ', NEW.prod_rec_quantity, ', prod_rec_quantity_type: ', NEW.prod_rec_quantity_type);
    
    INSERT INTO log_insert VALUES (null, 'INSERT', 'product_Receipt', new_record, NOW());
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS orders_insert;
DELIMITER $$
CREATE TRIGGER orders_insert
AFTER INSERT
ON orders
FOR EACH ROW
BEGIN
	DECLARE new_record TEXT;
    SET new_record = CONCAT('order_id: ', NEW.order_id, ', order_supplier_id: ', NEW.order_supplier_id);
    
    INSERT INTO log_insert VALUES (null, 'INSERT', 'orders', new_record, NOW());
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS product_Order_insert;
DELIMITER $$
CREATE TRIGGER product_Order_insert
AFTER INSERT
ON product_Order
FOR EACH ROW
BEGIN
	DECLARE new_record TEXT;
    SET new_record = CONCAT('prod_order_name: ', NEW.prod_order_name, ', prod_order_id: ', NEW.prod_order_id, ', prod_order_quantity: ', NEW.prod_order_quantity, ', quantity_type: ', NEW.quantity_type);
    
    INSERT INTO log_insert VALUES (null, 'INSERT', 'product_Order', new_record, NOW());
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS Z_insert;
DELIMITER $$
CREATE TRIGGER Z_insert
AFTER INSERT
ON Z
FOR EACH ROW
BEGIN
	DECLARE new_record TEXT;
    SET new_record = CONCAT('z_id: ', NEW.z_id, ', z_date: ', NEW.z_date, ', z_total_6: ', NEW.z_total_6, ', z_total_13: ', NEW.z_total_13, ', z_total_24: ', NEW.z_total_24, ', z_total: ', NEW.z_total);
    
    INSERT INTO log_insert VALUES (null, 'INSERT', 'Z', new_record, NOW());
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS scanner_insert;
DELIMITER $$
CREATE TRIGGER scanner_insert
AFTER INSERT
ON scanner
FOR EACH ROW
BEGIN
	DECLARE new_record TEXT;
    SET new_record = CONCAT('device_name: ', NEW.device_name, ', status: ', NEW.status);
    
    INSERT INTO log_insert VALUES (null, 'INSERT', 'scanner', new_record, NOW());
END $$
DELIMITER ;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TRIGGERS FOR DELETE
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DROP TRIGGER IF EXISTS user_delete;
DELIMITER $$
CREATE TRIGGER user_delete
AFTER DELETE
ON user
FOR EACH ROW
BEGIN
	DECLARE log_del_value TEXT;
    SET log_del_value = CONCAT('user_id: ', OLD.user_id, ', password: ', OLD.password, ', rights: ', OLD.rights, ', name: ', OLD.name, ', surname: ', OLD.surname);
    
    INSERT INTO log_delete VALUES (null, 'DELETE', 'user', log_del_value, NOW());
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS owner_delete;
DELIMITER $$
CREATE TRIGGER owner_delete
AFTER DELETE
ON owner
FOR EACH ROW
BEGIN
	DECLARE log_del_value TEXT;
    SET log_del_value = CONCAT('owner_id: ', OLD.owner_id, ', ownershipPercentage: ', OLD.ownershipPercentage);
    
    INSERT INTO log_delete VALUES (null, 'DELETE', 'owner', log_del_value, NOW());
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS employee_delete;
DELIMITER $$
CREATE TRIGGER employee_delete
AFTER DELETE
ON employee
FOR EACH ROW
BEGIN
	DECLARE log_del_value TEXT;
    SET log_del_value = CONCAT('employee_id: ', OLD.employee_id, ', afm: ', OLD.afm, ', phone: ', OLD.phone, ', address: ', OLD.address, ', salary: ', OLD.salary);
    
    INSERT INTO log_delete VALUES (null, 'DELETE', 'employee', log_del_value, NOW());
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS product_Storage_delete;
DELIMITER $$
CREATE TRIGGER product_Storage_delete
AFTER DELETE
ON product_Storage
FOR EACH ROW
BEGIN
	DECLARE log_del_value TEXT;
    SET log_del_value = CONCAT('prod_id: ', OLD.prod_id, ', prod_stor_name: ', OLD.prod_stor_name, ', prod_stor_barcode: ', OLD.prod_stor_barcode, ', prod_stor_fpa: ', OLD.prod_stor_fpa, ', prod_stor_quantity: ', OLD.prod_stor_quantity, ', prod_store_quantity_type: ', OLD.prod_stor_quantity_type, ', prod_stor_price: ', OLD.prod_stor_price);
    
    INSERT INTO log_delete VALUES (null, 'DELETE', 'product_Storage', log_del_value, NOW());
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS supplier_delete;
DELIMITER $$
CREATE TRIGGER supplier_delete
AFTER DELETE
ON supplier
FOR EACH ROW
BEGIN
	DECLARE log_del_value TEXT;
    SET log_del_value = CONCAT('supplier_id: ', OLD.supplier_id, ', supplier_name: ', OLD.supplier_name, ', supplier_phone: ', OLD.supplier_phone, ', supplier_afm: ', OLD.supplier_afm, ', supplier_email: ', OLD.supplier_email, ', supplier_address: ', OLD.supplier_address);
    
    INSERT INTO log_delete VALUES (null, 'DELETE', 'supplier', log_del_value, NOW());
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS invoice_delete;
DELIMITER $$
CREATE TRIGGER invoice_delete
AFTER DELETE
ON invoice
FOR EACH ROW
BEGIN
	DECLARE log_del_value TEXT;
    SET log_del_value = CONCAT('invoice_id: ', OLD.invoice_id, ', inv_supplier_id: ', OLD.inv_supplier_id, ', payment_type: ', OLD.payment_type, ', total: ', OLD.total, ', date: ', OLD.date);
    
    INSERT INTO log_delete VALUES (null, 'DELETE', 'invoice', log_del_value, NOW());
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS product_Invoice_delete;
DELIMITER $$
CREATE TRIGGER product_Invoice_delete
AFTER DELETE
ON product_Invoice
FOR EACH ROW
BEGIN
	DECLARE log_del_value TEXT;
    SET log_del_value = CONCAT('prod_inv_name: ', OLD.prod_inv_name, ', prod_inv_id: ', OLD.prod_inv_id, ', prod_inv_fpa: ', OLD.prod_inv_fpa, ', prod_inv_buy_price: ', OLD.prod_inv_buy_price, ', prod_inv_quantity: ', OLD.prod_inv_quantity, ', prod_inv_quantity_type: ', OLD.prod_inv_quantity_type);
    
    INSERT INTO log_delete VALUES (null, 'DELETE', 'product_Invoice', log_del_value, NOW());
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS customer_delete;
DELIMITER $$
CREATE TRIGGER customer_delete
AFTER DELETE
ON customer
FOR EACH ROW
BEGIN
	DECLARE log_del_value TEXT;
    SET log_del_value = CONCAT('email: ', OLD.email, ', points: ', OLD.points, ', voucher_count: ', OLD.voucher_count);
    
    INSERT INTO log_delete VALUES (null, 'DELETE', 'customer', log_del_value, NOW());
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS receipt_delete;
DELIMITER $$
CREATE TRIGGER receipt_delete
AFTER DELETE
ON receipt
FOR EACH ROW
BEGIN
	DECLARE log_del_value TEXT;
    SET log_del_value = CONCAT('receipt_id: ', OLD.receipt_id, ', date: ', OLD.date, ', sum: ', OLD.sum, ', res_employee_id: ', OLD.res_employee_id, ', customer_email: ', OLD.customer_email, ', receipt_points: ', OLD.receipt_points, ', voucher: ', OLD.voucher);
    
    INSERT INTO log_delete VALUES (null, 'DELETE', 'receipt', log_del_value, NOW());
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS product_Receipt_delete;
DELIMITER $$
CREATE TRIGGER product_Receipt_delete
AFTER DELETE
ON product_Receipt
FOR EACH ROW
BEGIN
	DECLARE log_del_value TEXT;
    SET log_del_value = CONCAT('prod_rec_name: ', OLD.prod_rec_name, ', prod_rec_id: ', OLD.prod_rec_id, ', prod_rec_quantity: ', OLD.prod_rec_quantity, ', prod_rec_quantity_type: ', OLD.prod_rec_quantity_type);
    
    INSERT INTO log_delete VALUES (null, 'DELETE', 'product_Receipt', log_del_value, NOW());
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS orders_delete;
DELIMITER $$
CREATE TRIGGER orders_delete
AFTER DELETE
ON orders
FOR EACH ROW
BEGIN
	DECLARE log_del_value TEXT;
    SET log_del_value = CONCAT('order_id: ', OLD.order_id, ', order_supplier_id: ', OLD.order_supplier_id);
    
    INSERT INTO log_delete VALUES (null, 'DELETE', 'orders', log_del_value, NOW());
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS product_Order_delete;
DELIMITER $$
CREATE TRIGGER product_Order_delete
AFTER DELETE
ON product_Order
FOR EACH ROW
BEGIN
	DECLARE log_del_value TEXT;
    SET log_del_value = CONCAT('prod_order_name: ', OLD.prod_order_name, ', prod_order_id: ', OLD.prod_order_id, ', prod_order_quantity: ', OLD.prod_order_quantity, ', quantity_type: ', OLD.quantity_type);
    
    INSERT INTO log_delete VALUES (null, 'DELETE', 'product_Order', log_del_value, NOW());
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS Z_delete;
DELIMITER $$
CREATE TRIGGER Z_delete
AFTER DELETE
ON Z
FOR EACH ROW
BEGIN
	DECLARE log_del_value TEXT;
    SET log_del_value = CONCAT('z_id: ', OLD.z_id, ', z_date: ', OLD.z_date, ', z_total_6: ', OLD.z_total_6, ', z_total_13: ', OLD.z_total_13, ', z_total_24: ', OLD.z_total_24, ', z_total: ', OLD.z_total);
    
    INSERT INTO log_delete VALUES (null, 'DELETE', 'Z', log_del_value, NOW());
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS scanner_delete;
DELIMITER $$
CREATE TRIGGER scanner_delete
AFTER DELETE
ON scanner
FOR EACH ROW
BEGIN
	DECLARE log_del_value TEXT;
    SET log_del_value = CONCAT('device_name: ', OLD.device_name, ', status: ', OLD.status);
    
    INSERT INTO log_delete VALUES (null, 'DELETE', 'scanner', log_del_value, NOW());
END $$
DELIMITER ;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- INSERTIONS
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO supplier VALUES (null, 'Κυριακόπουλος', '6984536243', '123423621', 'kyriakopoylos@gmail.com', 'Βάρθου 34');
INSERT INTO supplier VALUES (null, 'Πετρίδης', '6984636841', '043926623', 'petridis@gmail.com', 'Τράτου 22');

INSERT INTO invoice VALUES (null, '1', 'cash', '620', '2024-05-22 12:00:00');
INSERT INTO invoice VALUES (null, '1', 'cash', '730', '2023-05-19 12:00:00');
INSERT INTO invoice VALUES (null, '1', 'cash', '500', '2024-05-12 12:00:00');
INSERT INTO invoice VALUES (null, '1', 'cash', '1000', '2024-04-12 12:00:00');

INSERT INTO product_Invoice VALUES ('ΟΛΥΜΠΟΣ τυρί κεφαλοτύρι πρόβειο τριμμένο 150gr', '1', '13', '2.30', '100', 'τεμάχια');
INSERT INTO product_Invoice VALUES ('Γάλα ΟΛΥΜΠΟΣ κατσικίσιο 3,5% λιπαρά βιολογικό (1lt)', '1', '13', '3.40', '50', 'τεμάχια');
INSERT INTO product_Invoice VALUES ('Γιαούρτι ΟΛΥΜΠΟΣ στραγγιστό 5% (3x200g)', '1', '13', '4.40', '50', 'τεμάχια');

INSERT INTO product_Invoice VALUES ('ΟΛΥΜΠΟΣ τυρί κεφαλοτύρι πρόβειο τριμμένο 150gr', '2', '13', '2.30', '95', 'τεμάχια');
INSERT INTO product_Invoice VALUES ('Γάλα ΟΛΥΜΠΟΣ κατσικίσιο 3,5% λιπαρά βιολογικό (1lt)', '2', '13', '3.40', '45', 'τεμάχια');
INSERT INTO product_Invoice VALUES ('Γιαούρτι ΟΛΥΜΠΟΣ στραγγιστό 5% (3x200g)', '2', '13', '4.40', '40', 'τεμάχια');
INSERT INTO product_Invoice VALUES ('ΟΛΥΜΠΟΣ κεφίρ φράουλα 330ml', '2', '13', '2.20', '30', 'τεμάχια');

INSERT INTO product_Invoice VALUES ('ΟΛΥΜΠΟΣ τυρί κεφαλοτύρι πρόβειο τριμμένο 150gr', '3', '13', '2.30', '80', 'τεμάχια');
INSERT INTO product_Invoice VALUES ('Γάλα ΟΛΥΜΠΟΣ κατσικίσιο 3,5% λιπαρά βιολογικό (1lt)', '3', '13', '3.40', '60', 'τεμάχια');
INSERT INTO product_Invoice VALUES ('Γιαούρτι ΟΛΥΜΠΟΣ στραγγιστό 5% (3x200g)', '3', '13', '4.40', '45', 'τεμάχια');

INSERT INTO product_Invoice VALUES ('ΟΛΥΜΠΟΣ τυρί κεφαλοτύρι πρόβειο τριμμένο 150gr', '4', '13', '2.30', '30', 'τεμάχια');
INSERT INTO product_Invoice VALUES ('Γάλα ΟΛΥΜΠΟΣ κατσικίσιο 3,5% λιπαρά βιολογικό (1lt)', '4', '13', '3.40', '20', 'τεμάχια');
INSERT INTO product_Invoice VALUES ('Γιαούρτι ΟΛΥΜΠΟΣ στραγγιστό 5% (3x200g)', '4', '13', '4.40', '20', 'τεμάχια');

INSERT INTO product_Storage VALUES (null, 'μπανάνες Chicita', 09243789128344, 3.0, 20.0, 'τεμάχια', 1.5);
INSERT INTO product_Storage VALUES (null, 'Γάλα ΝΟΥΝΟΥ', 1781290345678, 3.0, 20.0, 'τεμάχια', 1.5);

INSERT INTO customer (email, points, voucher_count)
VALUES
('customer1@example.com', 100, 2),
('customer2@example.com', 50, 1),
('customer3@example.com', 200, 4),
('customer4@example.com', 75, 3);


INSERT INTO product_Storage (prod_stor_name, prod_stor_barcode, prod_stor_fpa, prod_stor_quantity, prod_stor_quantity_type, prod_stor_price)
VALUES
('Πακέτο Γάλα', 1234567890123, 13, 10, 'τεμάχια', 1.50),
('Φραντζόλα Ψωμί', 2345678901234, 6, 20, 'τεμάχια', 0.80),
('Κουτί Αυγά', 3456789012345, 0, 15, 'εξάδες', 2.50),
('Κουτί Σοκολάτα', 5678901234567, 13, 30, 'κουτιά', 3.20),
('Πακέτο Τσάι', 6789012345678, 6, 40, 'πακέτα', 1.20),
('Μπουκάλι Χυμός', 9012345678901, 13, 50, 'τεμάχια', 2.00),
('Μπουκάλι Νερό', 9123456789012, 13, 50, 'λίτρα', 0.50),
('Συσκευασία Ρύζι', 9234567890123, 24, 30, 'κιλά', 1.20),
('Πακέτο Μακαρόνια', 9345678901234, 13, 40, 'πακέτα', 1.00),
('Κουτί Μπισκότα', 9456789012345, 6, 20, 'κουτιά', 2.50),
('Συσκευασία Χαρτί Υγείας', 9567890123456, 24, 60, 'πακέτα', 3.50),
('Συσκευασία Απορρυπαντικό', 9678901234567, 13, 25, 'τεμάχια', 8.00),
('Μπουκάλι Ελαιόλαδο', 9789012345678, 13, 15, 'τεμάχια', 5.00),
('Κουτί Κρέμα Γάλακτος', 9890123456789, 6, 35, 'κουτιά', 2.00),
('Πακέτο Καφές', 9901234567890, 24, 50, 'πακέτα', 3.00),
('Συσκευασία Κουλούρι Θεσσαλονίκης', 9912345678901, 24, 100, 'τεμάχια', 0.40),
('Κουτί Σαπούνι', 9923456789012, 13, 30, 'κουτιά', 1.50),
('Πακέτο Πατατάκια', 9934567890123, 24, 80, 'πακέτα', 1.20),
('Συσκευασία Χυμός Πορτοκάλι', 9945678901234, 13, 20, 'τεμάχια', 2.50),
('Μπουκάλι Κόκα Κόλα', 9956789012345, 13, 50, 'τεμάχια', 1.80),
('Πακέτο Ζυμαρικά', 9967890123456, 24, 30, 'πακέτα', 1.00),
('Συσκευασία Βούτυρο', 9978901234567, 6, 40, 'πακέτα', 1.50),
('Μπουκάλι Ξύδι', 9989012345678, 13, 25, 'τεμάχια', 1.20),
('Κουτί Δημητριακά', 9990123456789, 13, 30, 'κουτιά', 2.50),
('Πακέτο Φρυγανιές', 9991234567890, 24, 20, 'πακέτα', 1.00),
('Συσκευασία Κρέμα Σώματος', 9992345678901, 13, 15, 'κουτιά', 3.00);


INSERT INTO user (password, rights, name, surname) VALUES
('pass1', 'employee', 'Γιάννης', 'Παπαδόπουλος'),
('pass2', 'employee', 'Ελένη', 'Καραγιάννη'),
('pass3', 'employee', 'Νίκος', 'Αντωνίου'),
('pass4', 'employee', 'Μαρία', 'Πετρίδη'),
('passw5', 'employee', 'Δημήτρης', 'Νικολάου'),
('passw6', 'employee', 'Αναστασία', 'Βασιλείου'),
('passw7', 'employee', 'Χρήστος', 'Γεωργίου'),
('passw8', 'employee', 'Σοφία', 'Λεμονή'),
('passw9', 'employee', 'Παναγιώτης', 'Αθανασίου'),
('passw10', 'owner', 'Κώστας', 'Σταυρόπουλος');

INSERT INTO employee (employee_id, afm, phone, address, salary) VALUES
(1, 12345678901, 6912345678, 'Οδός Αθηνάς 1, Αθήνα', 900.00),
(2, 23456789012, 6923456789, 'Οδός Πατησίων 2, Αθήνα', 920.00),
(3, 34567890123, 6934567890, 'Οδός Σταδίου 3, Αθήνα', 850.00),
(4, 45678901234, 6945678901, 'Οδός Πανεπιστημίου 4, Αθήνα', 950.00),
(5, 56789012345, 6956789012, 'Οδός Ερμού 5, Αθήνα', 1000.00),
(6, 67890123456, 6967890123, 'Οδός Ακαδημίας 6, Αθήνα', 800.00),
(7, 78901234567, 6978901234, 'Οδός Κηφισίας 7, Αθήνα', 800.00),
(8, 89012345678, 6989012345, 'Οδός Συγγρού 8, Αθήνα', 900.00),
(9, 90123456789, 6990123456, 'Οδός Πειραιώς 9, Αθήνα', 850.00);


INSERT INTO customer (email, points, voucher_count) VALUES
('dim@gmail.com', 150, 1),
('maria@hotmail.com', 50, 0),
('iwanna3@gmail.com', 200, 2),
('stella@gmail.com', 120, 1),
('christina@gmail.com', 300, 3),
('giannhs6@hotmail.com', 90, 0),
('petros7@gmail.com', 180, 1),
('lemoni@gmail.com', 60, 0),
('panagiwths9@hotmail.com', 250, 2),
('katerina10@gmail.com', 30, 0);

INSERT INTO receipt (date, sum, res_employee_id, customer_email, receipt_points, voucher)
VALUES
('2024-05-20 12:30:00', 25.50, 3, 'customer1@example.com', 10, 2.00),
('2024-05-20 15:45:00', 18.75, 3, 'customer2@example.com', 8, 1.50),
('2024-05-21 10:15:00', 32.00, 3, 'customer3@example.com', 12, 3.00),
('2024-05-21 14:20:00', 21.25, 3, 'customer4@example.com', 9, 1.80),
('2024-05-22 09:00:00', 22.80, 3, 'customer1@example.com', 10, 2.00),
('2024-05-22 11:10:00', 37.50, 3, 'customer2@example.com', 15, 4.50),
('2024-05-23 17:30:00', 28.90, 3, 'customer3@example.com', 13, 2.20),
('2024-05-23 13:45:00', 19.75, 3, 'customer4@example.com', 8, 1.50),
('2024-05-24 09:55:00', 33.20, 3, 'customer1@example.com', 11, 2.80),
('2024-05-24 16:05:00', 41.60, 3, 'customer2@example.com', 16, 3.50),
('2024-05-25 10:40:00', 27.85, 3, 'customer3@example.com', 12, 3.00),
('2024-05-25 12:00:00', 20.10, 3, 'customer4@example.com', 8, 1.20),
('2024-05-26 09:30:00', 19.45, 3, 'customer1@example.com', 9, 1.80),
('2024-05-26 14:45:00', 35.75, 3, 'customer2@example.com', 14, 2.50),
('2024-05-27 11:20:00', 24.80, 3, 'customer3@example.com', 11, 1.20),
('2024-05-27 13:30:00', 18.25, 3, 'customer4@example.com', 7, 1.00),
('2024-05-28 10:15:00', 29.60, 3, 'customer1@example.com', 12, 2.00),
('2024-05-28 15:30:00', 43.20, 3, 'customer2@example.com', 17, 3.00),
('2024-05-29 09:45:00', 26.75, 3, 'customer3@example.com', 11, 1.50),
('2024-05-29 12:15:00', 19.20, 3, 'customer4@example.com', 7, 1.00),
('2024-05-30 11:10:00', 31.45, 3, 'customer1@example.com', 13, 2.20),
('2024-05-30 16:45:00', 38.90, 3, 'customer2@example.com', 15, 3.50),
('2024-05-31 12:30:00', 22.60, 3, 'customer3@example.com', 9, 1.80),
('2024-05-31 14:00:00', 17.80, 3, 'customer4@example.com', 7, 0.50),
('2024-06-01 10:20:00', 28.75, 3, 'customer1@example.com', 12, 2.50),
('2024-06-01 15:55:00', 45.20, 3, 'customer2@example.com', 18, 3.00),
('2024-06-02 11:40:00', 23.90, 3, 'customer3@example.com', 10, 2.00),
('2024-06-02 13:00:00', 20.60, 3, 'customer4@example.com', 8, 1.50),
('2024-06-03 09:15:00', 30.80, 3, 'customer1@example.com', 13, 3.00),
('2024-06-03 16:20:00', 37.45, 3, 'customer2@example.com', 15, 2.80),
('2024-06-04 12:10:00', 26.90, 3, 'customer3@example.com', 11, 1.80),
('2024-06-04 14:25:00', 21.70, 3, 'customer4@example.com', 9, 1.00),
('2024-06-05 09:30:00', 35.60, 3, 'customer1@example.com', 15, 3.50),
('2024-06-05 17:00:00', 42.80, 3, 'customer2@example.com', 18, 2.50),
('2024-06-06 10:45:00', 28.90, 3, 'customer3@example.com', 12, 2.20),
('2024-06-06 14:15:00', 19.75, 3, 'customer4@example.com', 8, 1.20);


INSERT INTO product_Receipt (prod_rec_name, prod_rec_id, prod_rec_quantity, prod_rec_quantity_type)
VALUES
('Αλεύρι ολικής', 1, 1, 'κιλά'),
('Παρθένο Ελαιόλαδο', 1, 1, 'λίτρα'),
('Γάλα Φρέσκο', 1, 1, 'λίτρα'),
('Μέλι', 1, 500, 'γραμμάρια'),
('Ζάχαρη', 1, 1, 'κιλα'),
('Μακαρόνια', 1, 500, 'γραμμάρια');

INSERT INTO product_Receipt (prod_rec_name, prod_rec_id, prod_rec_quantity, prod_rec_quantity_type)
VALUES
('Τομάτες', 2, 1, 'κιλά'),
('Κρεμμύδια', 2, 1, 'κιλά'),
('Μαϊντανός', 2, 1, 'κιλά'),
('Λεμόνια', 2, 3, 'τεμάχια'),
('Φέτα', 2, 200, 'γραμμάρια'),
('Ελιές', 2, 500, 'γραμμάρια');

INSERT INTO product_Receipt (prod_rec_name, prod_rec_id, prod_rec_quantity, prod_rec_quantity_type)
VALUES
('Κοτόπουλο', 3, 1, 'κιλά'),
('Φακές', 3, 500, 'γραμμάρια'),
('Καρότα', 3, 500, 'γραμμάρια'),
('Αγγούρια', 3, 1, 'κιλά'),
('Πατάτες', 3, 1, 'κιλά'),
('Ρεβίθια', 3, 500, 'γραμμάρια');

INSERT INTO product_Receipt (prod_rec_name, prod_rec_id, prod_rec_quantity, prod_rec_quantity_type)
VALUES
('Μπανάνες', 4, 1, 'κιλά'),
('Καφές', 4, 250, 'γραμμάρια'),
('Αβοκάντο', 4, 2, 'τεμάχια'),
('Φράουλες', 4, 500, 'γραμμάρια'),
('Καλαμπόκι', 4, 500, 'γραμμάρια');

INSERT INTO product_Receipt (prod_rec_name, prod_rec_id, prod_rec_quantity, prod_rec_quantity_type)
VALUES
('Τυρί', 5, 200, 'γραμμάρια'),
('Μανιτάρια', 5, 250, 'γραμμάρια'),
('Κοτόπουλο', 5, 1, 'κιλά'),
('Πράσινες Ελιές', 5, 250, 'γραμμάρια'),
('Γιαούρτι', 5, 500, 'γραμμάρια');

INSERT INTO product_Receipt (prod_rec_name, prod_rec_id, prod_rec_quantity, prod_rec_quantity_type)
VALUES
('Σαλάτα', 6, 1, 'κιλά'),
('Καλαμπόκι', 6, 500, 'γραμμάρια'),
('Πατάτες', 6, 1, 'κιλά'),
('Κρεμμύδια', 6, 1, 'κιλά'),
('Φέτα', 6, 200, 'γραμμάρια'),
('Μήλα', 6, 1, 'κιλά');

INSERT INTO product_Receipt (prod_rec_name, prod_rec_id, prod_rec_quantity, prod_rec_quantity_type)
VALUES
('Λάδι', 7, 1, 'λίτρα'),
('Καρότα', 7, 500, 'γραμμάρια'),
('Φασόλια', 7, 500, 'γραμμάρια'),
('Κινόα', 7, 500, 'γραμμάρια'),
('Παρθένο Ελαιόλαδο', 7, 0.75, 'λίτρα');
 
INSERT INTO product_Receipt (prod_rec_name, prod_rec_id, prod_rec_quantity, prod_rec_quantity_type)
VALUES
('Τσάι', 8, 100, 'γραμμάρια'),
('Κέτσαπ', 8, 500, 'γραμμάρια'),
('Μπισκότα', 8, 1, 'πακέτα'),
('Σοκολάτα', 8, 200, 'γραμμάρια'),
('Λεμονάδα', 8, 1, 'λίτρα');

INSERT INTO product_Receipt (prod_rec_name, prod_rec_id, prod_rec_quantity, prod_rec_quantity_type)
VALUES
('Κονσέρβα Τόνου', 9, 1, 'κουτιά'),
('Γαρίδες', 9, 500, 'γραμμάρια'),
('Σαλάτα', 9, 1, 'κιλά'),
('Πίτσα', 9, 1, 'τεμάχια');

INSERT INTO product_Receipt (prod_rec_name, prod_rec_id, prod_rec_quantity, prod_rec_quantity_type)
VALUES
('Κοτόπουλο', 10, 1, 'κιλά'),
('Πατάτες', 10, 1, 'κιλά'),
('Πεπόνι', 10, 1, 'κιλά'),
('Καλαμπόκι', 10, 500, 'γραμμάρια'),
('Καρότα', 10, 500, 'γραμμάρια');

INSERT INTO product_Receipt (prod_rec_name, prod_rec_id, prod_rec_quantity, prod_rec_quantity_type)
VALUES
('Μήλα', 11, 1, 'κιλά'),
('Πορτοκάλια', 11, 1, 'κιλά'),
('Μπανάνες', 11, 1, 'κιλά'),
('Φράουλες', 11, 500, 'γραμμάρια'),
('Μανιτάρια', 11, 250, 'γραμμάρια'),
('Αβοκάντο', 11, 2, 'τεμάχια');

INSERT INTO product_Receipt (prod_rec_name, prod_rec_id, prod_rec_quantity, prod_rec_quantity_type)
VALUES
('Καφές', 12, 250, 'γραμμάρια'),
('Κασέρι', 12, 200, 'γραμμάρια'),
('Ζαχαρούχο', 12, 1, 'κιλά'),
('Αλεύρι', 12, 1, 'κιλά'),
('Μακαρόνια', 12, 500, 'γραμμάρια'),
('Ρύζι', 12, 1, 'κιλά');

INSERT INTO product_Receipt (prod_rec_name, prod_rec_id, prod_rec_quantity, prod_rec_quantity_type)
VALUES
('Πορτοκάλια', 13, 1, 'κιλά'),
('Λεμόνια', 13, 3, 'τεμάχια'),
('Μπανάνες', 13, 1, 'κιλά'),
('Μήλα', 13, 1, 'κιλά'),
('Σταφύλια', 13, 500, 'γραμμάρια'),
('Αβοκάντο', 13, 2, 'τεμάχια');

INSERT INTO product_Receipt (prod_rec_name, prod_rec_id, prod_rec_quantity, prod_rec_quantity_type)
VALUES
('Κοτόπουλο', 14, 1, 'κιλά'),
('Μακαρόνια', 14, 500, 'γραμμάρια'),
('Ρύζι', 14, 1, 'κιλά'),
('Λάδι', 14, 1, 'λίτρα'),
('Τυρί', 14, 200, 'γραμμάρια'),
('Καρότα', 14, 500, 'γραμμάρια');

INSERT INTO product_Receipt (prod_rec_name, prod_rec_id, prod_rec_quantity, prod_rec_quantity_type)
VALUES
('Πορτοκάλια', 15, 1, 'κιλά'),
('Μήλα', 15, 1, 'κιλά'),
('Λεμόνια', 15, 3, 'τεμάχια'),
('Φράουλες', 15, 500, 'γραμμάρια'),
('Μπανάνες', 15, 1, 'κιλά'),
('Αβοκάντο', 15, 2, 'τεμάχια');

INSERT INTO product_Receipt (prod_rec_name, prod_rec_id, prod_rec_quantity, prod_rec_quantity_type)
VALUES
('Σαπούνι', 16, 1, 'πακέτα'),
('Σαλάτα', 16, 1, 'πακέτα'),
('Μπισκότα', 16, 1, 'πακέτα'),
('Σοκολάτα', 16, 200, 'γραμμάρια');

INSERT INTO product_Receipt (prod_rec_name, prod_rec_id, prod_rec_quantity, prod_rec_quantity_type)
VALUES
('1', 17, 1, 'λίτρα'),
('Καφές', 17, 250, 'γραμμάρια'),
('Τσάι', 17, 100, 'γραμμάρια'),
('Ζαχαρούχο', 17, 1, 'κιλά'),
('Λεμόνια', 17, 3, 'τεμάχια'),
('Μήλα', 17, 1, 'κιλά');

INSERT INTO product_Receipt (prod_rec_name, prod_rec_id, prod_rec_quantity, prod_rec_quantity_type)
VALUES
('Αλεύρι', 18, 1, 'κιλά'),
('Ρύζι', 18, 1, 'κιλά'),
('Ζάχαρη', 18, 1, 'κιλά'),
('Λάδι', 18, 1, 'λίτρα'),
('Γάλα', 18, 1, 'λίτρα'),
('Τυρί', 18, 200, 'γραμμάρια');

INSERT INTO product_Receipt (prod_rec_name, prod_rec_id, prod_rec_quantity, prod_rec_quantity_type)
VALUES
('Καφές', 19, 250, 'γραμμάρια'),
('Τσάι', 19, 100, 'γραμμάρια'),
('Ζαχαρούχο', 19, 1, 'κιλά'),
('Λεμόνια', 19, 3, 'τεμάχια'),
('Μήλα', 19, 1, 'κιλά');

INSERT INTO product_Receipt (prod_rec_name, prod_rec_id, prod_rec_quantity, prod_rec_quantity_type)
VALUES
('Μπανάνες', 20, 1, 'κιλά'),
('Μήλα', 20, 1, 'κιλά'),
('Λεμόνια', 20, 3, 'τεμάχια'),
('Φράουλες', 20, 500, 'γραμμάρια'),
('Αβοκάντο', 20, 2, 'τεμάχια'),
('Καρότα', 20, 500, 'γραμμάρια');
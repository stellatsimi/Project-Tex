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
	prod_id int AUTO_INCREMENT,
	prod_inv_name VARCHAR(200),
	prod_inv_id int,
    prod_inv_fpa int,
    prod_inv_buy_price float,
    prod_inv_quantity INT,
    prod_inv_quantity_type enum('τεμάχια', 'κουτιά', 'εξάδες', 'κιλά', 'πακέτα', 'γραμμάρια', 'λίτρα'),
    
    PRIMARY KEY(prod_id),
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
    voucher float,
    
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
    
    PRIMARY KEY(prod_rec_name),
    CONSTRAINT FK_prod_rec_name FOREIGN KEY(prod_rec_name) REFERENCES product_Storage(prod_stor_name)
    ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_prod_rec_id FOREIGN KEY(prod_rec_id) REFERENCES receipt(receipt_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE orders(
	order_id INT auto_increment,
    order_supplier_id int,
    
    PRIMARY KEY(order_id),
    CONSTRAINT FK_order_supplier_id FOREIGN KEY(order_supplier_id) REFERENCES supplier(supplier_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE product_Order(
	prod_id int AUTO_INCREMENT,
	prod_order_name VARCHAR(200),
    prod_order_id int,
    prod_order_quantity int,
    quantity_type enum('τεμάχια', 'κουτιά', 'εξάδες', 'κιλά', 'πακέτα', 'γραμμάρια', 'λίτρα'),
    
    PRIMARY KEY(prod_id),
    CONSTRAINT FK_prod_order_id FOREIGN KEY(prod_order_id) REFERENCES orders(order_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE search_Results(
	prod_search_name VARCHAR(200),
    prod_price_1 float,
    prod_price_2 float,
    
    PRIMARY KEY(prod_search_name),
    CONSTRAINT FK_prod_search_name FOREIGN KEY(prod_search_name) REFERENCES product_Storage(prod_stor_name)
    ON UPDATE CASCADE ON DELETE CASCADE
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
    log_up_col_name VARCHAR(20),
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
		INSERT INTO log_update VALUES (null, 'UPDATE', 'product_Invoice', 'prod_inv_name', OLD.prod_id, OLD.prod_inv_name, NEW.prod_inv_name, NOW());
	END IF;
    IF OLD.prod_inv_id <> NEW.prod_inv_id THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'product_Invoice', 'prod_inv_id', OLD.prod_id, OLD.prod_inv_id, NEW.prod_inv_id, NOW());
	END IF;
    IF OLD.prod_inv_fpa <> NEW.prod_inv_fpa THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'product_Invoice', 'prod_inv_fpa', OLD.prod_id, OLD.prod_inv_fpa, NEW.prod_inv_fpa, NOW());
	END IF;
    IF OLD.prod_inv_buy_price <> NEW.prod_inv_buy_price THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'product_Invoice', 'prod_inv_buy_price', OLD.prod_id, OLD.prod_inv_buy_price, NEW.prod_inv_buy_price, NOW());
	END IF;
    IF OLD.prod_inv_quantity <> NEW.prod_inv_quantity THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'product_Invoice', 'prod_inv_quantity', OLD.prod_id, OLD.prod_inv_quantity, NEW.prod_inv_quantity, NOW());
	END IF;
    IF OLD.prod_inv_quantity_type <> NEW.prod_inv_quantity_type THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'product_Invoice', 'prod_inv_quantity_type', OLD.prod_id, OLD.prod_inv_quantity_type, NEW.prod_inv_quantity_type, NOW());
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
		INSERT INTO log_update VALUES (null, 'UPDATE', 'product_Receipt', 'prod_rec_name', OLD.prod_rec_name, OLD.prod_rec_name, NEW.prod_rec_name, NOW());
	END IF;
    IF OLD.prod_rec_id <> NEW.prod_rec_id THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'product_Receipt', 'prod_rec_id', OLD.prod_rec_name, OLD.prod_rec_id, NEW.prod_rec_id, NOW());
	END IF;
    IF OLD.prod_rec_quantity <> NEW.prod_rec_quantity THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'product_Receipt', 'prod_rec_quantity', OLD.prod_rec_name, OLD.prod_rec_quantity, NEW.prod_rec_quantity, NOW());
	END IF;
    IF OLD.prod_rec_quantity_type <> NEW.prod_rec_quantity_type THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'product_Receipt', 'prod_rec_quantity_type', OLD.prod_rec_name, OLD.prod_rec_quantity_type, NEW.prod_rec_quantity_type, NOW());
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
		INSERT INTO log_update VALUES (null, 'UPDATE', 'product_Order', 'prod_order_name', OLD.prod_id, OLD.prod_order_name, NEW.prod_order_name, NOW());
	END IF;
    IF OLD.prod_order_id <> NEW.prod_order_id THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'product_Order', 'prod_order_id', OLD.prod_id, OLD.prod_order_id, NEW.prod_order_id, NOW());
	END IF;
    IF OLD.prod_order_quantity <> NEW.prod_order_quantity THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'product_Order', 'prod_order_quantity', OLD.prod_id, OLD.prod_order_quantity, NEW.prod_order_quantity, NOW());
	END IF;
    IF OLD.quantity_type <> NEW.quantity_type THEN
		INSERT INTO log_update VALUES (null, 'UPDATE', 'product_Order', 'quantity_type', OLD.prod_id, OLD.quantity_type, NEW.quantity_type, NOW());
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
    SET new_record = CONCAT('prod_id: ', NEW.prod_id, ', prod_inv_name: ', NEW.prod_inv_name, ', prod_inv_id: ', NEW.prod_inv_id, ', prod_inv_fpa: ', NEW.prod_inv_fpa, ', prod_inv_buy_price: ', NEW.prod_inv_buy_price, ', prod_inv_quantity: ', NEW.prod_inv_quantity, ', prod_inv_quantity_type: ', NEW.prod_inv_quantity_type);
    
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
    SET new_record = CONCAT('prod_id: ', NEW.prod_id, ', prod_order_name: ', NEW.prod_order_name, ', prod_order_id: ', NEW.prod_order_id, ', prod_order_quantity: ', NEW.prod_order_quantity, ', quantity_type: ', NEW.quantity_type);
    
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
    SET log_del_value = CONCAT('prod_id: ', OLD.prod_id, ', prod_inv_name: ', OLD.prod_inv_name, ', prod_inv_id: ', OLD.prod_inv_id, ', prod_inv_fpa: ', OLD.prod_inv_fpa, ', prod_inv_buy_price: ', OLD.prod_inv_buy_price, ', prod_inv_quantity: ', OLD.prod_inv_quantity, ', prod_inv_quantity_type: ', OLD.prod_inv_quantity_type);
    
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
    SET log_del_value = CONCAT('prod_id: ', OLD.prod_id, ', prod_order_name: ', OLD.prod_order_name, ', prod_order_id: ', OLD.prod_order_id, ', prod_order_quantity: ', OLD.prod_order_quantity, ', quantity_type: ', OLD.quantity_type);
    
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

INSERT INTO product_Invoice VALUES (null, 'ΟΛΥΜΠΟΣ τυρί κεφαλοτύρι πρόβειο τριμμένο 150gr', '1', '13', '2.30', '100', 'τεμάχια');
INSERT INTO product_Invoice VALUES (null, 'Γάλα ΟΛΥΜΠΟΣ κατσικίσιο 3,5% λιπαρά βιολογικό (1lt)', '1', '13', '3.40', '50', 'τεμάχια');
INSERT INTO product_Invoice VALUES (null, 'Γιαούρτι ΟΛΥΜΠΟΣ στραγγιστό 5% (3x200g)', '1', '13', '4.40', '50', 'τεμάχια');

INSERT INTO product_Invoice VALUES (null, 'ΟΛΥΜΠΟΣ τυρί κεφαλοτύρι πρόβειο τριμμένο 150gr', '2', '13', '2.30', '95', 'τεμάχια');
INSERT INTO product_Invoice VALUES (null, 'Γάλα ΟΛΥΜΠΟΣ κατσικίσιο 3,5% λιπαρά βιολογικό (1lt)', '2', '13', '3.40', '45', 'τεμάχια');
INSERT INTO product_Invoice VALUES (null, 'Γιαούρτι ΟΛΥΜΠΟΣ στραγγιστό 5% (3x200g)', '2', '13', '4.40', '40', 'τεμάχια');
INSERT INTO product_Invoice VALUES (null, 'ΟΛΥΜΠΟΣ κεφίρ φράουλα 330ml', '2', '13', '2.20', '30', 'τεμάχια');

INSERT INTO product_Invoice VALUES (null, 'ΟΛΥΜΠΟΣ τυρί κεφαλοτύρι πρόβειο τριμμένο 150gr', '3', '13', '2.30', '80', 'τεμάχια');
INSERT INTO product_Invoice VALUES (null, 'Γάλα ΟΛΥΜΠΟΣ κατσικίσιο 3,5% λιπαρά βιολογικό (1lt)', '3', '13', '3.40', '60', 'τεμάχια');
INSERT INTO product_Invoice VALUES (null, 'Γιαούρτι ΟΛΥΜΠΟΣ στραγγιστό 5% (3x200g)', '3', '13', '4.40', '45', 'τεμάχια');

INSERT INTO product_Invoice VALUES (null, 'ΟΛΥΜΠΟΣ τυρί κεφαλοτύρι πρόβειο τριμμένο 150gr', '4', '13', '2.30', '30', 'τεμάχια');
INSERT INTO product_Invoice VALUES (null, 'Γάλα ΟΛΥΜΠΟΣ κατσικίσιο 3,5% λιπαρά βιολογικό (1lt)', '4', '13', '3.40', '20', 'τεμάχια');
INSERT INTO product_Invoice VALUES (null, 'Γιαούρτι ΟΛΥΜΠΟΣ στραγγιστό 5% (3x200g)', '4', '13', '4.40', '20', 'τεμάχια');



INSERT INTO user VALUES (null, '123', 'owner', 'sta', 'kaz');
INSERT INTO user VALUES (null, '12433', 'owner', 'kar', 'pet');
UPDATE user
SET password = '1036', rights = 'employee', name = 'petros'  WHERE user_id = '1';
UPDATE user
SET password = '15'  WHERE user_id = '2';
SELECT * FROM log_delete;
DELETE FROM user WHERE user_id = '1';
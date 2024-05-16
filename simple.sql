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
    product_name VARCHAR(100) UNIQUE,
    product_barcode BIGINT,
    fpa int,
    quantity float,
    quantity_type enum('τεμάχια', 'κουτιά', 'εξάδες', 'κιλά', 'πακέτα', 'γραμμάρια', 'λίτρα'),
	price float,
    
    PRIMARY KEY(product_name)
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
    supplier_id INT,
    payment_type enum('cash','card'),
    total float,
    date timestamp,
    
    PRIMARY KEY(invoice_id),
    CONSTRAINT FK_supplier_id FOREIGN KEY(supplier_id) REFERENCES supplier(supplier_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE product_Invoice(
	prod_inv_name VARCHAR(200),
	prod_inv_id int,
    prod_inv_fpa int,
    prod_inv_buy_price float,
    prod_inv_quantity INT,
    prod_inv_quantity_type enum('τεμάχια', 'κουτιά', 'εξάδες', 'κιλά', 'πακέτα', 'γραμμάρια', 'λίτρα'),
    
    PRIMARY KEY(prod_inv_name),
    CONSTRAINT FK_prod_inv_name FOREIGN KEY(prod_inv_name) REFERENCES product_Storage(product_name)
    ON UPDATE CASCADE ON DELETE CASCADE,
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
	prod_rec_name VARCHAR(200) UNIQUE,
    prod_rec_id int,
    prod_rec_quantity float,
    prod_rec_quantity_type enum('τεμάχια', 'κουτιά', 'εξάδες', 'κιλά', 'πακέτα', 'γραμμάρια', 'λίτρα'),
    
    PRIMARY KEY(prod_rec_name),
    CONSTRAINT FK_prod_rec_name FOREIGN KEY(prod_rec_name) REFERENCES product_Storage(product_name)
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
	prod_order_name VARCHAR(200) UNIQUE,
    prod_order_id int,
    prod_order_quantity float,
    quantity_type enum('τεμάχια', 'κουτιά', 'εξάδες', 'κιλά', 'πακέτα', 'γραμμάρια', 'λίτρα'),
    
    PRIMARY KEY(prod_order_name),
    CONSTRAINT FK_prod_order_name FOREIGN KEY(prod_order_name) REFERENCES product_Storage(product_name)
    ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT FK_prod_order_id FOREIGN KEY(prod_order_id) REFERENCES orders(order_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE search_Results(
	prod_search_name VARCHAR(200),
    prod_price_1 float,
    prod_price_2 float,
    
    PRIMARY KEY(prod_search_name),
    CONSTRAINT FK_prod_search_name FOREIGN KEY(prod_search_name) REFERENCES product_Storage(product_name)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Z(
	z_id int AUTO_INCREMENT,
	z_date DATETIME,
    z_total_6 float,
    z_total_13 float,
    z_total_24 float,
	z_total float,
    
    PRIMARY KEY(z_id)
);

CREATE TABLE IF NOT EXISTS scanner(
	device_name VARCHAR(200),
    status enum('Success','Fail'),
    current_barcode BIGINT,
    
    PRIMARY KEY(device_name)
);	
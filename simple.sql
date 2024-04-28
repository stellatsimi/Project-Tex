CREATE DATABASE IF NOT EXISTS simple;
USE simple;

CREATE TABLE IF NOT EXISTS user(
	password INT UNIQUE,
    rights ENUM('employee', 'owner'),
    salary FLOAT,
    name VARCHAR(20),
    surname VARCHAR(20),
    
    PRIMARY KEY(password)
    
);

CREATE TABLE IF NOT EXISTS product_Receipt(
	product_receipt_name VARCHAR(200) UNIQUE,
    product_receipt_quantity float,
    quantity_type enum('τεμάχια', 'κουτιά','εξάδες','κιλά'),
    product_receipt_fpa float,
    product_receipt_price float,
    receipt_id INT,
    
    PRIMARY KEY(product_receipt_name),
    CONSTRAINT FK_receipt FOREIGN KEY(receipt_id) REFERENCES receipt(receipt_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS product_Search(
	product_search_name VARCHAR(200),
    product_search_barcode INT,
    
    PRIMARY KEY(product_search_name)
);


CREATE TABLE IF NOT EXISTS customer(
	email VARCHAR(100) UNIQUE,
    points INT,
    voucher FLOAT, -- σε ευρώ
    
    PRIMARY KEY(email)
    
);

CREATE TABLE IF NOT EXISTS receipt(
	receipt_id INT auto_increment,
    final_cost float,
    customer VARCHAR(100),
    receipt_points INT,
    
    PRIMARY KEY(receipt_id),
    CONSTRAINT FK_email FOREIGN KEY(customer) REFERENCES customer(email)
    ON DELETE CASCADE ON UPDATE CASCADE

);

CREATE TABLE IF NOT EXISTS Z(
	day DATETIME
    -- θέλει και άλλα εδώ 
	
    
);

CREATE TABLE IF NOT EXISTS supplier(
	supplier_name VARCHAR(50),
    supplier_surname VARCHAR(50),
    supplier_afm VARCHAR(9) UNIQUE,
    supplier_email VARCHAR(100),
    
    PRIMARY KEY(supplier_afm)
);

CREATE TABLE IF NOT EXISTS orders(
	order_id INT auto_increment,
    supplier VARCHAR(9),
    
    PRIMARY KEY(order_id),
    CONSTRAINT FK_supplier FOREIGN KEY(supplier) REFERENCES supplier(supplier_afm)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS invoice(
	invoice_id INT auto_increment,
    order_id INT,
    supplier VARCHAR(9),
    payment enum('cash','card'),
    total float,
    
    PRIMARY KEY(invoice_id),
    CONSTRAINT FK_ORDER FOREIGN KEY(order_id) REFERENCES orders(order_id),
    CONSTRAINT FK_supplier FOREIGN KEY(supplier) REFERENCES supplier(supplier_afm)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS product_Invoice(
	product_invoice_name VARCHAR(200) UNIQUE,
    product_invoice_fpa float,
    product_invoice_buy_price float,
    product_invoice_quantity INT,
    quantity_type enum('τεμάχια', 'κουτιά','εξάδες','κιλά'),
    invoice_id INT,
    
    PRIMARY KEY(product_invoice_name),
    CONSTRAINT FK_invoice FOREIGN KEY(invoice_id) REFERENCES invoice(invoice_id)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS product_Order(
	product_order_name VARCHAR(200) UNIQUE,
    product_order_quantity float,
    quantity_type enum('τεμάχια', 'κουτιά','εξάδες','κιλά'),
    order_id INT,
    
    PRIMARY KEY(product_order_name),
    CONSTRAINT FK_orders FOREIGN KEY(order_id) REFERENCES orders(order_id)
    ON UPDATE CASCADE ON DELETE CASCADE
    
);

CREATE TABLE IF NOT EXISTS product_Receipt(
	product_receipt_name VARCHAR(200) UNIQUE,
    product_receipt_quantity float,
    quantity_type enum('τεμάχια', 'κουτιά','εξάδες','κιλά'),
    product_receipt_fpa float,
    product_receipt_price float,
    receipt_id INT,
    
    PRIMARY KEY(product_receipt_name),
    CONSTRAINT FK_receipt FOREIGN KEY(receipt_id) REFERENCES receipt(receipt_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS scanner(
	device VARCHAR(200),
    status enum('Success','Fail'),
    current_barcode INT,
    
    PRIMARY KEY(device)
);

	


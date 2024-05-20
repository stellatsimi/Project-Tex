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

SELECT invoice_id, prod_inv_name, prod_inv_quantity
FROM product_Invoice INNER JOIN invoice
ON invoice_id = prod_inv_id;

CREATE TABLE categories (
  id INTEGER NOT NULL PRIMARY KEY,
  name VARCHAR(25) NOT NULL
);

INSERT INTO categories(name) VALUES
('main dish'), 
('italian'), 
('dessert'),
('indonesian'),
('fruit');

CREATE TABLE items (
  id INTEGER NOT NULL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  stock INTEGER NOT NULL,
  price REAL NOT NULL
);

INSERT INTO items(name, stock, price) VALUES
('Ayam Geprek Jumbo', 45, 23000),
('Salad Buah Campur', 32, 18000),
('Spaghetti', 22, 32000),
('Rujak Kuah Pindang', 10, 8000),
('Lalapan Ikan Laut', 43, 31000);

CREATE TABLE category_details (
  id INTEGER NOT NULL PRIMARY KEY,
  item_id INTEGER DEFAULT NULL,
  category_id INTEGER DEFAULT NULL,
  FOREIGN KEY (item_id) REFERENCES items(id),
  FOREIGN KEY (category_id) REFERENCES categories(id)
);

INSERT INTO category_details(item_id, category_id) VALUES
(1,1),
(2,3),
(3,1),
(4,5),
(5,1),
(2,5),
(4,4);

CREATE TABLE customers (
  id INTEGER NOT NULL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  phone VARCHAR(25) NOT NULL,
  address TEXT NOT NULL
);

INSERT INTO customers(name, phone, address) VALUES
('Syakurr', '083223021910', 'Jimbaran'),
('Gungis', '083123844230', 'Dalung'),
('Nouval', '082134545677', 'Panjer'),
('Ambara', '083230224340', 'Batubulan'),
('Cahya', '083123424355', 'Denpasar');
  
CREATE TABLE ewallets (
  id INTEGER NOT NULL PRIMARY KEY,
  customer_id INTEGER NOT NULL,
  account_type VARCHAR(25) NOT NULL,
  account_number VARCHAR(50) NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES customers(id);
);

INSERT INTO ewallets(customer_id, account_type, account_number) VALUES
(1, 'GoPay', '849483223021910'),
(2, 'GoPay', '849483123844230'),
(3, 'GoPay', '849482134545677'),
(4, 'GoPay', '849483230224340'),
(5, 'GoPay', '849483123424355');

CREATE TABLE discounts (
  id INTEGER NOT NULL PRIMARY KEY,
  item_id INTEGER NOT NULL,
  percentage INTEGER NOT NULL,
  start_date TEXT NOT NULL,
  end_date TEXT NOT NULL,
  FOREIGN KEY (item_id) REFERENCES items(id)
);

INSERT INTO discounts(item_id, percentage, start_date, end_date) VALUES
(1, 5, '2022-03-25', '2022-03-27'),
(2, 5, '2022-03-25', '2022-03-27'),
(3, 5, '2022-03-25', '2022-03-27'),
(4, 5, '2022-03-25', '2022-03-27'),
(5, 5, '2022-03-25', '2022-03-27');

CREATE TABLE positions (
  id INTEGER NOT NULL PRIMARY KEY,
  name VARCHAR(25) NOT NULL
);

INSERT INTO positions(name) VALUES
('Admin'),
('Cashier'),
('Auditor'),
('Manager'),
('Warehouse');

CREATE TABLE employees (
  id INTEGER NOT NULL PRIMARY KEY,
  position_id INTEGER NOT NULL,
  username VARCHAR(50) NOT NULL,
  password VARCHAR(50) NOT NULL,
  name VARCHAR(50) NOT NULL,
  address TEXT NOT NULL,
  FOREIGN KEY (position_id) REFERENCES positions(id)
);

INSERT INTO employees(position_id, username, password, name, address) VALUES
(1, 'al3ix', 'qwerty123', 'Aleix', 'Jimbaran'),
(2, 'j0sh', 'qwerty123', 'Josh', 'Denpasar'),
(2, 'c4trine', 'qwerty123', 'Catrine', 'Panjer'),
(3, 'bry4n', 'qwerty123', 'Bryan', 'Batubulan'),
(4, 'l1am', 'qwerty123', 'Liam', 'Pecatu');

CREATE TABLE orders (
  id INTEGER NOT NULL PRIMARY KEY,
  customer_id INTEGER NOT NULL,
  employee_id INTEGER NOT NULL,
  table_number INTEGER NOT NULL,
  total REAL DEFAULT NULL,
  status TEXT DEFAULT 'Waiting for Payment',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (customer_id) REFERENCES customers(id),
  FOREIGN KEY (employee_id) REFERENCES employees(id)
);

INSERT INTO orders(customer_id, employee_id, table_number, total) VALUES
(1, 3, 7, 41000),
(2, 3, 7, 40000),
(3, 2, 3, 31000),
(4, 2, 10, 26000),
(5, 3, 1, 18000);

CREATE TABLE order_details (
  id INTEGER NOT NULL PRIMARY KEY,
  order_id INTEGER DEFAULT NULL,
  item_id INTEGER DEFAULT NULL,
  discount_id INTEGER DEFAULT NULL,
  quantity INTEGER NOT NULL,
  sub_total REAL NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(id),
  FOREIGN KEY (item_id) REFERENCES items(id),
  FOREIGN KEY (discount_id) REFERENCES discounts(id)
);

INSERT INTO order_details(order_id, item_id, discount_id, quantity, sub_total) VALUES
(1,1,NULL,1,23000),
(1,2,NULL,1,18000),
(2,3,NULL,1,32000),
(2,4,NULL,1,8000),
(3,1,NULL,1,23000),
(3,4,NULL,1,8000),
(4,2,NULL,1,18000),
(4,4,NULL,1,8000),
(5,2,NULL,1,18000);

CREATE TABLE transactions (
  id INTEGER NOT NULL PRIMARY KEY,
  order_id INTEGER NOT NULL,
  received_money REAL NOT NULL,
  change_money REAL NOT NULL,
  payment TEXT NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES orders(id)
);

INSERT INTO transactions(order_id, received_money, change_money, payment) values
(1,50000,9000,'Cash'),
(2,40000,0,'Cash'),
(3,31000,0,'Debit'),
(4,26000,0,'E-Wallet'),
(5,20000,2000,'Cash');

UPDATE orders SET status = 'Success';

SELECT o.id, o.created_at AS order_date, o.table_number, c.name, c.phone, o.total, GROUP_CONCAT(i.name) AS items
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.id
LEFT JOIN order_details od ON o.id = od.order_id
LEFT JOIN items i ON od.item_id = i.id
GROUP BY o.id;
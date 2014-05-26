/* Pre-populate DB with the following data */

INSERT INTO States VALUES('AL', 'Alabama');
INSERT INTO States VALUES('AK', 'Alaska');
INSERT INTO States VALUES('AZ', 'Arizona');
INSERT INTO States VALUES('AR', 'Arkansas');
INSERT INTO States VALUES('CA', 'California');
INSERT INTO States VALUES('CO', 'Colorado');
INSERT INTO States VALUES('CT', 'Connecticut');
INSERT INTO States VALUES('DE', 'Delaware');
INSERT INTO States VALUES('FL', 'Florida');
INSERT INTO States VALUES('GA', 'Georgia');
INSERT INTO States VALUES('HI', 'Hawaii');
INSERT INTO States VALUES('ID', 'Idaho');
INSERT INTO States VALUES('IL', 'Illinois');
INSERT INTO States VALUES('IN', 'Indiana');
INSERT INTO States VALUES('IA', 'Iowa');
INSERT INTO States VALUES('KS', 'Kansas');
INSERT INTO States VALUES('KY', 'Kentucky');
INSERT INTO States VALUES('LA', 'Louisiana');
INSERT INTO States VALUES('ME', 'Maine');
INSERT INTO States VALUES('MD', 'Maryland');
INSERT INTO States VALUES('MA', 'Massachusetts');
INSERT INTO States VALUES('MI', 'Michigan');
INSERT INTO States VALUES('MN', 'Minnesota');
INSERT INTO States VALUES('MS', 'Mississippi');
INSERT INTO States VALUES('MO', 'Missouri');
INSERT INTO States VALUES('MT', 'Montana');
INSERT INTO States VALUES('NE', 'Nebraska');
INSERT INTO States VALUES('NV', 'Nevada');
INSERT INTO States VALUES('NH', 'New Hampshire');
INSERT INTO States VALUES('NJ', 'New Jersey');
INSERT INTO States VALUES('NM', 'New Mexico');
INSERT INTO States VALUES('NY', 'New York');
INSERT INTO States VALUES('NC', 'North Carolina');
INSERT INTO States VALUES('ND', 'North Dakota');
INSERT INTO States VALUES('OH', 'Ohio');
INSERT INTO States VALUES('OK', 'Oklahoma');
INSERT INTO States VALUES('OR', 'Oregon');
INSERT INTO States VALUES('PA', 'Pennsylvania');
INSERT INTO States VALUES('RI', 'Rhode Island');
INSERT INTO States VALUES('SC', 'South Carolina');
INSERT INTO States VALUES('SD', 'South Dakota');
INSERT INTO States VALUES('TN', 'Tennessee');
INSERT INTO States VALUES('TX', 'Texas');
INSERT INTO States VALUES('UT', 'Utah');
INSERT INTO States VALUES('VT', 'Vermont');
INSERT INTO States VALUES('VA', 'Virginia');
INSERT INTO States VALUES('WA', 'Washington');
INSERT INTO States VALUES('WV', 'West Virginia');
INSERT INTO States VALUES('WI', 'Wisconsin');
INSERT INTO States VALUES('WY', 'Wyoming');

/* End pre-populated data */


/* users table */

INSERT INTO users (name, role, age, state) VALUES('Jasmine',   'Customer', 20, 'CA');
INSERT INTO users (name, role, age, state) VALUES('Allen',     'Customer', 20, 'CA');
INSERT INTO users (name, role, age, state) VALUES('Dhruv',     'Customer', 20, 'CA');
INSERT INTO users (name, role, age, state) VALUES('Yannis',    'Customer', 50, 'NY');
INSERT INTO users (name, role, age, state) VALUES('Aphrodite', 'Customer', 33, 'VT');
INSERT INTO users (name, role, age, state) VALUES('Apollo',    'Customer', 25, 'MD');
INSERT INTO users (name, role, age, state) VALUES('Ares',      'Customer', 39, 'LA');
INSERT INTO users (name, role, age, state) VALUES('Athena',    'Customer', 32, 'TX');
INSERT INTO users (name, role, age, state) VALUES('Atlas',     'Customer', 29, 'MO');
INSERT INTO users (name, role, age, state) VALUES('Demeter',   'Customer', 32, 'NY');
INSERT INTO users (name, role, age, state) VALUES('Dionysus',  'Owner',    37, 'CA');
INSERT INTO users (name, role, age, state) VALUES('Hades',     'Owner',    63, 'VA');
INSERT INTO users (name, role, age, state) VALUES('Hercules',  'Owner',    24, 'ME');
INSERT INTO users (name, role, age, state) VALUES('Hermes',    'Owner',    39, 'ME');
INSERT INTO users (name, role, age, state) VALUES('Hyperion',  'Owner',    25, 'MS');
INSERT INTO users (name, role, age, state) VALUES('Kronos',    'Owner',    31, 'MA');
INSERT INTO users (name, role, age, state) VALUES('Phoebe',    'Owner',    39, 'UT');
INSERT INTO users (name, role, age, state) VALUES('Poseidon',  'Owner',    40, 'NC');
INSERT INTO users (name, role, age, state) VALUES('Tethys',    'Owner',    63, 'NH');
INSERT INTO users (name, role, age, state) VALUES('Zeus',      'Owner',    32, 'TN');


/* categories table */

INSERT INTO categories (name, description) VALUES('Appliances',  'Microwaves and stuff');
INSERT INTO categories (name, description) VALUES('Beauty',      'Makeup');
INSERT INTO categories (name, description) VALUES('Clothing',    'Wearables');
INSERT INTO categories (name, description) VALUES('Electronics', 'Nerd stuff');
INSERT INTO categories (name, description) VALUES('Food',        'Nom nom nom');
INSERT INTO categories (name, description) VALUES('Furniture',   'Comfy');


/* products table */

INSERT INTO products (cid, name, SKU, price) VALUES(1, 'microwave',   'AP001', 100);
INSERT INTO products (cid, name, SKU, price) VALUES(1, 'toaster',     'AP002', 20);
INSERT INTO products (cid, name, SKU, price) VALUES(1, 'blender',     'AP003', 89);
INSERT INTO products (cid, name, SKU, price) VALUES(1, 'stove',       'AP004', 599);
INSERT INTO products (cid, name, SKU, price) VALUES(2, 'mascara',     'BT001', 4);
INSERT INTO products (cid, name, SKU, price) VALUES(2, 'lipstick',    'BT002', 8);
INSERT INTO products (cid, name, SKU, price) VALUES(2, 'nail polish', 'BT003', 5);
INSERT INTO products (cid, name, SKU, price) VALUES(2, 'concealer',   'BT004', 7);
INSERT INTO products (cid, name, SKU, price) VALUES(3, 'jeans',       'CL001', 120);
INSERT INTO products (cid, name, SKU, price) VALUES(3, 't-shirt',     'CL002', 25);
INSERT INTO products (cid, name, SKU, price) VALUES(3, 'leggings',    'CL003', 10);
INSERT INTO products (cid, name, SKU, price) VALUES(3, 'socks',       'CL004', 8);
INSERT INTO products (cid, name, SKU, price) VALUES(4, 'nexus 5',     'EC001', 399);
INSERT INTO products (cid, name, SKU, price) VALUES(4, 'macbook pro', 'EC002', 1299);
INSERT INTO products (cid, name, SKU, price) VALUES(4, 'iphone 5s',   'EC003', 649);
INSERT INTO products (cid, name, SKU, price) VALUES(4, 'chromecast',  'EC004', 35);
INSERT INTO products (cid, name, SKU, price) VALUES(5, 'bacon',       'FD001', 5);
INSERT INTO products (cid, name, SKU, price) VALUES(5, 'cheetos',     'FD002', 1);
INSERT INTO products (cid, name, SKU, price) VALUES(5, 'pizza',       'FD003', 15);
INSERT INTO products (cid, name, SKU, price) VALUES(5, 'burger',      'FD004', 8);
INSERT INTO products (cid, name, SKU, price) VALUES(6, 'desk',        'FR001', 100);
INSERT INTO products (cid, name, SKU, price) VALUES(6, 'chair',       'FR002', 40);
INSERT INTO products (cid, name, SKU, price) VALUES(6, 'sofa',        'FR003', 200);
INSERT INTO products (cid, name, SKU, price) VALUES(6, 'bed',         'FR004', 400);


/* carts table */

INSERT INTO carts (uid, pid, quantity, price) VALUES(1,  1,  1, 100);
INSERT INTO carts (uid, pid, quantity, price) VALUES(1,  2,  1, 20);
INSERT INTO carts (uid, pid, quantity, price) VALUES(2,  3,  1, 89);
INSERT INTO carts (uid, pid, quantity, price) VALUES(2,  4,  1, 599);
INSERT INTO carts (uid, pid, quantity, price) VALUES(3,  5,  2, 4);
INSERT INTO carts (uid, pid, quantity, price) VALUES(3,  6,  1, 8);
INSERT INTO carts (uid, pid, quantity, price) VALUES(4,  7,  1, 5);
INSERT INTO carts (uid, pid, quantity, price) VALUES(4,  8,  1, 7);
INSERT INTO carts (uid, pid, quantity, price) VALUES(5,  9,  1, 120);
INSERT INTO carts (uid, pid, quantity, price) VALUES(5,  10, 3, 25);
INSERT INTO carts (uid, pid, quantity, price) VALUES(6,  11, 1, 10);
INSERT INTO carts (uid, pid, quantity, price) VALUES(6,  12, 1, 8);
INSERT INTO carts (uid, pid, quantity, price) VALUES(7,  13, 1, 399);
INSERT INTO carts (uid, pid, quantity, price) VALUES(7,  14, 1, 1299);
INSERT INTO carts (uid, pid, quantity, price) VALUES(8,  15, 4, 649);
INSERT INTO carts (uid, pid, quantity, price) VALUES(8,  16, 1, 35);
INSERT INTO carts (uid, pid, quantity, price) VALUES(9,  17, 1, 5);
INSERT INTO carts (uid, pid, quantity, price) VALUES(9,  18, 1, 1);
INSERT INTO carts (uid, pid, quantity, price) VALUES(10, 19, 1, 15);
INSERT INTO carts (uid, pid, quantity, price) VALUES(10, 20, 5, 8);
INSERT INTO carts (uid, pid, quantity, price) VALUES(11, 21, 1, 100);
INSERT INTO carts (uid, pid, quantity, price) VALUES(11, 22, 1, 40);
INSERT INTO carts (uid, pid, quantity, price) VALUES(12, 23, 1, 200);
INSERT INTO carts (uid, pid, quantity, price) VALUES(12, 24, 1, 400);
INSERT INTO carts (uid, pid, quantity, price) VALUES(13, 24, 6, 400);
INSERT INTO carts (uid, pid, quantity, price) VALUES(13, 23, 1, 200);
INSERT INTO carts (uid, pid, quantity, price) VALUES(14, 22, 1, 40);
INSERT INTO carts (uid, pid, quantity, price) VALUES(14, 21, 1, 100);
INSERT INTO carts (uid, pid, quantity, price) VALUES(15, 20, 1, 8);
INSERT INTO carts (uid, pid, quantity, price) VALUES(15, 19, 7, 15);
INSERT INTO carts (uid, pid, quantity, price) VALUES(16, 18, 1, 1);
INSERT INTO carts (uid, pid, quantity, price) VALUES(16, 17, 1, 5);
INSERT INTO carts (uid, pid, quantity, price) VALUES(17, 16, 1, 35);
INSERT INTO carts (uid, pid, quantity, price) VALUES(17, 15, 1, 649);
INSERT INTO carts (uid, pid, quantity, price) VALUES(18, 14, 8, 1299);
INSERT INTO carts (uid, pid, quantity, price) VALUES(18, 13, 1, 399);


/* sales table */

INSERT INTO sales (uid, pid, quantity, price) VALUES(1,  1,  1, 100);
INSERT INTO sales (uid, pid, quantity, price) VALUES(1,  2,  1, 20);
INSERT INTO sales (uid, pid, quantity, price) VALUES(2,  3,  1, 89);
INSERT INTO sales (uid, pid, quantity, price) VALUES(2,  4,  1, 599);
INSERT INTO sales (uid, pid, quantity, price) VALUES(3,  5,  2, 4);
INSERT INTO sales (uid, pid, quantity, price) VALUES(3,  6,  1, 8);
INSERT INTO sales (uid, pid, quantity, price) VALUES(4,  7,  1, 5);
INSERT INTO sales (uid, pid, quantity, price) VALUES(4,  8,  1, 7);
INSERT INTO sales (uid, pid, quantity, price) VALUES(5,  9,  1, 120);
INSERT INTO sales (uid, pid, quantity, price) VALUES(5,  10, 3, 25);
INSERT INTO sales (uid, pid, quantity, price) VALUES(6,  11, 1, 10);
INSERT INTO sales (uid, pid, quantity, price) VALUES(6,  12, 1, 8);
INSERT INTO sales (uid, pid, quantity, price) VALUES(7,  13, 1, 399);
INSERT INTO sales (uid, pid, quantity, price) VALUES(7,  14, 1, 1299);
INSERT INTO sales (uid, pid, quantity, price) VALUES(8,  15, 4, 649);
INSERT INTO sales (uid, pid, quantity, price) VALUES(8,  16, 1, 35);
INSERT INTO sales (uid, pid, quantity, price) VALUES(9,  17, 1, 5);
INSERT INTO sales (uid, pid, quantity, price) VALUES(9,  18, 1, 1);
INSERT INTO sales (uid, pid, quantity, price) VALUES(10, 19, 1, 15);
INSERT INTO sales (uid, pid, quantity, price) VALUES(10, 20, 5, 8);
INSERT INTO sales (uid, pid, quantity, price) VALUES(11, 21, 1, 100);
INSERT INTO sales (uid, pid, quantity, price) VALUES(11, 22, 1, 40);
INSERT INTO sales (uid, pid, quantity, price) VALUES(12, 23, 1, 200);
INSERT INTO sales (uid, pid, quantity, price) VALUES(12, 24, 1, 400);
INSERT INTO sales (uid, pid, quantity, price) VALUES(13, 24, 6, 400);
INSERT INTO sales (uid, pid, quantity, price) VALUES(13, 23, 1, 200);
INSERT INTO sales (uid, pid, quantity, price) VALUES(14, 22, 1, 40);
INSERT INTO sales (uid, pid, quantity, price) VALUES(14, 21, 1, 100);
INSERT INTO sales (uid, pid, quantity, price) VALUES(15, 20, 1, 8);
INSERT INTO sales (uid, pid, quantity, price) VALUES(15, 19, 7, 15);
INSERT INTO sales (uid, pid, quantity, price) VALUES(16, 18, 1, 1);
INSERT INTO sales (uid, pid, quantity, price) VALUES(16, 17, 1, 5);
INSERT INTO sales (uid, pid, quantity, price) VALUES(17, 16, 1, 35);
INSERT INTO sales (uid, pid, quantity, price) VALUES(17, 15, 1, 649);
INSERT INTO sales (uid, pid, quantity, price) VALUES(18, 14, 8, 1299);
INSERT INTO sales (uid, pid, quantity, price) VALUES(18, 13, 1, 399);


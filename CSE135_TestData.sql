--//---- Pre-populate DB with the following data ----//--

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

INSERT INTO Roles VALUES('Customer');
INSERT INTO Roles VALUES('Owner');

--//---- End pre-populated data ----//--


INSERT INTO Users (name, role, age, state) VALUES('Jasmine', 'Customer', 20, 'CA');
INSERT INTO Users (name, role, age, state) VALUES('Allen',   'Customer', 20, 'CA');
INSERT INTO Users (name, role, age, state) VALUES('Dhruv',   'Customer', 20, 'CA');
INSERT INTO Users (name, role, age, state) VALUES('Yannis',  'Owner',    50, 'NY');
INSERT INTO Users (name, role, age, state) VALUES('Jack',    'Owner',    21, 'TN');
INSERT INTO Users (name, role, age, state) VALUES('Jill',    'Owner',    22, 'CO');

INSERT INTO Categories (name, description) VALUES('Clothing',    'things you wear');
INSERT INTO Categories (name, description) VALUES('Electronics', 'nerd stuff');
INSERT INTO Categories (name, description) VALUES('Food',        'nom nom nom');
INSERT INTO Categories (name, description) VALUES('Furniture',   'comfy');
/*INSERT INTO Categories VALUES('Wee', 'wee');*/

INSERT INTO Products (name, sku, category, price) VALUES('jeans',       'C001',  1,   80);
INSERT INTO Products (name, sku, category, price) VALUES('t-shirt',     'C002',  1,   10);
INSERT INTO Products (name, sku, category, price) VALUES('leggings',    'C003',  1,   10);
INSERT INTO Products (name, sku, category, price) VALUES('nexus 5',     'E001',  2,   400);
INSERT INTO Products (name, sku, category, price) VALUES('iphone 5s',   'E002',  2,   649);
INSERT INTO Products (name, sku, category, price) VALUES('macbook pro', 'E003',  2,   1299);
INSERT INTO Products (name, sku, category, price) VALUES('bacon',       'F001',  3,   5);
INSERT INTO Products (name, sku, category, price) VALUES('cheetos',     'F002',  3,   1);
INSERT INTO Products (name, sku, category, price) VALUES('coffee',      'F003',  3,   2);
INSERT INTO Products (name, sku, category, price) VALUES('desk',        'FR001', 4,   90);
INSERT INTO Products (name, sku, category, price) VALUES('chair',       'FR002', 4,   20);
INSERT INTO Products (name, sku, category, price) VALUES('sofa',        'FR003', 4,   60);
INSERT INTO Products (name, sku, category, price) VALUES('bed',         'FR004', 4,   100);

INSERT INTO Shopping_Cart VALUES(1, 4, 1);
INSERT INTO Shopping_Cart VALUES(1, 6, 1);
INSERT INTO Shopping_Cart VALUES(2, 6, 1);
INSERT INTO Shopping_Cart VALUES(3, 4, 1);
INSERT INTO Shopping_Cart VALUES(3, 9, 1);


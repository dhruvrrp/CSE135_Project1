/* Papa Yannis's syntax */

DROP TABLE IF EXISTS Users CASCADE;
CREATE TABLE Users
(
   user_id    SERIAL     PRIMARY KEY,
   name           VARCHAR(50)    NOT NULL UNIQUE,
   role           VARCHAR(8)     NOT NULL,
   age            INTEGER        NOT NULL,
   state          VARCHAR(20)    NOT NULL,
   CHECK          (name <> '')
);

DROP TABLE IF EXISTS States CASCADE;
CREATE TABLE States
(
    state_id      VARCHAR(2)     PRIMARY KEY,
    state         VARCHAR(20)
);

DROP TABLE IF EXISTS Roles CASCADE;
CREATE TABLE Roles
(
    role          VARCHAR(8)
);

DROP TABLE IF EXISTS Categories CASCADE;
CREATE TABLE Categories
(
    category_id   SERIAL     PRIMARY KEY,
    name          VARCHAR(20)    NOT NULL UNIQUE,
    description   TEXT,
    CHECK         (name <> '')
);

DROP TABLE IF EXISTS Products CASCADE;
CREATE TABLE Products
(
    product_id    SERIAL     PRIMARY KEY,
    name          VARCHAR(30),
    sku           VARCHAR(10)    NOT NULL UNIQUE,
    category      INTEGER        REFERENCES Categories(category_id) ON UPDATE CASCADE,
    price         FLOAT,
    CHECK         (sku <> ''),
    CHECK         (price >= 0)
);

DROP TABLE IF EXISTS Shopping_Cart CASCADE;
CREATE TABLE Shopping_Cart
(
    customer_name INTEGER    REFERENCES Users (user_id),
    product_sku   INTEGER    REFERENCES Products(product_id),
    product_price FLOAT,
    quantity      INTEGER
);

/* PRODUCT_ORDER CHANGED NAME TO SHOPPING_CART
     ALSO ADDED PRODUCT_PRICE ATTR */









/* Conventional Postgres way */
/*
DROP TABLE IF EXISTS Users CASCADE;
CREATE TABLE Users
(
    name          varchar(100),
    role          varchar(8),
    age           integer,
    state         varchar(25),
    PRIMARY KEY   (name)
);

DROP TABLE IF EXISTS States CASCADE;
CREATE TABLE States
(
    state_id      varchar(2)
    state         varchar(100) 
);

DROP TABLE IF EXISTS Roles CASCADE;
CREATE TABLE Roles
(
    role          varchar(8)
);

DROP TABLE IF EXISTS Categories CASCADE;
CREATE TABLE Categories
(
    name          varchar(20),
    description   varchar(100),
    PRIMARY KEY   (name)
);

DROP TABLE IF EXISTS Products CASCADE;
CREATE TABLE Products
(
    name          varchar(20),
    sku           varchar(20),
    category      varchar(20),
    price         integer,
    PRIMARY KEY   (sku),
    FOREIGN KEY   (category)      REFERENCES Categories(name),
    CHECK         (price >= 0)
);

DROP TABLE IF EXISTS Product_Order CASCADE;
CREATE TABLE Product_Order
(
    customer_name varchar(20),
    product_sku   varchar(20),
    quantity      integer,
    FOREIGN KEY   (customer_name) REFERENCES Users(name),
    FOREIGN KEY   (product_sku)   REFERENCES Products(sku)
);
*/

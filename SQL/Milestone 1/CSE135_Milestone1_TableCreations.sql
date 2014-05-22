CREATE TABLE Users
(
   user_id        SERIAL         PRIMARY KEY,
   name           VARCHAR(50)    NOT NULL UNIQUE,
   role           VARCHAR(8)     NOT NULL,
   age            INTEGER        NOT NULL,
   state          VARCHAR(20)    NOT NULL,
   CHECK          (name <> '')
);

CREATE TABLE States
(
    state_id      VARCHAR(2)     PRIMARY KEY,
    state         VARCHAR(20)
);

CREATE TABLE Roles
(
    role          VARCHAR(8)
);

CREATE TABLE Categories
(
    category_id   SERIAL         PRIMARY KEY,
    name          VARCHAR(20)    NOT NULL UNIQUE,
    description   TEXT,
    CHECK         (name <> '')
);

CREATE TABLE Products
(
    product_id    SERIAL         PRIMARY KEY,
    name          VARCHAR(30) 	 NOT NULL,
    sku           VARCHAR(10)    NOT NULL UNIQUE,
    category      INTEGER        REFERENCES Categories(category_id) ON UPDATE CASCADE,
    price         FLOAT 		 NOT NULL,
    CHECK         (sku <> ''),
    CHECK         (price >= 0)
);

CREATE TABLE Shopping_Cart
(
    customer_name INTEGER    REFERENCES Users (user_id),
    product_sku   INTEGER    REFERENCES Products(product_id),
    quantity      INTEGER
);

/* Check ON UPDATE CASCADE for product_sku and customer_name FKs */










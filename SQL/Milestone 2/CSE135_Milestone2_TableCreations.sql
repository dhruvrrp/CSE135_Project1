DROP TABLE IF EXISTS states CASCADE;
CREATE TABLE states
(
    state_id    TEXT     PRIMARY KEY,
    state       TEXT
);


DROP TABLE IF EXISTS users CASCADE;
CREATE TABLE users 
(
    id          SERIAL  PRIMARY KEY,
    name        TEXT    NOT NULL UNIQUE,
    role        TEXT    NOT NULL,
    age   	INTEGER NOT NULL,
    state  	TEXT    NOT NULL
);


DROP TABLE IF EXISTS categories CASCADE;
CREATE TABLE categories 
(
    id          SERIAL  PRIMARY KEY,
    name        TEXT    NOT NULL UNIQUE,
    description TEXT
);


DROP TABLE IF EXISTS products CASCADE;
CREATE TABLE products 
(
    id          SERIAL  PRIMARY KEY,
    cid         INTEGER REFERENCES categories (id) ON DELETE CASCADE,
    name        TEXT    NOT NULL,
    SKU         TEXT    NOT NULL UNIQUE,
    price       INTEGER NOT NULL
);


DROP TABLE IF EXISTS carts CASCADE;
CREATE TABLE carts 
(
    id          SERIAL  PRIMARY KEY,
    uid         INTEGER REFERENCES users      (id) ON DELETE CASCADE,
    pid         INTEGER REFERENCES products   (id) ON DELETE CASCADE,
    quantity    INTEGER NOT NULL,
    price	INTEGER NOT NULL
);


DROP TABLE IF EXISTS sales CASCADE;
CREATE TABLE sales 
(
    id          SERIAL  PRIMARY KEY,
    uid         INTEGER REFERENCES users      (id) ON DELETE CASCADE,
    pid         INTEGER REFERENCES products   (id) ON DELETE CASCADE,
    quantity    INTEGER NOT NULL,
    price	INTEGER NOT NULL
);

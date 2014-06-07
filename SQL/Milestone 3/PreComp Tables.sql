/*DROP TABLE IF EXISTS PreCompProductsRow; 
CREATE TABLE PreCompProductsRow AS 
(
    SELECT SUM(sales.quantity*sales.price) AS total, 
           products.name,
           users.state, 
           products.cid
    FROM (sales INNER JOIN users ON sales.uid = users.id) 
         RIGHT OUTER JOIN products ON products.id = sales.pid 
    GROUP BY users.state, products.name, products.cid
);


DROP TABLE IF EXISTS PreCompStaCusCol; 
CREATE TABLE PreCompStaCusCol AS
(
    SELECT SUM(sales.quantity*sales.price) AS total, users.name, users.state, products.cid
    FROM (sales INNER JOIN users ON sales.uid = users.id) 
         RIGHT OUTER JOIN products ON products.id = sales.pid
    GROUP BY users.state, users.name, products.cid 
);*/


DROP TABLE IF EXISTS PreCompProductsRow CASCADE; 
CREATE TABLE PreCompProductsRow AS 
(
    SELECT total, 
           products.name,
           foo.state, 
           products.cid
           
    FROM (
    SELECT SUM(sales.quantity*sales.price) AS total, users.state, users.id, sales.pid
    FROM users, sales
    WHERE sales.uid = users.id
    GROUP BY users.state, users.id, sales.pid) AS foo
    RIGHT OUTER JOIN products 
    ON products.id = foo.pid
    GROUP BY total, foo.state, products.name, products.cid
);


DROP TABLE IF EXISTS PreCompStaCusCol CASCADE; 
CREATE TABLE PreCompStaCusCol AS
(
   SELECT total, 
           users.name,
           users.state, 
           foo.cid
          
           
    FROM (
    SELECT SUM(sales.quantity*sales.price) AS total, sales.uid, products.cid
    FROM products, sales
    WHERE sales.pid = products.id
    GROUP BY sales.uid, products.cid) AS foo
    RIGHT OUTER JOIN users 
    ON users.id = foo.uid
    GROUP BY total, users.state, users.name, foo.cid

);
 /*   SELECT total, 
           users.name,
           users.state, 
           foo.cid,
           foo.id
           
    FROM (
    SELECT SUM(sales.quantity*sales.price) AS total, sales.uid, products.cid, sales.id
    FROM products, sales
    WHERE sales.pid = products.id
    GROUP BY sales.uid, products.cid, sales.id) AS foo
    RIGHT OUTER JOIN users 
    ON users.id = foo.uid
    GROUP BY total, users.state, users.name, foo.cid, foo.id
);*/

DROP TABLE IF EXISTS PreCompCells CASCADE; 
CREATE TABLE PreCompCells AS
(
    SELECT SUM(quantity* sales.price) AS total, products.name, users.state, users.name AS nam
    FROM sales INNER JOIN products ON sales.pid = products.id 
         RIGHT OUTER JOIN users ON users.id = sales.uid 
    GROUP BY users.state, products.name, users.name
);

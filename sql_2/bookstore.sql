-- ============================================================
--  BOOKSTORE DATABASE
--  Normalized to Third Normal Form (3NF)
--
--  Tables:
--    authors      – stores author details (no transitive deps)
--    books        – stores book details; references authors
--    customers    – stores customer contact info
--    orders       – one order per customer transaction
--    order_items  – line items; links orders to books
--
--  3NF justification:
--    1NF  – every column is atomic; every row has a PK
--    2NF  – no partial dependencies (all PKs are single-column)
--    3NF  – no transitive dependencies; author attributes live
--           in 'authors', not repeated inside 'books'
-- ============================================================


-- ------------------------------------------------------------
-- 0. CLEAN SLATE  (drop in reverse FK order)
-- ------------------------------------------------------------
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS authors;


-- ------------------------------------------------------------
-- 1. CREATE TABLES
-- ------------------------------------------------------------

CREATE TABLE authors (
    author_id  INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT    NOT NULL,
    last_name  TEXT    NOT NULL,
    country    TEXT    NOT NULL
);

CREATE TABLE books (
    book_id        INTEGER PRIMARY KEY AUTOINCREMENT,
    title          TEXT    NOT NULL,
    author_id      INTEGER NOT NULL,
    genre          TEXT    NOT NULL,
    price          REAL    NOT NULL,
    year_published INTEGER NOT NULL,
    FOREIGN KEY (author_id) REFERENCES authors(author_id)
);

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name  TEXT NOT NULL,
    last_name   TEXT NOT NULL,
    email       TEXT NOT NULL UNIQUE,
    phone       TEXT
);

CREATE TABLE orders (
    order_id    INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id INTEGER NOT NULL,
    order_date  TEXT    NOT NULL,
    status      TEXT    NOT NULL DEFAULT 'pending',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    item_id    INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id   INTEGER NOT NULL,
    book_id    INTEGER NOT NULL,
    quantity   INTEGER NOT NULL DEFAULT 1,
    unit_price REAL    NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (book_id)  REFERENCES books(book_id)
);


-- ------------------------------------------------------------
-- 2. INSERT DATA
-- ------------------------------------------------------------

-- Authors
INSERT INTO authors (first_name, last_name, country) VALUES
    ('George',   'Orwell',     'United Kingdom'),
    ('Harper',   'Lee',        'United States'),
    ('J.K.',     'Rowling',    'United Kingdom'),
    ('F. Scott', 'Fitzgerald', 'United States'),
    ('Toni',     'Morrison',   'United States');

-- Books  (author_id references authors above)
INSERT INTO books (title, author_id, genre, price, year_published) VALUES
    ('1984',                                    1, 'Dystopian',  12.99, 1949),
    ('Animal Farm',                             1, 'Satire',      9.99, 1945),
    ('To Kill a Mockingbird',                   2, 'Fiction',    14.99, 1960),
    ('Harry Potter and the Sorcerer''s Stone',  3, 'Fantasy',    19.99, 1997),
    ('The Great Gatsby',                        4, 'Classic',    11.99, 1925),
    ('Beloved',                                 5, 'Historical', 13.99, 1987),
    ('Harry Potter and the Chamber of Secrets', 3, 'Fantasy',    19.99, 1998);

-- Customers
INSERT INTO customers (first_name, last_name, email, phone) VALUES
    ('Alice', 'Johnson',  'alice.johnson@email.com',  '555-1001'),
    ('Bob',   'Smith',    'bob.smith@email.com',      '555-1002'),
    ('Carol', 'Williams', 'carol.williams@email.com', '555-1003'),
    ('David', 'Brown',    'david.brown@email.com',    '555-1004'),
    ('Eve',   'Davis',    'eve.davis@email.com',      '555-1005');

-- Orders
INSERT INTO orders (customer_id, order_date, status) VALUES
    (1, '2025-01-10', 'completed'),   -- order_id 1 : Alice
    (2, '2025-01-15', 'completed'),   -- order_id 2 : Bob
    (3, '2025-02-01', 'completed'),   -- order_id 3 : Carol
    (4, '2025-02-14', 'completed'),   -- order_id 4 : David
    (1, '2025-03-05', 'pending');     -- order_id 5 : Alice (second order)

-- Order items
-- Order 1 (Alice): 1984 + The Great Gatsby  = 12.99 + 11.99 = 24.98
INSERT INTO order_items (order_id, book_id, quantity, unit_price) VALUES
    (1, 1, 1, 12.99),
    (1, 5, 1, 11.99);

-- Order 2 (Bob): HP Sorcerer's Stone        = 19.99
INSERT INTO order_items (order_id, book_id, quantity, unit_price) VALUES
    (2, 4, 1, 19.99);

-- Order 3 (Carol): Animal Farm + Mockingbird = 9.99 + 14.99 = 24.98
INSERT INTO order_items (order_id, book_id, quantity, unit_price) VALUES
    (3, 2, 1,  9.99),
    (3, 3, 1, 14.99);

-- Order 4 (David): To Kill a Mockingbird    = 14.99
INSERT INTO order_items (order_id, book_id, quantity, unit_price) VALUES
    (4, 3, 1, 14.99);

-- Order 5 (Alice): Beloved                  = 13.99
INSERT INTO order_items (order_id, book_id, quantity, unit_price) VALUES
    (5, 6, 1, 13.99);

-- Temporary customer to demonstrate DELETE
INSERT INTO customers (first_name, last_name, email, phone) VALUES
    ('Temp', 'User', 'temp.delete@email.com', '555-0000');


-- ============================================================
-- 3. SELECT STATEMENTS
-- ============================================================

-- 3a. All books joined with their author  (two-table join for rubric)
SELECT
    b.book_id,
    b.title,
    a.first_name || ' ' || a.last_name AS author_name,
    a.country                          AS author_country,
    b.genre,
    b.price,
    b.year_published
FROM   books   b
JOIN   authors a ON b.author_id = a.author_id
ORDER  BY b.book_id;

-- 3b. Full order history: customer → order → items → book
SELECT
    c.first_name || ' ' || c.last_name AS customer_name,
    o.order_id,
    o.order_date,
    o.status,
    b.title                            AS book_title,
    oi.quantity,
    oi.unit_price,
    oi.quantity * oi.unit_price        AS line_total
FROM   customers   c
JOIN   orders      o  ON c.customer_id = o.customer_id
JOIN   order_items oi ON o.order_id    = oi.order_id
JOIN   books       b  ON oi.book_id    = b.book_id
ORDER  BY o.order_date, o.order_id;

-- 3c. Total spent per customer
SELECT
    c.first_name || ' ' || c.last_name    AS customer_name,
    COUNT(DISTINCT o.order_id)            AS total_orders,
    SUM(oi.quantity * oi.unit_price)      AS total_spent
FROM   customers   c
JOIN   orders      o  ON c.customer_id = o.customer_id
JOIN   order_items oi ON o.order_id    = oi.order_id
GROUP  BY c.customer_id
ORDER  BY total_spent DESC;

-- 3d. All books priced above $13 with author country
SELECT
    b.title,
    b.price,
    a.first_name || ' ' || a.last_name AS author_name,
    a.country
FROM   books   b
JOIN   authors a ON b.author_id = a.author_id
WHERE  b.price > 13.00
ORDER  BY b.price DESC;


-- ============================================================
-- 4. UPDATE STATEMENTS
-- ============================================================

-- 4a. Raise the price of '1984' after a new edition is released
UPDATE books
SET    price = 14.99
WHERE  book_id = 1;

-- 4b. Update Bob's phone number (customer_id 2)
UPDATE customers
SET    phone = '555-8888'
WHERE  customer_id = 2;

-- 4c. Mark Alice's pending order as 'shipped'
UPDATE orders
SET    status = 'shipped'
WHERE  order_id = 5;


-- ============================================================
-- 5. DELETE STATEMENTS
-- ============================================================

-- 5a. Remove the temporary placeholder customer inserted above
DELETE FROM customers
WHERE  email = 'temp.delete@email.com';

-- 5b. Cancel one item from order 1 (remove The Great Gatsby line)
DELETE FROM order_items
WHERE  order_id = 1
AND    book_id  = 5;


-- ============================================================
-- 6. VERIFY FINAL STATE  (run these to confirm all changes)
-- ============================================================

-- All authors
SELECT * FROM authors;

-- All books (note '1984' price is now 14.99)
SELECT * FROM books;

-- All customers (temp user gone; Bob has new phone)
SELECT * FROM customers;

-- All orders (order 5 is now 'shipped')
SELECT * FROM orders;

-- All order items (Great Gatsby line removed from order 1)
SELECT * FROM order_items;

-- Final join: books with authors (screenshot-ready two-table query)
SELECT
    b.book_id,
    b.title,
    a.first_name || ' ' || a.last_name AS author_name,
    a.country                          AS author_country,
    b.genre,
    b.price,
    b.year_published
FROM   books   b
JOIN   authors a ON b.author_id = a.author_id
ORDER  BY b.book_id;

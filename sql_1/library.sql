-- Final Project: Library Management Database
-- Database contains 4 tables, all populated with data

CREATE DATABASE IF NOT EXISTS library_management;
USE library_management;

-- Table 1: authors
CREATE TABLE IF NOT EXISTS authors (
    author_id   INT          NOT NULL AUTO_INCREMENT,
    first_name  VARCHAR(50)  NOT NULL,
    last_name   VARCHAR(50)  NOT NULL,
    birth_year  INT,
    nationality VARCHAR(50),
    PRIMARY KEY (author_id)
);

-- Table 2: books
CREATE TABLE IF NOT EXISTS books (
    book_id       INT           NOT NULL AUTO_INCREMENT,
    title         VARCHAR(150)  NOT NULL,
    author_id     INT           NOT NULL,
    genre         VARCHAR(50),
    publish_year  INT,
    total_copies  INT           NOT NULL DEFAULT 1,
    PRIMARY KEY (book_id),
    FOREIGN KEY (author_id) REFERENCES authors(author_id)
);

-- Table 3: members
CREATE TABLE IF NOT EXISTS members (
    member_id    INT          NOT NULL AUTO_INCREMENT,
    first_name   VARCHAR(50)  NOT NULL,
    last_name    VARCHAR(50)  NOT NULL,
    email        VARCHAR(100) NOT NULL UNIQUE,
    join_date    DATE         NOT NULL,
    phone_number VARCHAR(20),
    PRIMARY KEY (member_id)
);

-- Table 4: loans
CREATE TABLE IF NOT EXISTS loans (
    loan_id       INT  NOT NULL AUTO_INCREMENT,
    book_id       INT  NOT NULL,
    member_id     INT  NOT NULL,
    loan_date     DATE NOT NULL,
    due_date      DATE NOT NULL,
    return_date   DATE,
    PRIMARY KEY (loan_id),
    FOREIGN KEY (book_id)   REFERENCES books(book_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- -------------------------------------------------------
-- Populate authors (4 rows)
-- -------------------------------------------------------
INSERT INTO authors (first_name, last_name, birth_year, nationality) VALUES
    ('George',    'Orwell',      1903, 'British'),
    ('Harper',    'Lee',         1926, 'American'),
    ('J.K.',      'Rowling',     1965, 'British'),
    ('Gabriel',   'Garcia Marquez', 1927, 'Colombian');

-- -------------------------------------------------------
-- Populate books (4 rows)
-- -------------------------------------------------------
INSERT INTO books (title, author_id, genre, publish_year, total_copies) VALUES
    ('1984',                                  1, 'Dystopian',       1949, 3),
    ('To Kill a Mockingbird',                 2, 'Southern Gothic', 1960, 2),
    ('Harry Potter and the Sorcerer Stone',   3, 'Fantasy',         1997, 5),
    ('One Hundred Years of Solitude',         4, 'Magical Realism', 1967, 2);

-- -------------------------------------------------------
-- Populate members (4 rows)
-- -------------------------------------------------------
INSERT INTO members (first_name, last_name, email, join_date, phone_number) VALUES
    ('Alice',   'Johnson', 'alice.johnson@email.com',  '2024-01-15', '555-0101'),
    ('Brian',   'Smith',   'brian.smith@email.com',    '2024-02-20', '555-0102'),
    ('Carmen',  'Rivera',  'carmen.rivera@email.com',  '2024-03-05', '555-0103'),
    ('David',   'Kim',     'david.kim@email.com',      '2024-04-10', '555-0104');

-- -------------------------------------------------------
-- Populate loans (4 rows)
-- -------------------------------------------------------
INSERT INTO loans (book_id, member_id, loan_date, due_date, return_date) VALUES
    (1, 1, '2025-01-10', '2025-01-24', '2025-01-22'),
    (2, 2, '2025-02-01', '2025-02-15', NULL),
    (3, 3, '2025-02-10', '2025-02-24', '2025-02-20'),
    (4, 4, '2025-03-01', '2025-03-15', NULL);

-- -------------------------------------------------------
-- DESCRIBE all table structures
-- -------------------------------------------------------
DESCRIBE authors;
DESCRIBE books;
DESCRIBE members;
DESCRIBE loans;

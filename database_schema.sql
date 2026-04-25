```sql
-- 创建图书管理系统数据库
CREATE DATABASE IF NOT EXISTS book_management CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 使用数据库
USE book_management;

-- 创建用户表
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    real_name VARCHAR(100) NOT NULL,
    role ENUM('ADMIN', 'USER') NOT NULL DEFAULT 'USER',
    status ENUM('ACTIVE', 'INACTIVE', 'DELETED', 'PENDING') NOT NULL DEFAULT 'ACTIVE',
    create_time DATETIME NOT NULL
);

-- 创建图书表
CREATE TABLE books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author VARCHAR(100) NOT NULL,
    isbn VARCHAR(20) UNIQUE,
    publisher VARCHAR(100),
    publish_date DATE,
    category VARCHAR(50),
    total_copies INT NOT NULL DEFAULT 0,
    available_copies INT NOT NULL DEFAULT 0,
    create_time DATETIME NOT NULL,
    CONSTRAINT chk_copies CHECK (available_copies >= 0 AND available_copies <= total_copies)
);

-- 创建借阅记录表
CREATE TABLE borrow_records (
    id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    user_id INT NOT NULL,
    borrow_date DATETIME NOT NULL,
    expected_return_date DATETIME NOT NULL,
    actual_return_date DATETIME NULL,
    status ENUM('BORROWED', 'RETURNED', 'OVERDUE') NOT NULL DEFAULT 'BORROWED',
    FOREIGN KEY (book_id) REFERENCES books(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 创建索引以提高查询性能
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_create_time ON users(create_time);
CREATE INDEX idx_books_title ON books(title);
CREATE INDEX idx_books_author ON books(author);
CREATE INDEX idx_books_category ON books(category);
CREATE INDEX idx_books_create_time ON books(create_time);
CREATE INDEX idx_borrow_records_user_id ON borrow_records(user_id);
CREATE INDEX idx_borrow_records_book_id ON borrow_records(book_id);
CREATE INDEX idx_borrow_records_status ON borrow_records(status);
CREATE INDEX idx_borrow_records_borrow_date ON borrow_records(borrow_date);

-- 插入初始化数据

-- 插入管理员用户 (密码: admin123)
INSERT INTO users (username, password, real_name, role, status, create_time) VALUES
('admin', '$2a$10$N.zmdr9k7uOCQb0bta/OauRxaOKSr.QhqyD2R5FKvMQjmHoLkm5Sy', '系统管理员', 'ADMIN', 'ACTIVE', '2025-01-01 09:00:00');

-- 插入测试用户 (密码: user123)
INSERT INTO users (username, password, real_name, role, status, create_time) VALUES
('user1', '$2a$10$Fv3/.hv47/kB39mX41wzKO4Qq43nOW6/ZbPGsVmWQgJRR8xs5vVOe', '张三', 'USER', 'ACTIVE', '2025-01-02 10:00:00'),
('user2', '$2a$10$Fv3/.hv47/kB39mX41wzKO4Qq43nOW6/ZbPGsVmWQgJRR8xs5vVOe', '李四', 'USER', 'ACTIVE', '2025-01-03 11:00:00'),
('user3', '$2a$10$Fv3/.hv47/kB39mX41wzKO4Qq43nOW6/ZbPGsVmWQgJRR8xs5vVOe', '王五', 'USER', 'INACTIVE', '2025-01-04 12:00:00'),
('user4', '$2a$10$Fv3/.hv47/kB39mX41wzKO4Qq43nOW6/ZbPGsVmWQgJRR8xs5vVOe', '赵六', 'USER', 'PENDING', '2025-01-05 13:00:00'),
('user5', '$2a$10$Fv3/.hv47/kB39mX41wzKO4Qq43nOW6/ZbPGsVmWQgJRR8xs5vVOe', '钱七', 'USER', 'ACTIVE', '2025-01-06 14:00:00'),
('user6', '$2a$10$Fv3/.hv47/kB39mX41wzKO4Qq43nOW6/ZbPGsVmWQgJRR8xs5vVOe', '孙八', 'USER', 'ACTIVE', '2025-01-07 15:00:00'),
('user7', '$2a$10$Fv3/.hv47/kB39mX41wzKO4Qq43nOW6/ZbPGsVmWQgJRR8xs5vVOe', '周九', 'USER', 'DELETED', '2025-01-08 16:00:00'),
('user8', '$2a$10$Fv3/.hv47/kB39mX41wzKO4Qq43nOW6/ZbPGsVmWQgJRR8xs5vVOe', '吴十', 'USER', 'ACTIVE', '2025-01-09 17:00:00'),
('user9', '$2a$10$Fv3/.hv47/kB39mX41wzKO4Qq43nOW6/ZbPGsVmWQgJRR8xs5vVOe', '郑一', 'USER', 'ACTIVE', '2025-01-10 18:00:00');

-- 插入测试图书
INSERT INTO books (title, author, isbn, publisher, publish_date, category, total_copies, available_copies, create_time) VALUES
('Java编程思想', 'Bruce Eckel', '9787111213826', '机械工业出版社', '2007-06-01', '编程', 5, 2, '2025-01-01 09:30:00'),
('深入理解Java虚拟机', '周志明', '9787115262341', '机械工业出版社', '2011-09-01', '编程', 3, 0, '2025-01-02 10:30:00'),
('设计模式', 'Gang of Four', '9787115275441', '机械工业出版社', '2012-01-01', '编程', 4, 1, '2025-01-03 11:30:00'),
('算法导论', 'Thomas H. Cormen', '9787111274757', '机械工业出版社', '2009-08-01', '数学', 2, 0, '2025-01-04 12:30:00'),
('数据库系统概念', 'Abraham Silberschatz', '9787111274758', '机械工业出版社', '2009-08-01', '数据库', 3, 2, '2025-01-05 13:30:00'),
('计算机网络', 'Andrew S. Tanenbaum', '9787115274759', '机械工业出版社', '2012-03-01', '网络', 4, 3, '2025-01-06 14:30:00'),
('操作系统概念', 'Abraham Silberschatz', '9787115274760', '机械工业出版社', '2012-03-01', '系统', 2, 0, '2025-01-07 15:30:00'),
('C++ Primer', 'Stanley B. Lippman', '9787115274761', '中国电力出版社', '2012-03-01', '编程', 3, 1, '2025-01-08 16:30:00'),
('JavaScript高级程序设计', 'Nicholas C. Zakas', '9787115274762', '人民邮电出版社', '2012-03-01', '编程', 4, 4, '2025-01-09 17:30:00'),
('Python核心编程', 'Wesley J. Chun', '9787115274763', '人民邮电出版社', '2012-03-01', '编程', 3, 2, '2025-01-10 18:30:00');

-- 插入测试借阅记录
INSERT INTO borrow_records (book_id, user_id, borrow_date, expected_return_date, actual_return_date, status) VALUES
(1, 2, '2025-10-20 10:00:00', '2025-11-20 10:00:00', NULL, 'BORROWED'),
(2, 3, '2025-10-15 11:00:00', '2025-11-15 11:00:00', NULL, 'OVERDUE'),
(3, 4, '2025-10-10 12:00:00', '2025-11-10 12:00:00', '2025-11-05 14:00:00', 'RETURNED'),
(4, 5, '2025-10-05 13:00:00', '2025-11-05 13:00:00', NULL, 'OVERDUE'),
(5, 6, '2025-10-01 14:00:00', '2025-11-01 14:00:00', '2025-10-25 16:00:00', 'RETURNED'),
(6, 2, '2025-10-25 15:00:00', '2025-11-25 15:00:00', NULL, 'BORROWED'),
(7, 8, '2025-10-18 16:00:00', '2025-11-18 16:00:00', NULL, 'OVERDUE'),
(1, 9, '2025-10-22 17:00:00', '2025-11-22 17:00:00', NULL, 'BORROWED'),
(3, 10, '2025-10-12 18:00:00', '2025-11-12 18:00:00', '2025-11-10 19:00:00', 'RETURNED'),
(5, 2, '2025-10-08 19:00:00', '2025-11-08 19:00:00', NULL, 'OVERDUE'),
(6, 3, '2025-10-28 10:00:00', '2025-11-28 10:00:00', NULL, 'BORROWED'),
(8, 4, '2025-10-14 11:00:00', '2025-11-14 11:00:00', '2025-11-12 12:00:00', 'RETURNED'),
(9, 5, '2025-10-03 12:00:00', '2025-11-03 12:00:00', NULL, 'OVERDUE'),
(10, 6, '2025-10-26 13:00:00', '2025-11-26 13:00:00', NULL, 'BORROWED'),
(1, 7, '2025-10-16 14:00:00', '2025-11-16 14:00:00', '2025-11-14 15:00:00', 'RETURNED'),
(2, 8, '2025-10-06 15:00:00', '2025-11-06 15:00:00', NULL, 'OVERDUE'),
(4, 9, '2025-10-29 16:00:00', '2025-11-29 16:00:00', NULL, 'BORROWED'),
(7, 10, '2025-10-09 17:00:00', '2025-11-09 17:00:00', '2025-11-07 18:00:00', 'RETURNED'),
(8, 2, '2025-10-19 18:00:00', '2025-11-19 18:00:00', NULL, 'BORROWED'),
(9, 3, '2025-10-11 19:00:00', '2025-11-11 19:00:00', '2025-11-09 20:00:00', 'RETURNED');
```
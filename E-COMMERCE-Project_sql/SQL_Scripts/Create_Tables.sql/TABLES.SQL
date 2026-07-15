-- =====================================================================
-- TABLES.sql
-- E-COMMERCE DATABASE SCHEMA (DDL only — no data)
-- Engine: MySQL 8.0+
-- Modules: User & Auth | Product & Inventory | Orders & Cart | Payment/Shipping/Reviews
-- =====================================================================

CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

SET FOREIGN_KEY_CHECKS = 0;

-- =====================================================================
-- MODULE 1: USER & AUTHENTICATION
-- =====================================================================

DROP TABLE IF EXISTS addresses;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    user_id         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    first_name      VARCHAR(100) NOT NULL,
    last_name       VARCHAR(100) NOT NULL,
    email           VARCHAR(255) NOT NULL UNIQUE,
    password_hash   VARCHAR(255) NOT NULL,
    phone           VARCHAR(20),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP)
   

CREATE TABLE addresses (
    address_id      BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id         BIGINT UNSIGNED NOT NULL,
    street_address  VARCHAR(255) NOT NULL,
    city            VARCHAR(100) NOT NULL,
    state           VARCHAR(100) NOT NULL,
    postal_code     VARCHAR(20) NOT NULL,
    country         VARCHAR(100) NOT NULL,
    is_default      BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_addresses_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE)
    

-- =====================================================================
-- MODULE 2: PRODUCT & INVENTORY
-- =====================================================================

DROP TABLE IF EXISTS inventory;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;

CREATE TABLE categories (
    category_id         BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    category_name       VARCHAR(150) NOT NULL,
    parent_category_id  BIGINT UNSIGNED DEFAULT NULL,
    CONSTRAINT fk_categories_parent
        FOREIGN KEY (parent_category_id) REFERENCES categories(category_id)
        ON DELETE SET NULL)
    

CREATE TABLE products (
    product_id      BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    category_id     BIGINT UNSIGNED NOT NULL,
    title           VARCHAR(255) NOT NULL,
    description     TEXT,
    price           DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    sku             VARCHAR(100) NOT NULL UNIQUE,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_products_category
        FOREIGN KEY (category_id) REFERENCES categories(category_id)
        ON DELETE RESTRICT,
    

CREATE TABLE inventory (
    inventory_id        BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    product_id          BIGINT UNSIGNED NOT NULL,
    stock_quantity      INT NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    warehouse_location  VARCHAR(150),
    last_updated        TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_inventory_product
        FOREIGN KEY (product_id) REFERENCES products(product_id)
        ON DELETE CASCADE,
   

-- =====================================================================
-- MODULE 3: ORDERS & CART
-- =====================================================================

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS cart_items;

CREATE TABLE cart_items (
    cart_item_id    BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id         BIGINT UNSIGNED NOT NULL,
    product_id      BIGINT UNSIGNED NOT NULL,
    quantity        INT NOT NULL DEFAULT 1 CHECK (quantity > 0),
    added_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_cart_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_cart_product
        FOREIGN KEY (product_id) REFERENCES products(product_id)
        ON DELETE CASCADE,
    

CREATE TABLE orders (
    order_id            BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id             BIGINT UNSIGNED NOT NULL,
    shipping_address_id BIGINT UNSIGNED NOT NULL,
    total_amount        DECIMAL(12,2) NOT NULL CHECK (total_amount >= 0),
    order_status        ENUM('Pending','Shipped','Delivered','Cancelled') NOT NULL DEFAULT 'Pending',
    order_date          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_orders_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE RESTRICT,
    CONSTRAINT fk_orders_address
        FOREIGN KEY (shipping_address_id) REFERENCES addresses(address_id)
        ON DELETE RESTRICT,
    

CREATE TABLE order_items (
    order_item_id   BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_id        BIGINT UNSIGNED NOT NULL,
    product_id      BIGINT UNSIGNED NOT NULL,
    quantity        INT NOT NULL CHECK (quantity > 0),
    price_per_unit  DECIMAL(10,2) NOT NULL CHECK (price_per_unit >= 0), -- price at time of order
    CONSTRAINT fk_orderitems_order
        FOREIGN KEY (order_id) REFERENCES orders(order_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_orderitems_product
        FOREIGN KEY (product_id) REFERENCES products(product_id)
        ON DELETE RESTRICT,
    

-- =====================================================================
-- MODULE 4: PAYMENT, SHIPPING & REVIEWS
-- =====================================================================

DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS shipments;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS coupons;

CREATE TABLE payments (
    payment_id      BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_id        BIGINT UNSIGNED NOT NULL,
    payment_method  ENUM('UPI','Credit Card','COD') NOT NULL,
    payment_status  ENUM('Success','Failed','Pending') NOT NULL DEFAULT 'Pending',
    transaction_id  VARCHAR(150),
    paid_at         TIMESTAMP NULL,
    CONSTRAINT fk_payments_order
        FOREIGN KEY (order_id) REFERENCES orders(order_id)
        ON DELETE CASCADE,
   

CREATE TABLE shipments (
    shipment_id         BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_id            BIGINT UNSIGNED NOT NULL,
    courier_name        VARCHAR(150),
    tracking_number     VARCHAR(150),
    estimated_delivery  DATE,
    actual_delivery     DATE,
    shipment_status     ENUM('Processing','Shipped','In Transit','Delivered','Returned') NOT NULL DEFAULT 'Processing',
    CONSTRAINT fk_shipments_order
        FOREIGN KEY (order_id) REFERENCES orders(order_id)
        ON DELETE CASCADE,
    

CREATE TABLE reviews (
    review_id       BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id         BIGINT UNSIGNED NOT NULL,
    product_id      BIGINT UNSIGNED NOT NULL,
    rating          TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review_text     TEXT,
    review_date     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_reviews_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_reviews_product
        FOREIGN KEY (product_id) REFERENCES products(product_id)
        ON DELETE CASCADE,
    UNIQUE KEY uq_review_user_product (user_id, product_id),
   

CREATE TABLE coupons (
    coupon_id            BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    coupon_code          VARCHAR(50) NOT NULL UNIQUE,
    discount_percentage  DECIMAL(5,2) NOT NULL CHECK (discount_percentage BETWEEN 0 AND 100),
    expiry_date          DATE NOT NULL,
    is_active            BOOLEAN DEFAULT TRUE,
   

SET FOREIGN_KEY_CHECKS = 1;
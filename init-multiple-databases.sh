#!/bin/bash
set -e
POSTGRES_USER=root
POSTGRES_DB=mydb

echo "Creating tenant databases..."

psql -v ON_ERROR_STOP=1 \
     --username "$POSTGRES_USER" \
     --dbname "$POSTGRES_DB" <<EOF

    CREATE TABLE IF NOT EXISTS tenant_registry (
        tenant_id VARCHAR(50) PRIMARY KEY,
        db_name VARCHAR(100) NOT NULL,
        db_user VARCHAR(100) NOT NULL
    );

    CREATE DATABASE tenant_e29a9256;
    CREATE DATABASE tenant_d2447cca;
    CREATE DATABASE tenant_400f99f7;
    CREATE DATABASE tenant_68c82b83;
    CREATE DATABASE tenant_3d1eaf78;

EOF

echo "Creating tenant_e29a9256 schema..."

psql -v ON_ERROR_STOP=1 \
     --username "$POSTGRES_USER" \
     --dbname tenant_e29a9256 <<EOF

CREATE TABLE users
(
    user_id   serial PRIMARY KEY,
    user_name text,
    email     text,
    phone     varchar(10)
);

CREATE TABLE orders
(
    order_id     serial PRIMARY KEY,
    user_id      bigint,
    order_detail jsonb
);

INSERT INTO users(user_name, email, phone)
VALUES
    ('測試1', 'test1@email.com', '0910123456'),
    ('測試2', 'test2@email.com', '0984456789');
INSERT INTO orders(user_id, order_detail)
VALUES
    (1, '{"productName": "商品1", "price": 8000}'),
    (1, '{"productName": "商品2", "price": 12550}'),
    (2, '{"productName": "商品3", "price": 78940}');

EOF

echo "Creating tenant_d2447cca schema..."

psql -v ON_ERROR_STOP=1 \
     --username "$POSTGRES_USER" \
     --dbname tenant_d2447cca <<EOF

CREATE TABLE users
(
    user_id   serial PRIMARY KEY,
    user_name text,
    email     text,
    phone     varchar(10)
);

CREATE TABLE orders
(
    order_id     serial PRIMARY KEY,
    user_id      bigint,
    order_detail jsonb
);

INSERT INTO users(user_name, email, phone)
VALUES
    ('測試3', 'test3@email.com', '0941456878'),
    ('測試4', 'test4@email.com', '0978545654');
INSERT INTO orders(user_id, order_detail)
VALUES
    (1, '{"productName": "商品4", "price": 51530}'),
    (2, '{"productName": "商品5", "price": 4560}');

EOF


echo "Creating tenant_400f99f7 schema..."

psql -v ON_ERROR_STOP=1 \
     --username "$POSTGRES_USER" \
     --dbname tenant_400f99f7 <<EOF

CREATE TABLE users
(
    user_id   serial PRIMARY KEY,
    user_name text,
    email     text,
    phone     varchar(10)
);

CREATE TABLE orders
(
    order_id     serial PRIMARY KEY,
    user_id      bigint,
    order_detail jsonb
);

INSERT INTO users(user_name, email, phone)
VALUES
    ('測試5', 'test5@email.com', '0954321684'),
    ('測試6', 'test6@email.com', '0912489532');
INSERT INTO orders(user_id, order_detail)
VALUES
    (2, '{"productName": "商品6", "price": 50}');

EOF

echo "Creating tenant_68c82b83 schema..."

psql -v ON_ERROR_STOP=1 \
     --username "$POSTGRES_USER" \
     --dbname tenant_68c82b83 <<EOF

CREATE TABLE users
(
    user_id   serial PRIMARY KEY,
    user_name text,
    email     text,
    phone     varchar(10)
);

CREATE TABLE orders
(
    order_id     serial PRIMARY KEY,
    user_id      bigint,
    order_detail jsonb
);

INSERT INTO users(user_name, email, phone)
VALUES
    ('測試7', 'test7@email.com', '0922789422'),
    ('測試8', 'test8@email.com', '0987563481');
INSERT INTO orders(user_id, order_detail)
VALUES
    (1, '{"productName": "商品7", "price": 770}'),
    (2, '{"productName": "商品8", "price": 150}');

EOF

echo "Creating tenant_3d1eaf78 schema..."

psql -v ON_ERROR_STOP=1 \
     --username "$POSTGRES_USER" \
     --dbname tenant_3d1eaf78 <<EOF

CREATE TABLE users
(
    user_id   serial PRIMARY KEY,
    user_name text,
    email     text,
    phone     varchar(10)
);

CREATE TABLE orders
(
    order_id     serial PRIMARY KEY,
    user_id      bigint,
    order_detail jsonb
);

INSERT INTO users(user_name, email, phone)
VALUES
    ('測試9', 'test9@email.com', '0911597561'),
    ('測試10', 'test10@email.com', '0945783456');
INSERT INTO orders(user_id, order_detail)
VALUES
    (1, '{"productName": "商品9", "price": 7850}'),
    (2, '{"productName": "商品10", "price": 140}');

EOF

echo "Registering tenants..."

psql -v ON_ERROR_STOP=1 \
     --username "$POSTGRES_USER" \
     --dbname "$POSTGRES_DB" <<EOF

INSERT INTO tenant_registry(tenant_id, db_name, db_user)
VALUES
  ('tenant_e29a9256', 'tenant_e29a9256', 'root'),
  ('tenant_d2447cca', 'tenant_d2447cca', 'root'),
  ('tenant_400f99f7', 'tenant_400f99f7', 'root'),
  ('tenant_68c82b83', 'tenant_68c82b83', 'root'),
  ('tenant_3d1eaf78', 'tenant_3d1eaf78', 'root');

EOF

echo "Multi-tenant databases created successfully."

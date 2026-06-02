-- DCL
DO '
BEGIN
    -- 檢查 test 角色是否存在 (修正為 rolname)
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = ''test'') THEN

        -- 在單引號字串中，內部的單引號要寫兩次來轉義 (''test'')
        EXECUTE ''ALTER DEFAULT PRIVILEGES IN SCHEMA PUBLIC REVOKE SELECT, INSERT, UPDATE, DELETE ON TABLES FROM test'';
        EXECUTE ''REVOKE ALL PRIVILEGES ON TABLE users, orders, tenants FROM test'';
        EXECUTE ''REVOKE ALL PRIVILEGES ON SCHEMA PUBLIC FROM test'';
        EXECUTE ''REVOKE ALL PRIVILEGES ON DATABASE mydb FROM test'';

        -- 斷開連線
        PERFORM pg_terminate_backend(pid) FROM pg_stat_activity WHERE usename = ''test'';

        -- 轉移擁有權並刪除
        EXECUTE ''DROP OWNED BY test'';
        EXECUTE ''DROP USER test'';
    END IF;
END;
';

-- 建立一個專門給應用程式連線的一般帳號（非超級使用者）
CREATE USER test WITH PASSWORD 'test';
-- 將目標資料庫的連線與權限賦予該帳號
GRANT CONNECT ON DATABASE mydb TO test;
-- 賦予 Schema 權限
GRANT USAGE, CREATE ON SCHEMA PUBLIC TO test;
-- 確保未來建立的表，該帳號都有讀寫權限
ALTER DEFAULT PRIVILEGES IN SCHEMA PUBLIC GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO test;

-- DDL
DROP TABLE if EXISTS tenants;
DROP TABLE if EXISTS users;
DROP TABLE if EXISTS orders;
DROP POLICY if EXISTS tenant_isolation_policy ON users;
DROP POLICY if EXISTS tenant_isolation_policy ON orders;

CREATE TABLE tenants
(
    tenant_id   text PRIMARY KEY,
    tenant_name text NOT NULL
);

CREATE TABLE users
(
    user_id   serial PRIMARY KEY,
    tenant_id text NOT NULL,
    user_name text,
    email     text,
    phone     varchar(10)
);

CREATE TABLE orders
(
    order_id     serial PRIMARY KEY,
    tenant_id    text NOT NULL,
    user_id      bigint,
    order_detail jsonb
);
-- 查看 RLS 是否有開啟
-- SELECT relname, relrowsecurity, relforcerowsecurity FROM pg_class WHERE relname = 'users';
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE users FORCE ROW LEVEL SECURITY;
ALTER TABLE orders FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation_policy ON users USING (tenant_id = current_setting('app.tenant_id')::text);
CREATE POLICY tenant_isolation_policy ON orders USING (tenant_id = current_setting('app.tenant_id')::text);
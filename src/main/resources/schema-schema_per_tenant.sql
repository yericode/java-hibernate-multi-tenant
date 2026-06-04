--------------------------------------------------------------------------------
-- 第一部分：清理舊帳號與權限
--------------------------------------------------------------------------------
DO '
DECLARE
    r RECORD;
BEGIN
    -- 檢查 test 角色是否存在
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = ''test'') THEN

        -- 1. 動態收回所有現存 Schema (包含 public 與各租戶 schema) 的預設與現有權限
        FOR r IN (SELECT nspname FROM pg_namespace WHERE nspname NOT LIKE ''pg_%'' AND nspname != ''information_schema'') LOOP
            EXECUTE format(''ALTER DEFAULT PRIVILEGES IN SCHEMA %I REVOKE SELECT, INSERT, UPDATE, DELETE ON TABLES FROM test'', r.nspname);
            EXECUTE format(''REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA %I FROM test'', r.nspname);
            EXECUTE format(''REVOKE ALL PRIVILEGES ON SCHEMA %I FROM test'', r.nspname);
        END LOOP;
        -- 2. 收回資料庫層級權限
        REVOKE ALL PRIVILEGES ON DATABASE mydb FROM test;
        -- 3. 強制斷開該帳號的當前連線
        PERFORM pg_terminate_backend(pid) FROM pg_stat_activity WHERE usename = ''test'';
        -- 4. 清理依賴並刪除使用者
        -- 注意：DROP OWNED 會清理當前資料庫下該使用者擁有的物件與權限
        EXECUTE ''DROP OWNED BY test'';
        EXECUTE ''DROP USER test'';
    END IF;
END;
';

--------------------------------------------------------------------------------
-- 第二部分：建立 schema table
--------------------------------------------------------------------------------

DROP SCHEMA IF EXISTS management CASCADE;
CREATE SCHEMA management;
CREATE TABLE management.tenants
(
    tenant_id   text PRIMARY KEY,
    tenant_name text,
    schema_name text
);

DROP SCHEMA IF EXISTS tenant_e29a9256 CASCADE;
CREATE SCHEMA tenant_e29a9256;
CREATE TABLE tenant_e29a9256.users
(
    user_id   serial PRIMARY KEY,
    user_name text,
    email     text,
    phone     varchar(10)
);

CREATE TABLE tenant_e29a9256.orders
(
    order_id     serial PRIMARY KEY,
    user_id      bigint,
    order_detail jsonb
);

DROP SCHEMA IF EXISTS tenant_d2447cca CASCADE;
CREATE SCHEMA tenant_d2447cca;
CREATE TABLE tenant_d2447cca.users
(
    user_id   serial PRIMARY KEY,
    user_name text,
    email     text,
    phone     varchar(10)
);

CREATE TABLE tenant_d2447cca.orders
(
    order_id     serial PRIMARY KEY,
    user_id      bigint,
    order_detail jsonb
);

DROP SCHEMA IF EXISTS tenant_400f99f7 CASCADE;
CREATE SCHEMA tenant_400f99f7;
CREATE TABLE tenant_400f99f7.users
(
    user_id   serial PRIMARY KEY,
    user_name text,
    email     text,
    phone     varchar(10)
);

CREATE TABLE tenant_400f99f7.orders
(
    order_id     serial PRIMARY KEY,
    user_id      bigint,
    order_detail jsonb
);

DROP SCHEMA IF EXISTS tenant_68c82b83 CASCADE;
CREATE SCHEMA tenant_68c82b83;
CREATE TABLE tenant_68c82b83.users
(
    user_id   serial PRIMARY KEY,
    user_name text,
    email     text,
    phone     varchar(10)
);

CREATE TABLE tenant_68c82b83.orders
(
    order_id     serial PRIMARY KEY,
    user_id      bigint,
    order_detail jsonb
);

DROP SCHEMA IF EXISTS tenant_3d1eaf78 CASCADE;
CREATE SCHEMA tenant_3d1eaf78;
CREATE TABLE tenant_3d1eaf78.users
(
    user_id   serial PRIMARY KEY,
    user_name text,
    email     text,
    phone     varchar(10)
);

CREATE TABLE tenant_3d1eaf78.orders
(
    order_id     serial PRIMARY KEY,
    user_id      bigint,
    order_detail jsonb
);

--------------------------------------------------------------------------------
-- 第三部分：建立新帳號並動態賦權
--------------------------------------------------------------------------------
-- 1. 建立連線帳號
CREATE USER test WITH PASSWORD 'test';
-- 2. 賦予資料庫連線權限
GRANT CONNECT ON DATABASE mydb TO test;
-- 3. 動態為現有的所有租戶 Schema 賦權
DO '
DECLARE
    r RECORD;
BEGIN
    -- 走訪所有非系統的 Schema（包含 public, management, 以及各租戶如 tenant_e29a9256）
    FOR r IN (SELECT nspname FROM pg_namespace WHERE nspname NOT LIKE ''pg_%'' AND nspname != ''information_schema'') LOOP
        -- 賦予 Schema 的使用權與建立物件權（若應用程式需要動態建表）
        EXECUTE format(''GRANT USAGE, CREATE ON SCHEMA %I TO test'', r.nspname);
        -- 確保現有的表，該帳號都有讀寫權限
        EXECUTE format(''GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA %I TO test'', r.nspname);
        -- 確保未來在該 Schema 建立的表，該帳號也都擁有讀寫權限
        EXECUTE format(''ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO test'', r.nspname);
    END LOOP;
END;
';
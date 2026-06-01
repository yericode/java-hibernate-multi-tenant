drop table if exists tenants;
drop table if exists users;
drop table if exists orders;

drop POLICY if exists tenant_isolation_policy on users;
drop POLICY if exists tenant_isolation_policy on orders;

create table tenants
(
    tenant_id   text primary key,
    tenant_name text not null
);

create table users
(
    user_id   serial primary key,
    tenant_id text not null,
    user_name text,
    email     text,
    phone     varchar(10)
);

create table orders
(
    order_id     serial primary key,
    tenant_id    text not null,
    user_id      bigint,
    order_detail jsonb
);

ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation_policy ON users USING (tenant_id = current_setting('app.tenant_id')::text);
CREATE POLICY tenant_isolation_policy ON orders USING (tenant_id = current_setting('app.tenant_id')::text);
drop table if exists tenants;
drop table if exists users;
drop table if exists orders;

create table tenants(
  tenant_id text primary key,
  tenant_name text
);

create table users(
  user_id serial primary key,
  tenant_id text,
  user_name text,
  email text,
  phone varchar(10)
);

create table orders(
  order_id serial primary key,
  user_id bigint,
  tenant_id text,
  order_detail jsonb
);
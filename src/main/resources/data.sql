insert into tenants(tenant_id, tenant_name)
values
  ('e29a9256', '租戶1'),
  ('d2447cca', '租戶2'),
  ('400f99f7', '租戶3'),
  ('68c82b83', '租戶4'),
  ('3d1eaf78', '租戶5');

insert into users(tenant_id, user_name, email, phone)
values
  ('e29a9256', '測試1', 'test1@email.com', '0910123456'),
  ('e29a9256', '測試2', 'test2@email.com', '0984456789'),
  ('d2447cca', '測試3', 'test3@email.com', '0941456878'),
  ('d2447cca', '測試4', 'test4@email.com', '0978545654'),
  ('400f99f7', '測試5', 'test5@email.com', '0954321684'),
  ('400f99f7', '測試6', 'test6@email.com', '0912489532'),
  ('68c82b83', '測試7', 'test7@email.com', '0922789422'),
  ('68c82b83', '測試8', 'test8@email.com', '0987563481'),
  ('3d1eaf78', '測試9', 'test9@email.com', '0911597561'),
  ('3d1eaf78', '測試10', 'test10@email.com', '0945783456');

insert into orders(tenant_id, user_id, order_detail)
values
  ('e29a9256', 1, '{"product_name": "商品1", "price": 8000}'),
  ('e29a9256', 1, '{"product_name": "商品2", "price": 12550}'),
  ('d2447cca', 2, '{"product_name": "商品3", "price": 78940}'),
  ('d2447cca', 3, '{"product_name": "商品4", "price": 51530}'),
  ('400f99f7', 4, '{"product_name": "商品5", "price": 4560}'),
  ('400f99f7', 6, '{"product_name": "商品6", "price": 50}'),
  ('68c82b83', 7, '{"product_name": "商品7", "price": 770}'),
  ('68c82b83', 8, '{"product_name": "商品8", "price": 150}'),
  ('3d1eaf78', 9, '{"product_name": "商品9", "price": 7850}'),
  ('3d1eaf78', 10, '{"product_name": "商品10", "price": 140}');
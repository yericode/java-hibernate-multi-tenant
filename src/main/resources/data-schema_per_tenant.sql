INSERT INTO management.tenants(tenant_id, tenant_name, schema_name)
VALUES
    ('e29a9256', '租戶1', 'tenant_e29a9256'),
    ('d2447cca', '租戶2', 'tenant_d2447cca'),
    ('400f99f7', '租戶3', 'tenant_400f99f7'),
    ('68c82b83', '租戶4', 'tenant_68c82b83'),
    ('3d1eaf78', '租戶5', 'tenant_3d1eaf78');

INSERT INTO tenant_e29a9256.users(user_name, email, phone)
VALUES
    ('測試1', 'test1@email.com', '0910123456'),
    ('測試2', 'test2@email.com', '0984456789');
INSERT INTO tenant_e29a9256.orders(user_id, order_detail)
VALUES
    (1, '{"productName": "商品1", "price": 8000}'),
    (1, '{"productName": "商品2", "price": 12550}'),
    (2, '{"productName": "商品3", "price": 78940}');

INSERT INTO tenant_d2447cca.users(user_name, email, phone)
VALUES
    ('測試3', 'test3@email.com', '0941456878'),
    ('測試4', 'test4@email.com', '0978545654');
INSERT INTO tenant_d2447cca.orders(user_id, order_detail)
VALUES
    (3, '{"productName": "商品4", "price": 51530}'),
    (4, '{"productName": "商品5", "price": 4560}');

INSERT INTO tenant_400f99f7.users(user_name, email, phone)
VALUES
    ('測試5', 'test5@email.com', '0954321684'),
    ('測試6', 'test6@email.com', '0912489532');
INSERT INTO tenant_400f99f7.orders(user_id, order_detail)
VALUES
    (6, '{"productName": "商品6", "price": 50}');

INSERT INTO tenant_68c82b83.users(user_name, email, phone)
VALUES
    ('測試7', 'test7@email.com', '0922789422'),
    ('測試8', 'test8@email.com', '0987563481');
INSERT INTO tenant_68c82b83.orders(user_id, order_detail)
VALUES
    (7, '{"productName": "商品7", "price": 770}'),
    (8, '{"productName": "商品8", "price": 150}');

INSERT INTO tenant_3d1eaf78.users(user_name, email, phone)
VALUES
    ('測試9', 'test9@email.com', '0911597561'),
    ('測試10', 'test10@email.com', '0945783456');
INSERT INTO tenant_3d1eaf78.orders(user_id, order_detail)
VALUES
    (9, '{"productName": "商品9", "price": 7850}'),
    (10, '{"productName": "商品10", "price": 140}');

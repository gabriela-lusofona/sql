BEGIN TRANSACTION;
CREATE TABLE CUSTOMER (
    CUSTOMER_ID SERIAL PRIMARY KEY NOT NULL,
    NAME TEXT NOT NULL,
    REGION TEXT,
    STREET_ADDRESS TEXT,
    CITY TEXT,
    STATE TEXT,
    ZIP INTEGER
);

CREATE TABLE PRODUCT (
    PRODUCT_ID SERIAL PRIMARY KEY,
    DESCRIPTION TEXT,
    PRICE NUMERIC
);

CREATE TABLE CUSTOMER_ORDER (
    ORDER_ID SERIAL PRIMARY KEY NOT NULL,
    ORDER_DATE DATE NOT NULL,
    SHIP_DATE DATE,
    CUSTOMER_ID INTEGER REFERENCES CUSTOMER (CUSTOMER_ID) NOT NULL,
    PRODUCT_ID INTEGER REFERENCES PRODUCT (PRODUCT_ID) NOT NULL,
    ORDER_QTY INTEGER NOT NULL,
    SHIPPED BOOLEAN NOT NULL DEFAULT FALSE
);


-- Inserção dos produtos antes dos pedidos
INSERT INTO PRODUCT (PRODUCT_ID, DESCRIPTION, PRICE) VALUES (1, 'Copper', 7.51);
INSERT INTO PRODUCT (PRODUCT_ID, DESCRIPTION, PRICE) VALUES (2, 'Aluminum', 2.58);
INSERT INTO PRODUCT (PRODUCT_ID, DESCRIPTION, PRICE) VALUES (3, 'Silver', 15);
INSERT INTO PRODUCT (PRODUCT_ID, DESCRIPTION, PRICE) VALUES (4, 'Steel', 12.31);
INSERT INTO PRODUCT (PRODUCT_ID, DESCRIPTION, PRICE) VALUES (5, 'Bronze', 4);
INSERT INTO PRODUCT (PRODUCT_ID, DESCRIPTION, PRICE) VALUES (6, 'Duralumin', 7.6);
INSERT INTO PRODUCT (PRODUCT_ID, DESCRIPTION, PRICE) VALUES (7, 'Solder', 14.16);
INSERT INTO PRODUCT (PRODUCT_ID, DESCRIPTION, PRICE) VALUES (8, 'Stellite', 13.31);
INSERT INTO PRODUCT (PRODUCT_ID, DESCRIPTION, PRICE) VALUES (9, 'Brass', 4.75);


INSERT INTO CUSTOMER (NAME, REGION, STREET_ADDRESS, CITY, STATE, ZIP)
VALUES ('LITE Industrial','Southwest','729 Ravine Way','Irving','TX',75014);

INSERT INTO CUSTOMER (NAME, REGION, STREET_ADDRESS, CITY, STATE, ZIP)
VALUES ('Rex Tooling Inc','Southwest','6129 Collie Blvd','Dallas','TX',75201);

INSERT INTO CUSTOMER (NAME, REGION, STREET_ADDRESS, CITY, STATE, ZIP)
VALUES ('Re-Barre Construction','Southwest','9043 Windy Dr','Irving','TX',75032);

INSERT INTO CUSTOMER (NAME, REGION, STREET_ADDRESS, CITY, STATE, ZIP)
VALUES ('Prairie Construction','Southwest','264 Long Rd','Moore','OK',62104);

INSERT INTO CUSTOMER (NAME, REGION, STREET_ADDRESS, CITY, STATE, ZIP)
VALUES ('Marsh Lane Metal Works','Southeast','9143 Marsh Ln','Avondale','LA',79782);

INSERT INTO CUSTOMER_ORDER (ORDER_DATE, SHIP_DATE, CUSTOMER_ID, PRODUCT_ID, ORDER_QTY, SHIPPED)
VALUES ('2015-05-15','2015-05-18',1,1,450,FALSE);

INSERT INTO CUSTOMER_ORDER (ORDER_DATE, SHIP_DATE, CUSTOMER_ID, PRODUCT_ID, ORDER_QTY, SHIPPED)
VALUES ('2015-05-18','2015-05-21',3,2,600,FALSE);

INSERT INTO CUSTOMER_ORDER (ORDER_DATE, SHIP_DATE, CUSTOMER_ID, PRODUCT_ID, ORDER_QTY, SHIPPED)
VALUES ('2015-05-20','2015-05-23',3,5,300,FALSE);

INSERT INTO CUSTOMER_ORDER (ORDER_DATE, SHIP_DATE, CUSTOMER_ID, PRODUCT_ID, ORDER_QTY, SHIPPED)
VALUES ('2015-05-18','2015-05-22',5,4,375,FALSE);

INSERT INTO CUSTOMER_ORDER (ORDER_DATE, SHIP_DATE, CUSTOMER_ID, PRODUCT_ID, ORDER_QTY, SHIPPED)
VALUES ('2015-05-17','2015-05-20',3,2,500,FALSE);



-- Deletando a sequência para reiniciar os IDs
-- Se precisar resetar a sequência de IDs, você deve usar:
-- ALTER SEQUENCE <nome_da_sequencia> RESTART WITH <valor_inicial>;

-- Para o caso de uso comum, por exemplo, `PRODUCT_id_seq`, você pode fazer:
-- ALTER SEQUENCE product_id_seq RESTART WITH 10;  -- (aqui, 10 é o próximo valor a ser usado)

-- Para evitar o erro de reiniciar a sequência com valores incorretos, vamos ajustar a tabela como abaixo:
SELECT sequence_name
FROM information_schema.sequences
WHERE sequence_schema = 'public';

-- Ajuste para o produto
SELECT setval('product_product_id_seq', 9, true);

-- Ajuste para o cliente
SELECT setval('customer_customer_id_seq', 5, true);

-- Para ver a sequência de `product_id` da tabela `product`
SELECT pg_get_serial_sequence('product', 'product_id');

-- Para ver a sequência de `customer_id` da tabela `customer`
SELECT pg_get_serial_sequence('customer', 'customer_id');

-- Para ver a sequência de `order_id` da tabela `customer_order`
SELECT pg_get_serial_sequence('customer_order', 'order_id');


-- Criação das views
CREATE VIEW BEHIND_SCHEDULE AS
SELECT *
FROM customer_order
WHERE ship_date < CURRENT_DATE
  AND shipped = FALSE;

CREATE VIEW CUSTOMER_REVENUE AS
SELECT
  customer.name,
  SUM(customer_order.order_qty * product.price) AS revenue
FROM customer
INNER JOIN customer_order
  ON customer.customer_id = customer_order.customer_id
INNER JOIN product
  ON product.product_id = customer_order.product_id
GROUP BY customer.name;

-- Finalizando a transação
COMMIT;

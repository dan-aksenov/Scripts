CREATE OR REPLACE SYNONYM DBAX.DISTRICT FOR "public"."district"@PG_LINK;
CREATE OR REPLACE SYNONYM DBAX.HISTORY FOR "public"."history"@PG_LINK;
CREATE OR REPLACE SYNONYM DBAX.ITEM FOR "public"."item"@PG_LINK;
CREATE OR REPLACE SYNONYM DBAX.NEW_ORDER FOR "public"."new_order"@PG_LINK;
CREATE OR REPLACE SYNONYM DBAX.ORDERS FOR "public"."orders"@PG_LINK;
CREATE OR REPLACE SYNONYM DBAX.ORDER_LINE FOR "public"."order_line"@PG_LINK;
CREATE OR REPLACE SYNONYM DBAX.STOCK FOR "public"."stock"@PG_LINK;
CREATE OR REPLACE SYNONYM DBAX.WAREHOUSE FOR "public"."warehouse"@PG_LINK;
CREATE OR REPLACE SYNONYM DBAX.CUSTOMER FOR "public"."customer"@PG_LINK;

CREATE OR REPLACE PROCEDURE delivery(
d_w_id    integer,
d_o_carrier_id    integer)
IS
d_d_id	       	INTEGER;
d_c_id	       	NUMERIC;
d_no_o_id		INTEGER;
d_ol_total		NUMERIC;
loop_counter	INTEGER;
BEGIN
FOR loop_counter IN 1 .. 10
LOOP
d_d_id := loop_counter;
SELECT "no_o_id" INTO d_no_o_id FROM new_order WHERE "no_w_id" = d_w_id AND "no_d_id" = d_d_id ORDER BY "no_o_id" ASC FETCH FIRST 1 ROWS ONLY;
DELETE FROM new_order WHERE "no_w_id" = d_w_id AND "no_d_id" = d_d_id AND "no_o_id" = d_no_o_id;
SELECT "o_c_id" INTO d_c_id FROM orders
WHERE "o_id" = d_no_o_id AND "o_d_id" = d_d_id AND
"o_w_id" = d_w_id;
 UPDATE orders SET "o_carrier_id" = d_o_carrier_id
WHERE "o_id" = d_no_o_id AND "o_d_id" = d_d_id AND
"o_w_id" = d_w_id;
UPDATE order_line SET "ol_delivery_d" = current_timestamp
WHERE "ol_o_id" = d_no_o_id AND "ol_d_id" = d_d_id AND
"ol_w_id" = d_w_id;
SELECT SUM("ol_amount") INTO d_ol_total
FROM order_line
WHERE "ol_o_id" = d_no_o_id AND "ol_d_id" = d_d_id
AND "ol_w_id" = d_w_id;
UPDATE customer SET "c_balance" = "c_balance" + d_ol_total
WHERE "c_id" = d_c_id AND "c_d_id" = d_d_id AND
"c_w_id" = d_w_id;
END LOOP;
EXCEPTION
WHEN others
THEN ROLLBACK;
END; 

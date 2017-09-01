--1. Create a new sales invoice
--Sharon
ACCEPT p_inv PROMPT 'Enter inv#'
ACCEPT p_serial PROMPT 'Enter car serial no'
ACCEPT p_cname PROMPT 'Enter car customer name'
ACCEPT p_salesman PROMPT 'Enter salesman name: '
ACCEPT p_totalprice PROMPT 'Enter total price: '
ACCEPT p_discount PROMPT 'Enter discount: '
ACCEPT p_fire PROMPT 'Does it have fire insurance (Y/N): '
ACCEPT p_collision PROMPT 'Does it have collision insurance (Y/N): '
ACCEPT p_liability PROMPT 'Does it have liability insurance (Y/N): '
ACCEPT p_property PROMPT 'Does it have property damage insurance (Y/N): '
ACCEPT p_tradeallow PROMPT 'Enter trade in allowance: '
ACCEPT p_tradeSerial PROMPT 'Enter tradeserial  '
ACCEPT p_ocode PROMPT 'Enter option code for extra options: '
VARIABLE g_output VARCHAR2(4000)
DECLARE 
valid_insert NUMBER;
both_are_null Exception;
no_serial Exception;
no_cname Exception;
test_g NUMBER;
no_salesDate Exception;
v_countCname NUMBER;
v_countSerial NUMBER;
data_inserted NUMBER;
ocode_count NUMBER;
sales_inv CHAR(6);
BEGIN
-- checking the mandory fields
    IF '&p_serial' || '&p_cname' IS NULL THEN
      RAISE  both_are_null;
    END IF;
    IF '&p_inv' IS NULL THEN
      :g_output := 'Invoice number is null';
    END IF;
    IF '&p_serial' IS NOT NULL THEN
        IF '&p_cname' IS NULL THEN
           RAISE no_cname;
        END IF;
    END IF;
    IF '&p_cname' IS NOT NULL THEN
       IF '&p_serial' IS NULL THEN
         RAISE no_serial;
       END IF;
    END IF;
    
   IF '&p_serial' || '&p_cname' || '&p_inv' IS NOT NULL THEN
      SELECT COUNT(*) 
      INTO v_countCname
      FROM customer 
      WHERE cname = UPPER('&p_cname');
      
      SELECT COUNT(*) 
      INTO v_countSerial
      FROM car 
      WHERE serial = UPPER('&p_serial');
      
         IF v_countCname = 0 AND v_countSerial = 0 THEN
            :g_output := :g_output ||'Invalid input for customer name and serial number!! Not present in other tables'||CHR(10);
         END IF;
         IF v_countCname = 0 OR v_countSerial = 0 THEN
            :g_output := :g_output ||'Invalid input for customer name or serial number!! Not present in other tables'||CHR(10);
         END IF;
    END IF;
IF v_countCname = 1 AND v_countSerial = 1 THEN
    IF '&p_inv' IS NOT NULL THEN
       SELECT COUNT(*) into test_g FROM saleinv WHERE saleinv = UPPER('&p_inv');
       IF test_g = 1 then
           :g_output:=:g_output ||'THis inv# is already occupied'||CHR(10);
       END IF;
       IF test_g =0 THEN 
       SELECT COUNT(*) 
       INTO valid_insert 
       FROM car 
       WHERE serial = UPPER('&p_serial') AND cname IS NULL;
       IF  valid_insert = 0 THEN
              :g_output := :g_output ||'This car is already sold!!'||CHR(10);
       END IF;
      IF valid_insert = 1 THEN
            :g_output := 'good';
		   IF UPPER('&p_tradeSerial') IS NOT NULL THEN
		     INSERT INTO saleinv(saleinv,cname,salesman,saledate,serial,totalprice,discount,net,tax,tradeserial,tradeallow,fire,collision,liability,property)
             VALUES (UPPER('&p_inv'),UPPER('&p_cname'),UPPER('&p_salesman'),SYSDATE,UPPER('&p_serial'),'&p_totalprice','&p_discount','&p_totalprice'-'&p_discount'-'&p_tradeallow',
                    ('&p_totalprice'-'&p_discount'-'&p_tradeallow')*0.13,UPPER('&p_tradeSerial'),'&p_tradeallow',
                    UPPER('&p_fire'),UPPER('&p_collision'),UPPER('&p_liability'),UPPER('&p_property')) RETURNING saleinv INTO sales_inv;
            :g_output := 'Data inserted '||CHR(10);
		   END IF;
		   IF UPPER('&p_tradeSerial') IS NULL THEN
           INSERT INTO saleinv(saleinv,cname,salesman,saledate,serial,totalprice,discount,net,tax,tradeserial,tradeallow,fire,collision,liability,property)
           VALUES (UPPER('&p_inv'),UPPER('&p_cname'),UPPER('&p_salesman'),SYSDATE,UPPER('&p_serial'),'&p_totalprice','&p_discount','&p_totalprice'-'&p_discount'-'&p_tradeallow',
                    ('&p_totalprice'-'&p_discount'-'&p_tradeallow')*0.13,UPPER('&p_tradeSerial'),'&p_tradeallow',
                    UPPER('&p_fire'),UPPER('&p_collision'),UPPER('&p_liability'),UPPER('&p_property')) RETURNING saleinv INTO sales_inv;
            :g_output := 'Data inserted '||CHR(10);
           SELECT COUNT(*)
           INTO data_inserted 
           FROM saleinv
           WHERE saleinv = sales_inv;
          IF data_inserted = 1 THEN
              UPDATE car 
              SET cname = UPPER('&p_cname')
              WHERE serial = UPPER('&p_serial');
               IF UPPER('&p_ocode') IS NOT NULL THEN
                   SELECT COUNT(*) 
                    INTO ocode_count
                    FROM options 
                    WHERE ocode = UPPER('&p_ocode');
                    IF ocode_count = 0 THEN
                       :g_output := :g_output ||'Invalid option code'||CHR(10);
                     END IF;
                     IF ocode_count = 1 THEN
                      INSERT INTO invoption VALUES(sales_inv, UPPER('&p_ocode'), 23234); 
                    END IF;   
              END IF;   					
               END IF;
          END IF;        
   END IF;
END IF;
   END IF;
 END IF;
--
    EXCEPTION
    WHEN both_are_null THEN
    :g_output := :g_output ||'Serial and Customer name is null'||CHR(10);
    WHEN no_serial THEN
    :g_output := :g_output ||'Serial number is null'||CHR(10);    
    WHEN no_cname THEN
    :g_output := :g_output ||'Customer name is null'||CHR(10); 
    WHEN VALUE_ERROR THEN
      :g_output := :g_output ||'Error in input typed!! Try again'||CHR(10); 
END;
/
PRINT g_output


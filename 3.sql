--3. Create a new vehicle inventory record
--Sharon
ACCEPT p_serial PROMPT 'Enter serial number'
ACCEPT p_make PROMPT 'Enter make of car'
ACCEPT p_model PROMPT 'Enter model of car'
ACCEPT p_year PROMPT 'Enter year'
ACCEPT p_color  PROMPT 'Enter color'
ACCEPT p_trim PROMPT 'Enter trim'
ACCEPT p_enginetype PROMPT 'Enter engine type'
ACCEPT p_purchasedfrom PROMPT 'Enter phurchase from'
ACCEPT p_purchinv PROMPT 'Enter the phurchase invoice number'
ACCEPT p_purchcost PROMPT 'Enter purchase cost '
ACCEPT p_listprice PROMPT 'Enter list price'
ACCEPT p_ocode PROMPT 'Enter option code'

VARIABLE g_output VARCHAR2(4000)
DECLARE
v_countSerial NUMBER;
v_countSO  NUMBER;
all_null EXCEPTION;
v_countCode NUMBER;
BEGIN

--checking if any field is null 
IF '&p_serial' IS NULL THEN 
RAISE all_null;
END IF ;
IF '&p_make' IS NULL THEN 
RAISE all_null;
END IF ;
IF '&p_model' IS NULL THEN 
RAISE all_null;
END IF ;
IF '&p_year' IS NULL THEN 
RAISE all_null; 
END IF ;
IF '&p_color' IS NULL THEN 
RAISE all_null; 
END IF ;
IF '&p_trim' IS NULL THEN 
RAISE all_null; 
END IF ;
IF '&p_ocode' IS NULL THEN 
RAISE all_null;
END IF ;

IF '&p_enginetype' IS NULL THEN 
RAISE all_null;
END IF ;


IF '&p_serial' IS NOT NULL AND '&p_make'IS NOT NULL AND '&p_model'IS NOT NULL AND '&p_year'IS NOT NULL AND '&p_color'IS NOT NULL AND '&p_trim'IS NOT NULL AND '&p_enginetype' IS NOT NULL AND '&p_ocode'IS NOT NULL
THEN

--checking uniqueness of primary keys
SELECT COUNT(*)
        INTO v_countSerial
        FROM car 
        WHERE serial = UPPER('&p_serial');      
        
IF v_countSerial =1 THEN
:g_output := 'Dublicate Serial number';
END IF ;
--Inserting into car
IF v_countSerial =0 THEN
INSERT INTO car(serial, make, model, cyear, color, trim,enginetype, purchinv,purchfrom, purchdate, purchcost, listprice)
VALUES(UPPER('&p_serial') , UPPER('&p_make'), UPPER('&p_model'), UPPER('&p_year'),UPPER('&p_color'), UPPER('&p_trim'),UPPER('&p_enginetype'),UPPER('&p_purchinv'),UPPER('&p_purchasedfrom'),SYSDATE,'&p_purchcost','&p_listprice');

--Inserting into baseoptions
SELECT count(*) into v_countSO from baseoption where serial=UPPER('&p_serial') and ocode = UPPER('&p_ocode');
IF v_countSO =1 THEN
   :g_output := :g_output || 'Dublication of primary key in baseoption table';
END IF;
SELECT COUNT(*) INTO v_countCode FROM options WHERE ocode = UPPER('&p_ocode');
IF v_countCode = 1 THEN
IF v_countSO =0 THEN
INSERT INTO baseoption(serial,ocode)
VALUES(UPPER('&p_serial'),UPPER('&p_ocode'));
END IF;

:g_output :='The values are inserted into the tables';
END IF;
IF v_countCode = 0 THEN
  :g_output :='Invalid option code';
END IF;
END IF;
END IF;
EXCEPTION
WHEN all_null THEN 
:g_output := 'Please ensure the fields serial, model, year, color, trim and ocode is not null !!..';
END;
/
PRINT g_output


--select * from car;
select * from baseoption;
select * from options;
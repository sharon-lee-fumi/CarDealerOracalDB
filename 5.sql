--5. Create an accounting sales supplement
--Sharon
ACCEPT p_saleinv PROMPT 'Enter Sales Invoice number'
ACCEPT p_serial PROMPT 'Enter Serial number'
ACCEPT p_freightcost PROMPT 'Enter frieght cost of car'
ACCEPT p_licfee PROMPT 'Enter the license fee'
ACCEPT p_commission PROMPT 'Enter commission cost '

VARIABLE g_output VARCHAR2(4000)

DECLARE
v_countSaleinv  NUMBER;
v_countSerial NUMBER;
all_null EXCEPTION;
BEGIN

IF '&p_saleinv' IS NULL THEN 
RAISE all_null;
END IF ;

IF '&p_serial' IS NULL THEN 
RAISE all_null;
END IF ;

--Inserting the fields into saleinv table 
IF '&p_saleinv' IS NOT NULL AND '&p_serial' IS NOT NULL THEN 


--Checking that there is not any duplicate primary key
SELECT COUNT(*)
        INTO v_countSaleinv
        FROM saleinv 
        WHERE saleinv = UPPER('&p_saleinv');
 IF v_countSaleinv = 0 THEN
        :g_output := 'Invalid Salesinv# or saleinv#';
       
 END IF;
 
 
 SELECT COUNT(*)
        INTO v_countSerial
        FROM car
        WHERE serial = UPPER('&p_serial');
 IF v_countSerial = 0 THEN
        :g_output := 'Invalid Serial# OR saleinv#';
        END IF ;
 
IF v_countSaleinv =1 AND v_countSerial=1 THEN 
 UPDATE saleinv 
  SET commission = '&p_commission', licfee= '&p_licfee'
  WHERE saleinv = UPPER('&p_saleinv');

  
  
  UPDATE car
SET freightcost = '&p_freightcost'
WHERE serial = UPPER('&p_serial');

  :g_output := :g_output || 'Record Updated';  
END IF;

END IF;
EXCEPTION
WHEN all_null THEN 
:g_output := 'Saleinv# is null!!';
END;
/
PRINT g_output


select * from saleinv;
select * from car;
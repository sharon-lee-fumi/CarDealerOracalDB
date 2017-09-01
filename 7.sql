--7. Create a new service work order
--Sharon
ACCEPT p_cname PROMPT 'Enter customer name'
ACCEPT p_serial PROMPT 'ENTER serial number'
ACCEPT p_servinv PROMPT 'ENTER service#'
ACCEPT p_des PROMPT 'Enter Service description'
ACCEPT p_partCost PROMPT 'Enter cost of each part'
ACCEPT p_labourCost PROMPT 'Enter Labour Cost'
VARIABLE g_output VARCHAR2(4000)
DECLARE 
both_are_null Exception;
no_serial Exception;
no_cname Exception;
no_servinv Exception;
no_desc Exception;
null_fields Exception;
dublicate_pk NUMBER;
v_countCname NUMBER;
v_countSerial NUMBER;
data_inserted NUMBER;
BEGIN
IF  '&p_cname' || '&p_serial' || '&p_servinv' || '&p_des' IS NULL THEN
      RAISE  both_are_null;
END IF;
IF  '&p_cname' || '&p_serial' IS NULL THEN
     :g_output := 'Customer name and Serial number is null'||CHR(10);
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

IF '&p_serial' || '&p_cname' IS NOT NULL THEN
SELECT COUNT(*) INTO v_countCname FROM customer WHERE cname = UPPER('&p_cname');
SELECT COUNT(*) INTO v_countSerial FROM car WHERE serial = UPPER('&p_serial');
 IF v_countCname = 0 THEN
    :g_output := :g_output || 'Invalid customer name, not present in customer table!!'||CHR(10);
 END IF;
  IF v_countCname = 0 THEN
    :g_output := :g_output || 'Invalid serial#, not present in car table!!'||CHR(10);
 END IF;
 IF v_countCname = 1 AND v_countSerial = 1 THEN
    IF '&p_des' IS NOT NULL THEN
       IF '&p_servinv' IS NULL THEN
         RAISE no_servinv;
       END IF;
    END IF;  
    IF '&p_servinv' IS NOT NULL THEN
       IF '&p_des' IS NULL THEN
           RAISE no_desc;
       END IF;
    END IF;
    IF '&p_servinv' || '&p_des' IS NULL THEN
        RAISE null_fields;
     END IF;
     IF '&p_servinv' || '&p_des' IS NOT NULL THEN
        SELECT COUNT(*) INTO dublicate_pk FROM servinv WHERE servinv = UPPER('&p_servinv');
        IF dublicate_pk = 1 THEN
             :g_output := :g_output || 'Service# already exist, enter other one'||CHR(10);
        END IF;
        IF dublicate_pk = 0 THEN
            INSERT INTO servinv VALUES(UPPER('&p_servinv'), SYSDATE, UPPER('&p_cname'), UPPER('&p_serial'), '&p_partCost', '&p_labourCost', ('&p_partCost'+'&p_labourCost')*0.13,('&p_partCost'+'&p_labourCost')*1.13);
            :g_output := 'Record Inserted';
            SELECT COUNT(*) INTO data_inserted FROM servinv WHERE servinv=UPPER('&p_servinv');
            IF data_inserted = 1 THEN
               INSERT INTO servwork VALUES(UPPER('&p_servinv'), '&p_des');
                :g_output := 'Record Inserted';
            END IF;
        END IF;
     END IF;
END IF;
END IF;
--Exceptions
EXCEPTION
WHEN both_are_null THEN
    :g_output := 'Serial#,Customer name, service# and Service Description are null';
WHEN no_serial THEN
    :g_output := :g_output || 'Serial number is null'||CHR(10);    
WHEN no_cname THEN
    :g_output := :g_output || 'Customer name is null'||CHR(10); 
WHEN no_desc THEN
      :g_output := :g_output || 'Service Description is null'||CHR(10);
WHEN no_servinv THEN
      :g_output := :g_output || 'Service# is null'||CHR(10);
WHEN null_fields THEN
      :g_output := :g_output || 'Service# and Service Description are null'||CHR(10);
WHEN VALUE_ERROR THEN
      :g_output := :g_output || 'Error in input typed!! Try again'||CHR(10); 
END;
/
PRINT g_output


--select * from servinv;
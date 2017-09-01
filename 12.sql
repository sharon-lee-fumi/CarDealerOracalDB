--12. Delete a prospect entry
--Sharon
ACCEPT p_cname PROMPT 'Enter customer name: '
ACCEPT p_cyear PROMPT 'Enter year: '
ACCEPT p_color PROMPT 'Enter color: '
ACCEPT p_make PROMPT 'Enter make: '
ACCEPT p_model PROMPT 'Enter model: '
ACCEPT p_trim PROMPT 'Enter trim: '
ACCEPT p_ocode PROMPT 'Enter ocode: '
VARIABLE g_output VARCHAR2(4000)
DECLARE
  v_count NUMBER;
  v_nodelete EXCEPTION;
BEGIN
  v_count:=0;
  SELECT COUNT(*)
   INTO  v_count
    FROM prospect
    WHERE UPPER(cname) = UPPER('&p_cname')
    AND UPPER(cyear) = UPPER('&p_cyear')
    AND UPPER(color) = UPPER('&p_color')
    AND UPPER(make) = UPPER('&p_make')
    AND UPPER(model) = UPPER('&p_model')
    AND UPPER(cyear) = UPPER('&p_cyear')
    AND UPPER(trim) = UPPER('&p_trim')
    AND UPPER(ocode) = UPPER('&p_ocode'); 
    IF v_count = 0 THEN
      RAISE v_nodelete;
    END IF;
  DELETE FROM prospect
  WHERE UPPER(cname) = UPPER('&p_cname')
  AND UPPER(cyear) = UPPER('&p_cyear')
  AND UPPER(color) = UPPER('&p_color')
  AND UPPER(make) = UPPER('&p_make')
  AND UPPER(model) = UPPER('&p_model')
  AND UPPER(trim) = UPPER('&p_trim')
  AND UPPER(ocode) = UPPER('&p_ocode');
  COMMIT;
  :g_output:= 'Prospect deleted';
  EXCEPTION
    WHEN v_nodelete THEN
    :g_output:= 'Prospect not found';
    WHEN OTHERS THEN
    :g_output:= 'query returned an error';
END;
/
PRINT g_output;


--insert into prospect
--VALUES ('ALI','ACURA','EL','2017','RED','GT','W11');
--select * from prospect;
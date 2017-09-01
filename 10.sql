--10. Inquire a customer
--Sharon
ACCEPT p_cname PROMPT 'Enter customer name: '
VARIABLE g_output VARCHAR2(4000)
DECLARE 
  v_cname customer.cname%TYPE;
  v_cstreet customer.cstreet%TYPE;
  v_ccity customer.ccity%TYPE;
  v_cprov customer.cprov%TYPE;
  v_cpostal customer.cpostal%TYPE;
  v_chphone customer.chphone%TYPE;
  v_cbphone customer.cbphone%TYPE;
BEGIN
  SELECT cname,cstreet,ccity,cprov,cpostal,chphone,cbphone
    INTO v_cname,v_cstreet,v_ccity,v_cprov,v_cpostal,v_chphone,v_cbphone
    FROM customer
    WHERE UPPER(cname) = UPPER('&p_cname');
    :g_output:='Customer'|| CHR(10);
    :g_output:=:g_output||v_cname|| CHR(10);
    :g_output:=:g_output||TRIM(v_cstreet)||' '||TRIM(v_ccity)||' '||TRIM(v_cprov)||' '||TRIM(v_cpostal)||CHR(10);
    :g_output:=:g_output||TRIM(v_chphone)||' '||TRIM(v_cbphone)|| CHR(10);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
    :g_output:= '&p_cname' || ' not found';
    WHEN TOO_MANY_ROWS THEN
    :g_output:= '&p_cname' || ' query return too many records';
    WHEN OTHERS THEN
    :g_output:= 'query returned an error';
END;
/
PRINT g_output


--kenny
--10040
--select * from servinv; 
--select * from customer;
--select * from car where serial='M08WDT1';
--select * from s9.servwork; 
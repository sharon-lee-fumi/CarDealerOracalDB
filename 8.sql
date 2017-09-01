--8. Inquire a service work order
--Sharon
ACCEPT p_servinv PROMPT 'Enter service invoice#: '
VARIABLE g_output VARCHAR2(4000)
DECLARE 
  v_servinv servinv.servinv%TYPE;
  v_serdate servinv.serdate%TYPE;
  v_cname servinv.cname%TYPE;
  v_cstreet customer.cstreet%TYPE;
  v_ccity customer.ccity%TYPE;
  v_cprov customer.cprov%TYPE;
  v_cpostal customer.cpostal%TYPE;
  v_chphone customer.chphone%TYPE;
  v_cbphone customer.cbphone%TYPE;
  v_serial servinv.serial%TYPE;
  v_make car.make%TYPE;
  v_model car.model%TYPE;
  v_cyear car.cyear%TYPE;
  v_color car.color%TYPE;
  v_partscost servinv.partscost%TYPE;
  v_laborcost servinv.laborcost%TYPE;
  v_tax servinv.tax%TYPE;
  v_totalcost servinv.totalcost%TYPE;
   CURSOR workdesc IS
    SELECT s.servinv,workdesc
    FROM servinv s
    INNER JOIN servwork sw
    ON UPPER(s.servinv) = UPPER(sw.servinv)
    WHERE UPPER(s.servinv) = UPPER('&p_servinv');
BEGIN
  SELECT s.servinv,serdate,s.cname,cstreet,ccity,cprov,cpostal,chphone,cbphone,
  s.serial,make,model,cyear,color,partscost,laborcost,s.tax,s.totalcost
    INTO v_servinv,v_serdate,v_cname,v_cstreet,v_ccity,v_cprov,v_cpostal,v_chphone,v_cbphone,
    v_serial,v_make,v_model,v_cyear,v_color,v_partscost,v_laborcost,v_tax,v_totalcost
    FROM servinv s
    INNER JOIN customer cu
    ON UPPER(s.cname) = UPPER(cu.cname)
    INNER JOIN car c
    ON UPPER(s.serial) = UPPER(c.serial)
    WHERE UPPER(s.servinv) = UPPER('&p_servinv');
    :g_output:='Service Work Order'|| CHR(10);
    :g_output:=:g_output||'&p_servinv'||' '||TRIM(v_serdate)||' '|| TRIM(v_cname)|| CHR(10);
    :g_output:=:g_output||TRIM(v_cstreet)||' '||TRIM(v_ccity)||' '||TRIM(v_cprov)||' '||TRIM(v_cpostal)||' '||TRIM(v_chphone)||' '||TRIM(v_cbphone)|| CHR(10);
    :g_output:=:g_output||TRIM(v_serial)|| CHR(10);
    :g_output:=:g_output||TRIM(v_make)||' '||TRIM(v_model)||' '||TRIM(v_cyear)||' '||TRIM(v_color)|| CHR(10);
    FOR v_workdesc IN workdesc LOOP
      :g_output:=:g_output||'Work: '||TRIM(v_workdesc.workdesc)||CHR(10);
    END LOOP;
    :g_output:=:g_output||'Cost: Parts-'||v_partscost||', Labor-'||v_laborcost||', Tax-'||v_tax||', Total-'||v_totalcost||CHR(10);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
    :g_output:= '&p_servinv' || ' not found';
    WHEN TOO_MANY_ROWS THEN
    :g_output:= '&p_servinv' || ' query return too many records';
    WHEN OTHERS THEN
    :g_output:= 'query returned an error';
END;
/
PRINT g_output


--63527
--10040
--select * from servinv; 
--select * from customer;
--select * from car where serial='M08WDT1';
--select * from servwork; 
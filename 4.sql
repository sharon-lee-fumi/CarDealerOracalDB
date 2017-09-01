--4. Inquire a vehicle inventory record
--Sharon
ACCEPT p_serial PROMPT 'Enter serial#: '
VARIABLE g_output VARCHAR2(4000)
DECLARE 
  v_serial car.serial%TYPE;
  v_make car.make%TYPE;
  v_model car.model%TYPE;
  v_cyear car.cyear%TYPE;
  v_color car.color%TYPE;
  v_trim car.trim%TYPE;
  v_purchfrom car.purchfrom%TYPE;
  v_purchinv car.purchinv%TYPE;
  v_purchdate car.purchdate%TYPE;
  v_purchcost car.purchcost%TYPE;
  v_listprice car.listprice%TYPE;
  CURSOR options IS
    SELECT o.ocode, odesc,olist 
    FROM options o
    INNER JOIN baseoption b
    ON UPPER(b.ocode) = UPPER(o.ocode)
    INNER JOIN car c
    ON UPPER(c.serial) = UPPER(b.serial)
    WHERE UPPER(c.serial) = UPPER('&p_serial');
BEGIN
  SELECT serial,make,model,cyear,color,trim,purchfrom,purchinv,purchdate,purchcost,listprice
  INTO v_serial,v_make,v_model,v_cyear,v_color,v_trim,v_purchfrom,v_purchinv,v_purchdate,v_purchcost,v_listprice
  FROM car
  WHERE UPPER(serial) = UPPER('&p_serial');
    :g_output:='Vehicle Inventory'|| CHR(10);
    :g_output:=:g_output||v_serial||' '|| TRIM(v_make)||' '||TRIM(v_model)||' '||TRIM(v_cyear)||' '||TRIM(v_color)||' '||TRIM(v_trim)||CHR(10);
    :g_output:=:g_output||'Purchased:'||TRIM(v_purchfrom)||' '||TRIM(v_purchinv)||' '||TRIM(v_purchdate)||' '||TRIM(v_purchcost)||' '||TRIM(v_listprice)|| CHR(10);
  FOR v_options IN options LOOP
    :g_output:=:g_output||'Option: '||TRIM(v_options.ocode)||' '||TRIM(v_options.odesc)||' '||TRIM(v_options.olist)||CHR(10);
  END LOOP;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
    :g_output:= '&p_serial' || ' not found';
    WHEN TOO_MANY_ROWS THEN
    :g_output:= '&p_serial' || ' query return too many records';
    WHEN OTHERS THEN
    :g_output:= 'query returned an error';
END;
/
PRINT g_output

--s32
--234

--select * from saleinv; 
--select * from customer;
--select * from car where serial='M08WDT1';
--select * from baseoption;
--select * from options; 
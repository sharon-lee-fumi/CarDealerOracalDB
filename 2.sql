--2. Inquire a sales invoice
--Sharon
ACCEPT p_saleinv PROMPT 'Enter sales invoice#: '
VARIABLE g_output VARCHAR2(4000)
DECLARE 
  v_saleinv saleinv.saleinv%TYPE;
  v_cname saleinv.cname%TYPE;
  v_salesman saleinv.salesman%TYPE;
  v_saledate saleinv.saledate%TYPE;
  v_serial saleinv.serial%TYPE;
  v_totalprice saleinv.totalprice%TYPE;
  v_discount saleinv.discount%TYPE;
  v_net saleinv.net%TYPE;
  v_tax saleinv.tax%TYPE;
  v_licfee saleinv.licfee%TYPE;
  v_tradeserial saleinv.tradeserial%TYPE;
  v_tradeallow saleinv.tradeallow%TYPE;
  v_fire saleinv.fire%TYPE;
  v_collision saleinv.collision%TYPE;
  v_liability saleinv.liability%TYPE;
  v_property saleinv.property%TYPE;
  v_cstreet customer.cstreet%TYPE;
  v_ccity customer.ccity%TYPE;
  v_cprov customer.cprov%TYPE;
  v_cpostal customer.cpostal%TYPE;
  v_chphone customer.chphone%TYPE;
  v_make car.make%TYPE;
  v_model car.model%TYPE;
  v_cyear car.cyear%TYPE;
  v_color car.color%TYPE;
  v_trademake car.make%TYPE;
  v_trademodel car.model%TYPE;
  v_tradecyear car.cyear%TYPE;
  CURSOR options IS
    SELECT o.ocode, odesc,olist 
    FROM options o
    INNER JOIN invoption i
    ON UPPER(i.ocode) = UPPER(o.ocode)
    INNER JOIN saleinv s
    ON UPPER(s.saleinv) = UPPER(i.saleinv)
    WHERE UPPER(s.saleinv) = UPPER('&p_saleinv');
BEGIN
  SELECT saleinv,s.cname,salesman,saledate,s.serial,totalprice,discount,net,tax,licfee,
  tradeserial,tradeallow,fire,collision,liability,property,cstreet,ccity,cprov,cpostal,chphone,
  make,model,cyear,color
    INTO v_saleinv,v_cname,v_salesman,v_saledate,v_serial,v_totalprice,v_discount,
    v_net,v_tax,v_licfee,v_tradeserial,v_tradeallow,v_fire,v_collision,
    v_liability,v_property,v_cstreet,v_ccity,v_cprov,v_cpostal,v_chphone,
    v_make,v_model,v_cyear,v_color
    FROM saleinv s
    INNER JOIN customer cu
    ON UPPER(s.cname) = UPPER(cu.cname)
    INNER JOIN car c
    ON UPPER(s.serial) = UPPER(c.serial)
    WHERE UPPER(saleinv) = UPPER('&p_saleinv');
    SELECT make, model,cyear
    INTO v_trademake,v_trademodel,v_tradecyear
    FROM saleinv s
    INNER JOIN car c
    ON UPPER(s.tradeserial) = UPPER(c.serial)
    WHERE UPPER(s.saleinv) = UPPER('&p_saleinv');
    :g_output:='Sales Invoice'|| CHR(10);
    :g_output:=:g_output||'&p_saleinv'||' '|| TRIM(v_cname)||' '||TRIM(v_saledate)|| CHR(10);
    :g_output:=:g_output||TRIM(v_cstreet)||' '||TRIM(v_ccity)||' '||TRIM(v_cprov)||' '||TRIM(v_cpostal)||' '||TRIM(v_chphone)|| CHR(10);
    :g_output:=:g_output||TRIM(v_salesman)||' '||TRIM(v_serial)|| CHR(10);
    :g_output:=:g_output||TRIM(v_make)||' '||TRIM(v_model)||' '||TRIM(v_cyear)||' '||TRIM(v_color)|| CHR(10);
    :g_output:=:g_output||'Fire: '||TRIM(v_fire)||', Collision: '||TRIM(v_collision)||', Liability: '||TRIM(v_liability)||', Property: '||TRIM(v_property)|| CHR(10);
    :g_output:=:g_output||'Trade-In: '||TRIM(v_tradeserial)||' '||TRIM(v_trademake)||' '||TRIM(v_trademodel)||' '||TRIM(v_tradecyear)||' '||TRIM(v_tradeallow)|| CHR(10);
  FOR v_options IN options LOOP
  :g_output:=:g_output||'Option: '||TRIM(v_options.ocode)||' '||TRIM(v_options.odesc)||' '||TRIM(v_options.olist)||CHR(10);
  END LOOP;
  :g_output:=:g_output||'Price: '||TRIM(v_totalprice)||', Allownce:'||TRIM(v_tradeallow)||', Discount:'||TRIM(v_discount)||', Net: '||TRIM(v_net)||', Tax: '||TRIM(v_tax)||', Total Payable:'||TRIM(v_net+v_tax)||CHR(10);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
    :g_output:= '&p_saleinv' || ' not found';
    WHEN TOO_MANY_ROWS THEN
    :g_output:= '&p_saleinv' || ' query return too many records';
    WHEN OTHERS THEN
    :g_output:= 'query returned an error';
END;
/
PRINT g_output

--s32
--234

--select * from saleinv; 
--select * from customer;
--select * from car;
--select * from invoption;
--select * from options; 
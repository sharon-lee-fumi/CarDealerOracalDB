--6. Inquire an accounting sales supplement
--Sharon
ACCEPT p_saleinv PROMPT 'Enter sales invoice#: '
VARIABLE g_output VARCHAR2(4000)
DECLARE 
  v_saleinv saleinv.saleinv%TYPE;
  v_cname saleinv.cname%TYPE;
  v_saledate saleinv.saledate%TYPE;
  v_serial saleinv.serial%TYPE;
  v_purchcost car.purchcost%TYPE;
  v_listprice car.listprice%TYPE;
  v_freightcost car.freightcost%TYPE;
  v_tax saleinv.tax%TYPE;
  v_licfee saleinv.licfee%TYPE;
  v_commission saleinv.commission%TYPE;
  v_sumcost NUMBER(9,2);
  v_sumsale NUMBER(9,2);
  CURSOR options IS
    SELECT o.ocode, ocost,olist 
    FROM options o
    INNER JOIN invoption i
    ON UPPER(i.ocode) = UPPER(o.ocode)
    INNER JOIN saleinv s
    ON UPPER(s.saleinv) = UPPER(i.saleinv)
    WHERE UPPER(s.saleinv) = UPPER('&p_saleinv');
BEGIN
  v_sumcost:=0;
  v_sumsale:=0;
  SELECT saleinv,s.cname,saledate,s.serial,purchcost,listprice,freightcost,tax,licfee,commission
  INTO v_saleinv,v_cname,v_saledate,v_serial,v_purchcost,v_listprice,v_freightcost,v_tax,v_licfee,v_commission
  FROM saleinv s
  INNER JOIN car c
  ON UPPER(s.serial) = UPPER(c.serial)
  WHERE UPPER(s.saleinv) = UPPER('&p_saleinv');
    :g_output:='Accounting Sales Supplement'|| CHR(10);
    :g_output:=:g_output||v_saleinv||' '|| TRIM(v_cname)||' '||TRIM(v_saledate)||CHR(10);
    :g_output:=:g_output||'Item:'||TRIM(v_serial)||', Cost:'||v_purchcost||', Sale:'||v_listprice|| CHR(10);
  FOR v_options IN options LOOP
    :g_output:=:g_output||'Option:'||TRIM(v_options.ocode)||', Cost:'||TRIM(v_options.ocost)||', Sale:'||TRIM(v_options.olist)||CHR(10);
    v_sumcost:=v_sumcost+v_options.ocost;
    v_sumsale:=v_sumsale+v_options.olist;
  END LOOP;
    :g_output:=:g_output||'Costs: Freight-'||v_freightcost||', Tax-'||v_tax||', LicenseFees-'||v_licfee||', Commission-'||v_commission||CHR(10);
    :g_output:=:g_output||'Sales: Freight-'||v_freightcost||', Tax-'||v_tax||', LicenseFees-'||v_licfee||CHR(10);
    v_sumcost:=v_sumcost+v_purchcost+v_sumcost+v_freightcost+v_tax+v_licfee+v_commission;
    v_sumsale:=v_sumsale+v_listprice+v_sumsale+v_freightcost+v_tax+v_licfee;
    :g_output:=:g_output||'Total costs: '||v_sumcost||CHR(10);
    :g_output:=:g_output||'Total saless: '||v_sumsale||CHR(10);
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
--1
--select * from saleinv; 
--select * from customer;
--select * from car where serial='M08WDT1';
--select * from invoption;
--select * from options; 
--13. Generate a prospect list
--Sharon
VARIABLE g_output VARCHAR2(32000)
DECLARE
  v_count NUMBER;
  v_noprospect EXCEPTION;
  CURSOR prospect IS
    SELECT cname,cyear,color,make,model,trim,ocode
    FROM prospect;
BEGIN
  v_count:=0;
  :g_output:='Prospect List'|| CHR(10);
  :g_output:='Name'|| CHR(9) ||'Want'||CHR(10);
  FOR v_prospect IN prospect LOOP
    :g_output:=:g_output||TRIM(v_prospect.cname)||CHR(9)||TRIM(v_prospect.cyear)||' '||TRIM(v_prospect.color)||' '||TRIM(v_prospect.make)||' '||TRIM(v_prospect.model)||' '||TRIM(v_prospect.trim)||' '||TRIM(v_prospect.ocode)||CHR(10);
    v_count:=v_count+1;
  END LOOP;
  IF v_count = 0 THEN
  RAISE v_noprospect;
  END IF;
  EXCEPTION
    WHEN v_noprospect THEN
    :g_output:= 'Prospect not found';
END;
/
PRINT g_output
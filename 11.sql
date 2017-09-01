--11. Create a new prospect entry
--Sharon
ACCEPT p_cname PROMPT 'Enter customer name'
ACCEPT p_make PROMPT 'Enter make'
ACCEPT p_model PROMPT 'Enter model'
ACCEPT p_year PROMPT 'Enter year'
ACCEPT p_color PROMPT 'Enter color'
ACCEPT p_trim PROMPT 'Enter trim'
ACCEPT p_ocode PROMPT 'Enter option code'
VARIAbLE g_output VARCHAR2(4000)
DECLARE
 v_countOption NUMBER;
 v_countCname NUMBER;
 cname_is_null EXCEPTION;
 make_is_null EXCEPTION;
 both_is_null EXCEPTION;
 make_invalid EXCEPTION;
BEGIN
-- checking the mandory fields
    IF '&p_cname' || '&p_make' IS NULL THEN
      RAISE  both_is_null;
    END IF;
    IF '&p_cname' IS NOT NULL THEN
        IF '&p_make' IS  NULL THEN
         RAISE make_is_null;
       END IF;
    END IF;
    IF '&p_cname' IS  NULL THEN
       IF '&p_make' IS NOT NULL THEN
         RAISE cname_is_null;
       END IF;
    END IF;
     IF '&p_cname' || '&p_make' IS NOT NULL THEN
          IF UPPER('&p_make') NOT IN ('ACURA', 'MERCEDES','LAND ROVER','JAGUAR') THEN
           :g_output := :g_output ||'Please enter ACURA or MERCEDES or LAND ROVER or JAGUAR as car name'||CHR(10);
          END IF;
           IF UPPER('&p_make') IN ('ACURA', 'MERCEDES','LAND ROVER','JAGUAR') THEN
              SELECT COUNT(*)
              INTO  v_countCname
              FROM customer
              WHERE cname = UPPER('&p_cname');
              IF v_countCname = 0 THEN
                :g_output := :g_output ||'This customer is not present in customer table!!'||CHR(10);
                -- enter customer info in script 10
              END IF;
               IF v_countCname = 1 THEN
                  IF UPPER('&p_ocode') IS NOT NULL THEN
                      SELECT COUNT(*)
                      INTO  v_countOption
                      FROM  options
                      WHERE ocode = UPPER('&p_ocode');
                      IF v_countOption = 1 THEN
                         INSERT INTO prospect(cname, make, model, cyear, color, trim, ocode)
                         VALUES(UPPER('&p_cname'), UPPER('&p_make'), UPPER('&p_model'), '&p_year', UPPER('&p_color'),UPPER('&p_trim'), UPPER('&p_ocode'));
                          :g_output := :g_output ||'Row inserted in prospect table!!'||CHR(10);
                      END IF;
                      IF v_countOption = 0 THEN
                          :g_output := :g_output ||'Option code is not present in options tables!!!'||CHR(10);
                      END IF;
                END IF;
                IF UPPER('&p_ocode') IS NULL THEN
                            INSERT INTO prospect(cname, make, model, cyear, color, trim, ocode)
                         VALUES(UPPER('&p_cname'), UPPER('&p_make'), UPPER('&p_model'), '&p_year', UPPER('&p_color'),UPPER('&p_trim'), UPPER('&p_ocode'));
                          :g_output := :g_output ||'Row inserted in prospect table!!'||CHR(10);                  
                END IF;
              END IF;
              
          END IF;
      
    END IF;
    --Exception
   EXCEPTION
   WHEN both_is_null THEN
    :g_output := :g_output ||'Customer name and make is null';
  WHEN make_is_null THEN
  :g_output := :g_output ||'MAKE is null';
  WHEN cname_is_null THEN
  :g_output := :g_output ||'Customer name is null';
END;
/
PRINT g_output

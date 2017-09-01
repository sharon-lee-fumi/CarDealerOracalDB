--9. Create a new customer
--Sharon
ACCEPT p_cname PROMPT 'Enter customer name'
ACCEPT p_street PROMPT 'Enter Street'
ACCEPT p_city PROMPT 'Enter City'
ACCEPT p_prov PROMPT 'Enter Provience'
ACCEPT p_postal PROMPT 'Enter Postal'
ACCEPT p_chphone PROMPT 'Enter customer home phone'
ACCEPT p_cbphone PROMPT 'Enter customer business phone'
VARIAbLE g_output VARCHAR2(2000)
DECLARE
 v_countcname NUMBER;
 customerExist EXCEPTION;
BEGIN
   SELECT COUNT(*)
   INTO v_countcname FROM customer
   WHERE cname = UPPER('&p_cname');
   IF v_countcname > 0 THEN
   RAISE customerExist;
   END IF;
    
    IF v_countcname = 0 THEN
       IF '&p_cname' IS NULL THEN
          :g_output := 'Please enter customer name';
       END IF ;
       IF '&p_cname' IS NOT NULL THEN
          INSERT INTO customer(cname, cstreet, ccity, cprov, cpostal, chphone, cbphone)
          VALUES(UPPER('&p_cname'),UPPER('&p_street'), UPPER('&p_city'),UPPER('&p_prov'), UPPER('&p_postal'),UPPER('&p_chphone'), UPPER('&p_cbphone'));
          :g_output := 'Record inserted into table';
       END IF;
    END IF;
   EXCEPTION
   WHEN customerExist THEN
   :g_output := 'The customer name is occupied by someone else!! Please use another name';
   WHEN VALUE_ERROR THEN
   :g_output := 'DATA SIZE OR TYPE CONVERSION IS INCORRECT';
END;
/
PRINT g_output


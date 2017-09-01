--menu.sql
--Sharon
PROMPT 'Please make a selection: '
PROMPT '1: Create a new sales invoice'
PROMPT '2: Inquire a sales invoice'
PROMPT '3: Create a new vehicle inventory record'
PROMPT '4: Inquire a vehicle inventory record'
PROMPT '5: Create an accounting sales supplement'
PROMPT '6: Inquire an accounting sales supplement'
PROMPT '7: Create a new service work order'
PROMPT '8: Inquire a service work order'
PROMPT '9: Create a new customer'
PROMPT '10: Inquire a customer'
PROMPT '11: Create a new prospect entry'
PROMPT '12: Delete a prospect entry'
PROMPT '13: Generate a prospect list'
PROMPT ' '
ACCEPT p_selection PROMPT 'Enter option 1-13: '

SET term OFF

SELECT CASE '&p_selection'
       WHEN '1' THEN '1.sql'
       WHEN '2' THEN '2.sql'
       WHEN '3' THEN '3.sql'
       WHEN '4' THEN '4.sql'
       WHEN '5' THEN '5.sql'
       WHEN '6' THEN '6.sql'
       WHEN '7' THEN '7.sql'
       WHEN '8' THEN '8.sql'
       WHEN '9' THEN '1.sql'
       WHEN '10' THEN '10.sql'
       WHEN '11' THEN '11.sql'
       WHEN '12' THEN '12.sql'
       WHEN '13' THEN '13.sql'
       ELSE 'menu'
       END AS menu
FROM dual;

SET term on

@&p_selection
-- This procedure will add a new agent to the DELIVERY_AGENT table.
CREATE OR REPLACE PROCEDURE add_delivery_agent(
    p_agent_id IN NUMBER, 
    p_agent_name IN VARCHAR2, 
    p_agent_job IN VARCHAR2
) IS
BEGIN
    INSERT INTO DELIVERY_AGENT (AGENT_ID, AGENT_NAME, AGENT_JOB)
    VALUES (p_agent_id, p_agent_name, p_agent_job);
END add_delivery_agent;
/ 

-- Calling the stored procedure using BEGIN...END
BEGIN
    add_delivery_agent(1, 'John Doe', 'Driver');
END;
/

--------------------------------------------------------------------------------------

-- This procedure will retrieve customer details based on CUSTOMER_ID.
CREATE OR REPLACE PROCEDURE get_customer_details(
    p_customer_id IN NUMBER, 
    p_customer_name OUT VARCHAR2, 
    p_address OUT VARCHAR2, 
    p_email OUT VARCHAR2
) IS
BEGIN
    SELECT CUSTOMER_NAME, ADDRESS, CUSTOMER_EMAIL
    INTO p_customer_name, p_address, p_email
    FROM CUSTOMER
    WHERE CUSTOMER_ID = p_customer_id;
END get_customer_details;
/ 

-- Calling the stored procedure using BEGIN...END
DECLARE
    v_name VARCHAR2(50);
    v_address VARCHAR2(255);
    v_email VARCHAR2(255);
BEGIN
    get_customer_details(1, v_name, v_address, v_email);
    DBMS_OUTPUT.PUT_LINE('Customer Name: ' || v_name);
    DBMS_OUTPUT.PUT_LINE('Address: ' || v_address);
    DBMS_OUTPUT.PUT_LINE('Email: ' || v_email);
END;
/

--------------------------------------------------------------------------------------

-- This procedure will update the status of an order in the ORDERS table.
CREATE OR REPLACE PROCEDURE update_order_status(
    p_order_id IN NUMBER, 
    p_status IN VARCHAR2
) IS
BEGIN
    UPDATE ORDERS
    SET ORDER_STATUS = p_status
    WHERE ORDER_ID = p_order_id;
END update_order_status;
/ 

-- Calling the stored procedure using BEGIN...END
BEGIN
    update_order_status(101, 'Shipped');
END;
/

--------------------------------------------------------------------------------------

-- This procedure will update a customer's address based on the CUSTOMER_ID.
CREATE OR REPLACE PROCEDURE update_customer_address(
    p_customer_id IN NUMBER, 
    p_new_address IN VARCHAR2
) IS
BEGIN
    UPDATE CUSTOMER
    SET ADDRESS = p_new_address
    WHERE CUSTOMER_ID = p_customer_id;
    COMMIT;
END update_customer_address;
/ 

-- Calling the stored procedure using BEGIN...END
BEGIN
    update_customer_address(1, 'New Address, City, Country');
END;
/

---------------------------------------------------------------------------------------

-- This procedure will delete a delivery based on the DELIVERY_ID.
CREATE OR REPLACE PROCEDURE delete_delivery(
    p_delivery_id IN NUMBER
) IS
BEGIN
    DELETE FROM DELIVERY
    WHERE DELIVERY_ID = p_delivery_id;
    COMMIT;
END delete_delivery;
/ 

-- Calling the stored procedure using BEGIN...END
BEGIN
    delete_delivery(1);
END;
/

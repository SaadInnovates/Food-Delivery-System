CREATE OR REPLACE FUNCTION ASSIGN_DELIVERY_AGENT(p_order_id IN NUMBER) 
RETURN VARCHAR2 
IS
  v_agent_id NUMBER;
  v_agent_name VARCHAR2(50);
BEGIN
  -- Fetch the delivery agent with the minimum number of deliveries
  SELECT AGENT_ID, AGENT_NAME
  INTO v_agent_id, v_agent_name
  FROM 
  (
    SELECT 
      DA.AGENT_ID, 
      DA.AGENT_NAME, 
      COUNT(D.DELIVERY_ID) AS DELIVERY_COUNT
    FROM 
      DELIVERY_AGENT DA
    LEFT JOIN 
      DELIVERY D 
    ON 
      DA.AGENT_ID = D.AGENT_ID
    GROUP BY 
      DA.AGENT_ID, DA.AGENT_NAME
    ORDER BY 
      DELIVERY_COUNT ASC, DA.AGENT_ID ASC
  )
  WHERE 
    ROWNUM = 1;

  -- Insert the new delivery record
  INSERT INTO DELIVERY (DELIVERY_ID, AGENT_ID, ORDER_NO, STATUS, ESTIMATED_TIME_MINUTES)
  VALUES (
    (SELECT NVL(MAX(DELIVERY_ID), 0) + 1 FROM DELIVERY), 
    v_agent_id,
    p_order_id,
    'Assigned',
    30
  );

  -- Return the success message
  RETURN 'Agent ' || v_agent_name || ' has been assigned to Order ID ' || p_order_id;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    -- Handle the case where no delivery agents are available
    RETURN 'No delivery agents available for assignment.';
  WHEN OTHERS THEN
    -- Handle any unexpected errors
    RETURN 'An error occurred during agent assignment.';
END;
/


CREATE OR REPLACE FUNCTION GET_TOP_5_CUSTOMERS 
RETURN SYS_REFCURSOR 
IS
  v_cursor SYS_REFCURSOR;
BEGIN
  -- Open a cursor to fetch the top 5 customers
  OPEN v_cursor FOR
    SELECT 
      CUSTOMER_ID, 
      CUSTOMER_NAME, 
      TOTAL_AMOUNT
    FROM 
    (
      SELECT 
        O.CUSTOMER_ID, 
        C.CUSTOMER_NAME, 
        SUM(O.AMOUNT) AS TOTAL_AMOUNT,
        DENSE_RANK() OVER (ORDER BY SUM(O.AMOUNT) DESC) AS RANK
      FROM 
        ORDERS O
      JOIN 
        CUSTOMER C 
      ON 
        O.CUSTOMER_ID = C.CUSTOMER_ID
      GROUP BY 
        O.CUSTOMER_ID, C.CUSTOMER_NAME
    )
    WHERE 
      RANK <= 5;

  -- Return the cursor
  RETURN v_cursor;

EXCEPTION
  WHEN OTHERS THEN
    -- Handle unexpected errors
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    RETURN NULL;
END;
/




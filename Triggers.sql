CREATE OR REPLACE TRIGGER trg_update_order_status
AFTER UPDATE OF STATUS ON DELIVERY
FOR EACH ROW
WHEN (NEW.STATUS = 'Completed')
BEGIN
   UPDATE ORDERS
   SET ORDER_STATUS = 'Delivered'
   WHERE ORDER_ID = :NEW.ORDER_NO;
END;
/


CREATE OR REPLACE TRIGGER trg_check_rating_with_feedback
BEFORE INSERT OR UPDATE ON REVIEW
FOR EACH ROW
BEGIN
   IF :NEW.FEEDBACK IS NOT NULL AND :NEW.RATING IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001, 'Rating must be provided with feedback.');
   END IF;
END;
/


CREATE OR REPLACE TRIGGER trg_validate_item_availability
BEFORE INSERT ON ORDERITEMS
FOR EACH ROW
DECLARE
   v_availability_status VARCHAR2(20);
BEGIN
   SELECT AVAILIBILITY_STATUS 
   INTO v_availability_status
   FROM RESTAURANT_ITEMS
   WHERE ITEM_NUMBER = :NEW.ITEM_NO 
     AND RESTAURANT_ID = (SELECT RESTAURANT_ID FROM ITEMS WHERE ITEM_NO = :NEW.ITEM_NO);
   
   IF v_availability_status != 'Available' THEN
      RAISE_APPLICATION_ERROR(-20002, 'The item is not available for ordering.');
   END IF;
END;
/

CREATE OR REPLACE TRIGGER HR.Pay_ins_no_trigger
before insert 
ON HR.CONTRACTS for each row
declare 
 v_temp number(4);
begin
    IF :NEW.contract_payment_type = 'ANNUAL' THEN
    v_temp := 12 ;
   ELSIF :NEW.contract_payment_type = 'QUARTER' THEN
    v_temp := 3 ;

   ELSIF :NEW.contract_payment_type = 'MONTHLY' THEN
    v_temp := 1 ;
   ELSIF :NEW.contract_payment_type = 'HALF_ANNUAL' THEN 
    v_temp := 6 ;
   ELSE
      v_temp := 0;
   END IF;
    :new.payments_installments_no  := months_between(:NEW.contract_enddate , :NEW.contract_startdate) / v_temp;
end;

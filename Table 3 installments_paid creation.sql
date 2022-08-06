set serveroutput on 100000
declare 
CURSOR contract_cursor  IS select * from contracts ;
v_contract_id number(10);
v_contract_startdate date ;
v_contract_enddate date ; 
v_payments_installments_no number(10);
v_total_fees number(10) ;
v_total_deposit_fees number(10) ; 
begin 
    for cur in contract_cursor 
    LOOP
        select contract_id,contract_startdate , contract_enddate , nvl(payments_installments_no,0) , nvl(contract_total_fees,0) , nvl(contract_deposit_fees,0) 
        into v_contract_id ,v_contract_startdate ,v_contract_enddate,v_payments_installments_no,v_total_fees,v_total_deposit_fees 
       from contracts where contract_id = cur.contract_id ;

               for i in 1..v_payments_installments_no
               LOOP
                    INSERT INTO installments_paid(installment_id , contract_id , installment_date , installment_amount , paid)
                    VALUES (New_installments_paid_seq.nextval , v_contract_id ,
                    add_months(v_contract_startdate ,(months_between(v_contract_enddate,v_contract_startdate)*  (i-1)/v_payments_installments_no)) , 
                   (v_total_fees - v_total_deposit_fees )/v_payments_installments_no  ,  0);
               END LOOP;
    END LOOP; 
end ;

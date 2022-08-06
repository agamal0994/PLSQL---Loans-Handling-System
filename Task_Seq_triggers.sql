DECLARE
   cursor sq_trigger_cursor is ( select ucc.table_name
                         , ucc.column_name
                  from user_constraints uc
                       join user_cons_columns ucc
                           on ucc.table_name = uc.table_name
                          and ucc.constraint_name = uc.constraint_name
                       join user_tab_columns utc
                          on utc.table_name = ucc.table_name
                          and utc.column_name = ucc.column_name
                  where uc.constraint_type = 'P' 
                  and   utc.data_type = 'NUMBER' 
                  );
 BEGIN
   FOR rec_cur IN sq_trigger_cursor
   LOOP
       EXECUTE IMMEDIATE   'CREATE SEQUENCE '||rec_cur.table_name|| '_sq'||
                                          ' START WITH 1 
                                           INCREMENT BY 1 
                                           MAXVALUE 100000
                                           MINVALUE 1';
         EXECUTE IMMEDIATE   'CREATE OR REPLACE TRIGGER '|| rec_cur.table_name|| '_trigger 
                                            BEFORE INSERT ON '|| rec_cur.table_name||' FOR EACH ROW 
                                            BEGIN 
                                            :NEW.'||rec_cur.column_name|| ' := '||rec_cur.table_name||'_sq.NEXTVAL;'||
                                           ' END;' ;
    END LOOP; 
end ;
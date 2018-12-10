CREATE OR REPLACE FUNCTION idq.fn_load_array(integer, integer)
   RETURNS VOID AS
 $$
 /* v1.0 2018-12-10
    build cw contact linked id arrays to use as common key
 */
 
 DECLARE
    p_1 alias for $1;
    p_2 alias for $2;
    
    ary_id integer;
    ary_grp int[];
    
 BEGIN   
    BEGIN
     SELECT array_id, array_grp
      INTO  ary_id, ary_grp
     from  idq.tmp_cw_lnk_grp
      
      WHERE ( p_1 =ANY(array_grp)
              OR
             p_2 =ANY(array_grp )
            );
     END;                             
 
    BEGIN
    IF ary_id is null THEN
    ------- insert new pair array
      INSERT INTO idq.tmp_cw_lnk_grp(array_grp) VALUES  (('{'||p_1||','||p_2||'}')::int[]);  
    
    ------- add new element to array     
    ELSE 
        CASE WHEN array_position(ary_grp,p_1) IS NULL AND array_position(ary_grp,p_2) IS NOT NULL THEN
            UPDATE idq.tmp_cw_lnk_grp SET array_grp = array_append(ary_grp,p_1) WHERE ary_id = array_id;
             WHEN array_position(ary_grp,p_2) IS NULL AND array_position(ary_grp,p_1) IS NOT NULL THEN
            UPDATE idq.tmp_cw_lnk_grp SET array_grp = array_append(ary_grp,p_2) WHERE ary_id = array_id; 
        ELSE  NULL;
        
        END CASE;
              
    END IF;
    END;
         
 END;
 $$  LANGUAGE plpgsql volatile;

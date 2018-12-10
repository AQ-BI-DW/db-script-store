
CREATE OR REPLACE FUNCTION idq.fn_pop_lnk_array()
    RETURNS VOID AS 
 $BODY$
/*
    v1.0 2018-12-10
    build linked id element arrays for use as common keys
*/

DECLARE
    temprow idq.tmp_contact_link%ROWTYPE;
BEGIN
    truncate table idq.tmp_cw_lnk_grp;
    
    FOR temprow IN 
                    select * from idq.tmp_contact_link
    
    LOOP
     
        PERFORM idq.fn_load_array(temprow.person1_id,temprow.person2_id);
        
    END LOOP;
 
 	-----	build person_id array grp mapping
	TRUNCATE TABLE idq.tmp_cw_array_grp;
	
	INSERT INTO idq.tmp_cw_array_grp (array_grp_id, person_id, array_grp)
	(
	select distinct lg.array_id,  vt.person_id, lg.array_grp
	from
	(select distinct
		person1_id as person_id
	from idq.tmp_contact_link
	union
	select distinct
		person2_id as person_id
	from idq.tmp_contact_link) vt
	left outer join idq.tmp_cw_lnk_grp lg on vt.person_id = ANY(lg.array_grp)
	);
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

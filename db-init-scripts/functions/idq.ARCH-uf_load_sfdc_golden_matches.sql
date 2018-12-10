
/*
	NO GOOD 1st GEN TESTING


CREATE OR REPLACE FUNCTION  idq.uf_load_sfdc_golden_matches(v_mt_id text)
  RETURNS void
AS
$$

BEGIN


----------------------
--- #1
--- insert new records w/ existing golden id members
insert into golden.sfdc_contact (sfdc_contact_id,gold_person_id)

select distinct
        lpk.sfdc_id
	,	gp.gold_person_id
from golden.person gp
left outer join golden.sfdc_contact sfc on gp.gold_person_id = sfc.gold_person_id
--- only new person ids with members in golden db
join (
                select distinct
                    vt_gid.golden_id
                    ,   tlky.sfdc_id
                
                from tmp_match_set_out_uf_sfdc tlky
                ----------------------
                -- max golden id for person key matches  
                left outer join
                    ( select distinct
                                max(gsfc.gold_person_id) golden_id
                            ,   tpky.clusterid
                        from  tmp_match_set_out_uf_sfdc tpky 
                        left outer join golden.sfdc_contact gsfc on gsfc.sfdc_contact_id = tpky.sfdc_id
                        where gsfc.gold_person_id is not null
                        group by tpky.clusterid
                    ) vt_gid on tlky.clusterid = vt_gid.clusterid
                ----------------
                left outer join golden.sfdc_contact sf on tlky.sfdc_id = sf.sfdc_contact_id
                
                where vt_gid.clusterid is not null
                and sf.sfdc_contact_id is null

                ) lpk on gp.gold_person_id = lpk.golden_id
;


------------------------
--- #2
--- add new golden ids
insert into golden.person (clusterid,first_name,last_name,create_date,mod_date)
(
select distinct lkpM.mt_clusterid,'','',now(),now()
				  
	from
	 (select distinct 
		max(lpk.clusterid)|| v_mt_id ||current_date as mt_clusterid
		,   lpk.sfdc_id   
	  from tmp_match_set_out_uf_sfdc lpk
	    join (
	            select clusterid
	                ,   count(distinct sfdc_id)
	            from tmp_match_set_out_uf_sfdc 
	            group by clusterid
	            having count(distinct sfdc_id) > 1	    
	          ) g1 on lpk.clusterid = g1.clusterid
	          
	  group by lpk.sfdc_id
	  
	 ) lkpM
	left outer join golden.sfdc_contact sfc on lkpM.sfdc_id = sfc.sfdc_contact_id
	where sfc.gold_person_id is null
)
;

------------------------
--- #4
--- insert new persons w/ new golden id
insert into golden.sfdc_contact (sfdc_contact_id,gold_person_id)


select distinct
        lkpM.sfdc_id
    ,   gpN.gold_person_id

from 
     (select distinct 
		max(lpk.clusterid)|| v_mt_id ||current_date as mt_clusterid
		,   lpk.sfdc_id   
	  from tmp_match_set_out_uf_sfdc lpk
	  join ( 
	            select clusterid
	                ,   count(distinct sfdc_id)
	            from tmp_match_set_out_uf_sfdc 
	            group by clusterid
	            having count(distinct sfdc_id) > 1	    
	          ) g1 on lpk.clusterid = g1.clusterid
	  group by lpk.sfdc_id
	 ) lkpM
    left outer join golden.sfdc_contact sfc on lkpM.sfdc_id = sfc.sfdc_contact_id
    left outer join golden.person gpN on lkpM.mt_clusterid = gpN.clusterid

where sfc.sfdc_contact_id is null
;

END;

$$
LANGUAGE plpgsql;

*/
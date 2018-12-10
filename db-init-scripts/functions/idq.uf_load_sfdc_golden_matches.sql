/*

TESTING SCRIPT



CREATE OR REPLACE FUNCTION  idq.uf_load_sfdc_golden_matches(v_mt_id text) -- idq.uf_load_golden_mtch_sfdc_cw_id()
  RETURNS void
AS
$$

BEGIN

--- SFDC to SFDC matches
IF v_mt_id = '-SFDC-J1-' THEN
---
   BEGIN    
    -----------------------
    --- #J1-1
    --- set cluster size for groups 
    update tmp_match_set_out_uf_sfdc set clustersize = grp.num_sfdc_ids
    from
        (
        ----- find clustersize of man groups
            select clusterid
                , COUNT(distinct sfdc_id) num_sfdc_ids
            from tmp_match_set_out_uf_sfdc
            where NULLIF(cw_person_id,0) > 1
            group by clusterid 
        ) grp  
     
    where tmp_match_set_out_uf_sfdc.clusterid   =   grp.clusterid 
    ;

    -----------------------
    -- #J1-2 insert new sfdc contacts with existing golden ids
    insert into golden.sfdc_contact (sfdc_contact_id,gold_person_id)
    (
    select distinct sf.sfdc_id , vt_nsfc.existing_gold_id
    from tmp_match_set_out_uf_sfdc sf
    join (
           select sft.clusterid
           , COUNT(distinct sft.sfdc_id) num_sfdc_ids
           , MAX(sfc.gold_person_id) existing_gold_id
           from tmp_match_set_out_uf_sfdc sft
           left outer join golden.sfdc_contact sfc on sft.sfdc_id = sfc.sfdc_contact_id
                
           group by sft.clusterid 
           having COUNT(distinct sft.sfdc_id) > 1
         ) vt_nsfc on sf.clusterid = vt_nsfc.clusterid    
    left outer join golden.sfdc_contact sfc on sf.sfdc_id = sfc.sfdc_contact_id 
    
    where sfc.sfdc_contact_id is null    
    and vt_nsfc.existing_gold_id is not null
    )
    ;          
    
    ------------------------
    --- #J1-3
    --- add new golden ids for new matches
    insert into golden.person (clusterid,first_name,last_name,create_date,mod_date)
    (
        select distinct uf.clusterid|| v_mt_id ||current_date ,'','',now(),now()
        from
        tmp_match_set_out_uf_sfdc uf
        join (
           select sft.clusterid
           , COUNT(distinct sft.sfdc_id) num_sfdc_ids
           , MAX(sfc.gold_person_id) existing_gold_id
           from tmp_match_set_out_uf_sfdc sft
           left outer join golden.sfdc_contact sfc on sft.sfdc_id = sfc.sfdc_contact_id
                
           group by sft.clusterid 
           having COUNT(distinct sft.sfdc_id) > 1
         ) vt_nsfc on uf.clusterid = vt_nsfc.clusterid    
    left outer join golden.sfdc_contact sfc on uf.sfdc_id = sfc.sfdc_contact_id 
    
    where sfc.sfdc_contact_id is null    
    and vt_nsfc.existing_gold_id is null
    )
    ;

    ------------------------
    --- #J1-4
    --- new sfdc persons w/ golden id
    insert into golden.sfdc_contact (sfdc_contact_id,gold_person_id)
    (
     select distinct uf.sfdc_id , MAX(gp.gold_person_id)
     from tmp_match_set_out_uf_sfdc uf
        join (
           select sft.clusterid
           , COUNT(distinct sft.sfdc_id) num_sfdc_ids
           , MAX(sfc.gold_person_id) existing_gold_id
           from tmp_match_set_out_uf_sfdc sft
           left outer join golden.sfdc_contact sfc on sft.sfdc_id = sfc.sfdc_contact_id
                
           group by sft.clusterid 
           having COUNT(distinct sft.sfdc_id) > 1
         ) vt_nsfc on uf.clusterid = vt_nsfc.clusterid    
    left outer join golden.sfdc_contact sfc on uf.sfdc_id = sfc.sfdc_contact_id 
    
    left outer join golden.person gp on uf.clusterid|| v_mt_id ||current_date  = gp.clusterid
    
    where sfc.sfdc_contact_id is null    
    and vt_nsfc.existing_gold_id is null
    and gp.gold_person_id is not null
    
    group by  uf.sfdc_id 
    )
    ;
    END;
---------------------------
--- SFDC to CW matches  
ELSEIF v_mt_id = '-SFDC-J2-' THEN

	BEGIN
    -----------------------
    --- #J2-1
    --- insert new sfdc contacts with existing golden ids
    insert into golden.sfdc_contact (sfdc_contact_id,gold_person_id)
    (
    select distinct sf.sfdc_id , vt_nsfc.existing_gold_id
    from tmp_match_set_out_uf_sfdc sf
    join (        
           select vt_clst.clusterid, max(existing_gold_id) existing_gold_id
           from (
                 select distinct
                  sfg.clusterid
                  , sfg.sfdc_id
                  , sfg.cw_person_id
                  , COALESCE(sfc.gold_person_id,cwc.gold_person_id) existing_gold_id
                 from tmp_match_set_out_uf_sfdc sfg
                 left outer join golden.sfdc_contact sfc on sfg.sfdc_id = sfc.sfdc_contact_id
                 left outer join golden.cw_contact cwc on sfg.cw_person_id = cwc.cw_contact_id 
                 -- where clustersize > 1
                 order by 1
                 ) vt_clst 
           group by vt_clst.clusterid 
           having count(vt_clst.sfdc_id) > 0  
            and count(NULLIF(vt_clst.cw_person_id,0)) > 0
 
         ) vt_nsfc on sf.clusterid = vt_nsfc.clusterid    
    left outer join golden.sfdc_contact sfc on sf.sfdc_id = sfc.sfdc_contact_id 
    
    where sf.sfdc_id is not null
    AND sfc.sfdc_contact_id is null    
    AND vt_nsfc.existing_gold_id is not null
    
    )
    ;


    -----------------------
    -- #J2-2 insert new cw contacts with existing golden ids
    insert into golden.cw_contact (cw_contact_id,gold_person_id)
    (
    select distinct sf.cw_person_id , vt_nsfc.existing_gold_id
    from tmp_match_set_out_uf_sfdc sf
    join (
           select vt_clst.clusterid, max(existing_gold_id) existing_gold_id
           from (
                 select distinct
                  sfg.clusterid
                  , sfg.sfdc_id
                  , sfg.cw_person_id
                  , COALESCE(sfc.gold_person_id,cwc.gold_person_id) existing_gold_id
                 from tmp_match_set_out_uf_sfdc sfg
                 left outer join golden.sfdc_contact sfc on sfg.sfdc_id = sfc.sfdc_contact_id
                 left outer join golden.cw_contact cwc on sfg.cw_person_id = cwc.cw_contact_id 
                 where clustersize > 1
                 order by 1
                 ) vt_clst 
           group by vt_clst.clusterid 
           having count(vt_clst.sfdc_id) > 0  
           and count(NULLIF(vt_clst.cw_person_id,0)) > 0
     
              ) vt_nsfc on sf.clusterid = vt_nsfc.clusterid    
    left outer join golden.cw_contact cwc on sf.cw_person_id = cwc.cw_contact_id 
    
    where cwc.cw_contact_id is null  
    and NULLIF(sf.cw_person_id,0) is not null
    and vt_nsfc.existing_gold_id is not null      
    )
    ;  
    

    ------------------------
    --- #J2-3
    --- add new golden ids for new matches
    insert into golden.person (clusterid,first_name,last_name,create_date,mod_date)
    
    (   select distinct uf.clusterid|| v_mt_id ||current_date,'','',now(),now()
        from
        tmp_match_set_out_uf_sfdc uf
        join (
            -------- only pairs with both types of src records
               select vt_clst.clusterid, max(existing_gold_id) existing_gold_id
               from (
                     select distinct
                      sfg.clusterid
                      , sfg.sfdc_id
                      , sfg.cw_person_id
                      , COALESCE(sfc.gold_person_id,cwc.gold_person_id) existing_gold_id
                     from tmp_match_set_out_uf_sfdc sfg
                     left outer join golden.sfdc_contact sfc on sfg.sfdc_id = sfc.sfdc_contact_id
                     left outer join golden.cw_contact cwc on sfg.cw_person_id = cwc.cw_contact_id 
                     -- where clustersize > 1
                     order by 1
                     ) vt_clst 
               group by vt_clst.clusterid 
               having count(vt_clst.sfdc_id) > 0  
               and count(NULLIF(vt_clst.cw_person_id,0)) > 0
        
              ) ngrp on uf.clusterid = ngrp.clusterid
              
        left outer join golden.cw_contact cwc on uf.cw_person_id = cwc.cw_contact_id
        left outer join golden.sfdc_contact sfc on uf.sfdc_id = sfc.sfdc_contact_id       
        
        where ngrp.clusterid is not null
        --    and uf.clustersize > 1
        and ngrp.existing_gold_id is null
    )
    ;

    ------------------------
    --- #J2-4
    --- new sfdc persons w/ golden id
    insert into golden.sfdc_contact (sfdc_contact_id,gold_person_id)
    (   
        select distinct uf.sfdc_id, gp.gold_person_id
        from
        tmp_match_set_out_uf_sfdc uf
        left outer join golden.person gp on uf.clusterid || v_mt_id ||current_date = gp.clusterid
        join (
            -------- only pairs with both types of src records
               select vt_clst.clusterid, max(existing_gold_id) existing_gold_id
               from (
                     select distinct
                      sfg.clusterid
                      , sfg.sfdc_id
                      , sfg.cw_person_id
                      , COALESCE(sfc.gold_person_id,cwc.gold_person_id) existing_gold_id
                     from tmp_match_set_out_uf_sfdc sfg
                     left outer join golden.sfdc_contact sfc on sfg.sfdc_id = sfc.sfdc_contact_id
                     left outer join golden.cw_contact cwc on sfg.cw_person_id = cwc.cw_contact_id 
                   --  where clustersize > 1
                     order by 1
                     ) vt_clst 
               group by vt_clst.clusterid 
               having count(vt_clst.sfdc_id) > 0  
               and count(NULLIF(vt_clst.cw_person_id,0)) > 0
        
              ) ngrp on uf.clusterid = ngrp.clusterid
              
    --    left outer join golden.cw_contact cwc on uf.cw_person_id = cwc.cw_contact_id
        left outer join golden.sfdc_contact sfc on uf.sfdc_id = sfc.sfdc_contact_id       
        
        where ngrp.clusterid is not null
        --    and uf.clustersize > 1
        and ngrp.existing_gold_id is null
            and
                uf.sfdc_id is not null
    )  
    ;
    
    ------------------------
    --- #J2-5
    --- new CW contact persons w/ golden id
    insert into golden.cw_contact (cw_contact_id,gold_person_id) 
    (    
        select distinct uf.cw_person_id, MAX(COALESCE(gp.gold_person_id, ngrp.existing_gold_id)) as gold_person_id
        from
        tmp_match_set_out_uf_sfdc uf
        left outer join golden.person gp on uf.clusterid || v_mt_id ||current_date = gp.clusterid
        join (
        
           -------- only pairs with both types of src records
               select vt_clst.clusterid, max(existing_gold_id) existing_gold_id    
               from (
                     select distinct
                      sfg.clusterid
                      , sfg.sfdc_id
                      , sfg.cw_person_id
                      , COALESCE(sfc.gold_person_id,cwc.gold_person_id) existing_gold_id
                     from tmp_match_set_out_uf_sfdc sfg
                     left outer join golden.sfdc_contact sfc on sfg.sfdc_id = sfc.sfdc_contact_id
                     left outer join golden.cw_contact cwc on sfg.cw_person_id = cwc.cw_contact_id 
                    -- where clustersize > 1
                     order by 1
                     ) vt_clst 
               group by vt_clst.clusterid   
               having count(vt_clst.sfdc_id) > 0  
               and count(NULLIF(vt_clst.cw_person_id,0)) > 0  
               
              ) ngrp on uf.clusterid = ngrp.clusterid       
        left outer join golden.cw_contact cwc on uf.cw_person_id = cwc.cw_contact_id
      --  left outer join golden.sfdc_contact sfc on uf.sfdc_id = sfc.sfdc_contact_id       
        
        where ngrp.clusterid is not null
        --    and uf.clustersize > 1
        -- and ngrp.existing_gold_id is null
        and cwc.cw_contact_id is null
            and
                uf.cw_person_id > 0
        
    group by uf.cw_person_id
    ) 
    ; 
	END;
	
END IF;

END;

$$
LANGUAGE plpgsql;

*/
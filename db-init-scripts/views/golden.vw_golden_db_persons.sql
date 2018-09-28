
DROP VIEW golden.vw_golden_db_persons;

GO

CREATE OR REPLACE VIEW golden.vw_golden_db_persons
AS
/*
    v1.0 2018-09-23 vw for profiling outcome
*/


SELECT DISTINCT gp.gold_person_id
    ,   gcon.cw_contact_id
    ,   mso.seq_cluster_mt_2 final_mach_grp
    ,   mso.seq_cluster_mt_1 lnk_id_grp
    ,   (case when lig.seq_cluster_mt_1 is not null
            then 'true'  else 'false' end) as grouped_match_1 
    ,   (case when fgp.seq_cluster_key is not null
            then 'true'  else 'false' end) as grouped_match_2
   -- ,   (mso.linkedscore) min_match_score
   -- ,   (mso.linkedscore) max_match_score
    ,   mso.first_name
    ,   mso.middle_name
    ,   mso.last_name
    ,   fcs.city
    ,   fcs.state
    ,   mso.postal_code
  --  ,   country
    ,   mso.company_name
    ,   mso.norm_city
    ,   mso.norm_state
    ,   mso.main_phone
    ,   mso.current_phone
    ,   mso.cell_mobile_phone
    ,   mso.email
    ,   mso.private_email
    ,   mso.url
    ,   mso.norm_gender
  --  , mso.*
FROM golden.person gp
JOIN golden.cw_contact gcon on gp.gold_person_id = gcon.gold_person_id
JOIN idq.tmp_match_set_out_mf mso on gcon.cw_contact_id = mso.person_id
JOIN idq.tmp_full_contact_set fcs on gcon.cw_contact_id = fcs.person_id

-------
LEFT OUTER JOIN 
    (
    SELECT mso.seq_cluster_mt_1
        , count(mso.person_id)  num_ids
        
    FROM idq.tmp_match_set_out_bak mso 
    GROUP BY mso.seq_cluster_mt_1
    HAVING count(mso.person_id) > 1
    ) lig on mso.seq_cluster_mt_1 = lig.seq_cluster_mt_1
-------------
LEFT OUTER JOIN 
    (
    SELECT mso.seq_cluster_key
        , count(mso.person_id)  num_ids
        
    FROM idq.tmp_match_set_out_mf mso 
    GROUP BY mso.seq_cluster_key
    HAVING count(mso.person_id) > 1
    ) fgp on mso.seq_cluster_key = fgp.seq_cluster_key   

/*
    (
        (case when lig.seq_cluster_mt_1 is not null
            then 1  else 0 end)::boolean
     ) = true 
     and
    (
        (case when fgp.seq_cluster_key is not null
            then 1  else 0 end)::boolean
    ) = false
*/

;
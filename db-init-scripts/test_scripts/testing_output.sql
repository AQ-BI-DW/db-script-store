


select gp.gold_person_id
    ,   count(distinct gcon.cw_contact_id) num_person_ids
    ,   count(distinct mso.seq_cluster_key) num_groups
    ,   min(mso.linkedscore) min_match_score
    ,   max(mso.linkedscore) max_match_score

from golden.person gp
join golden.cw_contact gcon on gp.gold_person_id = gcon.gold_person_id
join idq.tmp_match_set_out_mf mso on gcon.cw_contact_id = mso.person_id

group by gp.gold_person_id

having count(distinct gcon.cw_contact_id) > 1

GO

select gp.gold_person_id
    ,   gcon.cw_contact_id
    ,   mso.seq_cluster_mt_2 final_mach_grp
    ,   mso.seq_cluster_mt_1 lnk_id_grp
    ,   (case when lig.seq_cluster_mt_1 is not null
            then 1  else 0 end)::boolean as grouped_match_1 
    ,   (case when fgp.seq_cluster_key is not null
            then 1  else 0 end)::boolean as grouped_match_2
   -- ,   (mso.linkedscore) min_match_score
   -- ,   (mso.linkedscore) max_match_score
    ,   mso.first_name
    ,   mso.middle_name
    ,   mso.last_name
    ,   mso.city
    ,   mso.state
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
    
  --  , mso.*
from golden.person gp
join golden.cw_contact gcon on gp.gold_person_id = gcon.gold_person_id
join idq.tmp_match_set_out_mf mso on gcon.cw_contact_id = mso.person_id
join idq.tmp_full_contact_set fcs on gcon.cw_contact_id = fcs.person_id

-------
left outer join 
    (
    select mso.seq_cluster_mt_1
        , count(mso.person_id)  num_ids
        
    from idq.tmp_match_set_out_bak mso 
    group by mso.seq_cluster_mt_1
    having count(mso.person_id) > 1
    ) lig on mso.seq_cluster_mt_1 = lig.seq_cluster_mt_1
-------------
left outer join 
    (
    select mso.seq_cluster_key
        , count(mso.person_id)  num_ids
        
    from idq.tmp_match_set_out_mf mso 
    group by mso.seq_cluster_key
    having count(mso.person_id) > 1
    ) fgp on mso.seq_cluster_key = fgp.seq_cluster_key   

where gp.gold_person_id = '5e483c7d-30bb-42f2-a02c-0fa6d397ce42'

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

limit 500;
    
GO

  select mso.seq_cluster_key
        , count(mso.person_id)  num_ids
        
    from idq.tmp_match_set_out_mf mso 
    group by mso.seq_cluster_key
    having count(mso.person_id) > 1
    
limit 500;  

go

select *
from idq.tmp_match_set_out_mf

where 
limit 500;
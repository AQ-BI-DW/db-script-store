
select gp.gold_person_id
    ,   count(distinct gcon.cw_contact_id) num_person_ids
    ,   count(distinct mso.seq_cluster_mt_1) num_lnk_groups
    ,   min(mso.linkedscore_mt_1) min_match_1_score
    ,   max(mso.linkedscore_mt_1) max_match_1_score

from golden.person gp
join golden.cw_contact gcon on gp.gold_person_id = gcon.gold_person_id
join idq.tmp_match_set_out_bak mso on gcon.cw_contact_id = mso.person_id

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
    ,   (mso.linkedscore_mt_1) min_match_1_score
    ,   (mso.linkedscore_mt_2) max_match_2_score

from golden.person gp
join golden.cw_contact gcon on gp.gold_person_id = gcon.gold_person_id
join idq.tmp_match_set_out_bak mso on gcon.cw_contact_id = mso.person_id
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
        
    from idq.tmp_match_set_out_bak mso 
    group by mso.seq_cluster_key
    having count(mso.person_id) > 1
    ) fgp on mso.seq_cluster_key = fgp.seq_cluster_key   
    

limit 500;
    
GO

  select mso.seq_cluster_key
        , count(mso.person_id)  num_ids
        
    from idq.tmp_match_set_out_bak mso 
    group by mso.seq_cluster_key
    having count(mso.person_id) > 1
    
limit 500;  
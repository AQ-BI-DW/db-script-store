


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
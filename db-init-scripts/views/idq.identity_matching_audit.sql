
--- REFRESH MATERIALIZED VIEW  idq.identity_matching_audit;
--- DROP MATERIALIZED VIEW  idq.identity_matching_audit;



CREATE MATERIALIZED VIEW idq.identity_matching_audit
AS
/*
    v1.0 2018-10-30 view for QA and Stewards
    v1.1 2018-11-02 add in sfdc rules
    v1.2 2018-11-16 add in additional keys (client, src_sys)
*/

select tbl.clusterid::TEXT
    , tbl.person_sys_id::TEXT
    , tbl.linkscore::float
    , tbl.first_name::TEXT
    , tbl.last_name::TEXT
    , tbl.address_1::TEXT
    , tbl.email::TEXT
    , tbl.private_email::TEXT 
    , tbl.score_perc::float
    , tbl.clustersize
    , tbl.run_date
    , tbl.rule_set::TEXT
    , tbl.gold_person_id::TEXT
    , tbl.client_id::TEXT
    , tbl.company_name::TEXT
    , tbl.src_sys::TEXT
    
from
(
select distinct
      rs.clusterid||'-cw-rules-3' as clusterid
    , grp.clustersize
    , rs.person_id::varchar  as person_sys_id
    , rs.linkscore::decimal(18,5) as linkscore
    , rs.first_name
    , rs.last_name
    , rs.address_1
    , rs.email
    , rs.private_email 
    , grp.score_perc
    , rs.load_stamp::DATE as run_date
    , 'cw-rules-3'  as rule_set
    , cwc.gold_person_id
    , fcs.client_id::TEXT
    , fcs.company_name
    , 'Cloudwall'  as src_sys
from tmp_match_set_out_uf3 rs
left outer join golden.cw_contact cwc on rs.person_id = cwc.cw_contact_id
left outer join idq.tmp_full_contact_set fcs on rs.person_id = fcs.person_id
join
(
    select count(distinct person_id) as clustersize
        , min(linkscore)::decimal(18,5) as min_linkscore
        , clusterid
        , case when min(linkscore)::decimal(18,5) between .69999 and .79998
            then '70'
               when min(linkscore)::decimal(18,5) between .79999 and .89998
            then '80'
               when min(linkscore)::decimal(18,5) between .89999 and 1
            then '90' -- else min(linkscore)::float
             end score_perc
       , load_stamp::DATE as load_stamp
    from tmp_match_set_out_uf3
    --  where person_id <= 51 -- clustersize > 1
--  and linkscore < 1
    group by clusterid, load_stamp::DATE
)grp on rs.clusterid = grp.clusterid and rs.load_stamp::DATE = grp.load_stamp
/*
join (select max(load_stamp::DATE) as run_date 
        from tmp_match_set_out_uf
     ) lr on rs.load_stamp::DATE = lr.run_date
*/    

UNION

select distinct
      rs.clusterid||'-cw-rules-2' as clusterid
    , grp.clustersize
    , rs.person_id::varchar  as person_sys_id
    , rs.linkscore::decimal(18,5) as linkscore
    , rs.first_name
    , rs.last_name
    , rs.address_1
    , rs.email
    , rs.private_email 
    , grp.score_perc
    , rs.load_stamp::DATE as run_date
    , 'cw-rules-2'  as rule_set
    , cwc.gold_person_id
    , fcs.client_id::TEXT
    , fcs.company_name
    , 'Cloudwall'     as src_sys
from tmp_match_set_out_uf2 rs
left outer join golden.cw_contact cwc on rs.person_id = cwc.cw_contact_id
left outer join idq.tmp_full_contact_set fcs on rs.person_id = fcs.person_id
join
(
    select count(distinct person_id) as clustersize
        , min(linkscore)::decimal(18,5) as min_linkscore
        , clusterid
        , case when min(linkscore)::decimal(18,5) between .69999 and .79998
            then '70'
               when min(linkscore)::decimal(18,5) between .79999 and .89998
            then '80'
               when min(linkscore)::decimal(18,5) between .89999 and 1
            then '90' -- else min(linkscore)::float
             end score_perc
       , load_stamp::DATE as load_stamp
    from tmp_match_set_out_uf2
    --  where person_id <= 51 -- clustersize > 1
--  and linkscore < 1
    group by clusterid, load_stamp::DATE
)grp on rs.clusterid = grp.clusterid and rs.load_stamp::DATE = grp.load_stamp

UNION

select distinct
      rs.clusterid||'-cw-rules-1' as clusterid
    , grp.clustersize
    , rs.person_id::varchar  as person_sys_id
    , rs.linkscore::decimal(18,5) as linkscore
    , rs.first_name
    , rs.last_name
    , rs.address_1
    , rs.email
    , rs.private_email 
    , grp.score_perc
    , rs.load_stamp::DATE as run_date
    , 'cw-rules-1'  as rule_set
    , cwc.gold_person_id
    , fcs.client_id::TEXT
    , fcs.company_name
    , 'Cloudwall'     as src_sys
from tmp_match_set_out_uf1 rs
left outer join golden.cw_contact cwc on rs.person_id = cwc.cw_contact_id
left outer join idq.tmp_full_contact_set fcs on rs.person_id = fcs.person_id
join
(
    select count(distinct person_id) as clustersize
        , min(linkscore)::decimal(18,5) as min_linkscore
        , clusterid
        , case when min(linkscore)::decimal(18,5) between .69999 and .79998
            then '70'
               when min(linkscore)::decimal(18,5) between .79999 and .89998
            then '80'
               when min(linkscore)::decimal(18,5) between .89999 and 1
            then '90' -- else min(linkscore)::float
             end score_perc
       , load_stamp::DATE as load_stamp
    from tmp_match_set_out_uf1
    --  where person_id <= 51 -- clustersize > 1
--  and linkscore < 1
    group by clusterid, load_stamp::DATE
)grp on rs.clusterid = grp.clusterid and rs.load_stamp::DATE = grp.load_stamp
--------------------------
--------------------------
--- sfdc contacts
--------------------------
--------------------------
UNION

select distinct
      rs.clusterid||'-sfdc-rules-1' as clusterid
    , grp.clustersize
    , rs.sfdc_id::varchar  as person_sys_id
    , rs.linkscore::decimal(18,5) as linkscore
    , rs.first_name
    , rs.last_name
    , rs.address_1
    , rs.email
    , rs.private_email 
    , grp.score_perc
    , rs.load_stamp::DATE as run_date
    , 'sfdc-rules-1'  as rule_set
    , sfc.gold_person_id
    , rs.sfdc_acct_id
    , rs.company_name
    , 'SFDC'    as src_sys
from tmp_match_set_out_uf_sfdc1 rs
left outer join golden.sfdc_contact sfc on rs.sfdc_id = sfc.sfdc_contact_id
join
(
    select count(distinct sfdc_id) as clustersize
        , min(linkscore)::decimal(18,5) as min_linkscore
        , clusterid
        , case when min(linkscore)::decimal(18,5) between .69999 and .79998
            then '70'
               when min(linkscore)::decimal(18,5) between .79999 and .89998
            then '80'
               when min(linkscore)::decimal(18,5) between .89999 and 1
            then '90' -- else min(linkscore)::float
             end score_perc
       , load_stamp::DATE as load_stamp
    from tmp_match_set_out_uf_sfdc1
    --  where person_id <= 51 -- clustersize > 1
--  and linkscore < 1
    group by clusterid, load_stamp::DATE
)grp on rs.clusterid = grp.clusterid and rs.load_stamp::DATE = grp.load_stamp

where rs.clustersize > 1

UNION

select distinct
      rs.clusterid||'-sfdc-rules-2' as clusterid
    , grp.clustersize
    , case when rs.cw_person_id=0 
        then rs.sfdc_id else rs.cw_person_id::varchar end::varchar  as person_sys_id
    , rs.linkscore::decimal(18,5) as linkscore
    , rs.first_name
    , rs.last_name
    , rs.address_1
    , rs.email
    , rs.private_email 
    , grp.score_perc
    , rs.load_stamp::DATE as run_date
    , 'sfdc-rules-2'  as rule_set
    , COALESCE(sfc.gold_person_id,cwc.gold_person_id) as gold_person_id
    , case when rs.cw_person_id=0 
        then rs.sfdc_acct_id else fcs.client_id::varchar end::varchar as acct_client_id
    , case when rs.cw_person_id=0
        then rs.company_name else fcs.company_name end
    , case when rs.cw_person_id=0 
        then 'SFDC' else 'Cloudwall' end    as src_sys
from tmp_match_set_out_uf_sfdc2 rs
left outer join golden.sfdc_contact sfc on rs.sfdc_id = sfc.sfdc_contact_id
left outer join golden.cw_contact cwc on rs.cw_person_id = cwc.cw_contact_id
left outer join idq.tmp_full_contact_set fcs on cwc.cw_contact_id = fcs.person_id
join
(
    select count(distinct sfdc_id) as clustersize
        , min(linkscore)::decimal(18,5) as min_linkscore
        , clusterid
        , case when min(linkscore)::decimal(18,5) between .69999 and .79998
            then '70'
               when min(linkscore)::decimal(18,5) between .79999 and .89998
            then '80'
               when min(linkscore)::decimal(18,5) between .89999 and 1
            then '90' -- else min(linkscore)::float
             end score_perc
       , load_stamp::DATE as load_stamp
    from tmp_match_set_out_uf_sfdc2
    --  where person_id <= 51 -- clustersize > 1
--  and linkscore < 1
    group by clusterid, load_stamp::DATE
)grp on rs.clusterid = grp.clusterid and rs.load_stamp::DATE = grp.load_stamp

where rs.clustersize > 1

) tbl

ORDER BY tbl.run_date, tbl.rule_set
;


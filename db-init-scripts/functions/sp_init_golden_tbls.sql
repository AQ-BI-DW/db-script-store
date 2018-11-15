
select idq.sp_init_golden_tbls();

GO
CREATE OR REPLACE FUNCTION  idq.sp_init_golden_tbls()
RETURNS INTEGER 
AS
$$

DECLARE rcount INTEGER default 0;

BEGIN
truncate table golden.person
;
truncate table golden.cw_contact
;
----------------------
---- tbl1 
insert into golden.person (clusterid,first_name,last_name,create_date,mod_date)
(
    select distinct combo_clusterid,'','',now(),now()
    from 
       (
        select distinct
        tdupM.mt_dup_clusterid
        , tdup.person_id
        , temailM.mt_email_clusterid
        , coalesce(tdupM.mt_dup_clusterid ||':'|| temailM.mt_email_clusterid ,tdupM.mt_dup_clusterid ) as combo_clusterid
        from tmp_match_set_out_qa_2 tdup
        ----------------------
        -- max cluster for email matches           
        left outer join
            (select distinct 
                    max(tema.clusterid) as mt_email_clusterid
                ,   tema.person_id   
            from tmp_match_set_out_qa_3 tema
            where tema.clustersize > 1
            group by tema.person_id
            ) temailM on tdup.person_id = temailM.person_id
        ----------------------
        -- max cluster for dup matches               
        left outer join 
            (select distinct 
                    max(td.clusterid) as mt_dup_clusterid
                ,   td.person_id   
            from tmp_match_set_out_qa_2 td
            -- where td.clustersize > 1
            group by td.person_id
            ) tdupM on tdup.person_id = tdupM.person_id
        where   
            ( tdup.clustersize > 1 
            OR
              temailM.mt_email_clusterid is not null
            )

        ) vt
);

---- tbl2
insert into golden.cw_contact (cw_contact_id,gold_person_id)
(
select distinct 
    src.person_id
    ,   gp.gold_person_id
from idq.tmp_full_contact_set src 
left outer join 
       (
        select distinct
        tdupM.mt_dup_clusterid
        , tdup.person_id
        , temailM.mt_email_clusterid
        , coalesce(tdupM.mt_dup_clusterid ||':'|| temailM.mt_email_clusterid ,tdupM.mt_dup_clusterid ) as combo_clusterid
        from tmp_match_set_out_qa_2 tdup
        ----------------------
        -- max cluster for email matches           
        left outer join
            (select distinct 
                    max(tema.clusterid) as mt_email_clusterid
                ,   tema.person_id   
            from tmp_match_set_out_qa_3 tema
            where tema.clustersize > 1
            group by tema.person_id
            ) temailM on tdup.person_id = temailM.person_id
        ----------------------
        -- max cluster for email matches               
        left outer join 
            (select distinct 
                    max(td.clusterid) as mt_dup_clusterid
                ,   td.person_id   
            from tmp_match_set_out_qa_2 td
            -- where td.clustersize > 1
            group by td.person_id
            ) tdupM on tdup.person_id = tdupM.person_id
        where   
            ( tdup.clustersize > 1 
            OR
              temailM.mt_email_clusterid is not null
            )

        ) vt on src.person_id = vt.person_id
left outer join golden.person gp on vt.combo_clusterid = gp.clusterid
);


/* -- inital - 7 day run
---- tbl1
insert into golden.person (clusterid,first_name,last_name,create_date,mod_date)
(
select distinct seq_cluster_key,'','',now(),now()
from tmp_match_set_out  --  _mf
);

---- tbl2
insert into golden.cw_contact (cw_contact_id,gold_person_id)
(
select distinct mto.person_id
    ,   gp.gold_person_id
from idq.tmp_match_set_out mto --  _mf mto 
left outer join golden.person gp on mto.seq_cluster_key = gp.clusterid
);

-- set rcount = 1; -- (select count(distinct gold_person_id) from golden.person);
*/

RETURN rcount;

END;

$$
LANGUAGE plpgsql;



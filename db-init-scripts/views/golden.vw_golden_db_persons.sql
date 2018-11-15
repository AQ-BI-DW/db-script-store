
DROP VIEW golden.vw_golden_db_persons;

GO

CREATE OR REPLACE VIEW golden.vw_golden_db_persons
AS
/*
    v1.0 2018-09-23 vw for profiling outcome
    v1.0 2018-10-30
*/
GO

SELECT DISTINCT gp.gold_person_id
    ,   gcon.cw_contact_id
   
    ,   fcs.first_name
    ,   fcs.middle_name
    ,   fcs.last_name

    ,   fcs.city
    ,   fcs.state
    ,   fcs.postal_code
  --  ,   country
    ,   fcs.company_name
    ,   fcs.norm_city
    ,   fcs.norm_state
    ,   fcs.main_phone
    ,   fcs.current_phone
    ,   fcs.cell_mobile_phone
    ,   fcs.email
    ,   fcs.private_email
    ,   fcs.url
    ,   fcs.address_1

FROM golden.person gp
JOIN golden.cw_contact gcon on gp.gold_person_id = gcon.gold_person_id
--- JOIN idq.tmp_full_contact_set mso on gcon.cw_contact_id = mso.person_id
JOIN idq.tmp_full_contact_set fcs on gcon.cw_contact_id = fcs.person_id


-------------------

GO

CREATE MATERIALIZED VIEW golden.mv_golden_db_persons
	AS
	SELECT gp.gold_person_id,
    gcon.cw_contact_id,
    mso.seq_cluster_mt_2 AS final_mach_grp,
    mso.seq_cluster_mt_1 AS lnk_id_grp,
        CASE
            WHEN (lig.seq_cluster_mt_1 IS NOT NULL) THEN 'true'::text
            ELSE 'false'::text
        END AS grouped_match_1,
        CASE
            WHEN (fgp.seq_cluster_key IS NOT NULL) THEN 'true'::text
            ELSE 'false'::text
        END AS grouped_match_2,
    mso.first_name,
    mso.middle_name,
    mso.last_name,
    fcs.city,
    fcs.state,
    mso.postal_code,
    mso.company_name,
    mso.norm_city,
    mso.norm_state,
    mso.main_phone,
    mso.current_phone,
    mso.cell_mobile_phone,
    mso.email,
    mso.private_email,
    mso.url,
    mso.norm_gender
   FROM (((((person gp
     JOIN cw_contact gcon ON ((gp.gold_person_id = gcon.gold_person_id)))
     JOIN tmp_match_set_out_mf mso ON ((gcon.cw_contact_id = mso.person_id)))
     JOIN tmp_full_contact_set fcs ON ((gcon.cw_contact_id = fcs.person_id)))
     LEFT JOIN ( SELECT mso_1.seq_cluster_mt_1,
            count(mso_1.person_id) AS num_ids
           FROM tmp_match_set_out_bak mso_1
          GROUP BY mso_1.seq_cluster_mt_1
         HAVING (count(mso_1.person_id) > 1)) lig ON (((mso.seq_cluster_mt_1)::text = (lig.seq_cluster_mt_1)::text)))
     LEFT JOIN ( SELECT mso_1.seq_cluster_key,
            count(mso_1.person_id) AS num_ids
           FROM tmp_match_set_out_mf mso_1
          GROUP BY mso_1.seq_cluster_key
         HAVING (count(mso_1.person_id) > 1)) fgp ON (((mso.seq_cluster_key)::text = (fgp.seq_cluster_key)::text)))
WITH DATA
GO
ALTER MATERIALIZED VIEW golden.mv_golden_db_persons OWNER TO idqadmin
GO

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

RETURN rcount;

END;

$$
LANGUAGE plpgsql;



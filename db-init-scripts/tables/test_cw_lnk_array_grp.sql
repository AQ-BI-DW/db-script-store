drop table idq.tmp_cw_lnk_grp;

CREATE TABLE idq.tmp_cw_lnk_grp (
    array_id serial ,
    array_grp   int[][],
    load_stamp  timestamptz not null default(now()),
    CONSTRAINT arry_grp_pkey PRIMARY KEY (array_id)
);


GO
/*
insert into idq.tmp_cw_lnk_grp (array_grp)
VALUES ('{0}');
*/
GO
DROP TABLE idq.tmp_cw_array_grp;
 
CREATE TABLE idq.tmp_cw_array_grp(
    array_grp_id        int4 ,
    person_id           int4 ,
    array_grp           int[][] null,
    load_stamp          timestamptz not null default(now())
);

CREATE INDEX idx_tmp_cw_array_grp_per_id
	ON idq.tmp_cw_array_grp(person_id, array_grp_id);
GO
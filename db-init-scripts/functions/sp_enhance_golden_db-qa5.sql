truncate table golden.person
;
truncate table golden.cw_contact
;

GO
----------------------
--- #1
--- insert new records w/ existing golden id members
insert into golden.cw_contact (cw_contact_id,gold_person_id)

select  lpk.person_id
	,	gp.gold_person_id
from golden.person gp
left outer join golden.cw_contact cwc on gp.gold_person_id = cwc.gold_person_id
--- only new person ids with members in golden db
join (
                select distinct
                    vt_gid.golden_id
                    ,   tlky.person_id
                
                from tmp_match_set_out_qa_5 tlky
                ----------------------
                -- max golden id for person key matches  
                left outer join
                    ( select distinct
                                max(gcwc.gold_person_id) golden_id
                            ,   tpky.clusterid
                        from  tmp_match_set_out_qa_5 tpky 
                        left outer join golden.cw_contact gcwc on gcwc.cw_contact_id = tpky.person_id
                        where gcwc.gold_person_id is not null
                        group by tpky.clusterid
                    ) vt_gid on tlky.clusterid = vt_gid.clusterid
                ----------------
                left outer join golden.cw_contact cw on tlky.person_id = cw.cw_contact_id
                
                where vt_gid.clusterid is not null
                and cw.cw_contact_id is null

                ) lpk on gp.gold_person_id = lpk.golden_id
;

------------------------
--- #2
--- add new golden ids
insert into golden.person (clusterid,first_name,last_name,create_date,mod_date)
(
select distinct lkpM.mt_clusterid,'','',now(),now()
				  
	from
	 (select distinct 
		max(lpk.clusterid)||'-lpk-'||current_date as mt_clusterid
		,   lpk.person_id   
	  from tmp_match_set_out_qa_5 lpk
	  where lpk.clustersize > 1
	  group by lpk.person_id
	 ) lkpM
	left outer join golden.cw_contact cwc on lkpM.person_id = cwc.cw_contact_id
	where cwc.gold_person_id is null
)
;

------------------------
--- #3
--- update existing persons w/ new golden id

update golden.cw_contact set gold_person_id = upd1.gold_person_id

from
    (
        select distinct
                lkpM.person_id
            ,   gpN.gold_person_id
        
        from 
             (select distinct 
                max(lpk.clusterid)||'-lpk-'||current_date as mt_clusterid
                ,   lpk.person_id   
              from tmp_match_set_out_qa_5 lpk
              where lpk.clustersize > 1
              group by lpk.person_id
             ) lkpM
            left outer join golden.cw_contact cwc on lkpM.person_id = cwc.cw_contact_id
            left outer join golden.person gpN on lkpM.mt_clusterid = gpN.clusterid
        
        where cwc.gold_person_id is null
    ) upd1
where golden.cw_contact.cw_contact_id = upd1.person_id
and golden.cw_contact.gold_person_id is null
;

------------------------
--- #4
--- insert new persons w/ new golden id
insert into golden.cw_contact (cw_contact_id,gold_person_id)

select distinct
        lkpM.person_id
    ,   gpN.gold_person_id

from 
     (select distinct 
		max(lpk.clusterid)||'-lpk-'||current_date as mt_clusterid
		,   lpk.person_id   
	  from tmp_match_set_out_qa_5 lpk
	  where lpk.clustersize > 1
	  group by lpk.person_id
	 ) lkpM
    left outer join golden.cw_contact cwc on lkpM.person_id = cwc.cw_contact_id
    left outer join golden.person gpN on lkpM.mt_clusterid = gpN.clusterid

where cwc.cw_contact_id is null
;










GO

select *
from golden.cw_contact


GO

update tmp_match_set_out_qa_5 set clustersize = 2 where clusterid = '000010723'

go

select *
from cw_contact
where cw_contact_id in (2027794,2453917)
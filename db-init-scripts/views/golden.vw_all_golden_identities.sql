
drop view golden.vw_all_golden_identities

GO
CREATE OR REPLACE VIEW golden.vw_all_golden_identities
AS
/*
    v1.0 2018-10-29 vw for profiling outcome
*/


select 
        tbl.gold_person_id
    ,   tbl.person_sys_id::TEXT 
    ,   tbl.person_src_sys::TEXT 
    ,   tbl.first_name::TEXT 
    ,   tbl.last_name::TEXT 
    ,   tbl.company_name::TEXT 
    ,   tbl.email::TEXT 
    ,   tbl.private_email::TEXT 
    ,   tbl.url::TEXT 
    ,   tbl.address_1::TEXT 
    ,   tbl.address_2::TEXT     
    ,   tbl.city::TEXT 
    ,   tbl.state::TEXT 
    ,   tbl.postal_code::TEXT 
    ,   tbl.country::TEXT 
    ,   src_sys.src_systems::TEXT
    
from (
--- cw contact golden peeps
SELECT DISTINCT gp.gold_person_id
    ,   cwc.cw_contact_id::TEXT as person_sys_id
    ,   'cloudwall' as person_src_sys
    ,   fcs.first_name
    ,   fcs.last_name
    ,   fcs.company_name
    ,   fcs.email
    ,   fcs.private_email
    ,   fcs.url
    ,   fcs.address_1
    ,   fcs.address_2    
    ,   fcs.city
    ,   fcs.state
    ,   fcs.postal_code
    ,   null as country
FROM golden.person gp
JOIN golden.cw_contact cwc on gp.gold_person_id = cwc.gold_person_id
JOIN idq.tmp_full_contact_set fcs on cwc.cw_contact_id = fcs.person_id

union
--- sfdc contact golden peeps
SELECT DISTINCT gp.gold_person_id
    ,   sfdc.sfdc_contact_id::TEXT as person_sys_id
    ,   'salesforce' as person_src_sys
    ,   fcs.firstname_contact
    ,   fcs.lastname_contact
    ,   fcs.name_account
    ,   fcs.email
    ,   null as private_email
    ,   fcs.link_cw_profile__c
    ,   fcs.mailing_address
    ,   null as address_2    
    ,   null as city
    ,   null as state
    ,   fcs.mailing_postalcode
    ,   null as country
FROM golden.person gp
JOIN golden.sfdc_contact sfdc on gp.gold_person_id = sfdc.gold_person_id
JOIN idq.tmp_sfdc_contacts fcs on sfdc.sfdc_contact_id = fcs.id_contact_sfdc

) tbl
--------------------
left outer join 
    (
        select gold_person_id, array_agg(distinct person_src_sys) src_systems
        from (
                select distinct gold_person_id, 'cloudwall' as person_src_sys
                from golden.cw_contact
                union
                select distinct gold_person_id, 'salesforce' as person_src_sys
                from golden.sfdc_contact
            ) vt
        group by gold_person_id
    ) src_sys on tbl.gold_person_id = src_sys.gold_person_id
;    


CREATE TABLE idq.grouped_golden_people (

        gold_person_id                  varchar(128) 
    ,   cw_contact_id                   integer
    ,   final_mach_grp                  varchar(30)   
    ,   lnk_id_grp                      varchar(30)
    ,   grouped_id_link                 varchar(12)
    ,   grouped_all_fields              varchar(12)
    ,   first_name                      varchar(30)
    ,   middle_name                     varchar(30)
    ,   last_name                       varchar(40)
    ,   city                            varchar(36)
    ,   state                           varchar(3)
    ,   postal_code                     varchar(15)
    ,   company_name                    varchar(40)
    ,   norm_city                       varchar(128)
    ,   norm_state                      varchar(128)
    ,   main_phone                      varchar(255)
    ,   current_phone                   varchar(255)
    ,   cell_mobile_phone               varchar(255)
    ,   email                           varchar(255)
    ,   private_email                   varchar(255)
    ,   url                             varchar(255)
    ,   norm_gender                     varchar(3)
    ,   dw_datestamp                    timestamptz default now()
);

CREATE INDEX grouped_golden_people_gold_id
    ON idq.grouped_golden_people
  USING btree
   (gold_person_id COLLATE pg_catalog.default varchar_pattern_ops);
   
CREATE INDEX grouped_golden_people_cw_contact_id
    ON idq.grouped_golden_people
  USING btree
  (cw_contact_id);
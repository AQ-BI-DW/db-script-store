

DROP TABLE if exists tmp_sfdc_rejected_contacts;


CREATE TABLE tmp_sfdc_rejected_contacts (

    sfdc_contact_id         text ,
    sfdc_acct_id            text ,
    reason                  text ,
    load_stamp              timestamptz default(now())

);

ALTER TABLE tmp_full_contact_set
    OWNER TO idqadmin;

GRANT ALL ON TABLE tmp_full_contact_set TO idqadmin;
GRANT SELECT ON TABLE tmp_full_contact_set TO idqdevelopers;
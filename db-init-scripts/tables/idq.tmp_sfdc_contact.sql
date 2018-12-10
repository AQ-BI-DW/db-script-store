
DROP TABLE idq.tmp_sfdc_contacts ;

CREATE TABLE idq.tmp_sfdc_contacts (

    id_account_sfdc                 text null ,
    name_account                    text null,
    cloudwall_id_account            text null,
    id_contact_sfdc                 text NULL,
    lastname_contact                text null,
    firstname_contact               text null,
    cloudwall_id_contact            text null,
    email                           text null,
    phone                           text null,
    mailing_address                 text null,
    mailing_postalcode              text null,
    salutaion                       text null,
    link_cw_profile__c              text null,
    main_phone__c                   text null,
    isdeleted_contact               int null,
    isdeleted_acct                  int null,
    norm_email                      text null,
    title							text null,
    cell_mobile						text null,
    fax								text null,
    linkedin_profile__c				text null,
    redbooks_contact_id__c			text null,
    
    load_stamp timestamptz NOT NULL DEFAULT now()
)
;

ALTER TABLE idq.tmp_sfdc_contacts
    OWNER TO idqadmin;

GRANT ALL ON TABLE idq.tmp_sfdc_contacts TO idqadmin;
GRANT SELECT ON TABLE idq.tmp_sfdc_contacts TO idqdevelopers;
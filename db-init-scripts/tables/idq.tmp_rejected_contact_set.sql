
DROP TABLE idq.tmp_rejected_contact_set;

CREATE TABLE idq.tmp_rejected_contact_set  ( 
	person_id        	integer NULL,
	first_name       	varchar(30) NULL,
	middle_name      	varchar(30) NULL,
	last_name        	varchar(40) NULL,
	nickname         	varchar(30) NULL,
	address_1        	varchar(4000) NULL,
	address_2        	varchar(30) NULL,
	city             	varchar(35) NULL,
	state            	char(3) NULL,
	postal_code      	varchar(15) NULL,
	country_id       	integer NULL,
	company_name     	varchar(40) NULL,
	url              	varchar(80) NULL,
    linkedin_url        varchar(128),
	email            	text NULL,
	private_email    	text NULL,
	cell_mobile_phone	text NULL,
	main_phone       	text NULL,
	current_phone    	text NULL,
	sms              	text NULL,
	addl_main        	text NULL,
	addl_current     	text NULL,
	im_name          	text NULL,
	addl_im_name     	text NULL,
	pager            	text NULL,
	emergency_phone  	text NULL,
	linked_person_id 	integer NULL,
	norm_state       	text NULL,
	norm_city        	text NULL,
	linked_person_key	text NULL,
	gender_ref       	varchar(1) NULL,
	name_salutation  	varchar(28) NULL,
    reason              text null ,
	load_stamp       	timestamptz NOT NULL DEFAULT(now()) --  ,
	--  CONSTRAINT pk_person_reason PRIMARY KEY(person_id) 
	)
;
GO
ALTER TABLE idq.tmp_rejected_contact_set
    OWNER TO idqauth;
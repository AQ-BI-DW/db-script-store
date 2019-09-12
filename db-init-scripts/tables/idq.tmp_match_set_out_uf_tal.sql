
DROP TABLE idq.tmp_match_set_out_uf_tal1;

CREATE TABLE idq.tmp_match_set_out_uf_tal1  ( 
	clusterid        	varchar(30) NULL,
	groupkey         	text NULL,
	clustersize      	integer NULL,
	rowid            	text NULL,
	driverid         	text NULL,
	driverscore      	real NULL,
	linkid           	text NULL,
	linkscore        	real NULL,
	person_id        	integer NULL,
	first_name       	varchar(30) NULL,
	middle_name      	varchar(30) NULL,
	last_name        	varchar(40) NULL,
	nickname         	varchar(30) NULL,
	address_1        	text NULL,
	address_2        	varchar(30) NULL,
	city             	varchar(35) NULL,
	state            	char(3) NULL,
	postal_code      	varchar(15) NULL,
	country_id       	integer NULL,
	company_name     	varchar(40) NULL,
	url              	varchar(80) NULL,
	email            	varchar(255) NULL,
	private_email    	varchar(255) NULL,
	cell_mobile_phone	varchar(255) NULL,
	main_phone       	varchar(255) NULL,
	current_phone    	varchar(255) NULL,
	sms              	varchar(255) NULL,
	addl_main        	varchar(255) NULL,
	addl_current     	varchar(255) NULL,
	im_name          	varchar(255) NULL,
	addl_im_name     	varchar(255) NULL,
	pager            	varchar(255) NULL,
	emergency_phone  	varchar(255) NULL,
	linked_person_id 	integer NULL,
	norm_state       	text NULL,
	norm_city        	text NULL,
	linked_person_key	text NULL,
	load_stamp       	timestamp with time zone NOT NULL DEFAULT now(),
	norm_gender      	varchar(3) NULL,
	full_name        	text NULL 
);

CREATE INDEX idx_tmp_match_set_out_uf_tal1_id_clusterid
    ON idq.tmp_match_set_out_uf_tal1(clusterid, person_id)
;    
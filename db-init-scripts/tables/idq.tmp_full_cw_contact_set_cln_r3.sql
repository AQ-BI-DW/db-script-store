
-- DROP TABLE tmp_full_contact_set CASCADE;
--- dependencies golden.vw_golden_db_persons

CREATE TABLE tmp_full_cw_contact_set_cln_r3
(
  person_id integer,
  first_name character varying(30),
  middle_name character varying(30),
  last_name character varying(40),
  nickname character varying(30),
  address_1 character varying(4000),
  address_2 character varying(30),
  city character varying(35),
  state character(3),
  postal_code character varying(15),
  country_id integer,
  client_id integer,
  company_name character varying(40),
  url character varying(80),
  linkedin_url character varying(128),
  email text,
  private_email text,
  cell_mobile_phone text,
  main_phone text,
  current_phone text,
  sms text,
  addl_main text,
  addl_current text,
  im_name text,
  addl_im_name text,
  pager text,
  emergency_phone text,
  linked_person_id integer,
  norm_state text,
  norm_city text,
  linked_person_key text,
  gender_ref character varying(1),
  name_salutation character varying(28),
  load_stamp timestamp without time zone
);

ALTER TABLE tmp_full_cw_contact_set_cln_r3
    OWNER TO idqadmin;

GRANT ALL ON TABLE tmp_full_cw_contact_set_cln_r3 TO idqadmin;
GRANT SELECT ON TABLE tmp_full_cw_contact_set_cln_r3 TO idqdevelopers;

GO


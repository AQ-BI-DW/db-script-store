
DROP TABLE idq.tmp_match_cases;

CREATE TABLE idq.tmp_match_cases  ( 
	person_id  	integer NULL,
	cluster_id 	text NULL,
	groupkey   	text NULL,
	clustersize	integer NULL,
	driverid   	text NULL,
	driverscore	double precision NULL,
	seq_num    	integer NULL,
	mtch_seq_name   text null,
	load_stamp 	timestamp with time zone NOT NULL DEFAULT now() 
);
	
CREATE INDEX tmp_match_cases_person_id_idx
  ON idq.tmp_match_cases
  USING btree
  (person_id)
;
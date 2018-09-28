TRUNCATE TABLE idq.grouped_golden_people;

insert into idq.grouped_golden_people
      (gold_person_id, cw_contact_id, final_mach_grp, lnk_id_grp, grouped_id_link, grouped_all_fields, first_name, middle_name, last_name, city, state, postal_code, company_name, norm_city, norm_state, main_phone, current_phone, cell_mobile_phone, email, private_email, url, norm_gender)
(
SELECT DISTINCT gold_person_id, cw_contact_id, final_mach_grp, lnk_id_grp, grouped_match_1, grouped_match_2, first_name, middle_name, last_name, city, state, postal_code, company_name, norm_city, norm_state, main_phone, current_phone, cell_mobile_phone, email, private_email, url, norm_gender 
	FROM golden.vw_golden_db_persons
);

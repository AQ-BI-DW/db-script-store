
UNLOAD  ('SELECT * FROM public.tbl_title_ratings')
TO 
's3://hs-data-store/unload/unload_data_title_ratings'
iam_role 'arn:aws:iam::810310880928:role/RedshiftIAM'
HEADER ADDQUOTES delimiter '\t' gzip ;

GO

UNLOAD  ('SELECT * FROM public.tbl_title_ratings')
TO 
's3://hs-data-store/unload/unload_data_title_ratings'
iam_role 'arn:aws:iam::810310880928:role/RedshiftIAM'
FORMAT CSV gzip ;
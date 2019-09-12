DROP TABLE if exists public.tbl_name_basic;

CREATE TABLE public.tbl_name_basic (
    nconst	        text,
    primaryName     text,
    birthYear       integer,
    deathYear       integer,
    primaryProfession   text,
    knownForTitles      text
   );
----------------------
DROP TABLE if exists public.tbl_title_akas;

CREATE TABLE public.tbl_title_akas (
    titleId             text,
    ordering            integer,
    title               varchar(30000),
    region              text,
    language            text,
    types               text,
    attributes          text,     
    isOriginalTitle     varchar(30000)
 );

-------------------
DROP TABLE if exists public.tbl_title_basic;

CREATE TABLE public.tbl_title_basic (
    tconst              text,
    titleType           text,
    primaryTitle        varchar(30000),
    originalTitle       varchar(30000),
    isAdult             boolean,
    startYear           integer,
    endYear             integer,
    runtimeMinutes      integer,
    genres              text
);

-------------------
DROP TABLE if exists public.tbl_title_crew;

CREATE TABLE public.tbl_title_crew (
    tconst              text,
    directors           varchar(30000),
    writers             varchar(30000)
);
-------------------

DROP TABLE if exists public.tbl_title_episode;

CREATE TABLE public.tbl_title_episode (
    tconst              text,
    parentTconst        text,
    seasonNumber        integer,
    episodeNumber       integer
);    
-------------------
DROP TABLE if exists public.tbl_title_principals;

CREATE TABLE public.tbl_title_principals (
	tconst				text,
	ordering			integer,
	nconst				text,
	category			text,
	job					varchar(30000),
	characters			varchar(30000)
);
-------------------
DROP TABLE if exists public.tbl_title_ratings;

CREATE TABLE public.tbl_title_ratings (
	tconst				text,
	averageRating		float,
	numVotes			integer
);	

-------------------
COPY public.tbl_name_basic FROM 's3://hs-data-store/name.basics.tsv.gz'
iam_role 'arn:aws:iam::810310880928:role/RedshiftIAM'
IGNOREHEADER 1 delimiter '\t' gzip ;

COPY public.tbl_title_akas FROM 's3://hs-data-store/title.akas.tsv.gz'
iam_role 'arn:aws:iam::810310880928:role/RedshiftIAM'
IGNOREHEADER 1 delimiter '\t' gzip ;

COPY public.tbl_title_basic FROM 's3://hs-data-store/title.basics.tsv.gz'
iam_role 'arn:aws:iam::810310880928:role/RedshiftIAM'
IGNOREHEADER 1 delimiter '\t' gzip ;

COPY public.tbl_title_crew FROM 's3://hs-data-store/title.crew.tsv.gz'
iam_role 'arn:aws:iam::810310880928:role/RedshiftIAM'
IGNOREHEADER 1 delimiter '\t' gzip ;

COPY public.tbl_title_episode FROM 's3://hs-data-store/title.episode.tsv.gz'
iam_role 'arn:aws:iam::810310880928:role/RedshiftIAM'
IGNOREHEADER 1 delimiter '\t' gzip ;

COPY public.tbl_title_principals FROM 's3://hs-data-store/title.principals.tsv.gz'
iam_role 'arn:aws:iam::810310880928:role/RedshiftIAM'
IGNOREHEADER 1 delimiter '\t' gzip ;

COPY public.tbl_title_ratings FROM 's3://hs-data-store/title.ratings.tsv.gz'
iam_role 'arn:aws:iam::810310880928:role/RedshiftIAM'
IGNOREHEADER 1 delimiter '\t' gzip ;

----------------------
GO

SELECT *
from stl_load_errors;
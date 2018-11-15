CREATE OR REPLACE FUNCTION "aquent"."normalize_email" (text)  RETURNS text
  IMMUTABLE
  RETURNS NULL ON NULL INPUT
AS $dbvis$
for (@_) {
    s/[\x00-\x20\x7F]+//g;
    s/[[:upper:]]+/\L$&/g;
    return $_;
}
$dbvis$ LANGUAGE plperl
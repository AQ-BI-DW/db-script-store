select first_name, last_name, email, substring(email,1,strpos(email,'@')-1) mailbox, substring(email,strpos(email,'@')+1, (strpos(email,'.') - ( strpos(email,'@')+1))) subdomain

 from rs1 ;

cat $1 | awk -F ',' -v q="'" '/^G/{print "insert into server_metrics values (nextval(" q "server_metrics_id_seq" q ")," q substr($2,4,2)"/"substr($2,1,2)"/"substr($2,7,5) q "," q substr($2,4,2)"/"substr($2,1,2)"/"substr($2,7,5)" "$3 q ","$5","$7","$9","$10","$6",14,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP);"}' > $2

cat $1 | awk -F ',' -v q="'" '/^P/{print "insert into process_metrics values (nextval(" q "process_metrics_id_seq" q ")," q substr($2,4,2)"/"substr($2,1,2)"/"substr($2,7,5) q "," q substr($2,4,2)"/"substr($2,1,2)"/"substr($2,7,5)" "$3 q ","$5"," q $6 q "," q "unknown" q ","$7","$8","$9",0,14,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP);"}' >> $2

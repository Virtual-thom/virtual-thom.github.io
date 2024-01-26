---
layout: post
title: Rotation de partition de table Oracle en PL/SQL
date: 2017-06-28 21:10
author: Virtual Thom
categories: [oracle, pl, sql, table, partition, rotation]
---

J'ai une table oracle partitionnée. Je veux un job mensuel qui drop les partitions plus vieilles que 13 mois et qui en créé une nouvelle s'il y a eu au moins un drop.

__NE JAMAIS__ copier/coller sans comprendre et sans adapter à vos besoins. Pour le coup, c'est plus un mémo pour moi.

```sql
-- exemple d'une partition PARTITION "P201608"  VALUES LESS THAN (TIMESTAMP' 2016-09-01 00:00:00')
SET serveroutput ON
DECLARE
  l_sql_stmt VARCHAR2(1000);
  new_partition_name VARCHAR2(7);
  new_range_lessdate DATE ;
  is_at_least_one_drop NUMBER(1);
BEGIN
    is_at_least_one_drop := 0 ;
    FOR cc IN (SELECT partition_name, high_value
                 FROM user_tab_partitions
                WHERE table_name = 'TOP100_STATS_TRT') LOOP
           IF sysdate >=  ADD_MONTHS(TO_DATE(SUBSTR(cc.partition_name,2,6),'YYYYMM'),14) THEN -- je compare la sysdate avec la date avec le nom de la partition en ajoutant 14 mois 
                l_sql_stmt := 'ALTER TABLE TOP100_STATS_TRT' ||
                        ' DROP PARTITION ' || cc.partition_name;
                dbms_output.put_line( l_sql_stmt );
                EXECUTE IMMEDIATE l_sql_stmt;
                
                is_at_least_one_drop := 1 ; -- on est passe au moins une fois dans un drop
           END IF ;

    END LOOP;
    IF is_at_least_one_drop =  1 THEN
          SELECT TO_CHAR(ADD_MONTHS(partition_date,1),'"P"YYYYMM'), ADD_MONTHS(partition_date,2) INTO new_partition_name, new_range_lessdate FROM (
            SELECT partition_name, TO_DATE(SUBSTR(partition_name,2,6),'YYYYMM') as partition_date
            FROM user_tab_partitions
            WHERE table_name = 'TOP100_STATS_TRT'
            ORDER BY partition_date DESC
          ) WHERE rownum = 1 ;
          l_sql_stmt := 'ALTER TABLE TOP100_STATS_TRT ADD PARTITION '|| new_partition_name ||' VALUES LESS THAN ('''|| new_range_lessdate ||''')' ;
          dbms_output.put_line( l_sql_stmt );
          EXECUTE IMMEDIATE l_sql_stmt;

          l_sql_stmt := 'ALTER INDEX TOP100_STATS_TRT_PK REBUILD'; -- on reconstruit l'index
          dbms_output.put_line( l_sql_stmt );
          EXECUTE IMMEDIATE l_sql_stmt;
     END IF ;
 END;
 /
```

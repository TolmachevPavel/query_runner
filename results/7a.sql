                                                                                                      QUERY PLAN                                                                                                       
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=1918.23..1918.24 rows=1 width=64) (actual time=829.793..829.797 rows=1 loops=1)
   ->  Nested Loop  (cost=21.22..1918.22 rows=1 width=32) (actual time=43.795..829.768 rows=32 loops=1)
         ->  Nested Loop  (cost=21.08..1917.21 rows=1 width=36) (actual time=43.775..829.678 rows=32 loops=1)
               Join Filter: (an.person_id = n.id)
               ->  Nested Loop  (cost=20.66..1916.72 rows=1 width=48) (actual time=43.751..829.478 rows=14 loops=1)
                     Join Filter: (n.id = pi.person_id)
                     ->  Nested Loop  (cost=20.23..1822.77 rows=97 width=40) (actual time=0.111..729.544 rows=17559 loops=1)
                           ->  Nested Loop  (cost=19.80..1430.28 rows=839 width=21) (actual time=0.090..258.191 rows=105262 loops=1)
                                 ->  Nested Loop  (cost=19.36..1317.70 rows=23 width=25) (actual time=0.069..34.570 rows=1467 loops=1)
                                       ->  Hash Join  (cost=18.93..561.10 rows=169 width=4) (actual time=0.043..4.209 rows=5186 loops=1)
                                             Hash Cond: (ml.link_type_id = lt.id)
                                             ->  Seq Scan on movie_link ml  (cost=0.00..462.97 rows=29997 width=8) (actual time=0.009..1.745 rows=29997 loops=1)
                                             ->  Hash  (cost=18.88..18.88 rows=4 width=4) (actual time=0.015..0.016 rows=1 loops=1)
                                                   Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                   ->  Seq Scan on link_type lt  (cost=0.00..18.88 rows=4 width=4) (actual time=0.009..0.010 rows=1 loops=1)
                                                         Filter: ((link)::text = 'features'::text)
                                                         Rows Removed by Filter: 17
                                       ->  Index Scan using title_pkey on title t  (cost=0.43..4.48 rows=1 width=21) (actual time=0.006..0.006 rows=0 loops=5186)
                                             Index Cond: (id = ml.linked_movie_id)
                                             Filter: ((production_year >= 1980) AND (production_year <= 1995))
                                             Rows Removed by Filter: 1
                                 ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..4.52 rows=37 width=8) (actual time=0.007..0.146 rows=72 loops=1467)
                                       Index Cond: (movie_id = t.id)
                           ->  Index Scan using name_pkey on name n  (cost=0.43..0.47 rows=1 width=19) (actual time=0.004..0.004 rows=0 loops=105262)
                                 Index Cond: (id = ci.person_id)
                                 Filter: (((name_pcode_cf)::text >= 'A'::text) AND ((name_pcode_cf)::text <= 'F'::text) AND (((gender)::text = 'm'::text) OR (((gender)::text = 'f'::text) AND (name ~~ 'B%'::text))))
                                 Rows Removed by Filter: 1
                     ->  Index Scan using person_id_person_info on person_info pi  (cost=0.43..0.96 rows=1 width=8) (actual time=0.006..0.006 rows=0 loops=17559)
                           Index Cond: (person_id = ci.person_id)
                           Filter: (note = 'Volker Boehm'::text)
                           Rows Removed by Filter: 20
               ->  Index Scan using person_id_aka_name on aka_name an  (cost=0.42..0.47 rows=2 width=4) (actual time=0.010..0.013 rows=2 loops=14)
                     Index Cond: (person_id = ci.person_id)
                     Filter: (name ~~ '%a%'::text)
                     Rows Removed by Filter: 1
         ->  Index Scan using info_type_pkey on info_type it  (cost=0.14..0.58 rows=1 width=4) (actual time=0.002..0.002 rows=1 loops=32)
               Index Cond: (id = pi.info_type_id)
               Filter: ((info)::text = 'mini biography'::text)
 Planning Time: 5.173 ms
 Execution Time: 829.950 ms
(40 rows)


                                                                                QUERY PLAN                                                                                
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=1494.81..1494.82 rows=1 width=64) (actual time=224.913..224.918 rows=1 loops=1)
   ->  Nested Loop  (cost=21.22..1494.81 rows=1 width=32) (actual time=9.724..224.892 rows=16 loops=1)
         ->  Nested Loop  (cost=21.08..1493.80 rows=1 width=36) (actual time=9.702..224.840 rows=16 loops=1)
               Join Filter: (an.person_id = n.id)
               ->  Nested Loop  (cost=20.66..1493.30 rows=1 width=48) (actual time=9.682..224.768 rows=8 loops=1)
                     Join Filter: (n.id = pi.person_id)
                     ->  Nested Loop  (cost=20.23..1488.46 rows=5 width=40) (actual time=0.269..219.415 rows=1076 loops=1)
                           ->  Nested Loop  (cost=19.80..1399.62 rows=193 width=21) (actual time=0.092..90.371 rows=33415 loops=1)
                                 ->  Nested Loop  (cost=19.36..1317.70 rows=5 width=25) (actual time=0.072..30.358 rows=435 loops=1)
                                       ->  Hash Join  (cost=18.93..561.10 rows=169 width=4) (actual time=0.049..3.687 rows=5186 loops=1)
                                             Hash Cond: (ml.link_type_id = lt.id)
                                             ->  Seq Scan on movie_link ml  (cost=0.00..462.97 rows=29997 width=8) (actual time=0.010..1.584 rows=29997 loops=1)
                                             ->  Hash  (cost=18.88..18.88 rows=4 width=4) (actual time=0.016..0.017 rows=1 loops=1)
                                                   Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                   ->  Seq Scan on link_type lt  (cost=0.00..18.88 rows=4 width=4) (actual time=0.010..0.010 rows=1 loops=1)
                                                         Filter: ((link)::text = 'features'::text)
                                                         Rows Removed by Filter: 17
                                       ->  Index Scan using title_pkey on title t  (cost=0.43..4.48 rows=1 width=21) (actual time=0.005..0.005 rows=0 loops=5186)
                                             Index Cond: (id = ml.linked_movie_id)
                                             Filter: ((production_year >= 1980) AND (production_year <= 1984))
                                             Rows Removed by Filter: 1
                                 ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..16.01 rows=37 width=8) (actual time=0.006..0.131 rows=77 loops=435)
                                       Index Cond: (movie_id = t.id)
                           ->  Index Scan using name_pkey on name n  (cost=0.43..0.46 rows=1 width=19) (actual time=0.004..0.004 rows=0 loops=33415)
                                 Index Cond: (id = ci.person_id)
                                 Filter: (((name_pcode_cf)::text ~~ 'D%'::text) AND ((gender)::text = 'm'::text))
                                 Rows Removed by Filter: 1
                     ->  Index Scan using person_id_person_info on person_info pi  (cost=0.43..0.96 rows=1 width=8) (actual time=0.005..0.005 rows=0 loops=1076)
                           Index Cond: (person_id = ci.person_id)
                           Filter: (note = 'Volker Boehm'::text)
                           Rows Removed by Filter: 16
               ->  Index Scan using person_id_aka_name on aka_name an  (cost=0.42..0.47 rows=2 width=4) (actual time=0.006..0.007 rows=2 loops=8)
                     Index Cond: (person_id = ci.person_id)
                     Filter: (name ~~ '%a%'::text)
                     Rows Removed by Filter: 1
         ->  Index Scan using info_type_pkey on info_type it  (cost=0.14..0.58 rows=1 width=4) (actual time=0.003..0.003 rows=1 loops=16)
               Index Cond: (id = pi.info_type_id)
               Filter: ((info)::text = 'mini biography'::text)
 Planning Time: 4.862 ms
 Execution Time: 225.051 ms
(40 rows)


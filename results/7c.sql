                                                                                                      QUERY PLAN                                                                                                       
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=11771.89..11771.90 rows=1 width=64) (actual time=9198.349..9198.356 rows=1 loops=1)
   ->  Nested Loop  (cost=22.98..11771.88 rows=1 width=110) (actual time=0.575..8976.505 rows=68185 loops=1)
         Join Filter: (an.person_id = n.id)
         ->  Nested Loop  (cost=22.55..11771.38 rows=1 width=122) (actual time=0.551..8779.720 rows=40157 loops=1)
               Join Filter: (it.id = pi.info_type_id)
               ->  Seq Scan on info_type it  (cost=0.00..2.41 rows=1 width=4) (actual time=0.019..0.025 rows=1 loops=1)
                     Filter: ((info)::text = 'mini biography'::text)
                     Rows Removed by Filter: 112
               ->  Nested Loop  (cost=22.55..11768.58 rows=31 width=126) (actual time=0.531..8774.687 rows=40157 loops=1)
                     Join Filter: (n.id = pi.person_id)
                     ->  Nested Loop  (cost=22.12..10368.93 rows=1549 width=23) (actual time=0.142..7887.521 rows=150772 loops=1)
                           ->  Nested Loop  (cost=21.70..4009.68 rows=13594 width=4) (actual time=0.106..2699.114 rows=1097209 loops=1)
                                 ->  Nested Loop  (cost=21.25..3208.85 rows=364 width=8) (actual time=0.083..151.073 rows=14194 loops=1)
                                       ->  Hash Join  (cost=20.82..563.00 rows=591 width=4) (actual time=0.052..10.539 rows=21505 loops=1)
                                             Hash Cond: (ml.link_type_id = lt.id)
                                             ->  Seq Scan on movie_link ml  (cost=0.00..462.97 rows=29997 width=8) (actual time=0.009..2.689 rows=29997 loops=1)
                                             ->  Hash  (cost=20.65..20.65 rows=14 width=4) (actual time=0.029..0.031 rows=4 loops=1)
                                                   Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                   ->  Seq Scan on link_type lt  (cost=0.00..20.65 rows=14 width=4) (actual time=0.018..0.019 rows=4 loops=1)
                                                         Filter: ((link)::text = ANY ('{references,"referenced in",features,"featured in"}'::text[]))
                                                         Rows Removed by Filter: 14
                                       ->  Index Scan using title_pkey on title t  (cost=0.43..4.48 rows=1 width=4) (actual time=0.006..0.006 rows=1 loops=21505)
                                             Index Cond: (id = ml.linked_movie_id)
                                             Filter: ((production_year >= 1980) AND (production_year <= 2010))
                                             Rows Removed by Filter: 0
                                 ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..1.83 rows=37 width=8) (actual time=0.007..0.173 rows=77 loops=14194)
                                       Index Cond: (movie_id = t.id)
                           ->  Index Scan using name_pkey on name n  (cost=0.43..0.47 rows=1 width=19) (actual time=0.005..0.005 rows=0 loops=1097209)
                                 Index Cond: (id = ci.person_id)
                                 Filter: (((name_pcode_cf)::text >= 'A'::text) AND ((name_pcode_cf)::text <= 'F'::text) AND (((gender)::text = 'm'::text) OR (((gender)::text = 'f'::text) AND (name ~~ 'A%'::text))))
                                 Rows Removed by Filter: 1
                     ->  Index Scan using person_id_person_info on person_info pi  (cost=0.43..0.89 rows=1 width=103) (actual time=0.005..0.006 rows=0 loops=150772)
                           Index Cond: (person_id = ci.person_id)
                           Filter: (note IS NOT NULL)
                           Rows Removed by Filter: 20
         ->  Index Scan using person_id_aka_name on aka_name an  (cost=0.42..0.47 rows=2 width=4) (actual time=0.004..0.005 rows=2 loops=40157)
               Index Cond: (person_id = ci.person_id)
               Filter: ((name IS NOT NULL) AND ((name ~~ '%a%'::text) OR (name ~~ 'A%'::text)))
               Rows Removed by Filter: 1
 Planning Time: 5.607 ms
 Execution Time: 9198.509 ms
(41 rows)


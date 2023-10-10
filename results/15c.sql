                                                                                              QUERY PLAN                                                                                              
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Finalize Aggregate  (cost=270852.92..270852.93 rows=1 width=64) (actual time=318.175..326.516 rows=1 loops=1)
   ->  Gather  (cost=270852.70..270852.91 rows=2 width=64) (actual time=318.017..326.497 rows=3 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         ->  Partial Aggregate  (cost=269852.70..269852.71 rows=1 width=64) (actual time=305.009..305.015 rows=1 loops=3)
               ->  Nested Loop  (cost=5.13..269852.52 rows=36 width=60) (actual time=93.838..304.853 rows=757 loops=3)
                     ->  Nested Loop  (cost=4.71..269836.75 rows=36 width=64) (actual time=93.817..303.869 rows=757 loops=3)
                           ->  Nested Loop  (cost=4.28..269834.96 rows=1 width=76) (actual time=91.765..303.412 rows=95 loops=3)
                                 ->  Nested Loop  (cost=4.13..269834.79 rows=1 width=80) (actual time=91.743..303.316 rows=95 loops=3)
                                       ->  Nested Loop  (cost=3.71..269833.46 rows=3 width=84) (actual time=91.720..302.770 rows=133 loops=3)
                                             ->  Nested Loop  (cost=3.28..269832.83 rows=1 width=72) (actual time=91.700..302.340 rows=40 loops=3)
                                                   ->  Nested Loop  (cost=2.85..269831.89 rows=1 width=51) (actual time=91.668..301.992 rows=40 loops=3)
                                                         ->  Hash Join  (cost=2.43..269827.80 rows=1 width=47) (actual time=90.602..300.405 rows=594 loops=3)
                                                               Hash Cond: (mi.info_type_id = it1.id)
                                                               ->  Parallel Seq Scan on movie_info mi  (cost=0.00..269825.12 rows=92 width=51) (actual time=90.477..300.175 rows=594 loops=3)
                                                                     Filter: ((info IS NOT NULL) AND (note ~~ '%internet%'::text) AND ((info ~~ 'USA:% 199%'::text) OR (info ~~ 'USA:% 200%'::text)))
                                                                     Rows Removed by Filter: 4944646
                                                               ->  Hash  (cost=2.41..2.41 rows=1 width=4) (actual time=0.038..0.039 rows=1 loops=3)
                                                                     Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                                     ->  Seq Scan on info_type it1  (cost=0.00..2.41 rows=1 width=4) (actual time=0.028..0.031 rows=1 loops=3)
                                                                           Filter: ((info)::text = 'release dates'::text)
                                                                           Rows Removed by Filter: 112
                                                         ->  Index Only Scan using movie_id_aka_title on aka_title at  (cost=0.42..4.05 rows=3 width=4) (actual time=0.002..0.002 rows=0 loops=1783)
                                                               Index Cond: (movie_id = mi.movie_id)
                                                               Heap Fetches: 0
                                                   ->  Index Scan using title_pkey on title t  (cost=0.43..0.95 rows=1 width=21) (actual time=0.008..0.008 rows=1 loops=120)
                                                         Index Cond: (id = at.movie_id)
                                                         Filter: (production_year > 1990)
                                             ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..0.57 rows=5 width=12) (actual time=0.007..0.010 rows=3 loops=120)
                                                   Index Cond: (movie_id = t.id)
                                       ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..0.45 rows=1 width=4) (actual time=0.004..0.004 rows=1 loops=400)
                                             Index Cond: (id = mc.company_id)
                                             Filter: ((country_code)::text = '[us]'::text)
                                             Rows Removed by Filter: 0
                                 ->  Index Only Scan using company_type_pkey on company_type ct  (cost=0.15..0.17 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=284)
                                       Index Cond: (id = mc.company_type_id)
                                       Heap Fetches: 284
                           ->  Index Scan using movie_id_movie_keyword on movie_keyword mk  (cost=0.43..1.32 rows=47 width=8) (actual time=0.003..0.004 rows=8 loops=284)
                                 Index Cond: (movie_id = t.id)
                     ->  Index Only Scan using keyword_pkey on keyword k  (cost=0.42..0.44 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=2271)
                           Index Cond: (id = mk.keyword_id)
                           Heap Fetches: 0
 Planning Time: 11.856 ms
 JIT:
   Functions: 146
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 3.958 ms, Inlining 0.000 ms, Optimization 1.584 ms, Emission 43.852 ms, Total 49.394 ms
 Execution Time: 340.910 ms
(48 rows)


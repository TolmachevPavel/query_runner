                                                                                            QUERY PLAN                                                                                            
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Finalize Aggregate  (cost=240757.02..240757.03 rows=1 width=64) (actual time=315.613..324.539 rows=1 loops=1)
   ->  Gather  (cost=240756.80..240757.01 rows=2 width=64) (actual time=315.450..324.522 rows=3 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         ->  Partial Aggregate  (cost=239756.80..239756.81 rows=1 width=64) (actual time=302.282..302.289 rows=1 loops=3)
               ->  Nested Loop  (cost=5.14..239750.52 rows=1257 width=38) (actual time=88.860..301.768 rows=3782 loops=3)
                     ->  Nested Loop  (cost=4.72..239199.96 rows=1257 width=42) (actual time=88.833..297.995 rows=3782 loops=3)
                           ->  Nested Loop  (cost=4.29..239128.26 rows=40 width=54) (actual time=87.842..296.603 rows=292 loops=3)
                                 ->  Nested Loop  (cost=4.13..239126.77 rows=40 width=58) (actual time=87.818..296.484 rows=292 loops=3)
                                       ->  Nested Loop  (cost=3.71..239077.71 rows=110 width=62) (actual time=87.792..294.258 rows=700 loops=3)
                                             ->  Nested Loop  (cost=3.28..239064.02 rows=22 width=50) (actual time=87.606..292.739 rows=195 loops=3)
                                                   ->  Nested Loop  (cost=2.85..239034.63 rows=31 width=29) (actual time=87.572..291.471 rows=197 loops=3)
                                                         ->  Hash Join  (cost=2.43..238929.43 rows=31 width=4) (actual time=87.223..285.880 rows=3560 loops=3)
                                                               Hash Cond: (mi.info_type_id = it1.id)
                                                               ->  Parallel Seq Scan on movie_info mi  (cost=0.00..238917.38 rows=3536 width=8) (actual time=24.444..285.304 rows=3603 loops=3)
                                                                     Filter: (note ~~ '%internet%'::text)
                                                                     Rows Removed by Filter: 4941637
                                                               ->  Hash  (cost=2.41..2.41 rows=1 width=4) (actual time=0.042..0.043 rows=1 loops=3)
                                                                     Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                                     ->  Seq Scan on info_type it1  (cost=0.00..2.41 rows=1 width=4) (actual time=0.030..0.034 rows=1 loops=3)
                                                                           Filter: ((info)::text = 'release dates'::text)
                                                                           Rows Removed by Filter: 112
                                                         ->  Index Scan using movie_id_aka_title on aka_title at  (cost=0.42..3.36 rows=3 width=25) (actual time=0.001..0.001 rows=0 loops=10679)
                                                               Index Cond: (movie_id = mi.movie_id)
                                                   ->  Index Scan using title_pkey on title t  (cost=0.43..0.95 rows=1 width=21) (actual time=0.006..0.006 rows=1 loops=591)
                                                         Index Cond: (id = at.movie_id)
                                                         Filter: (production_year > 1990)
                                                         Rows Removed by Filter: 0
                                             ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..0.57 rows=5 width=12) (actual time=0.006..0.007 rows=4 loops=584)
                                                   Index Cond: (movie_id = t.id)
                                       ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..0.45 rows=1 width=4) (actual time=0.003..0.003 rows=0 loops=2099)
                                             Index Cond: (id = mc.company_id)
                                             Filter: ((country_code)::text = '[us]'::text)
                                             Rows Removed by Filter: 1
                                 ->  Memoize  (cost=0.16..0.18 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=875)
                                       Cache Key: mc.company_type_id
                                       Cache Mode: logical
                                       Hits: 251  Misses: 2  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                       Worker 0:  Hits: 386  Misses: 2  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                       Worker 1:  Hits: 232  Misses: 2  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                       ->  Index Only Scan using company_type_pkey on company_type ct  (cost=0.15..0.17 rows=1 width=4) (actual time=0.008..0.008 rows=1 loops=6)
                                             Index Cond: (id = mc.company_type_id)
                                             Heap Fetches: 6
                           ->  Index Scan using movie_id_movie_keyword on movie_keyword mk  (cost=0.43..1.32 rows=47 width=8) (actual time=0.002..0.004 rows=13 loops=875)
                                 Index Cond: (movie_id = t.id)
                     ->  Index Only Scan using keyword_pkey on keyword k  (cost=0.42..0.44 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=11347)
                           Index Cond: (id = mk.keyword_id)
                           Heap Fetches: 0
 Planning Time: 20.931 ms
 JIT:
   Functions: 161
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 4.134 ms, Inlining 0.000 ms, Optimization 1.417 ms, Emission 44.423 ms, Total 49.973 ms
 Execution Time: 340.271 ms
(54 rows)


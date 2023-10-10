                                                                                                       QUERY PLAN                                                                                                       
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=4714.42..4714.43 rows=1 width=96) (actual time=106.943..112.575 rows=1 loops=1)
   ->  Nested Loop  (cost=1005.33..4713.93 rows=66 width=60) (actual time=74.502..109.461 rows=14899 loops=1)
         ->  Nested Loop  (cost=1004.91..4680.50 rows=74 width=45) (actual time=74.482..95.785 rows=14916 loops=1)
               ->  Nested Loop  (cost=1004.75..4678.13 rows=75 width=49) (actual time=74.464..92.532 rows=15510 loops=1)
                     Join Filter: (mc.movie_id = ml.movie_id)
                     ->  Nested Loop  (cost=1004.32..4661.99 rows=28 width=29) (actual time=74.437..87.525 rows=1460 loops=1)
                           ->  Nested Loop  (cost=1004.16..4658.52 rows=28 width=33) (actual time=74.374..87.093 rows=1460 loops=1)
                                 Join Filter: (ml.movie_id = t.id)
                                 ->  Merge Join  (cost=1003.73..4642.95 rows=31 width=12) (actual time=74.331..84.383 rows=1460 loops=1)
                                       Merge Cond: (mk.movie_id = ml.movie_id)
                                       ->  Gather Merge  (cost=1000.89..140948.73 rows=101 width=4) (actual time=74.220..80.202 rows=481 loops=1)
                                             Workers Planned: 2
                                             Workers Launched: 2
                                             ->  Nested Loop  (cost=0.86..139937.05 rows=42 width=4) (actual time=0.797..69.172 rows=696 loops=3)
                                                   ->  Parallel Index Scan using movie_id_movie_keyword on movie_keyword mk  (cost=0.43..86260.85 rows=1884971 width=8) (actual time=0.016..14.181 rows=143368 loops=3)
                                                   ->  Memoize  (cost=0.43..0.45 rows=1 width=4) (actual time=0.000..0.000 rows=0 loops=430105)
                                                         Cache Key: mk.keyword_id
                                                         Cache Mode: logical
                                                         Hits: 241  Misses: 447  Evictions: 0  Overflows: 0  Memory Usage: 30kB
                                                         Worker 0:  Hits: 178117  Misses: 35671  Evictions: 0  Overflows: 0  Memory Usage: 2369kB
                                                         Worker 1:  Hits: 179868  Misses: 35761  Evictions: 0  Overflows: 0  Memory Usage: 2375kB
                                                         ->  Index Scan using keyword_pkey on keyword k  (cost=0.42..0.44 rows=1 width=4) (actual time=0.001..0.001 rows=0 loops=71879)
                                                               Index Cond: (id = mk.keyword_id)
                                                               Filter: (keyword = ANY ('{sequel,revenge,based-on-novel}'::text[]))
                                                               Rows Removed by Filter: 1
                                       ->  Index Scan using movie_id_movie_link on movie_link ml  (cost=0.29..795.51 rows=29997 width=8) (actual time=0.032..2.842 rows=30043 loops=1)
                                 ->  Index Scan using title_pkey on title t  (cost=0.43..0.49 rows=1 width=21) (actual time=0.002..0.002 rows=1 loops=1460)
                                       Index Cond: (id = mk.movie_id)
                                       Filter: (production_year > 1950)
                           ->  Memoize  (cost=0.16..0.18 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=1460)
                                 Cache Key: ml.link_type_id
                                 Cache Mode: logical
                                 Hits: 1445  Misses: 15  Evictions: 0  Overflows: 0  Memory Usage: 2kB
                                 ->  Index Only Scan using link_type_pkey on link_type lt  (cost=0.15..0.17 rows=1 width=4) (actual time=0.004..0.004 rows=1 loops=15)
                                       Index Cond: (id = ml.link_type_id)
                                       Heap Fetches: 15
                     ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..0.54 rows=3 width=36) (actual time=0.001..0.003 rows=11 loops=1460)
                           Index Cond: (movie_id = mk.movie_id)
                           Filter: (note IS NOT NULL)
                           Rows Removed by Filter: 2
               ->  Memoize  (cost=0.16..0.18 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=15510)
                     Cache Key: mc.company_type_id
                     Cache Mode: logical
                     Hits: 15508  Misses: 2  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                     ->  Index Scan using company_type_pkey on company_type ct  (cost=0.15..0.17 rows=1 width=4) (actual time=0.008..0.008 rows=0 loops=2)
                           Index Cond: (id = mc.company_type_id)
                           Filter: ((kind IS NOT NULL) AND ((kind)::text <> 'production companies'::text))
                           Rows Removed by Filter: 0
         ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..0.45 rows=1 width=23) (actual time=0.001..0.001 rows=1 loops=14916)
               Index Cond: (id = mc.company_id)
               Filter: ((country_code)::text <> '[pl]'::text)
               Rows Removed by Filter: 0
 Planning Time: 4.818 ms
 Execution Time: 113.140 ms
(54 rows)


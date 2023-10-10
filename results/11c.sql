                                                                                                       QUERY PLAN                                                                                                       
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=4699.57..4699.58 rows=1 width=96) (actual time=120.550..125.573 rows=1 loops=1)
   ->  Nested Loop  (cost=1005.31..4699.56 rows=1 width=60) (actual time=78.883..123.900 rows=6946 loops=1)
         Join Filter: (ml.movie_id = t.id)
         ->  Nested Loop  (cost=1004.88..4699.06 rows=1 width=55) (actual time=78.862..117.491 rows=6946 loops=1)
               ->  Nested Loop  (cost=1004.73..4698.89 rows=1 width=59) (actual time=78.829..113.367 rows=6946 loops=1)
                     ->  Nested Loop  (cost=1004.58..4698.72 rows=1 width=63) (actual time=78.811..109.204 rows=6946 loops=1)
                           ->  Nested Loop  (cost=1004.16..4660.81 rows=83 width=48) (actual time=75.311..93.013 rows=15510 loops=1)
                                 Join Filter: (mc.movie_id = ml.movie_id)
                                 ->  Merge Join  (cost=1003.73..4642.95 rows=31 width=12) (actual time=75.293..87.555 rows=1460 loops=1)
                                       Merge Cond: (mk.movie_id = ml.movie_id)
                                       ->  Gather Merge  (cost=1000.89..140948.73 rows=101 width=4) (actual time=75.198..83.162 rows=481 loops=1)
                                             Workers Planned: 2
                                             Workers Launched: 2
                                             ->  Nested Loop  (cost=0.86..139937.05 rows=42 width=4) (actual time=0.784..79.479 rows=774 loops=3)
                                                   ->  Parallel Index Scan using movie_id_movie_keyword on movie_keyword mk  (cost=0.43..86260.85 rows=1884971 width=8) (actual time=0.026..17.391 rows=157201 loops=3)
                                                   ->  Memoize  (cost=0.43..0.45 rows=1 width=4) (actual time=0.000..0.000 rows=0 loops=471604)
                                                         Cache Key: mk.keyword_id
                                                         Cache Mode: logical
                                                         Hits: 920  Misses: 1488  Evictions: 0  Overflows: 0  Memory Usage: 99kB
                                                         Worker 0:  Hits: 194363  Misses: 38452  Evictions: 0  Overflows: 0  Memory Usage: 2554kB
                                                         Worker 1:  Hits: 198765  Misses: 37616  Evictions: 0  Overflows: 0  Memory Usage: 2499kB
                                                         ->  Index Scan using keyword_pkey on keyword k  (cost=0.42..0.44 rows=1 width=4) (actual time=0.001..0.001 rows=0 loops=77556)
                                                               Index Cond: (id = mk.keyword_id)
                                                               Filter: (keyword = ANY ('{sequel,revenge,based-on-novel}'::text[]))
                                                               Rows Removed by Filter: 1
                                       ->  Index Scan using movie_id_movie_link on movie_link ml  (cost=0.29..795.51 rows=29997 width=8) (actual time=0.027..3.050 rows=30043 loops=1)
                                 ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..0.54 rows=3 width=36) (actual time=0.001..0.002 rows=11 loops=1460)
                                       Index Cond: (movie_id = mk.movie_id)
                                       Filter: (note IS NOT NULL)
                                       Rows Removed by Filter: 2
                           ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..0.46 rows=1 width=23) (actual time=0.001..0.001 rows=0 loops=15510)
                                 Index Cond: (id = mc.company_id)
                                 Filter: (((country_code)::text <> '[pl]'::text) AND ((name ~~ '20th Century Fox%'::text) OR (name ~~ 'Twentieth Century Fox%'::text)))
                                 Rows Removed by Filter: 1
                     ->  Index Scan using company_type_pkey on company_type ct  (cost=0.15..0.17 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=6946)
                           Index Cond: (id = mc.company_type_id)
                           Filter: ((kind IS NOT NULL) AND ((kind)::text <> 'production companies'::text))
               ->  Index Only Scan using link_type_pkey on link_type lt  (cost=0.15..0.17 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=6946)
                     Index Cond: (id = ml.link_type_id)
                     Heap Fetches: 6946
         ->  Index Scan using title_pkey on title t  (cost=0.43..0.49 rows=1 width=21) (actual time=0.001..0.001 rows=1 loops=6946)
               Index Cond: (id = mk.movie_id)
               Filter: (production_year > 1950)
 Planning Time: 4.704 ms
 Execution Time: 126.086 ms
(45 rows)


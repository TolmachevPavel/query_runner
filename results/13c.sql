                                                                                            QUERY PLAN                                                                                             
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=19269.82..19269.83 rows=1 width=96) (actual time=298.001..306.710 rows=1 loops=1)
   ->  Nested Loop  (cost=1004.59..19269.81 rows=1 width=41) (actual time=160.674..306.670 rows=53 loops=1)
         ->  Nested Loop  (cost=1004.45..19269.63 rows=1 width=45) (actual time=160.632..306.494 rows=218 loops=1)
               Join Filter: (mi.movie_id = t.id)
               ->  Nested Loop  (cost=1004.01..19267.69 rows=1 width=53) (actual time=160.613..306.274 rows=14 loops=1)
                     ->  Nested Loop  (cost=1003.86..19267.51 rows=1 width=57) (actual time=160.527..306.215 rows=47 loops=1)
                           ->  Nested Loop  (cost=1003.44..19267.07 rows=1 width=42) (actual time=160.498..305.663 rows=95 loops=1)
                                 Join Filter: (mc.movie_id = t.id)
                                 ->  Gather  (cost=1003.01..19266.42 rows=1 width=30) (actual time=160.472..305.552 rows=29 loops=1)
                                       Workers Planned: 2
                                       Workers Launched: 2
                                       ->  Nested Loop  (cost=3.02..18266.32 rows=1 width=30) (actual time=222.482..294.648 rows=10 loops=3)
                                             ->  Nested Loop  (cost=2.86..18266.02 rows=1 width=34) (actual time=24.828..294.592 rows=22 loops=3)
                                                   ->  Hash Join  (cost=2.43..15286.60 rows=5089 width=9) (actual time=0.075..63.008 rows=153308 loops=3)
                                                         Hash Cond: (miidx.info_type_id = it.id)
                                                         ->  Parallel Seq Scan on movie_info_idx miidx  (cost=0.00..13718.15 rows=575015 width=13) (actual time=0.015..23.840 rows=460012 loops=3)
                                                         ->  Hash  (cost=2.41..2.41 rows=1 width=4) (actual time=0.023..0.024 rows=1 loops=3)
                                                               Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                               ->  Seq Scan on info_type it  (cost=0.00..2.41 rows=1 width=4) (actual time=0.015..0.016 rows=1 loops=3)
                                                                     Filter: ((info)::text = 'rating'::text)
                                                                     Rows Removed by Filter: 112
                                                   ->  Index Scan using title_pkey on title t  (cost=0.43..0.59 rows=1 width=25) (actual time=0.001..0.001 rows=0 loops=459925)
                                                         Index Cond: (id = miidx.movie_id)
                                                         Filter: ((title <> ''::text) AND ((title ~~ 'Champion%'::text) OR (title ~~ 'Loser%'::text)))
                                                         Rows Removed by Filter: 1
                                             ->  Memoize  (cost=0.16..0.28 rows=1 width=4) (actual time=0.002..0.002 rows=0 loops=66)
                                                   Cache Key: t.kind_id
                                                   Cache Mode: logical
                                                   Hits: 35  Misses: 5  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                                   Worker 0:  Hits: 14  Misses: 4  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                                   Worker 1:  Hits: 6  Misses: 2  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                                   ->  Index Scan using kind_type_pkey on kind_type kt  (cost=0.15..0.27 rows=1 width=4) (actual time=0.009..0.009 rows=0 loops=11)
                                                         Index Cond: (id = t.kind_id)
                                                         Filter: ((kind)::text = 'movie'::text)
                                                         Rows Removed by Filter: 1
                                 ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..0.59 rows=5 width=12) (actual time=0.002..0.003 rows=3 loops=29)
                                       Index Cond: (movie_id = miidx.movie_id)
                           ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..0.45 rows=1 width=23) (actual time=0.006..0.006 rows=0 loops=95)
                                 Index Cond: (id = mc.company_id)
                                 Filter: ((country_code)::text = '[us]'::text)
                                 Rows Removed by Filter: 1
                     ->  Index Scan using company_type_pkey on company_type ct  (cost=0.15..0.17 rows=1 width=4) (actual time=0.001..0.001 rows=0 loops=47)
                           Index Cond: (id = mc.company_type_id)
                           Filter: ((kind)::text = 'production companies'::text)
                           Rows Removed by Filter: 1
               ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..1.43 rows=41 width=8) (actual time=0.003..0.013 rows=16 loops=14)
                     Index Cond: (movie_id = mc.movie_id)
         ->  Index Scan using info_type_pkey on info_type it2  (cost=0.14..0.16 rows=1 width=4) (actual time=0.001..0.001 rows=0 loops=218)
               Index Cond: (id = mi.info_type_id)
               Filter: ((info)::text = 'release dates'::text)
               Rows Removed by Filter: 1
 Planning Time: 7.372 ms
 Execution Time: 306.878 ms
(53 rows)


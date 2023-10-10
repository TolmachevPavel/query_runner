                                                                                            QUERY PLAN                                                                                             
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=19285.50..19285.51 rows=1 width=96) (actual time=826.441..835.414 rows=1 loops=1)
   ->  Gather  (cost=1027.26..19285.50 rows=1 width=65) (actual time=134.676..818.359 rows=111101 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         ->  Nested Loop  (cost=27.25..18285.40 rows=1 width=65) (actual time=132.139..813.041 rows=37034 loops=3)
               ->  Nested Loop  (cost=27.11..18285.21 rows=1 width=69) (actual time=132.103..705.742 rows=172109 loops=3)
                     ->  Nested Loop  (cost=26.68..18283.37 rows=1 width=34) (actual time=132.076..624.631 rows=5490 loops=3)
                           ->  Nested Loop  (cost=26.26..18282.92 rows=1 width=38) (actual time=131.697..481.181 rows=100870 loops=3)
                                 ->  Nested Loop  (cost=26.10..18279.22 rows=128 width=42) (actual time=131.667..431.136 rows=257695 loops=3)
                                       ->  Hash Join  (cost=25.67..18264.08 rows=25 width=30) (actual time=131.617..306.806 rows=69960 loops=3)
                                             Hash Cond: (t.kind_id = kt.id)
                                             ->  Nested Loop  (cost=2.86..18227.86 rows=5089 width=34) (actual time=0.122..292.409 rows=153308 loops=3)
                                                   ->  Hash Join  (cost=2.43..15286.60 rows=5089 width=9) (actual time=0.083..64.255 rows=153308 loops=3)
                                                         Hash Cond: (miidx.info_type_id = it.id)
                                                         ->  Parallel Seq Scan on movie_info_idx miidx  (cost=0.00..13718.15 rows=575015 width=13) (actual time=0.015..24.612 rows=460012 loops=3)
                                                         ->  Hash  (cost=2.41..2.41 rows=1 width=4) (actual time=0.027..0.028 rows=1 loops=3)
                                                               Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                               ->  Seq Scan on info_type it  (cost=0.00..2.41 rows=1 width=4) (actual time=0.020..0.021 rows=1 loops=3)
                                                                     Filter: ((info)::text = 'rating'::text)
                                                                     Rows Removed by Filter: 112
                                                   ->  Index Scan using title_pkey on title t  (cost=0.43..0.58 rows=1 width=25) (actual time=0.001..0.001 rows=1 loops=459925)
                                                         Index Cond: (id = miidx.movie_id)
                                             ->  Hash  (cost=22.75..22.75 rows=5 width=4) (actual time=0.015..0.016 rows=1 loops=3)
                                                   Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                   ->  Seq Scan on kind_type kt  (cost=0.00..22.75 rows=5 width=4) (actual time=0.012..0.013 rows=1 loops=3)
                                                         Filter: ((kind)::text = 'movie'::text)
                                                         Rows Removed by Filter: 6
                                       ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..0.56 rows=5 width=12) (actual time=0.001..0.001 rows=4 loops=209880)
                                             Index Cond: (movie_id = t.id)
                                 ->  Memoize  (cost=0.16..0.18 rows=1 width=4) (actual time=0.000..0.000 rows=0 loops=773084)
                                       Cache Key: mc.company_type_id
                                       Cache Mode: logical
                                       Hits: 252116  Misses: 2  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                       Worker 0:  Hits: 257584  Misses: 2  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                       Worker 1:  Hits: 263378  Misses: 2  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                       ->  Index Scan using company_type_pkey on company_type ct  (cost=0.15..0.17 rows=1 width=4) (actual time=0.012..0.012 rows=0 loops=6)
                                             Index Cond: (id = mc.company_type_id)
                                             Filter: ((kind)::text = 'production companies'::text)
                                             Rows Removed by Filter: 0
                           ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..0.45 rows=1 width=4) (actual time=0.001..0.001 rows=0 loops=302610)
                                 Index Cond: (id = mc.company_id)
                                 Filter: ((country_code)::text = '[de]'::text)
                                 Rows Removed by Filter: 1
                     ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..1.44 rows=41 width=51) (actual time=0.002..0.012 rows=31 loops=16470)
                           Index Cond: (movie_id = t.id)
               ->  Index Scan using info_type_pkey on info_type it2  (cost=0.14..0.16 rows=1 width=4) (actual time=0.000..0.000 rows=0 loops=516327)
                     Index Cond: (id = mi.info_type_id)
                     Filter: ((info)::text = 'release dates'::text)
                     Rows Removed by Filter: 1
 Planning Time: 7.782 ms
 Execution Time: 835.584 ms
(51 rows)


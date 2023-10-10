                                                                                              QUERY PLAN                                                                                              
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Finalize Aggregate  (cost=47125.38..47125.39 rows=1 width=64) (actual time=173.769..180.170 rows=1 loops=1)
   ->  Gather  (cost=47125.16..47125.37 rows=2 width=64) (actual time=173.301..180.162 rows=3 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         ->  Partial Aggregate  (cost=46125.16..46125.17 rows=1 width=64) (actual time=170.271..170.277 rows=1 loops=3)
               ->  Nested Loop  (cost=5398.10..46125.13 rows=7 width=60) (actual time=53.611..170.229 rows=109 loops=3)
                     ->  Nested Loop  (cost=5397.68..46122.06 rows=7 width=64) (actual time=53.579..169.922 rows=109 loops=3)
                           ->  Nested Loop  (cost=5397.25..46120.25 rows=1 width=76) (actual time=28.849..169.746 rows=19 loops=3)
                                 ->  Nested Loop  (cost=5397.11..46119.93 rows=1 width=80) (actual time=28.830..169.690 rows=19 loops=3)
                                       ->  Nested Loop  (cost=5396.96..46119.76 rows=1 width=84) (actual time=28.791..169.620 rows=19 loops=3)
                                             ->  Nested Loop  (cost=5396.52..44175.25 rows=1030 width=33) (actual time=14.196..116.389 rows=1711 loops=3)
                                                   ->  Nested Loop  (cost=5396.09..42392.85 rows=1880 width=12) (actual time=14.147..101.385 rows=4566 loops=3)
                                                         ->  Parallel Hash Join  (cost=5395.67..40545.86 rows=2649 width=8) (actual time=13.992..87.439 rows=14612 loops=3)
                                                               Hash Cond: (mc.company_id = cn.id)
                                                               ->  Parallel Seq Scan on movie_companies mc  (cost=0.00..35131.06 rows=7291 width=12) (actual time=0.066..69.149 rows=20555 loops=3)
                                                                     Filter: ((note ~~ '%(200%)%'::text) AND (note ~~ '%(worldwide)%'::text))
                                                                     Rows Removed by Filter: 849155
                                                               ->  Parallel Hash  (cost=4767.92..4767.92 rows=50220 width=4) (actual time=13.446..13.446 rows=28281 loops=3)
                                                                     Buckets: 131072  Batches: 1  Memory Usage: 4384kB
                                                                     ->  Parallel Seq Scan on company_name cn  (cost=0.00..4767.92 rows=50220 width=4) (actual time=0.015..10.009 rows=28281 loops=3)
                                                                           Filter: ((country_code)::text = '[us]'::text)
                                                                           Rows Removed by Filter: 50051
                                                         ->  Index Only Scan using movie_id_aka_title on aka_title at  (cost=0.42..0.67 rows=3 width=4) (actual time=0.001..0.001 rows=0 loops=43837)
                                                               Index Cond: (movie_id = mc.movie_id)
                                                               Heap Fetches: 0
                                                   ->  Index Scan using title_pkey on title t  (cost=0.43..0.95 rows=1 width=21) (actual time=0.003..0.003 rows=0 loops=13699)
                                                         Index Cond: (id = at.movie_id)
                                                         Filter: (production_year > 2000)
                                                         Rows Removed by Filter: 1
                                             ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..1.88 rows=1 width=51) (actual time=0.031..0.031 rows=0 loops=5134)
                                                   Index Cond: (movie_id = t.id)
                                                   Filter: ((note ~~ '%internet%'::text) AND (info ~~ 'USA:% 200%'::text))
                                                   Rows Removed by Filter: 72
                                       ->  Index Only Scan using company_type_pkey on company_type ct  (cost=0.15..0.17 rows=1 width=4) (actual time=0.003..0.003 rows=1 loops=57)
                                             Index Cond: (id = mc.company_type_id)
                                             Heap Fetches: 57
                                 ->  Index Scan using info_type_pkey on info_type it1  (cost=0.14..0.23 rows=1 width=4) (actual time=0.002..0.002 rows=1 loops=57)
                                       Index Cond: (id = mi.info_type_id)
                                       Filter: ((info)::text = 'release dates'::text)
                           ->  Index Scan using movie_id_movie_keyword on movie_keyword mk  (cost=0.43..1.34 rows=47 width=8) (actual time=0.007..0.008 rows=6 loops=57)
                                 Index Cond: (movie_id = t.id)
                     ->  Index Only Scan using keyword_pkey on keyword k  (cost=0.42..0.44 rows=1 width=4) (actual time=0.003..0.003 rows=1 loops=328)
                           Index Cond: (id = mk.keyword_id)
                           Heap Fetches: 0
 Planning Time: 11.341 ms
 Execution Time: 180.359 ms
(46 rows)


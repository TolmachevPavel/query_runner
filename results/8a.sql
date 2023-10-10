                                                                                   QUERY PLAN                                                                                    
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=42214.30..42214.31 rows=1 width=64) (actual time=1121.479..1129.260 rows=1 loops=1)
   ->  Nested Loop  (cost=5817.95..42214.29 rows=1 width=33) (actual time=110.161..1129.147 rows=62 loops=1)
         ->  Nested Loop  (cost=5817.52..42213.53 rows=1 width=41) (actual time=11.685..1100.799 rows=17379 loops=1)
               ->  Gather  (cost=5817.10..42212.48 rows=1 width=21) (actual time=11.656..1075.617 rows=7438 loops=1)
                     Workers Planned: 2
                     Workers Launched: 2
                     ->  Nested Loop  (cost=4817.10..41212.38 rows=1 width=21) (actual time=29.470..1099.179 rows=2479 loops=3)
                           ->  Nested Loop  (cost=4816.94..41210.05 rows=16 width=25) (actual time=29.428..1097.515 rows=6533 loops=3)
                                 ->  Nested Loop  (cost=4816.50..40943.13 rows=162 width=25) (actual time=9.046..146.723 rows=16109 loops=3)
                                       ->  Parallel Hash Join  (cost=4816.07..39962.37 rows=162 width=4) (actual time=9.006..87.600 rows=16109 loops=3)
                                             Hash Cond: (mc.company_id = cn.id)
                                             ->  Parallel Seq Scan on movie_companies mc  (cost=0.00..35131.06 rows=5806 width=8) (actual time=0.049..73.350 rows=16299 loops=3)
                                                   Filter: ((note ~~ '%(Japan)%'::text) AND (note !~~ '%(USA)%'::text))
                                                   Rows Removed by Filter: 853411
                                             ->  Parallel Hash  (cost=4767.92..4767.92 rows=3852 width=4) (actual time=8.768..8.768 rows=2251 loops=3)
                                                   Buckets: 8192  Batches: 1  Memory Usage: 384kB
                                                   ->  Parallel Seq Scan on company_name cn  (cost=0.00..4767.92 rows=3852 width=4) (actual time=0.014..8.475 rows=2251 loops=3)
                                                         Filter: ((country_code)::text = '[jp]'::text)
                                                         Rows Removed by Filter: 76082
                                       ->  Index Scan using title_pkey on title t  (cost=0.43..6.05 rows=1 width=21) (actual time=0.003..0.003 rows=1 loops=48328)
                                             Index Cond: (id = mc.movie_id)
                                 ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..1.64 rows=1 width=12) (actual time=0.057..0.059 rows=0 loops=48328)
                                       Index Cond: (movie_id = t.id)
                                       Filter: (note = '(voice: English version)'::text)
                                       Rows Removed by Filter: 32
                           ->  Memoize  (cost=0.16..0.18 rows=1 width=4) (actual time=0.000..0.000 rows=0 loops=19600)
                                 Cache Key: ci.role_id
                                 Cache Mode: logical
                                 Hits: 6111  Misses: 2  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                 Worker 0:  Hits: 6238  Misses: 2  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                 Worker 1:  Hits: 7245  Misses: 2  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                 ->  Index Scan using role_type_pkey on role_type rt  (cost=0.15..0.17 rows=1 width=4) (actual time=0.012..0.012 rows=0 loops=6)
                                       Index Cond: (id = ci.role_id)
                                       Filter: ((role)::text = 'actress'::text)
                                       Rows Removed by Filter: 0
               ->  Index Scan using person_id_aka_name on aka_name an1  (cost=0.42..1.03 rows=2 width=20) (actual time=0.003..0.003 rows=2 loops=7438)
                     Index Cond: (person_id = ci.person_id)
         ->  Index Scan using name_pkey on name n1  (cost=0.43..0.77 rows=1 width=4) (actual time=0.002..0.002 rows=0 loops=17379)
               Index Cond: (id = an1.person_id)
               Filter: ((name ~~ '%Yo%'::text) AND (name !~~ '%Yu%'::text))
               Rows Removed by Filter: 1
 Planning Time: 3.480 ms
 Execution Time: 1129.413 ms
(43 rows)


                                                                                           QUERY PLAN                                                                                            
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Finalize Aggregate  (cost=575173.62..575173.63 rows=1 width=64) (actual time=4364.701..4445.531 rows=1 loops=1)
   ->  Gather  (cost=575173.40..575173.61 rows=2 width=64) (actual time=4359.452..4445.508 rows=3 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         ->  Partial Aggregate  (cost=574173.40..574173.41 rows=1 width=64) (actual time=4345.797..4346.649 rows=1 loops=3)
               ->  Parallel Hash Join  (cost=556488.18..573142.90 rows=206100 width=33) (actual time=4130.477..4269.601 rows=829204 loops=3)
                     Hash Cond: (a1.person_id = n1.id)
                     ->  Parallel Seq Scan on aka_name a1  (cost=0.00..15171.60 rows=375560 width=20) (actual time=0.019..21.312 rows=300448 loops=3)
                     ->  Parallel Hash  (cost=555451.05..555451.05 rows=82970 width=25) (actual time=4054.013..4054.863 rows=656886 loops=3)
                           Buckets: 131072 (originally 262144)  Batches: 16 (originally 1)  Memory Usage: 9216kB
                           ->  Nested Loop  (cost=450095.94..555451.05 rows=82970 width=25) (actual time=1968.724..3870.306 rows=656886 loops=3)
                                 ->  Nested Loop  (cost=450095.51..517909.83 rows=82970 width=16) (actual time=1968.697..2710.289 rows=656886 loops=3)
                                       ->  Parallel Hash Join  (cost=450095.07..484471.03 rows=82970 width=12) (actual time=1968.630..2197.718 rows=656886 loops=3)
                                             Hash Cond: (mc.movie_id = ci.movie_id)
                                             ->  Parallel Hash Join  (cost=5395.67..37944.83 rows=394955 width=4) (actual time=10.026..149.844 rows=384599 loops=3)
                                                   Hash Cond: (mc.company_id = cn.id)
                                                   ->  Parallel Seq Scan on movie_companies mc  (cost=0.00..29695.37 rows=1087137 width=8) (actual time=0.022..47.223 rows=869710 loops=3)
                                                   ->  Parallel Hash  (cost=4767.92..4767.92 rows=50220 width=4) (actual time=9.932..9.933 rows=28281 loops=3)
                                                         Buckets: 131072  Batches: 1  Memory Usage: 4384kB
                                                         ->  Parallel Seq Scan on company_name cn  (cost=0.00..4767.92 rows=50220 width=4) (actual time=0.029..7.544 rows=28281 loops=3)
                                                               Filter: ((country_code)::text = '[us]'::text)
                                                               Rows Removed by Filter: 50051
                                             ->  Parallel Hash  (cost=443635.91..443635.91 rows=85080 width=8) (actual time=1775.459..1775.461 rows=909648 loops=3)
                                                   Buckets: 262144 (originally 262144)  Batches: 16 (originally 1)  Memory Usage: 8768kB
                                                   ->  Hash Join  (cost=18.93..443635.91 rows=85080 width=8) (actual time=1152.718..1604.434 rows=909648 loops=3)
                                                         Hash Cond: (ci.role_id = rt.id)
                                                         ->  Parallel Seq Scan on cast_info ci  (cost=0.00..403738.10 rows=15101810 width=12) (actual time=0.019..634.380 rows=12081448 loops=3)
                                                         ->  Hash  (cost=18.88..18.88 rows=4 width=4) (actual time=282.014..282.015 rows=1 loops=3)
                                                               Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                               ->  Seq Scan on role_type rt  (cost=0.00..18.88 rows=4 width=4) (actual time=282.003..282.005 rows=1 loops=3)
                                                                     Filter: ((role)::text = 'writer'::text)
                                                                     Rows Removed by Filter: 11
                                       ->  Memoize  (cost=0.44..0.46 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=1970658)
                                             Cache Key: ci.person_id
                                             Cache Mode: logical
                                             Hits: 579211  Misses: 78475  Evictions: 0  Overflows: 0  Memory Usage: 7971kB
                                             Worker 0:  Hits: 577553  Misses: 78486  Evictions: 0  Overflows: 0  Memory Usage: 7972kB
                                             Worker 1:  Hits: 578470  Misses: 78463  Evictions: 0  Overflows: 0  Memory Usage: 7969kB
                                             ->  Index Only Scan using name_pkey on name n1  (cost=0.43..0.45 rows=1 width=4) (actual time=0.003..0.003 rows=1 loops=235424)
                                                   Index Cond: (id = ci.person_id)
                                                   Heap Fetches: 0
                                 ->  Index Scan using title_pkey on title t  (cost=0.43..0.45 rows=1 width=21) (actual time=0.002..0.002 rows=1 loops=1970658)
                                       Index Cond: (id = ci.movie_id)
 Planning Time: 3.269 ms
 JIT:
   Functions: 161
   Options: Inlining true, Optimization true, Expressions true, Deforming true
   Timing: Generation 4.342 ms, Inlining 132.710 ms, Optimization 421.520 ms, Emission 292.215 ms, Total 850.788 ms
 Execution Time: 4463.066 ms
(49 rows)


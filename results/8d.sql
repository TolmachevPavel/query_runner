                                                                                           QUERY PLAN                                                                                            
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Finalize Aggregate  (cost=575173.62..575173.63 rows=1 width=64) (actual time=2206.314..2217.470 rows=1 loops=1)
   ->  Gather  (cost=575173.40..575173.61 rows=2 width=64) (actual time=2201.670..2217.447 rows=3 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         ->  Partial Aggregate  (cost=574173.40..574173.41 rows=1 width=64) (actual time=2186.712..2186.721 rows=1 loops=3)
               ->  Parallel Hash Join  (cost=556488.18..573142.90 rows=206100 width=33) (actual time=2120.695..2177.143 rows=107668 loops=3)
                     Hash Cond: (an1.person_id = n1.id)
                     ->  Parallel Seq Scan on aka_name an1  (cost=0.00..15171.60 rows=375560 width=20) (actual time=0.018..19.045 rows=300448 loops=3)
                     ->  Parallel Hash  (cost=555451.05..555451.05 rows=82970 width=25) (actual time=2120.026..2120.035 rows=95179 loops=3)
                           Buckets: 524288 (originally 262144)  Batches: 1 (originally 1)  Memory Usage: 23168kB
                           ->  Nested Loop  (cost=450095.94..555451.05 rows=82970 width=25) (actual time=1623.780..2092.416 rows=95179 loops=3)
                                 ->  Nested Loop  (cost=450095.51..517909.83 rows=82970 width=16) (actual time=1623.741..1910.976 rows=95179 loops=3)
                                       ->  Parallel Hash Join  (cost=450095.07..484471.03 rows=82970 width=12) (actual time=1623.691..1857.626 rows=95179 loops=3)
                                             Hash Cond: (mc.movie_id = ci.movie_id)
                                             ->  Parallel Hash Join  (cost=5395.67..37944.83 rows=394955 width=4) (actual time=15.770..170.829 rows=384599 loops=3)
                                                   Hash Cond: (mc.company_id = cn.id)
                                                   ->  Parallel Seq Scan on movie_companies mc  (cost=0.00..29695.37 rows=1087137 width=8) (actual time=0.016..47.918 rows=869710 loops=3)
                                                   ->  Parallel Hash  (cost=4767.92..4767.92 rows=50220 width=4) (actual time=15.682..15.683 rows=28281 loops=3)
                                                         Buckets: 131072  Batches: 1  Memory Usage: 4384kB
                                                         ->  Parallel Seq Scan on company_name cn  (cost=0.00..4767.92 rows=50220 width=4) (actual time=0.064..9.597 rows=28281 loops=3)
                                                               Filter: ((country_code)::text = '[us]'::text)
                                                               Rows Removed by Filter: 50051
                                             ->  Parallel Hash  (cost=443635.91..443635.91 rows=85080 width=8) (actual time=1607.391..1607.393 rows=92134 loops=3)
                                                   Buckets: 524288 (originally 262144)  Batches: 1 (originally 1)  Memory Usage: 17024kB
                                                   ->  Hash Join  (cost=18.93..443635.91 rows=85080 width=8) (actual time=1326.853..1586.462 rows=92134 loops=3)
                                                         Hash Cond: (ci.role_id = rt.id)
                                                         ->  Parallel Seq Scan on cast_info ci  (cost=0.00..403738.10 rows=15101810 width=12) (actual time=0.019..644.964 rows=12081448 loops=3)
                                                         ->  Hash  (cost=18.88..18.88 rows=4 width=4) (actual time=284.015..284.016 rows=1 loops=3)
                                                               Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                               ->  Seq Scan on role_type rt  (cost=0.00..18.88 rows=4 width=4) (actual time=284.003..284.005 rows=1 loops=3)
                                                                     Filter: ((role)::text = 'costume designer'::text)
                                                                     Rows Removed by Filter: 11
                                       ->  Memoize  (cost=0.44..0.46 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=285538)
                                             Cache Key: ci.person_id
                                             Cache Mode: logical
                                             Hits: 83422  Misses: 9800  Evictions: 0  Overflows: 0  Memory Usage: 996kB
                                             Worker 0:  Hits: 83621  Misses: 9685  Evictions: 0  Overflows: 0  Memory Usage: 984kB
                                             Worker 1:  Hits: 89159  Misses: 9851  Evictions: 0  Overflows: 0  Memory Usage: 1001kB
                                             ->  Index Only Scan using name_pkey on name n1  (cost=0.43..0.45 rows=1 width=4) (actual time=0.002..0.002 rows=1 loops=29336)
                                                   Index Cond: (id = ci.person_id)
                                                   Heap Fetches: 0
                                 ->  Index Scan using title_pkey on title t  (cost=0.43..0.45 rows=1 width=21) (actual time=0.002..0.002 rows=1 loops=285538)
                                       Index Cond: (id = ci.movie_id)
 Planning Time: 3.799 ms
 JIT:
   Functions: 161
   Options: Inlining true, Optimization true, Expressions true, Deforming true
   Timing: Generation 4.551 ms, Inlining 135.220 ms, Optimization 421.112 ms, Emission 295.938 ms, Total 856.822 ms
 Execution Time: 2234.565 ms
(49 rows)


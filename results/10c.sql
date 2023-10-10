                                                                                            QUERY PLAN                                                                                            
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Finalize Aggregate  (cost=581579.06..581579.07 rows=1 width=64) (actual time=8744.407..8767.282 rows=1 loops=1)
   ->  Gather  (cost=581578.84..581579.05 rows=2 width=64) (actual time=8741.927..8767.253 rows=3 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         ->  Partial Aggregate  (cost=580578.84..580578.85 rows=1 width=64) (actual time=8726.280..8726.288 rows=1 loops=3)
               ->  Hash Join  (cost=44477.60..579617.76 rows=192217 width=33) (actual time=4668.346..8726.245 rows=3 loops=3)
                     Hash Cond: (ci.role_id = rt.id)
                     ->  Hash Join  (cost=44451.62..579084.20 rows=192217 width=37) (actual time=4427.404..8485.298 rows=3 loops=3)
                           Hash Cond: (mc.company_type_id = ct.id)
                           ->  Nested Loop  (cost=44425.65..578550.64 rows=192217 width=41) (actual time=4427.346..8485.235 rows=3 loops=3)
                                 ->  Nested Loop  (cost=44425.21..555408.56 rows=397087 width=29) (actual time=326.963..8438.708 rows=260701 loops=3)
                                       Join Filter: (ci.movie_id = t.id)
                                       ->  Parallel Hash Join  (cost=44424.77..107580.60 rows=273733 width=29) (actual time=326.818..562.650 rows=198750 loops=3)
                                             Hash Cond: (t.id = mc.movie_id)
                                             ->  Parallel Seq Scan on title t  (cost=0.00..49176.29 rows=730129 width=21) (actual time=0.042..65.329 rows=583011 loops=3)
                                                   Filter: (production_year > 1990)
                                                   Rows Removed by Filter: 259760
                                             ->  Parallel Hash  (cost=37944.83..37944.83 rows=394955 width=8) (actual time=181.553..181.556 rows=384599 loops=3)
                                                   Buckets: 262144  Batches: 8  Memory Usage: 7712kB
                                                   ->  Parallel Hash Join  (cost=5395.67..37944.83 rows=394955 width=8) (actual time=13.169..137.211 rows=384599 loops=3)
                                                         Hash Cond: (mc.company_id = cn.id)
                                                         ->  Parallel Seq Scan on movie_companies mc  (cost=0.00..29695.37 rows=1087137 width=12) (actual time=0.019..43.797 rows=869710 loops=3)
                                                         ->  Parallel Hash  (cost=4767.92..4767.92 rows=50220 width=4) (actual time=12.812..12.813 rows=28281 loops=3)
                                                               Buckets: 131072  Batches: 1  Memory Usage: 4384kB
                                                               ->  Parallel Seq Scan on company_name cn  (cost=0.00..4767.92 rows=50220 width=4) (actual time=0.021..8.896 rows=28281 loops=3)
                                                                     Filter: ((country_code)::text = '[us]'::text)
                                                                     Rows Removed by Filter: 50051
                                       ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..1.62 rows=1 width=12) (actual time=0.025..0.039 rows=1 loops=596250)
                                             Index Cond: (movie_id = mc.movie_id)
                                             Filter: (note ~~ '%(producer)%'::text)
                                             Rows Removed by Filter: 34
                                 ->  Memoize  (cost=0.44..0.59 rows=1 width=20) (actual time=0.000..0.000 rows=0 loops=782104)
                                       Cache Key: ci.person_role_id
                                       Cache Mode: logical
                                       Hits: 262160  Misses: 2  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                       Worker 0:  Hits: 259055  Misses: 1  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                       Worker 1:  Hits: 260884  Misses: 2  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                       ->  Index Scan using char_name_pkey on char_name chn  (cost=0.43..0.58 rows=1 width=20) (actual time=0.027..0.027 rows=0 loops=5)
                                             Index Cond: (id = ci.person_role_id)
                           ->  Hash  (cost=17.10..17.10 rows=710 width=4) (actual time=0.046..0.046 rows=4 loops=3)
                                 Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                 ->  Seq Scan on company_type ct  (cost=0.00..17.10 rows=710 width=4) (actual time=0.043..0.044 rows=4 loops=3)
                     ->  Hash  (cost=17.10..17.10 rows=710 width=4) (actual time=240.925..240.926 rows=12 loops=3)
                           Buckets: 1024  Batches: 1  Memory Usage: 9kB
                           ->  Seq Scan on role_type rt  (cost=0.00..17.10 rows=710 width=4) (actual time=240.902..240.907 rows=12 loops=3)
 Planning Time: 2.953 ms
 JIT:
   Functions: 173
   Options: Inlining true, Optimization true, Expressions true, Deforming true
   Timing: Generation 4.307 ms, Inlining 133.551 ms, Optimization 338.182 ms, Emission 251.291 ms, Total 727.331 ms
 Execution Time: 8796.577 ms
(51 rows)


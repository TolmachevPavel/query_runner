                                                                                         QUERY PLAN                                                                                         
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Finalize Aggregate  (cost=43097.75..43097.76 rows=1 width=64) (actual time=166.577..173.910 rows=1 loops=1)
   ->  Gather  (cost=43097.53..43097.74 rows=2 width=64) (actual time=166.439..173.904 rows=3 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         ->  Partial Aggregate  (cost=42097.53..42097.54 rows=1 width=64) (actual time=163.943..163.947 rows=1 loops=3)
               ->  Nested Loop  (cost=4798.04..42097.51 rows=4 width=33) (actual time=163.940..163.944 rows=0 loops=3)
                     ->  Nested Loop  (cost=4797.88..42096.99 rows=4 width=37) (actual time=163.940..163.943 rows=0 loops=3)
                           ->  Hash Join  (cost=4797.45..42092.33 rows=8 width=25) (actual time=163.939..163.942 rows=0 loops=3)
                                 Hash Cond: (ci.role_id = rt.id)
                                 ->  Nested Loop  (cost=4778.53..42069.74 rows=1387 width=29) (actual time=10.119..163.821 rows=871 loops=3)
                                       Join Filter: (ci.movie_id = t.id)
                                       ->  Nested Loop  (cost=4778.09..40505.73 rows=956 width=29) (actual time=9.554..119.994 rows=420 loops=3)
                                             ->  Parallel Hash Join  (cost=4777.66..37326.82 rows=6125 width=8) (actual time=8.708..103.858 rows=2930 loops=3)
                                                   Hash Cond: (mc.company_id = cn.id)
                                                   ->  Parallel Seq Scan on movie_companies mc  (cost=0.00..29695.37 rows=1087137 width=12) (actual time=0.019..44.104 rows=869710 loops=3)
                                                   ->  Parallel Hash  (cost=4767.92..4767.92 rows=779 width=4) (actual time=8.464..8.465 rows=454 loops=3)
                                                         Buckets: 2048  Batches: 1  Memory Usage: 112kB
                                                         ->  Parallel Seq Scan on company_name cn  (cost=0.00..4767.92 rows=779 width=4) (actual time=0.014..8.372 rows=454 loops=3)
                                                               Filter: ((country_code)::text = '[ru]'::text)
                                                               Rows Removed by Filter: 77879
                                             ->  Index Scan using title_pkey on title t  (cost=0.43..0.52 rows=1 width=21) (actual time=0.005..0.005 rows=0 loops=8790)
                                                   Index Cond: (id = mc.movie_id)
                                                   Filter: (production_year > 2010)
                                                   Rows Removed by Filter: 1
                                       ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..1.62 rows=1 width=12) (actual time=0.054..0.104 rows=2 loops=1259)
                                             Index Cond: (movie_id = mc.movie_id)
                                             Filter: (note ~~ '%(producer)%'::text)
                                             Rows Removed by Filter: 44
                                 ->  Hash  (cost=18.88..18.88 rows=4 width=4) (actual time=0.019..0.020 rows=1 loops=3)
                                       Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                       ->  Seq Scan on role_type rt  (cost=0.00..18.88 rows=4 width=4) (actual time=0.013..0.014 rows=1 loops=3)
                                             Filter: ((role)::text = 'actor'::text)
                                             Rows Removed by Filter: 11
                           ->  Index Scan using char_name_pkey on char_name chn  (cost=0.43..0.58 rows=1 width=20) (never executed)
                                 Index Cond: (id = ci.person_role_id)
                     ->  Memoize  (cost=0.16..0.18 rows=1 width=4) (never executed)
                           Cache Key: mc.company_type_id
                           Cache Mode: logical
                           ->  Index Only Scan using company_type_pkey on company_type ct  (cost=0.15..0.17 rows=1 width=4) (never executed)
                                 Index Cond: (id = mc.company_type_id)
                                 Heap Fetches: 0
 Planning Time: 3.173 ms
 Execution Time: 174.068 ms
(43 rows)


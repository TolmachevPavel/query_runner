                                                                                      QUERY PLAN                                                                                      
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=45756.72..45756.73 rows=1 width=64) (actual time=297.811..303.856 rows=1 loops=1)
   ->  Nested Loop  (cost=5779.27..45756.72 rows=1 width=33) (actual time=29.595..303.699 rows=104 loops=1)
         ->  Nested Loop  (cost=5779.12..45756.55 rows=1 width=37) (actual time=29.540..303.453 rows=104 loops=1)
               ->  Gather  (cost=5778.69..45750.95 rows=1 width=25) (actual time=29.319..296.586 rows=112 loops=1)
                     Workers Planned: 2
                     Workers Launched: 2
                     ->  Nested Loop  (cost=4778.69..44750.85 rows=1 width=25) (actual time=36.618..290.265 rows=37 loops=3)
                           ->  Nested Loop  (cost=4778.53..44747.47 rows=54 width=29) (actual time=36.581..290.133 rows=50 loops=3)
                                 Join Filter: (ci.movie_id = t.id)
                                 ->  Nested Loop  (cost=4778.09..40505.73 rows=2454 width=29) (actual time=7.790..118.063 rows=1513 loops=3)
                                       ->  Parallel Hash Join  (cost=4777.66..37326.82 rows=6125 width=8) (actual time=7.653..102.892 rows=2930 loops=3)
                                             Hash Cond: (mc.company_id = cn.id)
                                             ->  Parallel Seq Scan on movie_companies mc  (cost=0.00..29695.37 rows=1087137 width=12) (actual time=0.013..44.412 rows=869710 loops=3)
                                             ->  Parallel Hash  (cost=4767.92..4767.92 rows=779 width=4) (actual time=7.345..7.346 rows=454 loops=3)
                                                   Buckets: 2048  Batches: 1  Memory Usage: 112kB
                                                   ->  Parallel Seq Scan on company_name cn  (cost=0.00..4767.92 rows=779 width=4) (actual time=0.024..7.258 rows=454 loops=3)
                                                         Filter: ((country_code)::text = '[ru]'::text)
                                                         Rows Removed by Filter: 77879
                                       ->  Index Scan using title_pkey on title t  (cost=0.43..0.52 rows=1 width=21) (actual time=0.005..0.005 rows=1 loops=8790)
                                             Index Cond: (id = mc.movie_id)
                                             Filter: (production_year > 2005)
                                             Rows Removed by Filter: 0
                                 ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..1.72 rows=1 width=12) (actual time=0.106..0.114 rows=0 loops=4539)
                                       Index Cond: (movie_id = mc.movie_id)
                                       Filter: ((note ~~ '%(voice)%'::text) AND (note ~~ '%(uncredited)%'::text))
                                       Rows Removed by Filter: 50
                           ->  Memoize  (cost=0.16..0.18 rows=1 width=4) (actual time=0.002..0.002 rows=1 loops=151)
                                 Cache Key: ci.role_id
                                 Cache Mode: logical
                                 Hits: 46  Misses: 3  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                 Worker 0:  Hits: 50  Misses: 3  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                 Worker 1:  Hits: 47  Misses: 2  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                 ->  Index Scan using role_type_pkey on role_type rt  (cost=0.15..0.17 rows=1 width=4) (actual time=0.019..0.019 rows=0 loops=8)
                                       Index Cond: (id = ci.role_id)
                                       Filter: ((role)::text = 'actor'::text)
                                       Rows Removed by Filter: 1
               ->  Index Scan using char_name_pkey on char_name chn  (cost=0.43..5.60 rows=1 width=20) (actual time=0.061..0.061 rows=1 loops=112)
                     Index Cond: (id = ci.person_role_id)
         ->  Index Only Scan using company_type_pkey on company_type ct  (cost=0.15..0.17 rows=1 width=4) (actual time=0.002..0.002 rows=1 loops=104)
               Index Cond: (id = mc.company_type_id)
               Heap Fetches: 104
 Planning Time: 3.430 ms
 Execution Time: 304.038 ms
(43 rows)


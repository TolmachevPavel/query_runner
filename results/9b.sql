                                                                                        QUERY PLAN                                                                                         
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=83286.20..83286.21 rows=1 width=128) (actual time=143.338..145.956 rows=1 loops=1)
   ->  Nested Loop  (cost=1002.73..83286.19 rows=1 width=64) (actual time=69.984..145.917 rows=40 loops=1)
         ->  Nested Loop  (cost=1002.30..83285.48 rows=1 width=55) (actual time=57.244..145.540 rows=94 loops=1)
               ->  Nested Loop  (cost=1001.88..83284.87 rows=1 width=59) (actual time=57.219..145.235 rows=94 loops=1)
                     ->  Nested Loop  (cost=1001.45..83284.17 rows=1 width=51) (actual time=57.177..143.985 rows=237 loops=1)
                           ->  Gather  (cost=1001.02..83283.45 rows=1 width=39) (actual time=57.157..143.378 rows=265 loops=1)
                                 Workers Planned: 2
                                 Workers Launched: 2
                                 ->  Nested Loop  (cost=1.02..82283.35 rows=1 width=39) (actual time=55.084..138.781 rows=88 loops=3)
                                       ->  Nested Loop  (cost=0.86..82281.03 rows=16 width=43) (actual time=55.057..138.730 rows=88 loops=3)
                                             Join Filter: (ci.person_id = n.id)
                                             ->  Nested Loop  (cost=0.42..82183.08 rows=8 width=39) (actual time=53.622..135.208 rows=432 loops=3)
                                                   ->  Parallel Seq Scan on name n  (cost=0.00..81701.66 rows=39 width=19) (actual time=53.434..131.181 rows=1803 loops=3)
                                                         Filter: ((name ~~ '%Angel%'::text) AND ((gender)::text = 'f'::text))
                                                         Rows Removed by Filter: 1387361
                                                   ->  Index Scan using person_id_aka_name on aka_name an  (cost=0.42..12.32 rows=2 width=20) (actual time=0.002..0.002 rows=0 loops=5409)
                                                         Index Cond: (person_id = n.id)
                                             ->  Index Scan using person_id_cast_info on cast_info ci  (cost=0.44..12.12 rows=10 width=16) (actual time=0.007..0.008 rows=0 loops=1296)
                                                   Index Cond: (person_id = an.person_id)
                                                   Filter: (note = '(voice)'::text)
                                                   Rows Removed by Filter: 43
                                       ->  Memoize  (cost=0.16..0.18 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=265)
                                             Cache Key: ci.role_id
                                             Cache Mode: logical
                                             Hits: 70  Misses: 1  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                             Worker 0:  Hits: 122  Misses: 1  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                             Worker 1:  Hits: 70  Misses: 1  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                             ->  Index Scan using role_type_pkey on role_type rt  (cost=0.15..0.17 rows=1 width=4) (actual time=0.018..0.018 rows=1 loops=3)
                                                   Index Cond: (id = ci.role_id)
                                                   Filter: ((role)::text = 'actress'::text)
                           ->  Index Scan using char_name_pkey on char_name chn  (cost=0.43..0.72 rows=1 width=20) (actual time=0.002..0.002 rows=1 loops=265)
                                 Index Cond: (id = ci.person_role_id)
                     ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..0.69 rows=1 width=8) (actual time=0.004..0.005 rows=0 loops=237)
                           Index Cond: (movie_id = ci.movie_id)
                           Filter: ((note ~~ '%(200%)%'::text) AND ((note ~~ '%(USA)%'::text) OR (note ~~ '%(worldwide)%'::text)))
                           Rows Removed by Filter: 5
               ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..0.61 rows=1 width=4) (actual time=0.003..0.003 rows=1 loops=94)
                     Index Cond: (id = mc.company_id)
                     Filter: ((country_code)::text = '[us]'::text)
         ->  Index Scan using title_pkey on title t  (cost=0.43..0.71 rows=1 width=21) (actual time=0.004..0.004 rows=0 loops=94)
               Index Cond: (id = ci.movie_id)
               Filter: ((production_year >= 2007) AND (production_year <= 2010))
               Rows Removed by Filter: 1
 Planning Time: 5.344 ms
 Execution Time: 146.129 ms
(45 rows)


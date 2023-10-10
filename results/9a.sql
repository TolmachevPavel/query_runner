                                                                                        QUERY PLAN                                                                                         
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=83296.72..83296.73 rows=1 width=96) (actual time=149.592..149.732 rows=1 loops=1)
   ->  Nested Loop  (cost=1002.73..83296.72 rows=1 width=49) (actual time=59.536..149.670 rows=121 loops=1)
         ->  Nested Loop  (cost=1002.31..83296.22 rows=1 width=53) (actual time=59.514..149.185 rows=123 loops=1)
               Join Filter: (ci.movie_id = mc.movie_id)
               ->  Nested Loop  (cost=1001.88..83295.58 rows=1 width=57) (actual time=57.529..148.157 rows=139 loops=1)
                     ->  Nested Loop  (cost=1001.45..83294.92 rows=1 width=36) (actual time=57.493..145.985 rows=387 loops=1)
                           ->  Gather  (cost=1001.02..83294.26 rows=1 width=24) (actual time=57.473..144.487 rows=425 loops=1)
                                 Workers Planned: 2
                                 Workers Launched: 2
                                 ->  Nested Loop  (cost=1.02..82294.16 rows=1 width=24) (actual time=54.920..142.929 rows=142 loops=3)
                                       ->  Nested Loop  (cost=0.86..82291.71 rows=20 width=28) (actual time=54.887..142.856 rows=142 loops=3)
                                             Join Filter: (ci.person_id = n.id)
                                             ->  Nested Loop  (cost=0.42..82183.08 rows=8 width=24) (actual time=53.320..136.522 rows=519 loops=3)
                                                   ->  Parallel Seq Scan on name n  (cost=0.00..81701.66 rows=39 width=4) (actual time=53.114..131.010 rows=2256 loops=3)
                                                         Filter: ((name ~~ '%Ang%'::text) AND ((gender)::text = 'f'::text))
                                                         Rows Removed by Filter: 1386908
                                                   ->  Index Scan using person_id_aka_name on aka_name an  (cost=0.42..12.32 rows=2 width=20) (actual time=0.002..0.002 rows=0 loops=6768)
                                                         Index Cond: (person_id = n.id)
                                             ->  Index Scan using person_id_cast_info on cast_info ci  (cost=0.44..13.42 rows=13 width=16) (actual time=0.011..0.012 rows=0 loops=1558)
                                                   Index Cond: (person_id = an.person_id)
                                                   Filter: (note = ANY ('{(voice),"(voice: Japanese version)","(voice) (uncredited)","(voice: English version)"}'::text[]))
                                                   Rows Removed by Filter: 44
                                       ->  Memoize  (cost=0.16..0.18 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=425)
                                             Cache Key: ci.role_id
                                             Cache Mode: logical
                                             Hits: 62  Misses: 1  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                             Worker 0:  Hits: 65  Misses: 1  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                             Worker 1:  Hits: 295  Misses: 1  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                             ->  Index Scan using role_type_pkey on role_type rt  (cost=0.15..0.17 rows=1 width=4) (actual time=0.025..0.026 rows=1 loops=3)
                                                   Index Cond: (id = ci.role_id)
                                                   Filter: ((role)::text = 'actress'::text)
                           ->  Index Scan using char_name_pkey on char_name chn  (cost=0.43..0.67 rows=1 width=20) (actual time=0.003..0.003 rows=1 loops=425)
                                 Index Cond: (id = ci.person_role_id)
                     ->  Index Scan using title_pkey on title t  (cost=0.43..0.66 rows=1 width=21) (actual time=0.005..0.005 rows=0 loops=387)
                           Index Cond: (id = ci.movie_id)
                           Filter: ((production_year >= 2005) AND (production_year <= 2015))
                           Rows Removed by Filter: 1
               ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..0.63 rows=1 width=8) (actual time=0.006..0.007 rows=1 loops=139)
                     Index Cond: (movie_id = t.id)
                     Filter: ((note IS NOT NULL) AND ((note ~~ '%(USA)%'::text) OR (note ~~ '%(worldwide)%'::text)))
                     Rows Removed by Filter: 5
         ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..0.50 rows=1 width=4) (actual time=0.004..0.004 rows=1 loops=123)
               Index Cond: (id = mc.company_id)
               Filter: ((country_code)::text = '[us]'::text)
               Rows Removed by Filter: 0
 Planning Time: 5.859 ms
 Execution Time: 149.895 ms
(47 rows)


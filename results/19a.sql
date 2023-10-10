                                                                                                QUERY PLAN                                                                                                
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=84259.42..84259.43 rows=1 width=64) (actual time=159.491..159.582 rows=1 loops=1)
   ->  Nested Loop  (cost=1003.31..84259.42 rows=1 width=32) (actual time=83.580..159.524 rows=184 loops=1)
         ->  Nested Loop  (cost=1003.17..84259.24 rows=1 width=36) (actual time=83.570..159.376 rows=184 loops=1)
               Join Filter: (mi.movie_id = t.id)
               ->  Nested Loop  (cost=1002.73..84237.70 rows=1 width=44) (actual time=83.516..156.027 rows=77 loops=1)
                     ->  Nested Loop  (cost=1002.31..84236.49 rows=1 width=48) (actual time=83.491..155.664 rows=79 loops=1)
                           Join Filter: (mc.movie_id = t.id)
                           ->  Nested Loop  (cost=1001.88..84233.82 rows=1 width=40) (actual time=69.063..154.835 rows=102 loops=1)
                                 ->  Nested Loop  (cost=1001.45..84232.39 rows=1 width=19) (actual time=66.048..152.305 rows=387 loops=1)
                                       ->  Gather  (cost=1001.02..84231.48 rows=1 width=23) (actual time=57.655..136.979 rows=425 loops=1)
                                             Workers Planned: 2
                                             Workers Launched: 2
                                             ->  Nested Loop  (cost=1.02..83231.38 rows=1 width=23) (actual time=54.779..141.682 rows=142 loops=3)
                                                   ->  Nested Loop  (cost=0.86..83228.94 rows=20 width=27) (actual time=54.742..141.600 rows=142 loops=3)
                                                         Join Filter: (ci.person_id = n.id)
                                                         ->  Nested Loop  (cost=0.42..81874.71 rows=8 width=23) (actual time=53.245..135.432 rows=519 loops=3)
                                                               ->  Parallel Seq Scan on name n  (cost=0.00..81701.66 rows=39 width=19) (actual time=53.014..131.514 rows=2256 loops=3)
                                                                     Filter: ((name ~~ '%Ang%'::text) AND ((gender)::text = 'f'::text))
                                                                     Rows Removed by Filter: 1386908
                                                               ->  Index Only Scan using person_id_aka_name on aka_name an  (cost=0.42..4.42 rows=2 width=4) (actual time=0.002..0.002 rows=0 loops=6768)
                                                                     Index Cond: (person_id = n.id)
                                                                     Heap Fetches: 0
                                                         ->  Index Scan using person_id_cast_info on cast_info ci  (cost=0.44..169.12 rows=13 width=16) (actual time=0.011..0.012 rows=0 loops=1558)
                                                               Index Cond: (person_id = an.person_id)
                                                               Filter: (note = ANY ('{(voice),"(voice: Japanese version)","(voice) (uncredited)","(voice: English version)"}'::text[]))
                                                               Rows Removed by Filter: 44
                                                   ->  Memoize  (cost=0.16..0.18 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=425)
                                                         Cache Key: ci.role_id
                                                         Cache Mode: logical
                                                         Hits: 57  Misses: 1  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                                         Worker 0:  Hits: 261  Misses: 1  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                                         Worker 1:  Hits: 104  Misses: 1  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                                         ->  Index Scan using role_type_pkey on role_type rt  (cost=0.15..0.17 rows=1 width=4) (actual time=0.029..0.029 rows=1 loops=3)
                                                               Index Cond: (id = ci.role_id)
                                                               Filter: ((role)::text = 'actress'::text)
                                       ->  Index Only Scan using char_name_pkey on char_name chn  (cost=0.43..0.91 rows=1 width=4) (actual time=0.036..0.036 rows=1 loops=425)
                                             Index Cond: (id = ci.person_role_id)
                                             Heap Fetches: 0
                                 ->  Index Scan using title_pkey on title t  (cost=0.43..1.43 rows=1 width=21) (actual time=0.006..0.006 rows=0 loops=387)
                                       Index Cond: (id = ci.movie_id)
                                       Filter: ((production_year >= 2005) AND (production_year <= 2009))
                                       Rows Removed by Filter: 1
                           ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..2.65 rows=1 width=8) (actual time=0.006..0.008 rows=1 loops=102)
                                 Index Cond: (movie_id = ci.movie_id)
                                 Filter: ((note IS NOT NULL) AND ((note ~~ '%(USA)%'::text) OR (note ~~ '%(worldwide)%'::text)))
                                 Rows Removed by Filter: 6
                     ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..1.21 rows=1 width=4) (actual time=0.004..0.004 rows=1 loops=79)
                           Index Cond: (id = mc.company_id)
                           Filter: ((country_code)::text = '[us]'::text)
                           Rows Removed by Filter: 0
               ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..21.53 rows=1 width=8) (actual time=0.012..0.043 rows=2 loops=77)
                     Index Cond: (movie_id = ci.movie_id)
                     Filter: ((info IS NOT NULL) AND ((info ~~ 'Japan:%200%'::text) OR (info ~~ 'USA:%200%'::text)))
                     Rows Removed by Filter: 166
         ->  Index Scan using info_type_pkey on info_type it  (cost=0.14..0.16 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=184)
               Index Cond: (id = mi.info_type_id)
               Filter: ((info)::text = 'release dates'::text)
 Planning Time: 18.172 ms
 Execution Time: 159.767 ms
(59 rows)


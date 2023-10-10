                                                                                                            QUERY PLAN                                                                                                            
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=6546.19..6546.20 rows=1 width=96) (actual time=17.866..19.323 rows=1 loops=1)
   ->  Nested Loop  (cost=1004.17..6546.18 rows=1 width=48) (actual time=16.623..19.298 rows=45 loops=1)
         ->  Nested Loop  (cost=1004.03..6546.00 rows=1 width=52) (actual time=16.616..19.260 rows=45 loops=1)
               Join Filter: (mi.movie_id = t.id)
               ->  Nested Loop  (cost=1003.60..6518.92 rows=1 width=64) (actual time=16.590..18.873 rows=25 loops=1)
                     Join Filter: (an.person_id = n.id)
                     ->  Nested Loop  (cost=1003.17..6517.90 rows=1 width=72) (actual time=16.574..18.846 rows=5 loops=1)
                           ->  Nested Loop  (cost=1003.02..6517.16 rows=1 width=76) (actual time=16.554..18.821 rows=5 loops=1)
                                 ->  Nested Loop  (cost=1002.59..6515.42 rows=1 width=64) (actual time=16.534..18.795 rows=5 loops=1)
                                       ->  Nested Loop  (cost=1002.16..6513.57 rows=1 width=45) (actual time=16.049..18.102 rows=108 loops=1)
                                             Join Filter: (ci.movie_id = t.id)
                                             ->  Gather  (cost=1001.72..6485.09 rows=1 width=29) (actual time=15.902..17.354 rows=6 loops=1)
                                                   Workers Planned: 1
                                                   Workers Launched: 1
                                                   ->  Nested Loop  (cost=1.72..5484.99 rows=1 width=29) (actual time=8.982..13.910 rows=3 loops=2)
                                                         ->  Nested Loop  (cost=1.29..5483.51 rows=1 width=33) (actual time=8.938..13.658 rows=42 loops=2)
                                                               Join Filter: (mk.movie_id = t.id)
                                                               ->  Nested Loop  (cost=0.86..5480.53 rows=1 width=25) (actual time=8.917..13.617 rows=2 loops=2)
                                                                     ->  Nested Loop  (cost=0.43..5470.72 rows=6 width=4) (actual time=8.764..13.099 rows=50 loops=2)
                                                                           ->  Parallel Seq Scan on company_name cn  (cost=0.00..5113.50 rows=1 width=4) (actual time=8.741..12.885 rows=0 loops=2)
                                                                                 Filter: (((country_code)::text = '[us]'::text) AND (name = 'DreamWorks Animation'::text))
                                                                                 Rows Removed by Filter: 117498
                                                                           ->  Index Scan using company_id_movie_companies on movie_companies mc  (cost=0.43..355.89 rows=133 width=8) (actual time=0.045..0.414 rows=99 loops=1)
                                                                                 Index Cond: (company_id = cn.id)
                                                                     ->  Index Scan using title_pkey on title t  (cost=0.43..1.62 rows=1 width=21) (actual time=0.010..0.010 rows=0 loops=99)
                                                                           Index Cond: (id = mc.movie_id)
                                                                           Filter: ((production_year > 2010) AND (title ~~ 'Kung Fu Panda%'::text))
                                                                           Rows Removed by Filter: 1
                                                               ->  Index Scan using movie_id_movie_keyword on movie_keyword mk  (cost=0.43..2.39 rows=47 width=8) (actual time=0.015..0.018 rows=21 loops=4)
                                                                     Index Cond: (movie_id = mc.movie_id)
                                                         ->  Memoize  (cost=0.43..1.47 rows=1 width=4) (actual time=0.006..0.006 rows=0 loops=83)
                                                               Cache Key: mk.keyword_id
                                                               Cache Mode: logical
                                                               Worker 0:  Hits: 24  Misses: 59  Evictions: 0  Overflows: 0  Memory Usage: 4kB
                                                               ->  Index Scan using keyword_pkey on keyword k  (cost=0.42..1.46 rows=1 width=4) (actual time=0.008..0.008 rows=0 loops=59)
                                                                     Index Cond: (id = mk.keyword_id)
                                                                     Filter: (keyword = ANY ('{hero,martial-arts,hand-to-hand-combat,computer-animated-movie}'::text[]))
                                                                     Rows Removed by Filter: 1
                                             ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..28.47 rows=1 width=16) (actual time=0.026..0.121 rows=18 loops=6)
                                                   Index Cond: (movie_id = mk.movie_id)
                                                   Filter: (note = ANY ('{(voice),"(voice: Japanese version)","(voice) (uncredited)","(voice: English version)"}'::text[]))
                                                   Rows Removed by Filter: 56
                                       ->  Index Scan using name_pkey on name n  (cost=0.43..1.85 rows=1 width=19) (actual time=0.006..0.006 rows=0 loops=108)
                                             Index Cond: (id = ci.person_id)
                                             Filter: ((name ~~ '%An%'::text) AND ((gender)::text = 'f'::text))
                                             Rows Removed by Filter: 1
                                 ->  Index Scan using char_name_pkey on char_name chn  (cost=0.43..1.74 rows=1 width=20) (actual time=0.004..0.004 rows=1 loops=5)
                                       Index Cond: (id = ci.person_role_id)
                           ->  Index Scan using role_type_pkey on role_type rt  (cost=0.15..0.57 rows=1 width=4) (actual time=0.004..0.004 rows=1 loops=5)
                                 Index Cond: (id = ci.role_id)
                                 Filter: ((role)::text = 'actress'::text)
                     ->  Index Only Scan using person_id_aka_name on aka_name an  (cost=0.42..0.99 rows=2 width=4) (actual time=0.004..0.004 rows=5 loops=5)
                           Index Cond: (person_id = ci.person_id)
                           Heap Fetches: 0
               ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..27.07 rows=1 width=8) (actual time=0.003..0.015 rows=2 loops=25)
                     Index Cond: (movie_id = mk.movie_id)
                     Filter: ((info IS NOT NULL) AND ((info ~~ 'Japan:%201%'::text) OR (info ~~ 'USA:%201%'::text)))
                     Rows Removed by Filter: 104
         ->  Index Scan using info_type_pkey on info_type it  (cost=0.14..0.16 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=45)
               Index Cond: (id = mi.info_type_id)
               Filter: ((info)::text = 'release dates'::text)
 Planning Time: 44.252 ms
 Execution Time: 19.523 ms
(63 rows)


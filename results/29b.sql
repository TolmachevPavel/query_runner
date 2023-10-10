                                                                                                                  QUERY PLAN                                                                                                                   
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=2769.09..2769.10 rows=1 width=96) (actual time=2255.546..2255.558 rows=1 loops=1)
   ->  Nested Loop  (cost=24.27..2769.08 rows=1 width=48) (actual time=1479.563..2255.544 rows=15 loops=1)
         ->  Nested Loop  (cost=24.13..2768.90 rows=1 width=52) (actual time=1479.463..2254.213 rows=2445 loops=1)
               Join Filter: (n.id = pi.person_id)
               ->  Nested Loop  (cost=23.70..2749.14 rows=1 width=60) (actual time=1479.438..2253.770 rows=15 loops=1)
                     Join Filter: (ci.person_id = n.id)
                     ->  Nested Loop  (cost=23.27..2746.79 rows=1 width=41) (actual time=1479.413..2253.729 rows=15 loops=1)
                           Join Filter: (mi.movie_id = t.id)
                           ->  Nested Loop  (cost=22.84..2744.64 rows=1 width=44) (actual time=1479.391..2253.691 rows=15 loops=1)
                                 ->  Nested Loop  (cost=22.70..2744.46 rows=1 width=48) (actual time=1479.377..2253.666 rows=15 loops=1)
                                       ->  Nested Loop  (cost=22.27..2736.29 rows=4 width=52) (actual time=1477.710..2251.097 rows=9396 loops=1)
                                             ->  Nested Loop  (cost=21.85..2716.01 rows=10 width=56) (actual time=1477.687..2222.008 rows=31752 loops=1)
                                                   Join Filter: (mc.movie_id = mi.movie_id)
                                                   ->  Nested Loop  (cost=21.42..2706.35 rows=2 width=48) (actual time=1477.656..2215.651 rows=972 loops=1)
                                                         ->  Nested Loop  (cost=20.99..2705.07 rows=1 width=44) (actual time=1477.631..2215.297 rows=216 loops=1)
                                                               ->  Nested Loop  (cost=20.83..2698.45 rows=12 width=48) (actual time=1477.615..2215.221 rows=216 loops=1)
                                                                     Join Filter: (mi.movie_id = mk.movie_id)
                                                                     ->  Nested Loop  (cost=20.40..2694.87 rows=1 width=40) (actual time=1477.597..2215.133 rows=2 loops=1)
                                                                           ->  Nested Loop  (cost=19.97..2656.71 rows=1 width=32) (actual time=55.791..2214.105 rows=4 loops=1)
                                                                                 ->  Nested Loop  (cost=19.53..2649.88 rows=3 width=20) (actual time=0.455..2181.640 rows=7127 loops=1)
                                                                                       ->  Nested Loop  (cost=19.09..2483.22 rows=4 width=4) (actual time=0.067..40.622 rows=17879 loops=1)
                                                                                             ->  Hash Join  (cost=18.93..2462.50 rows=761 width=8) (actual time=0.049..23.199 rows=85941 loops=1)
                                                                                                   Hash Cond: (cc.subject_id = cct1.id)
                                                                                                   ->  Seq Scan on complete_cast cc  (cost=0.00..2086.86 rows=135086 width=12) (actual time=0.014..7.719 rows=135086 loops=1)
                                                                                                   ->  Hash  (cost=18.88..18.88 rows=4 width=4) (actual time=0.020..0.021 rows=1 loops=1)
                                                                                                         Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                                                                         ->  Seq Scan on comp_cast_type cct1  (cost=0.00..18.88 rows=4 width=4) (actual time=0.012..0.012 rows=1 loops=1)
                                                                                                               Filter: ((kind)::text = 'cast'::text)
                                                                                                               Rows Removed by Filter: 3
                                                                                             ->  Memoize  (cost=0.16..0.58 rows=1 width=4) (actual time=0.000..0.000 rows=0 loops=85941)
                                                                                                   Cache Key: cc.status_id
                                                                                                   Cache Mode: logical
                                                                                                   Hits: 85939  Misses: 2  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                                                                                   ->  Index Scan using comp_cast_type_pkey on comp_cast_type cct2  (cost=0.15..0.57 rows=1 width=4) (actual time=0.008..0.008 rows=0 loops=2)
                                                                                                         Index Cond: (id = cc.status_id)
                                                                                                         Filter: ((kind)::text = 'complete+verified'::text)
                                                                                                         Rows Removed by Filter: 0
                                                                                       ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..41.65 rows=1 width=16) (actual time=0.105..0.119 rows=0 loops=17879)
                                                                                             Index Cond: (movie_id = cc.movie_id)
                                                                                             Filter: (note = ANY ('{(voice),"(voice) (uncredited)","(voice: English version)"}'::text[]))
                                                                                             Rows Removed by Filter: 55
                                                                                 ->  Memoize  (cost=0.44..2.26 rows=1 width=20) (actual time=0.004..0.004 rows=0 loops=7127)
                                                                                       Cache Key: ci.person_role_id
                                                                                       Cache Mode: logical
                                                                                       Hits: 3298  Misses: 3829  Evictions: 0  Overflows: 0  Memory Usage: 255kB
                                                                                       ->  Index Scan using char_name_pkey on char_name chn  (cost=0.43..2.25 rows=1 width=20) (actual time=0.007..0.007 rows=0 loops=3829)
                                                                                             Index Cond: (id = ci.person_role_id)
                                                                                             Filter: (name = 'Queen'::text)
                                                                                             Rows Removed by Filter: 1
                                                                           ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..38.14 rows=1 width=8) (actual time=0.210..0.254 rows=0 loops=4)
                                                                                 Index Cond: (movie_id = ci.movie_id)
                                                                                 Filter: (info ~~ 'USA:%200%'::text)
                                                                                 Rows Removed by Filter: 359
                                                                     ->  Index Scan using movie_id_movie_keyword on movie_keyword mk  (cost=0.43..3.00 rows=47 width=8) (actual time=0.012..0.028 rows=108 loops=2)
                                                                           Index Cond: (movie_id = ci.movie_id)
                                                               ->  Memoize  (cost=0.16..0.58 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=216)
                                                                     Cache Key: ci.role_id
                                                                     Cache Mode: logical
                                                                     Hits: 215  Misses: 1  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                                                     ->  Index Scan using role_type_pkey on role_type rt  (cost=0.15..0.57 rows=1 width=4) (actual time=0.013..0.014 rows=1 loops=1)
                                                                           Index Cond: (id = ci.role_id)
                                                                           Filter: ((role)::text = 'actress'::text)
                                                         ->  Index Only Scan using person_id_aka_name on aka_name an  (cost=0.42..1.27 rows=2 width=4) (actual time=0.001..0.001 rows=4 loops=216)
                                                               Index Cond: (person_id = ci.person_id)
                                                               Heap Fetches: 0
                                                   ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..4.77 rows=5 width=8) (actual time=0.001..0.003 rows=33 loops=972)
                                                         Index Cond: (movie_id = mk.movie_id)
                                             ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..2.03 rows=1 width=4) (actual time=0.001..0.001 rows=0 loops=31752)
                                                   Index Cond: (id = mc.company_id)
                                                   Filter: ((country_code)::text = '[us]'::text)
                                                   Rows Removed by Filter: 1
                                       ->  Memoize  (cost=0.43..2.03 rows=1 width=4) (actual time=0.000..0.000 rows=0 loops=9396)
                                             Cache Key: mk.keyword_id
                                             Cache Mode: logical
                                             Hits: 9192  Misses: 204  Evictions: 0  Overflows: 0  Memory Usage: 14kB
                                             ->  Index Scan using keyword_pkey on keyword k  (cost=0.42..2.02 rows=1 width=4) (actual time=0.004..0.004 rows=0 loops=204)
                                                   Index Cond: (id = mk.keyword_id)
                                                   Filter: (keyword = 'computer-animation'::text)
                                                   Rows Removed by Filter: 1
                                 ->  Index Scan using info_type_pkey on info_type it  (cost=0.14..0.16 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=15)
                                       Index Cond: (id = mi.info_type_id)
                                       Filter: ((info)::text = 'release dates'::text)
                           ->  Index Scan using title_pkey on title t  (cost=0.43..2.14 rows=1 width=21) (actual time=0.002..0.002 rows=1 loops=15)
                                 Index Cond: (id = mk.movie_id)
                                 Filter: ((production_year >= 2000) AND (production_year <= 2005) AND (title = 'Shrek 2'::text))
                     ->  Index Scan using name_pkey on name n  (cost=0.43..2.33 rows=1 width=19) (actual time=0.002..0.002 rows=1 loops=15)
                           Index Cond: (id = an.person_id)
                           Filter: ((name ~~ '%An%'::text) AND ((gender)::text = 'f'::text))
               ->  Index Scan using person_id_person_info on person_info pi  (cost=0.43..19.44 rows=26 width=8) (actual time=0.002..0.015 rows=163 loops=15)
                     Index Cond: (person_id = an.person_id)
         ->  Index Scan using info_type_pkey on info_type it3  (cost=0.14..0.16 rows=1 width=4) (actual time=0.000..0.000 rows=0 loops=2445)
               Index Cond: (id = pi.info_type_id)
               Filter: ((info)::text = 'height'::text)
               Rows Removed by Filter: 1
 Planning Time: 62.650 ms
 Execution Time: 2255.888 ms
(96 rows)


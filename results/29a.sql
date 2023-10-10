                                                                                                                  QUERY PLAN                                                                                                                   
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=2672.43..2672.44 rows=1 width=96) (actual time=142.635..142.647 rows=1 loops=1)
   ->  Nested Loop  (cost=24.27..2672.42 rows=1 width=48) (actual time=78.350..142.435 rows=1620 loops=1)
         ->  Nested Loop  (cost=23.85..2670.40 rows=1 width=52) (actual time=78.338..135.394 rows=7128 loops=1)
               Join Filter: (mc.movie_id = t.id)
               ->  Nested Loop  (cost=23.42..2665.57 rows=1 width=68) (actual time=78.321..133.819 rows=324 loops=1)
                     Join Filter: (ci.person_id = n.id)
                     ->  Nested Loop  (cost=22.99..2663.33 rows=1 width=65) (actual time=78.286..133.425 rows=324 loops=1)
                           ->  Nested Loop  (cost=22.85..2663.15 rows=1 width=69) (actual time=78.277..133.190 rows=324 loops=1)
                                 Join Filter: (mi.movie_id = t.id)
                                 ->  Nested Loop  (cost=22.42..2625.25 rows=1 width=61) (actual time=78.222..125.288 rows=162 loops=1)
                                       ->  Nested Loop  (cost=21.99..2621.17 rows=2 width=65) (actual time=78.046..121.705 rows=17496 loops=1)
                                             Join Filter: (mk.movie_id = t.id)
                                             ->  Nested Loop  (cost=21.55..2617.58 rows=1 width=57) (actual time=78.024..118.669 rows=162 loops=1)
                                                   ->  Nested Loop  (cost=21.40..2616.84 rows=1 width=61) (actual time=78.003..118.528 rows=162 loops=1)
                                                         ->  Nested Loop  (cost=21.26..2616.50 rows=2 width=65) (actual time=77.986..118.171 rows=489 loops=1)
                                                               ->  Nested Loop  (cost=20.84..2615.21 rows=1 width=61) (actual time=77.972..117.928 rows=163 loops=1)
                                                                     ->  Nested Loop  (cost=20.40..2555.94 rows=26 width=49) (actual time=77.117..117.363 rows=1667 loops=1)
                                                                           ->  Nested Loop  (cost=19.97..2536.23 rows=1 width=41) (actual time=77.100..116.654 rows=38 loops=1)
                                                                                 Join Filter: (ci.movie_id = t.id)
                                                                                 ->  Nested Loop  (cost=19.53..2494.56 rows=1 width=25) (actual time=77.079..115.693 rows=1 loops=1)
                                                                                       ->  Nested Loop  (cost=19.09..2483.22 rows=4 width=4) (actual time=0.088..22.664 rows=17879 loops=1)
                                                                                             ->  Hash Join  (cost=18.93..2462.50 rows=761 width=8) (actual time=0.063..17.296 rows=24592 loops=1)
                                                                                                   Hash Cond: (cc.status_id = cct2.id)
                                                                                                   ->  Seq Scan on complete_cast cc  (cost=0.00..2086.86 rows=135086 width=12) (actual time=0.015..8.055 rows=135086 loops=1)
                                                                                                   ->  Hash  (cost=18.88..18.88 rows=4 width=4) (actual time=0.033..0.034 rows=1 loops=1)
                                                                                                         Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                                                                         ->  Seq Scan on comp_cast_type cct2  (cost=0.00..18.88 rows=4 width=4) (actual time=0.022..0.022 rows=1 loops=1)
                                                                                                               Filter: ((kind)::text = 'complete+verified'::text)
                                                                                                               Rows Removed by Filter: 3
                                                                                             ->  Memoize  (cost=0.16..0.58 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=24592)
                                                                                                   Cache Key: cc.subject_id
                                                                                                   Cache Mode: logical
                                                                                                   Hits: 24590  Misses: 2  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                                                                                   ->  Index Scan using comp_cast_type_pkey on comp_cast_type cct1  (cost=0.15..0.57 rows=1 width=4) (actual time=0.013..0.013 rows=0 loops=2)
                                                                                                         Index Cond: (id = cc.subject_id)
                                                                                                         Filter: ((kind)::text = 'cast'::text)
                                                                                                         Rows Removed by Filter: 0
                                                                                       ->  Memoize  (cost=0.44..2.82 rows=1 width=21) (actual time=0.005..0.005 rows=0 loops=17879)
                                                                                             Cache Key: cc.movie_id
                                                                                             Cache Mode: logical
                                                                                             Hits: 0  Misses: 17879  Evictions: 0  Overflows: 0  Memory Usage: 1188kB
                                                                                             ->  Index Scan using title_pkey on title t  (cost=0.43..2.81 rows=1 width=21) (actual time=0.005..0.005 rows=0 loops=17879)
                                                                                                   Index Cond: (id = cc.movie_id)
                                                                                                   Filter: ((production_year >= 2000) AND (production_year <= 2010) AND (title = 'Shrek 2'::text))
                                                                                                   Rows Removed by Filter: 1
                                                                                 ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..41.65 rows=1 width=16) (actual time=0.018..0.952 rows=38 loops=1)
                                                                                       Index Cond: (movie_id = cc.movie_id)
                                                                                       Filter: (note = ANY ('{(voice),"(voice) (uncredited)","(voice: English version)"}'::text[]))
                                                                                       Rows Removed by Filter: 191
                                                                           ->  Index Scan using person_id_person_info on person_info pi  (cost=0.43..19.45 rows=26 width=8) (actual time=0.007..0.015 rows=44 loops=38)
                                                                                 Index Cond: (person_id = ci.person_id)
                                                                     ->  Memoize  (cost=0.44..2.26 rows=1 width=20) (actual time=0.000..0.000 rows=0 loops=1667)
                                                                           Cache Key: ci.person_role_id
                                                                           Cache Mode: logical
                                                                           Hits: 1642  Misses: 25  Evictions: 0  Overflows: 0  Memory Usage: 2kB
                                                                           ->  Index Scan using char_name_pkey on char_name chn  (cost=0.43..2.25 rows=1 width=20) (actual time=0.011..0.011 rows=0 loops=25)
                                                                                 Index Cond: (id = ci.person_role_id)
                                                                                 Filter: (name = 'Queen'::text)
                                                                                 Rows Removed by Filter: 1
                                                               ->  Index Only Scan using person_id_aka_name on aka_name an  (cost=0.42..1.27 rows=2 width=4) (actual time=0.001..0.001 rows=3 loops=163)
                                                                     Index Cond: (person_id = ci.person_id)
                                                                     Heap Fetches: 0
                                                         ->  Index Scan using info_type_pkey on info_type it3  (cost=0.14..0.16 rows=1 width=4) (actual time=0.001..0.001 rows=0 loops=489)
                                                               Index Cond: (id = pi.info_type_id)
                                                               Filter: ((info)::text = 'trivia'::text)
                                                               Rows Removed by Filter: 1
                                                   ->  Index Scan using role_type_pkey on role_type rt  (cost=0.15..0.57 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=162)
                                                         Index Cond: (id = ci.role_id)
                                                         Filter: ((role)::text = 'actress'::text)
                                             ->  Index Scan using movie_id_movie_keyword on movie_keyword mk  (cost=0.43..3.00 rows=47 width=8) (actual time=0.001..0.009 rows=108 loops=162)
                                                   Index Cond: (movie_id = ci.movie_id)
                                       ->  Memoize  (cost=0.43..2.03 rows=1 width=4) (actual time=0.000..0.000 rows=0 loops=17496)
                                             Cache Key: mk.keyword_id
                                             Cache Mode: logical
                                             Hits: 17388  Misses: 108  Evictions: 0  Overflows: 0  Memory Usage: 8kB
                                             ->  Index Scan using keyword_pkey on keyword k  (cost=0.42..2.02 rows=1 width=4) (actual time=0.005..0.005 rows=0 loops=108)
                                                   Index Cond: (id = mk.keyword_id)
                                                   Filter: (keyword = 'computer-animation'::text)
                                                   Rows Removed by Filter: 1
                                 ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..37.89 rows=1 width=8) (actual time=0.004..0.048 rows=2 loops=162)
                                       Index Cond: (movie_id = mk.movie_id)
                                       Filter: ((info IS NOT NULL) AND ((info ~~ 'Japan:%200%'::text) OR (info ~~ 'USA:%200%'::text)))
                                       Rows Removed by Filter: 455
                           ->  Index Scan using info_type_pkey on info_type it  (cost=0.14..0.16 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=324)
                                 Index Cond: (id = mi.info_type_id)
                                 Filter: ((info)::text = 'release dates'::text)
                     ->  Index Scan using name_pkey on name n  (cost=0.43..2.22 rows=1 width=19) (actual time=0.001..0.001 rows=1 loops=324)
                           Index Cond: (id = pi.person_id)
                           Filter: ((name ~~ '%An%'::text) AND ((gender)::text = 'f'::text))
               ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..4.77 rows=5 width=8) (actual time=0.001..0.003 rows=22 loops=324)
                     Index Cond: (movie_id = mk.movie_id)
         ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..2.03 rows=1 width=4) (actual time=0.001..0.001 rows=0 loops=7128)
               Index Cond: (id = mc.company_id)
               Filter: ((country_code)::text = '[us]'::text)
               Rows Removed by Filter: 1
 Planning Time: 70.913 ms
 Execution Time: 143.185 ms
(97 rows)


                                                                                                  QUERY PLAN                                                                                                   
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=303.15..303.16 rows=1 width=96) (actual time=16.163..16.166 rows=1 loops=1)
   ->  Nested Loop  (cost=26.27..303.14 rows=1 width=118) (actual time=2.489..16.062 rows=477 loops=1)
         ->  Nested Loop  (cost=25.85..282.38 rows=47 width=122) (actual time=2.447..10.133 rows=6483 loops=1)
               Join Filter: (mk.movie_id = ml.movie_id)
               ->  Nested Loop  (cost=25.41..280.44 rows=1 width=138) (actual time=2.426..8.504 rows=705 loops=1)
                     Join Filter: (mi.movie_id = ml.movie_id)
                     ->  Nested Loop  (cost=24.98..278.50 rows=1 width=134) (actual time=0.420..6.591 rows=269 loops=1)
                           ->  Nested Loop  (cost=24.56..278.04 rows=1 width=119) (actual time=0.354..5.362 rows=691 loops=1)
                                 ->  Nested Loop  (cost=24.41..277.69 rows=2 width=123) (actual time=0.338..4.854 rows=780 loops=1)
                                       Join Filter: (mc.movie_id = ml.movie_id)
                                       ->  Nested Loop  (cost=23.98..277.05 rows=1 width=111) (actual time=0.312..3.956 rows=179 loops=1)
                                             Join Filter: (ml.movie_id = t.id)
                                             ->  Nested Loop  (cost=23.55..275.25 rows=1 width=90) (actual time=0.293..3.270 rows=189 loops=1)
                                                   ->  Nested Loop  (cost=23.40..275.07 rows=1 width=94) (actual time=0.287..3.096 rows=257 loops=1)
                                                         ->  Nested Loop  (cost=23.24..272.92 rows=66 width=98) (actual time=0.259..2.996 rows=257 loops=1)
                                                               ->  Nested Loop  (cost=22.82..246.88 rows=42 width=86) (actual time=0.066..1.058 rows=2315 loops=1)
                                                                     ->  Seq Scan on link_type lt  (cost=0.00..18.88 rows=1 width=86) (actual time=0.012..0.014 rows=2 loops=1)
                                                                           Filter: ((link)::text ~~ '%follow%'::text)
                                                                           Rows Removed by Filter: 16
                                                                     ->  Bitmap Heap Scan on movie_link ml  (cost=22.82..209.26 rows=1875 width=8) (actual time=0.042..0.441 rows=1158 loops=2)
                                                                           Recheck Cond: (lt.id = link_type_id)
                                                                           Heap Blocks: exact=191
                                                                           ->  Bitmap Index Scan on link_type_id_movie_link  (cost=0.00..22.35 rows=1875 width=0) (actual time=0.030..0.030 rows=1158 loops=2)
                                                                                 Index Cond: (link_type_id = lt.id)
                                                               ->  Index Scan using movie_id_complete_cast on complete_cast cc  (cost=0.42..0.60 rows=2 width=12) (actual time=0.001..0.001 rows=0 loops=2315)
                                                                     Index Cond: (movie_id = ml.movie_id)
                                                         ->  Memoize  (cost=0.16..0.18 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=257)
                                                               Cache Key: cc.subject_id
                                                               Cache Mode: logical
                                                               Hits: 255  Misses: 2  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                                               ->  Index Scan using comp_cast_type_pkey on comp_cast_type cct1  (cost=0.15..0.17 rows=1 width=4) (actual time=0.011..0.011 rows=1 loops=2)
                                                                     Index Cond: (id = cc.subject_id)
                                                                     Filter: ((kind)::text = ANY ('{cast,crew}'::text[]))
                                                   ->  Index Scan using comp_cast_type_pkey on comp_cast_type cct2  (cost=0.15..0.17 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=257)
                                                         Index Cond: (id = cc.status_id)
                                                         Filter: ((kind)::text = 'complete'::text)
                                                         Rows Removed by Filter: 0
                                             ->  Index Scan using title_pkey on title t  (cost=0.43..1.79 rows=1 width=21) (actual time=0.003..0.003 rows=1 loops=189)
                                                   Index Cond: (id = cc.movie_id)
                                                   Filter: ((production_year >= 1950) AND (production_year <= 2000))
                                                   Rows Removed by Filter: 0
                                       ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..0.62 rows=2 width=12) (actual time=0.003..0.004 rows=4 loops=179)
                                             Index Cond: (movie_id = t.id)
                                             Filter: (note IS NULL)
                                             Rows Removed by Filter: 2
                                 ->  Index Scan using company_type_pkey on company_type ct  (cost=0.15..0.17 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=780)
                                       Index Cond: (id = mc.company_type_id)
                                       Filter: ((kind)::text = 'production companies'::text)
                                       Rows Removed by Filter: 0
                           ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..0.46 rows=1 width=23) (actual time=0.002..0.002 rows=0 loops=691)
                                 Index Cond: (id = mc.company_id)
                                 Filter: (((country_code)::text <> '[pl]'::text) AND ((name ~~ '%Film%'::text) OR (name ~~ '%Warner%'::text)))
                                 Rows Removed by Filter: 1
                     ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..1.93 rows=1 width=4) (actual time=0.006..0.007 rows=3 loops=269)
                           Index Cond: (movie_id = mc.movie_id)
                           Filter: (info = ANY ('{Sweden,Germany,Swedish,German}'::text[]))
                           Rows Removed by Filter: 23
               ->  Index Scan using movie_id_movie_keyword on movie_keyword mk  (cost=0.43..1.35 rows=47 width=8) (actual time=0.001..0.001 rows=9 loops=705)
                     Index Cond: (movie_id = mc.movie_id)
         ->  Index Scan using keyword_pkey on keyword k  (cost=0.42..0.44 rows=1 width=4) (actual time=0.001..0.001 rows=0 loops=6483)
               Index Cond: (id = mk.keyword_id)
               Filter: (keyword = 'sequel'::text)
               Rows Removed by Filter: 1
 Planning Time: 39.364 ms
 Execution Time: 16.350 ms
(65 rows)


                                                                                                  QUERY PLAN                                                                                                   
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=302.74..302.75 rows=1 width=96) (actual time=12.301..12.303 rows=1 loops=1)
   ->  Nested Loop  (cost=26.30..302.74 rows=1 width=118) (actual time=2.114..12.169 rows=743 loops=1)
         ->  Nested Loop  (cost=26.14..302.27 rows=3 width=122) (actual time=2.106..11.952 rows=1028 loops=1)
               Join Filter: (mi.movie_id = ml.movie_id)
               ->  Nested Loop  (cost=25.68..300.69 rows=1 width=142) (actual time=2.079..10.873 rows=229 loops=1)
                     ->  Nested Loop  (cost=25.53..300.51 rows=1 width=146) (actual time=2.044..10.705 rows=248 loops=1)
                           ->  Nested Loop  (cost=25.11..279.75 rows=47 width=150) (actual time=0.316..6.801 rows=3911 loops=1)
                                 Join Filter: (mk.movie_id = ml.movie_id)
                                 ->  Nested Loop  (cost=24.68..277.84 rows=1 width=142) (actual time=0.291..5.720 rows=359 loops=1)
                                       Join Filter: (ml.movie_id = t.id)
                                       ->  Nested Loop  (cost=24.25..277.24 rows=1 width=121) (actual time=0.280..5.292 rows=359 loops=1)
                                             ->  Nested Loop  (cost=23.83..276.32 rows=2 width=106) (actual time=0.250..3.650 rows=1043 loops=1)
                                                   Join Filter: (mc.movie_id = ml.movie_id)
                                                   ->  Nested Loop  (cost=23.40..275.07 rows=1 width=94) (actual time=0.235..2.554 rows=257 loops=1)
                                                         ->  Nested Loop  (cost=23.24..272.92 rows=66 width=98) (actual time=0.207..2.458 rows=257 loops=1)
                                                               ->  Nested Loop  (cost=22.82..246.88 rows=42 width=86) (actual time=0.054..0.701 rows=2315 loops=1)
                                                                     ->  Seq Scan on link_type lt  (cost=0.00..18.88 rows=1 width=86) (actual time=0.007..0.010 rows=2 loops=1)
                                                                           Filter: ((link)::text ~~ '%follow%'::text)
                                                                           Rows Removed by Filter: 16
                                                                     ->  Bitmap Heap Scan on movie_link ml  (cost=22.82..209.26 rows=1875 width=8) (actual time=0.034..0.266 rows=1158 loops=2)
                                                                           Recheck Cond: (lt.id = link_type_id)
                                                                           Heap Blocks: exact=191
                                                                           ->  Bitmap Index Scan on link_type_id_movie_link  (cost=0.00..22.35 rows=1875 width=0) (actual time=0.025..0.025 rows=1158 loops=2)
                                                                                 Index Cond: (link_type_id = lt.id)
                                                               ->  Index Scan using movie_id_complete_cast on complete_cast cc  (cost=0.42..0.60 rows=2 width=12) (actual time=0.001..0.001 rows=0 loops=2315)
                                                                     Index Cond: (movie_id = ml.movie_id)
                                                         ->  Memoize  (cost=0.16..0.18 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=257)
                                                               Cache Key: cc.status_id
                                                               Cache Mode: logical
                                                               Hits: 255  Misses: 2  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                                               ->  Index Scan using comp_cast_type_pkey on comp_cast_type cct2  (cost=0.15..0.17 rows=1 width=4) (actual time=0.012..0.012 rows=1 loops=2)
                                                                     Index Cond: (id = cc.status_id)
                                                                     Filter: ((kind)::text ~~ 'complete%'::text)
                                                   ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..1.23 rows=2 width=12) (actual time=0.003..0.004 rows=4 loops=257)
                                                         Index Cond: (movie_id = cc.movie_id)
                                                         Filter: (note IS NULL)
                                                         Rows Removed by Filter: 3
                                             ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..0.46 rows=1 width=23) (actual time=0.001..0.001 rows=0 loops=1043)
                                                   Index Cond: (id = mc.company_id)
                                                   Filter: (((country_code)::text <> '[pl]'::text) AND ((name ~~ '%Film%'::text) OR (name ~~ '%Warner%'::text)))
                                                   Rows Removed by Filter: 1
                                       ->  Index Scan using title_pkey on title t  (cost=0.43..0.59 rows=1 width=21) (actual time=0.001..0.001 rows=1 loops=359)
                                             Index Cond: (id = mc.movie_id)
                                             Filter: ((production_year >= 1950) AND (production_year <= 2010))
                                 ->  Index Scan using movie_id_movie_keyword on movie_keyword mk  (cost=0.43..1.32 rows=47 width=8) (actual time=0.001..0.002 rows=11 loops=359)
                                       Index Cond: (movie_id = t.id)
                           ->  Index Scan using keyword_pkey on keyword k  (cost=0.42..0.44 rows=1 width=4) (actual time=0.001..0.001 rows=0 loops=3911)
                                 Index Cond: (id = mk.keyword_id)
                                 Filter: (keyword = 'sequel'::text)
                                 Rows Removed by Filter: 1
                     ->  Index Scan using company_type_pkey on company_type ct  (cost=0.15..0.17 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=248)
                           Index Cond: (id = mc.company_type_id)
                           Filter: ((kind)::text = 'production companies'::text)
                           Rows Removed by Filter: 0
               ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.46..1.54 rows=3 width=4) (actual time=0.003..0.004 rows=4 loops=229)
                     Index Cond: (movie_id = mk.movie_id)
                     Filter: (info = ANY ('{Sweden,Norway,Germany,Denmark,Swedish,Denish,Norwegian,German,English}'::text[]))
                     Rows Removed by Filter: 14
         ->  Memoize  (cost=0.16..0.18 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=1028)
               Cache Key: cc.subject_id
               Cache Mode: logical
               Hits: 1026  Misses: 2  Evictions: 0  Overflows: 0  Memory Usage: 1kB
               ->  Index Scan using comp_cast_type_pkey on comp_cast_type cct1  (cost=0.15..0.17 rows=1 width=4) (actual time=0.004..0.004 rows=0 loops=2)
                     Index Cond: (id = cc.subject_id)
                     Filter: ((kind)::text = 'cast'::text)
                     Rows Removed by Filter: 0
 Planning Time: 41.349 ms
 Execution Time: 12.494 ms
(68 rows)


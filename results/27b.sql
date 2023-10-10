                                                                                                  QUERY PLAN                                                                                                   
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=303.43..303.44 rows=1 width=96) (actual time=5.108..5.111 rows=1 loops=1)
   ->  Nested Loop  (cost=26.27..303.42 rows=1 width=118) (actual time=1.348..5.054 rows=247 loops=1)
         ->  Nested Loop  (cost=25.85..302.97 rows=1 width=103) (actual time=1.337..4.475 rows=532 loops=1)
               ->  Nested Loop  (cost=25.70..302.62 rows=2 width=107) (actual time=1.323..4.140 rows=532 loops=1)
                     Join Filter: (mc.movie_id = ml.movie_id)
                     ->  Nested Loop  (cost=25.27..302.05 rows=1 width=119) (actual time=1.314..3.921 rows=95 loops=1)
                           Join Filter: (mi.movie_id = ml.movie_id)
                           ->  Nested Loop  (cost=24.83..300.53 rows=1 width=115) (actual time=1.294..3.750 rows=38 loops=1)
                                 ->  Nested Loop  (cost=24.41..279.76 rows=47 width=119) (actual time=1.240..3.389 rows=266 loops=1)
                                       Join Filter: (mk.movie_id = ml.movie_id)
                                       ->  Nested Loop  (cost=23.98..277.04 rows=1 width=111) (actual time=1.223..3.290 rows=38 loops=1)
                                             Join Filter: (ml.movie_id = t.id)
                                             ->  Nested Loop  (cost=23.55..275.25 rows=1 width=90) (actual time=0.235..2.825 rows=189 loops=1)
                                                   ->  Nested Loop  (cost=23.40..275.07 rows=1 width=94) (actual time=0.230..2.668 rows=257 loops=1)
                                                         ->  Nested Loop  (cost=23.24..272.92 rows=66 width=98) (actual time=0.203..2.576 rows=257 loops=1)
                                                               ->  Nested Loop  (cost=22.82..246.88 rows=42 width=86) (actual time=0.053..0.757 rows=2315 loops=1)
                                                                     ->  Seq Scan on link_type lt  (cost=0.00..18.88 rows=1 width=86) (actual time=0.006..0.009 rows=2 loops=1)
                                                                           Filter: ((link)::text ~~ '%follow%'::text)
                                                                           Rows Removed by Filter: 16
                                                                     ->  Bitmap Heap Scan on movie_link ml  (cost=22.82..209.26 rows=1875 width=8) (actual time=0.036..0.295 rows=1158 loops=2)
                                                                           Recheck Cond: (lt.id = link_type_id)
                                                                           Heap Blocks: exact=191
                                                                           ->  Bitmap Index Scan on link_type_id_movie_link  (cost=0.00..22.35 rows=1875 width=0) (actual time=0.025..0.025 rows=1158 loops=2)
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
                                             ->  Index Scan using title_pkey on title t  (cost=0.43..1.78 rows=1 width=21) (actual time=0.002..0.002 rows=0 loops=189)
                                                   Index Cond: (id = cc.movie_id)
                                                   Filter: (production_year = 1998)
                                                   Rows Removed by Filter: 1
                                       ->  Index Scan using movie_id_movie_keyword on movie_keyword mk  (cost=0.43..2.13 rows=47 width=8) (actual time=0.001..0.002 rows=7 loops=38)
                                             Index Cond: (movie_id = cc.movie_id)
                                 ->  Index Scan using keyword_pkey on keyword k  (cost=0.42..0.44 rows=1 width=4) (actual time=0.001..0.001 rows=0 loops=266)
                                       Index Cond: (id = mk.keyword_id)
                                       Filter: (keyword = 'sequel'::text)
                                       Rows Removed by Filter: 1
                           ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..1.52 rows=1 width=4) (actual time=0.003..0.004 rows=2 loops=38)
                                 Index Cond: (movie_id = mk.movie_id)
                                 Filter: (info = ANY ('{Sweden,Germany,Swedish,German}'::text[]))
                                 Rows Removed by Filter: 10
                     ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..0.54 rows=2 width=12) (actual time=0.001..0.002 rows=6 loops=95)
                           Index Cond: (movie_id = mk.movie_id)
                           Filter: (note IS NULL)
                           Rows Removed by Filter: 1
               ->  Index Scan using company_type_pkey on company_type ct  (cost=0.15..0.17 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=532)
                     Index Cond: (id = mc.company_type_id)
                     Filter: ((kind)::text = 'production companies'::text)
         ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..0.46 rows=1 width=23) (actual time=0.001..0.001 rows=0 loops=532)
               Index Cond: (id = mc.company_id)
               Filter: (((country_code)::text <> '[pl]'::text) AND ((name ~~ '%Film%'::text) OR (name ~~ '%Warner%'::text)))
               Rows Removed by Filter: 1
 Planning Time: 38.047 ms
 Execution Time: 5.290 ms
(64 rows)


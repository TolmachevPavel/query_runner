                                                                                           QUERY PLAN                                                                                            
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=409.61..409.62 rows=1 width=96) (actual time=25.737..25.740 rows=1 loops=1)
   ->  Nested Loop  (cost=25.55..409.60 rows=1 width=118) (actual time=5.881..25.717 rows=38 loops=1)
         Join Filter: (ml.movie_id = t.id)
         ->  Nested Loop  (cost=25.12..409.10 rows=1 width=117) (actual time=1.870..25.382 rows=308 loops=1)
               ->  Nested Loop  (cost=24.70..408.64 rows=1 width=121) (actual time=0.447..19.522 rows=6365 loops=1)
                     Join Filter: (mk.movie_id = ml.movie_id)
                     ->  Nested Loop  (cost=24.26..406.70 rows=1 width=113) (actual time=0.420..17.568 rows=1072 loops=1)
                           Join Filter: (mi.movie_id = ml.movie_id)
                           ->  Nested Loop  (cost=23.83..404.86 rows=1 width=109) (actual time=0.366..12.424 rows=1152 loops=1)
                                 ->  Nested Loop  (cost=23.41..404.40 rows=1 width=94) (actual time=0.081..6.718 rows=4393 loops=1)
                                       ->  Nested Loop  (cost=23.25..401.30 rows=104 width=98) (actual time=0.065..5.643 rows=5069 loops=1)
                                             ->  Nested Loop  (cost=22.82..246.88 rows=42 width=86) (actual time=0.055..0.769 rows=2315 loops=1)
                                                   ->  Seq Scan on link_type lt  (cost=0.00..18.88 rows=1 width=86) (actual time=0.009..0.012 rows=2 loops=1)
                                                         Filter: ((link)::text ~~ '%follow%'::text)
                                                         Rows Removed by Filter: 16
                                                   ->  Bitmap Heap Scan on movie_link ml  (cost=22.82..209.26 rows=1875 width=8) (actual time=0.035..0.292 rows=1158 loops=2)
                                                         Recheck Cond: (lt.id = link_type_id)
                                                         Heap Blocks: exact=191
                                                         ->  Bitmap Index Scan on link_type_id_movie_link  (cost=0.00..22.35 rows=1875 width=0) (actual time=0.025..0.025 rows=1158 loops=2)
                                                               Index Cond: (link_type_id = lt.id)
                                             ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..3.66 rows=2 width=12) (actual time=0.002..0.002 rows=2 loops=2315)
                                                   Index Cond: (movie_id = ml.movie_id)
                                                   Filter: (note IS NULL)
                                                   Rows Removed by Filter: 2
                                       ->  Memoize  (cost=0.16..0.18 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=5069)
                                             Cache Key: mc.company_type_id
                                             Cache Mode: logical
                                             Hits: 5067  Misses: 2  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                             ->  Index Scan using company_type_pkey on company_type ct  (cost=0.15..0.17 rows=1 width=4) (actual time=0.005..0.005 rows=0 loops=2)
                                                   Index Cond: (id = mc.company_type_id)
                                                   Filter: ((kind)::text = 'production companies'::text)
                                                   Rows Removed by Filter: 0
                                 ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..0.46 rows=1 width=23) (actual time=0.001..0.001 rows=0 loops=4393)
                                       Index Cond: (id = mc.company_id)
                                       Filter: (((country_code)::text <> '[pl]'::text) AND ((name ~~ '%Film%'::text) OR (name ~~ '%Warner%'::text)))
                                       Rows Removed by Filter: 1
                           ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..1.83 rows=1 width=4) (actual time=0.004..0.004 rows=1 loops=1152)
                                 Index Cond: (movie_id = mc.movie_id)
                                 Filter: (info = ANY ('{Germany,German}'::text[]))
                                 Rows Removed by Filter: 16
                     ->  Index Scan using movie_id_movie_keyword on movie_keyword mk  (cost=0.43..1.35 rows=47 width=8) (actual time=0.001..0.001 rows=6 loops=1072)
                           Index Cond: (movie_id = mc.movie_id)
               ->  Index Scan using keyword_pkey on keyword k  (cost=0.42..0.44 rows=1 width=4) (actual time=0.001..0.001 rows=0 loops=6365)
                     Index Cond: (id = mk.keyword_id)
                     Filter: (keyword = 'sequel'::text)
                     Rows Removed by Filter: 1
         ->  Index Scan using title_pkey on title t  (cost=0.43..0.49 rows=1 width=21) (actual time=0.001..0.001 rows=0 loops=308)
               Index Cond: (id = mk.movie_id)
               Filter: ((production_year >= 2000) AND (production_year <= 2010))
               Rows Removed by Filter: 1
 Planning Time: 10.648 ms
 Execution Time: 25.929 ms
(52 rows)


                                                                          QUERY PLAN                                                                          
--------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=17130.41..17130.42 rows=1 width=32) (actual time=267.160..267.162 rows=1 loops=1)
   ->  Nested Loop  (cost=7.69..17128.97 rows=577 width=17) (actual time=2.091..265.989 rows=7250 loops=1)
         Join Filter: (mi.movie_id = t.id)
         ->  Nested Loop  (cost=7.23..16652.62 rows=304 width=25) (actual time=1.901..93.342 rows=7874 loops=1)
               ->  Nested Loop  (cost=6.80..16438.09 rows=438 width=4) (actual time=1.887..40.577 rows=12951 loops=1)
                     ->  Seq Scan on keyword k  (cost=0.00..2685.12 rows=13 width=4) (actual time=0.690..11.777 rows=30 loops=1)
                           Filter: (keyword ~~ '%sequel%'::text)
                           Rows Removed by Filter: 134140
                     ->  Bitmap Heap Scan on movie_keyword mk  (cost=6.80..1054.86 rows=306 width=8) (actual time=0.055..0.918 rows=432 loops=30)
                           Recheck Cond: (k.id = keyword_id)
                           Heap Blocks: exact=6979
                           ->  Bitmap Index Scan on keyword_id_movie_keyword  (cost=0.00..6.73 rows=306 width=0) (actual time=0.032..0.032 rows=432 loops=30)
                                 Index Cond: (keyword_id = k.id)
               ->  Index Scan using title_pkey on title t  (cost=0.43..0.49 rows=1 width=21) (actual time=0.004..0.004 rows=1 loops=12951)
                     Index Cond: (id = mk.movie_id)
                     Filter: (production_year > 1990)
                     Rows Removed by Filter: 0
         ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.46..1.54 rows=2 width=4) (actual time=0.019..0.022 rows=1 loops=7874)
               Index Cond: (movie_id = mk.movie_id)
               Filter: (info = ANY ('{Sweden,Norway,Germany,Denmark,Swedish,Denish,Norwegian,German,USA,American}'::text[]))
               Rows Removed by Filter: 35
 Planning Time: 1.615 ms
 Execution Time: 267.242 ms
(23 rows)


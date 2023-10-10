                                                                                 QUERY PLAN                                                                                 
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=16670.79..16670.80 rows=1 width=64) (actual time=114.548..114.550 rows=1 loops=1)
   ->  Nested Loop  (cost=7.66..16670.78 rows=2 width=22) (actual time=3.550..114.365 rows=740 loops=1)
         Join Filter: (mi_idx.movie_id = t.id)
         ->  Nested Loop  (cost=7.23..16668.77 rows=4 width=13) (actual time=1.970..81.088 rows=5820 loops=1)
               Join Filter: (it.id = mi_idx.info_type_id)
               Rows Removed by Join Filter: 2643
               ->  Seq Scan on info_type it  (cost=0.00..2.41 rows=1 width=4) (actual time=0.009..0.011 rows=1 loops=1)
                     Filter: ((info)::text = 'rating'::text)
                     Rows Removed by Filter: 112
               ->  Nested Loop  (cost=7.23..16660.16 rows=496 width=17) (actual time=1.961..80.485 rows=8463 loops=1)
                     ->  Nested Loop  (cost=6.80..16438.09 rows=438 width=4) (actual time=1.944..44.428 rows=12951 loops=1)
                           ->  Seq Scan on keyword k  (cost=0.00..2685.12 rows=13 width=4) (actual time=0.686..12.018 rows=30 loops=1)
                                 Filter: (keyword ~~ '%sequel%'::text)
                                 Rows Removed by Filter: 134140
                           ->  Bitmap Heap Scan on movie_keyword mk  (cost=6.80..1054.86 rows=306 width=8) (actual time=0.054..1.043 rows=432 loops=30)
                                 Recheck Cond: (k.id = keyword_id)
                                 Heap Blocks: exact=6979
                                 ->  Bitmap Index Scan on keyword_id_movie_keyword  (cost=0.00..6.73 rows=306 width=0) (actual time=0.032..0.032 rows=432 loops=30)
                                       Index Cond: (keyword_id = k.id)
                     ->  Index Scan using movie_id_movie_info_idx on movie_info_idx mi_idx  (cost=0.43..0.50 rows=1 width=13) (actual time=0.003..0.003 rows=1 loops=12951)
                           Index Cond: (movie_id = mk.movie_id)
                           Filter: (info > '5.0'::text)
                           Rows Removed by Filter: 1
         ->  Index Scan using title_pkey on title t  (cost=0.43..0.49 rows=1 width=21) (actual time=0.006..0.006 rows=0 loops=5820)
               Index Cond: (id = mk.movie_id)
               Filter: (production_year > 2005)
               Rows Removed by Filter: 1
 Planning Time: 1.756 ms
 Execution Time: 114.650 ms
(29 rows)


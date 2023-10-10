                                                                                 QUERY PLAN                                                                                 
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=16680.65..16680.66 rows=1 width=64) (actual time=105.495..105.497 rows=1 loops=1)
   ->  Nested Loop  (cost=7.66..16680.63 rows=5 width=22) (actual time=1.985..104.607 rows=4700 loops=1)
         Join Filter: (mi_idx.movie_id = t.id)
         ->  Nested Loop  (cost=7.23..16677.11 rows=7 width=13) (actual time=1.970..69.199 rows=8092 loops=1)
               Join Filter: (it.id = mi_idx.info_type_id)
               Rows Removed by Join Filter: 6865
               ->  Seq Scan on info_type it  (cost=0.00..2.41 rows=1 width=4) (actual time=0.007..0.010 rows=1 loops=1)
                     Filter: ((info)::text = 'rating'::text)
                     Rows Removed by Filter: 112
               ->  Nested Loop  (cost=7.23..16664.54 rows=813 width=17) (actual time=1.962..68.232 rows=14957 loops=1)
                     ->  Nested Loop  (cost=6.80..16438.09 rows=438 width=4) (actual time=1.945..38.797 rows=12951 loops=1)
                           ->  Seq Scan on keyword k  (cost=0.00..2685.12 rows=13 width=4) (actual time=0.719..11.103 rows=30 loops=1)
                                 Filter: (keyword ~~ '%sequel%'::text)
                                 Rows Removed by Filter: 134140
                           ->  Bitmap Heap Scan on movie_keyword mk  (cost=6.80..1054.86 rows=306 width=8) (actual time=0.052..0.886 rows=432 loops=30)
                                 Recheck Cond: (k.id = keyword_id)
                                 Heap Blocks: exact=6979
                                 ->  Bitmap Index Scan on keyword_id_movie_keyword  (cost=0.00..6.73 rows=306 width=0) (actual time=0.030..0.030 rows=432 loops=30)
                                       Index Cond: (keyword_id = k.id)
                     ->  Index Scan using movie_id_movie_info_idx on movie_info_idx mi_idx  (cost=0.43..0.50 rows=2 width=13) (actual time=0.002..0.002 rows=1 loops=12951)
                           Index Cond: (movie_id = mk.movie_id)
                           Filter: (info > '2.0'::text)
                           Rows Removed by Filter: 1
         ->  Index Scan using title_pkey on title t  (cost=0.43..0.49 rows=1 width=21) (actual time=0.004..0.004 rows=1 loops=8092)
               Index Cond: (id = mk.movie_id)
               Filter: (production_year > 1990)
               Rows Removed by Filter: 0
 Planning Time: 1.396 ms
 Execution Time: 105.588 ms
(29 rows)


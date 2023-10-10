                                                                                  QUERY PLAN                                                                                   
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=15583.16..15583.17 rows=1 width=64) (actual time=89.990..89.992 rows=1 loops=1)
   ->  Nested Loop  (cost=3008.08..15583.15 rows=1 width=22) (actual time=48.262..89.979 rows=6 loops=1)
         ->  Nested Loop  (cost=3007.66..15545.19 rows=86 width=26) (actual time=12.814..87.040 rows=1070 loops=1)
               ->  Nested Loop  (cost=3007.23..15526.97 rows=9 width=30) (actual time=10.297..86.287 rows=72 loops=1)
                     ->  Nested Loop  (cost=3006.80..15129.94 rows=56 width=9) (actual time=10.276..83.608 rows=305 loops=1)
                           ->  Seq Scan on info_type it  (cost=0.00..2.41 rows=1 width=4) (actual time=0.008..0.010 rows=1 loops=1)
                                 Filter: ((info)::text = 'rating'::text)
                                 Rows Removed by Filter: 112
                           ->  Bitmap Heap Scan on movie_info_idx mi_idx  (cost=3006.80..15114.90 rows=1263 width=13) (actual time=10.264..83.562 rows=305 loops=1)
                                 Recheck Cond: (it.id = info_type_id)
                                 Filter: (info > '9.0'::text)
                                 Rows Removed by Filter: 459620
                                 Heap Blocks: exact=7934
                                 ->  Bitmap Index Scan on info_type_id_movie_info_idx  (cost=0.00..3006.48 rows=276007 width=0) (actual time=8.495..8.495 rows=459925 loops=1)
                                       Index Cond: (info_type_id = it.id)
                     ->  Index Scan using title_pkey on title t  (cost=0.43..7.09 rows=1 width=21) (actual time=0.009..0.009 rows=0 loops=305)
                           Index Cond: (id = mi_idx.movie_id)
                           Filter: (production_year > 2010)
                           Rows Removed by Filter: 1
               ->  Index Scan using movie_id_movie_keyword on movie_keyword mk  (cost=0.43..1.55 rows=47 width=8) (actual time=0.008..0.009 rows=15 loops=72)
                     Index Cond: (movie_id = t.id)
         ->  Index Scan using keyword_pkey on keyword k  (cost=0.42..0.44 rows=1 width=4) (actual time=0.003..0.003 rows=0 loops=1070)
               Index Cond: (id = mk.keyword_id)
               Filter: (keyword ~~ '%sequel%'::text)
               Rows Removed by Filter: 1
 Planning Time: 1.564 ms
 Execution Time: 90.170 ms
(27 rows)


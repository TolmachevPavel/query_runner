                                                                             QUERY PLAN                                                                             
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=15330.90..15330.91 rows=1 width=96) (actual time=5711.393..5711.396 rows=1 loops=1)
   ->  Nested Loop  (cost=8.10..15289.55 rows=5514 width=48) (actual time=0.417..5545.644 rows=785477 loops=1)
         ->  Nested Loop  (cost=7.67..12779.03 rows=5514 width=37) (actual time=0.390..2101.867 rows=785477 loops=1)
               Join Filter: (ci.movie_id = t.id)
               ->  Nested Loop  (cost=7.23..12511.77 rows=148 width=41) (actual time=0.375..265.549 rows=14165 loops=1)
                     ->  Nested Loop  (cost=6.80..12379.53 rows=270 width=20) (actual time=0.359..107.310 rows=35548 loops=1)
                           ->  Seq Scan on keyword k  (cost=0.00..3691.40 rows=8 width=20) (actual time=0.053..16.406 rows=8 loops=1)
                                 Filter: (keyword = ANY ('{superhero,sequel,second-part,marvel-comics,based-on-comic,tv-special,fight,violence}'::text[]))
                                 Rows Removed by Filter: 134162
                           ->  Bitmap Heap Scan on movie_keyword mk  (cost=6.80..1082.96 rows=306 width=8) (actual time=0.630..10.827 rows=4444 loops=8)
                                 Recheck Cond: (k.id = keyword_id)
                                 Heap Blocks: exact=23488
                                 ->  Bitmap Index Scan on keyword_id_movie_keyword  (cost=0.00..6.73 rows=306 width=0) (actual time=0.355..0.355 rows=4444 loops=8)
                                       Index Cond: (keyword_id = k.id)
                     ->  Index Scan using title_pkey on title t  (cost=0.43..0.49 rows=1 width=21) (actual time=0.004..0.004 rows=0 loops=35548)
                           Index Cond: (id = mk.movie_id)
                           Filter: (production_year > 2000)
                           Rows Removed by Filter: 1
               ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..1.34 rows=37 width=8) (actual time=0.005..0.123 rows=55 loops=14165)
                     Index Cond: (movie_id = mk.movie_id)
         ->  Index Scan using name_pkey on name n  (cost=0.43..0.46 rows=1 width=19) (actual time=0.004..0.004 rows=1 loops=785477)
               Index Cond: (id = ci.person_id)
 Planning Time: 1.608 ms
 Execution Time: 5711.491 ms
(24 rows)


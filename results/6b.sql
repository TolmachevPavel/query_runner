                                                                             QUERY PLAN                                                                             
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=12514.05..12514.06 rows=1 width=96) (actual time=235.077..235.080 rows=1 loops=1)
   ->  Nested Loop  (cost=8.10..12514.04 rows=1 width=48) (actual time=22.716..235.050 rows=12 loops=1)
         ->  Nested Loop  (cost=7.67..12513.58 rows=1 width=37) (actual time=7.028..233.089 rows=383 loops=1)
               Join Filter: (ci.movie_id = t.id)
               ->  Nested Loop  (cost=7.23..12511.77 rows=1 width=41) (actual time=7.016..232.067 rows=36 loops=1)
                     ->  Nested Loop  (cost=6.80..12379.53 rows=270 width=20) (actual time=0.384..100.568 rows=35548 loops=1)
                           ->  Seq Scan on keyword k  (cost=0.00..3691.40 rows=8 width=20) (actual time=0.065..16.621 rows=8 loops=1)
                                 Filter: (keyword = ANY ('{superhero,sequel,second-part,marvel-comics,based-on-comic,tv-special,fight,violence}'::text[]))
                                 Rows Removed by Filter: 134162
                           ->  Bitmap Heap Scan on movie_keyword mk  (cost=6.80..1082.96 rows=306 width=8) (actual time=0.604..10.065 rows=4444 loops=8)
                                 Recheck Cond: (k.id = keyword_id)
                                 Heap Blocks: exact=23488
                                 ->  Bitmap Index Scan on keyword_id_movie_keyword  (cost=0.00..6.73 rows=306 width=0) (actual time=0.335..0.335 rows=4444 loops=8)
                                       Index Cond: (keyword_id = k.id)
                     ->  Index Scan using title_pkey on title t  (cost=0.43..0.49 rows=1 width=21) (actual time=0.004..0.004 rows=0 loops=35548)
                           Index Cond: (id = mk.movie_id)
                           Filter: (production_year > 2014)
                           Rows Removed by Filter: 1
               ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..1.34 rows=37 width=8) (actual time=0.009..0.027 rows=11 loops=36)
                     Index Cond: (movie_id = mk.movie_id)
         ->  Index Scan using name_pkey on name n  (cost=0.43..0.46 rows=1 width=19) (actual time=0.005..0.005 rows=0 loops=383)
               Index Cond: (id = ci.person_id)
               Filter: (name ~~ '%Downey%Robert%'::text)
               Rows Removed by Filter: 1
 Planning Time: 1.587 ms
 Execution Time: 235.176 ms
(26 rows)


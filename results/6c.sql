                                                                            QUERY PLAN                                                                            
------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=3835.61..3835.62 rows=1 width=96) (actual time=7.044..7.046 rows=1 loops=1)
   ->  Nested Loop  (cost=8.10..3835.60 rows=1 width=48) (actual time=0.639..7.041 rows=2 loops=1)
         ->  Nested Loop  (cost=7.67..3835.14 rows=1 width=37) (actual time=0.330..6.841 rows=33 loops=1)
               Join Filter: (ci.movie_id = t.id)
               ->  Nested Loop  (cost=7.23..3833.34 rows=1 width=41) (actual time=0.310..6.727 rows=2 loops=1)
                     ->  Nested Loop  (cost=6.80..3816.68 rows=34 width=20) (actual time=0.272..6.530 rows=14 loops=1)
                           ->  Seq Scan on keyword k  (cost=0.00..2685.12 rows=1 width=20) (actual time=0.251..6.451 rows=1 loops=1)
                                 Filter: (keyword = 'marvel-cinematic-universe'::text)
                                 Rows Removed by Filter: 134169
                           ->  Bitmap Heap Scan on movie_keyword mk  (cost=6.80..1128.50 rows=306 width=8) (actual time=0.020..0.075 rows=14 loops=1)
                                 Recheck Cond: (k.id = keyword_id)
                                 Heap Blocks: exact=12
                                 ->  Bitmap Index Scan on keyword_id_movie_keyword  (cost=0.00..6.73 rows=306 width=0) (actual time=0.016..0.016 rows=14 loops=1)
                                       Index Cond: (keyword_id = k.id)
                     ->  Index Scan using title_pkey on title t  (cost=0.43..0.49 rows=1 width=21) (actual time=0.014..0.014 rows=0 loops=14)
                           Index Cond: (id = mk.movie_id)
                           Filter: (production_year > 2014)
                           Rows Removed by Filter: 1
               ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..1.34 rows=37 width=8) (actual time=0.018..0.055 rows=16 loops=2)
                     Index Cond: (movie_id = mk.movie_id)
         ->  Index Scan using name_pkey on name n  (cost=0.43..0.46 rows=1 width=19) (actual time=0.006..0.006 rows=0 loops=33)
               Index Cond: (id = ci.person_id)
               Filter: (name ~~ '%Downey%Robert%'::text)
               Rows Removed by Filter: 1
 Planning Time: 2.223 ms
 Execution Time: 7.154 ms
(26 rows)


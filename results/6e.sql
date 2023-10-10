                                                                            QUERY PLAN                                                                            
------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=4183.08..4183.09 rows=1 width=96) (actual time=17.713..17.715 rows=1 loops=1)
   ->  Nested Loop  (cost=8.10..4183.07 rows=1 width=48) (actual time=3.172..17.701 rows=6 loops=1)
         ->  Nested Loop  (cost=7.67..3867.64 rows=689 width=37) (actual time=0.298..9.646 rows=1224 loops=1)
               Join Filter: (ci.movie_id = t.id)
               ->  Nested Loop  (cost=7.23..3833.33 rows=19 width=41) (actual time=0.275..5.975 rows=11 loops=1)
                     ->  Nested Loop  (cost=6.80..3816.68 rows=34 width=20) (actual time=0.256..5.788 rows=14 loops=1)
                           ->  Seq Scan on keyword k  (cost=0.00..2685.12 rows=1 width=20) (actual time=0.228..5.683 rows=1 loops=1)
                                 Filter: (keyword = 'marvel-cinematic-universe'::text)
                                 Rows Removed by Filter: 134169
                           ->  Bitmap Heap Scan on movie_keyword mk  (cost=6.80..1128.50 rows=306 width=8) (actual time=0.027..0.100 rows=14 loops=1)
                                 Recheck Cond: (k.id = keyword_id)
                                 Heap Blocks: exact=12
                                 ->  Bitmap Index Scan on keyword_id_movie_keyword  (cost=0.00..6.73 rows=306 width=0) (actual time=0.017..0.017 rows=14 loops=1)
                                       Index Cond: (keyword_id = k.id)
                     ->  Index Scan using title_pkey on title t  (cost=0.43..0.49 rows=1 width=21) (actual time=0.013..0.013 rows=1 loops=14)
                           Index Cond: (id = mk.movie_id)
                           Filter: (production_year > 2000)
                           Rows Removed by Filter: 0
               ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..1.34 rows=37 width=8) (actual time=0.011..0.321 rows=111 loops=11)
                     Index Cond: (movie_id = mk.movie_id)
         ->  Index Scan using name_pkey on name n  (cost=0.43..0.46 rows=1 width=19) (actual time=0.006..0.006 rows=0 loops=1224)
               Index Cond: (id = ci.person_id)
               Filter: (name ~~ '%Downey%Robert%'::text)
               Rows Removed by Filter: 1
 Planning Time: 1.801 ms
 Execution Time: 17.821 ms
(26 rows)


                                                                                   QUERY PLAN                                                                                    
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=4451.85..4451.86 rows=1 width=32) (actual time=7619.362..7619.366 rows=1 loops=1)
   ->  Nested Loop  (cost=8.95..4451.84 rows=1 width=15) (actual time=40.973..7616.338 rows=11538 loops=1)
         ->  Nested Loop  (cost=8.52..4451.40 rows=1 width=27) (actual time=40.959..7601.078 rows=11538 loops=1)
               ->  Nested Loop  (cost=8.10..4450.96 rows=1 width=31) (actual time=40.947..7573.048 rows=11538 loops=1)
                     ->  Nested Loop  (cost=7.67..4450.39 rows=1 width=23) (actual time=40.925..7556.075 rows=1972 loops=1)
                           ->  Nested Loop  (cost=7.24..3874.93 rows=1257 width=12) (actual time=3.331..2635.853 rows=1038393 loops=1)
                                 ->  Nested Loop  (cost=6.80..3816.68 rows=34 width=4) (actual time=3.312..60.491 rows=41840 loops=1)
                                       ->  Seq Scan on keyword k  (cost=0.00..2685.12 rows=1 width=4) (actual time=0.394..7.186 rows=1 loops=1)
                                             Filter: (keyword = 'character-name-in-title'::text)
                                             Rows Removed by Filter: 134169
                                       ->  Bitmap Heap Scan on movie_keyword mk  (cost=6.80..1128.50 rows=306 width=8) (actual time=2.916..48.579 rows=41840 loops=1)
                                             Recheck Cond: (k.id = keyword_id)
                                             Heap Blocks: exact=11541
                                             ->  Bitmap Index Scan on keyword_id_movie_keyword  (cost=0.00..6.73 rows=306 width=0) (actual time=1.778..1.778 rows=41840 loops=1)
                                                   Index Cond: (keyword_id = k.id)
                                 ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..1.34 rows=37 width=8) (actual time=0.004..0.059 rows=25 loops=41840)
                                       Index Cond: (movie_id = mk.movie_id)
                           ->  Index Scan using name_pkey on name n  (cost=0.43..0.46 rows=1 width=19) (actual time=0.005..0.005 rows=0 loops=1038393)
                                 Index Cond: (id = ci.person_id)
                                 Filter: (name ~~ '%Bert%'::text)
                                 Rows Removed by Filter: 1
                     ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..0.52 rows=5 width=8) (actual time=0.005..0.007 rows=6 loops=1972)
                           Index Cond: (movie_id = ci.movie_id)
               ->  Index Only Scan using company_name_pkey on company_name cn  (cost=0.42..0.44 rows=1 width=4) (actual time=0.002..0.002 rows=1 loops=11538)
                     Index Cond: (id = mc.company_id)
                     Heap Fetches: 0
         ->  Index Only Scan using title_pkey on title t  (cost=0.43..0.45 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=11538)
               Index Cond: (id = ci.movie_id)
               Heap Fetches: 0
 Planning Time: 3.887 ms
 Execution Time: 7619.586 ms
(31 rows)


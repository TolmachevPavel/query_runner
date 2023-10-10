                                                                                   QUERY PLAN                                                                                    
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=4758.64..4758.65 rows=1 width=32) (actual time=9207.122..9207.124 rows=1 loops=1)
   ->  Nested Loop  (cost=8.95..4757.53 rows=443 width=15) (actual time=4.620..9107.098 rows=1113120 loops=1)
         ->  Nested Loop  (cost=8.53..4563.09 rows=443 width=19) (actual time=4.607..8128.860 rows=1113120 loops=1)
               ->  Nested Loop  (cost=8.10..4469.02 rows=165 width=27) (actual time=3.422..7718.941 rows=149494 loops=1)
                     ->  Nested Loop  (cost=7.67..3893.56 rows=1257 width=16) (actual time=3.400..2745.666 rows=1038393 loops=1)
                           Join Filter: (ci.movie_id = t.id)
                           ->  Nested Loop  (cost=7.23..3832.17 rows=34 width=8) (actual time=3.382..126.475 rows=41840 loops=1)
                                 ->  Nested Loop  (cost=6.80..3816.68 rows=34 width=4) (actual time=3.374..60.894 rows=41840 loops=1)
                                       ->  Seq Scan on keyword k  (cost=0.00..2685.12 rows=1 width=4) (actual time=0.398..6.871 rows=1 loops=1)
                                             Filter: (keyword = 'character-name-in-title'::text)
                                             Rows Removed by Filter: 134169
                                       ->  Bitmap Heap Scan on movie_keyword mk  (cost=6.80..1128.50 rows=306 width=8) (actual time=2.974..49.651 rows=41840 loops=1)
                                             Recheck Cond: (k.id = keyword_id)
                                             Heap Blocks: exact=11541
                                             ->  Bitmap Index Scan on keyword_id_movie_keyword  (cost=0.00..6.73 rows=306 width=0) (actual time=1.805..1.805 rows=41840 loops=1)
                                                   Index Cond: (keyword_id = k.id)
                                 ->  Index Only Scan using title_pkey on title t  (cost=0.43..0.46 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=41840)
                                       Index Cond: (id = mk.movie_id)
                                       Heap Fetches: 0
                           ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..1.34 rows=37 width=8) (actual time=0.004..0.059 rows=25 loops=41840)
                                 Index Cond: (movie_id = mk.movie_id)
                     ->  Index Scan using name_pkey on name n  (cost=0.43..0.46 rows=1 width=19) (actual time=0.005..0.005 rows=0 loops=1038393)
                           Index Cond: (id = ci.person_id)
                           Filter: (name ~~ '%B%'::text)
                           Rows Removed by Filter: 1
               ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..0.52 rows=5 width=8) (actual time=0.001..0.002 rows=7 loops=149494)
                     Index Cond: (movie_id = ci.movie_id)
         ->  Index Only Scan using company_name_pkey on company_name cn  (cost=0.42..0.44 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=1113120)
               Index Cond: (id = mc.company_id)
               Heap Fetches: 0
 Planning Time: 3.780 ms
 Execution Time: 9207.367 ms
(32 rows)


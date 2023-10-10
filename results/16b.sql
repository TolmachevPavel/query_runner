                                                                                      QUERY PLAN                                                                                       
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=5207.40..5207.41 rows=1 width=64) (actual time=13145.643..13145.646 rows=1 loops=1)
   ->  Nested Loop  (cost=9.38..5192.17 rows=3046 width=33) (actual time=3.740..12680.382 rows=3710592 loops=1)
         Join Filter: (an.person_id = n.id)
         ->  Nested Loop  (cost=8.95..4595.73 rows=1226 width=25) (actual time=3.716..7753.894 rows=2832555 loops=1)
               ->  Nested Loop  (cost=8.52..4045.06 rows=1226 width=21) (actual time=3.699..3396.398 rows=2832555 loops=1)
                     Join Filter: (ci.movie_id = t.id)
                     ->  Nested Loop  (cost=8.08..3931.30 rows=63 width=29) (actual time=3.428..784.275 rows=68316 loops=1)
                           ->  Nested Loop  (cost=7.66..3853.69 rows=174 width=33) (actual time=3.389..361.236 rows=148552 loops=1)
                                 Join Filter: (mc.movie_id = t.id)
                                 ->  Nested Loop  (cost=7.23..3833.25 rows=34 width=25) (actual time=3.348..220.893 rows=41840 loops=1)
                                       ->  Nested Loop  (cost=6.80..3816.68 rows=34 width=4) (actual time=3.338..60.637 rows=41840 loops=1)
                                             ->  Seq Scan on keyword k  (cost=0.00..2685.12 rows=1 width=4) (actual time=0.369..6.721 rows=1 loops=1)
                                                   Filter: (keyword = 'character-name-in-title'::text)
                                                   Rows Removed by Filter: 134169
                                             ->  Bitmap Heap Scan on movie_keyword mk  (cost=6.80..1128.50 rows=306 width=8) (actual time=2.967..48.467 rows=41840 loops=1)
                                                   Recheck Cond: (k.id = keyword_id)
                                                   Heap Blocks: exact=11541
                                                   ->  Bitmap Index Scan on keyword_id_movie_keyword  (cost=0.00..6.73 rows=306 width=0) (actual time=1.778..1.778 rows=41840 loops=1)
                                                         Index Cond: (keyword_id = k.id)
                                       ->  Index Scan using title_pkey on title t  (cost=0.43..0.49 rows=1 width=21) (actual time=0.004..0.004 rows=1 loops=41840)
                                             Index Cond: (id = mk.movie_id)
                                 ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..0.54 rows=5 width=8) (actual time=0.002..0.003 rows=4 loops=41840)
                                       Index Cond: (movie_id = mk.movie_id)
                           ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..0.45 rows=1 width=4) (actual time=0.003..0.003 rows=0 loops=148552)
                                 Index Cond: (id = mc.company_id)
                                 Filter: ((country_code)::text = '[us]'::text)
                                 Rows Removed by Filter: 1
                     ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..1.34 rows=37 width=8) (actual time=0.002..0.034 rows=41 loops=68316)
                           Index Cond: (movie_id = mk.movie_id)
               ->  Index Only Scan using name_pkey on name n  (cost=0.43..0.45 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=2832555)
                     Index Cond: (id = ci.person_id)
                     Heap Fetches: 0
         ->  Index Scan using person_id_aka_name on aka_name an  (cost=0.42..0.46 rows=2 width=20) (actual time=0.001..0.002 rows=1 loops=2832555)
               Index Cond: (person_id = ci.person_id)
 Planning Time: 5.733 ms
 Execution Time: 13145.875 ms
(36 rows)


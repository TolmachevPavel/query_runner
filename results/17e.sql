                                                                                   QUERY PLAN                                                                                    
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=4605.24..4605.25 rows=1 width=32) (actual time=9751.257..9751.261 rows=1 loops=1)
   ->  Nested Loop  (cost=8.95..4602.18 rows=1226 width=15) (actual time=3.598..9488.749 rows=2832555 loops=1)
         ->  Nested Loop  (cost=8.52..4043.98 rows=1226 width=4) (actual time=3.572..3376.748 rows=2832555 loops=1)
               Join Filter: (ci.movie_id = t.id)
               ->  Nested Loop  (cost=8.08..3930.21 rows=63 width=12) (actual time=3.383..723.854 rows=68316 loops=1)
                     ->  Nested Loop  (cost=7.66..3852.61 rows=174 width=16) (actual time=3.350..270.291 rows=148552 loops=1)
                           Join Filter: (mc.movie_id = t.id)
                           ->  Nested Loop  (cost=7.23..3832.17 rows=34 width=8) (actual time=3.317..129.925 rows=41840 loops=1)
                                 ->  Nested Loop  (cost=6.80..3816.68 rows=34 width=4) (actual time=3.309..63.723 rows=41840 loops=1)
                                       ->  Seq Scan on keyword k  (cost=0.00..2685.12 rows=1 width=4) (actual time=0.402..6.913 rows=1 loops=1)
                                             Filter: (keyword = 'character-name-in-title'::text)
                                             Rows Removed by Filter: 134169
                                       ->  Bitmap Heap Scan on movie_keyword mk  (cost=6.80..1128.50 rows=306 width=8) (actual time=2.905..51.502 rows=41840 loops=1)
                                             Recheck Cond: (k.id = keyword_id)
                                             Heap Blocks: exact=11541
                                             ->  Bitmap Index Scan on keyword_id_movie_keyword  (cost=0.00..6.73 rows=306 width=0) (actual time=1.759..1.759 rows=41840 loops=1)
                                                   Index Cond: (keyword_id = k.id)
                                 ->  Index Only Scan using title_pkey on title t  (cost=0.43..0.46 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=41840)
                                       Index Cond: (id = mk.movie_id)
                                       Heap Fetches: 0
                           ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..0.54 rows=5 width=8) (actual time=0.002..0.003 rows=4 loops=41840)
                                 Index Cond: (movie_id = mk.movie_id)
                     ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..0.45 rows=1 width=4) (actual time=0.003..0.003 rows=0 loops=148552)
                           Index Cond: (id = mc.company_id)
                           Filter: ((country_code)::text = '[us]'::text)
                           Rows Removed by Filter: 1
               ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..1.34 rows=37 width=8) (actual time=0.002..0.035 rows=41 loops=68316)
                     Index Cond: (movie_id = mk.movie_id)
         ->  Index Scan using name_pkey on name n  (cost=0.43..0.46 rows=1 width=19) (actual time=0.002..0.002 rows=1 loops=2832555)
               Index Cond: (id = ci.person_id)
 Planning Time: 3.756 ms
 Execution Time: 9751.473 ms
(32 rows)


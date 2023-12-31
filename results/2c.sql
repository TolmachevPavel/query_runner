                                                                               QUERY PLAN                                                                                
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=3914.81..3914.82 rows=1 width=32) (actual time=357.986..357.989 rows=1 loops=1)
   ->  Nested Loop  (cost=8.08..3914.81 rows=1 width=17) (actual time=357.982..357.985 rows=0 loops=1)
         Join Filter: (mc.movie_id = t.id)
         ->  Nested Loop  (cost=7.65..3914.31 rows=1 width=8) (actual time=357.982..357.984 rows=0 loops=1)
               ->  Nested Loop  (cost=7.23..3836.70 rows=174 width=12) (actual time=3.216..174.754 rows=148552 loops=1)
                     ->  Nested Loop  (cost=6.80..3816.68 rows=34 width=4) (actual time=3.193..59.690 rows=41840 loops=1)
                           ->  Seq Scan on keyword k  (cost=0.00..2685.12 rows=1 width=4) (actual time=0.369..7.118 rows=1 loops=1)
                                 Filter: (keyword = 'character-name-in-title'::text)
                                 Rows Removed by Filter: 134169
                           ->  Bitmap Heap Scan on movie_keyword mk  (cost=6.80..1128.50 rows=306 width=8) (actual time=2.820..49.585 rows=41840 loops=1)
                                 Recheck Cond: (k.id = keyword_id)
                                 Heap Blocks: exact=11541
                                 ->  Bitmap Index Scan on keyword_id_movie_keyword  (cost=0.00..6.73 rows=306 width=0) (actual time=1.694..1.694 rows=41840 loops=1)
                                       Index Cond: (keyword_id = k.id)
                     ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..0.54 rows=5 width=8) (actual time=0.002..0.002 rows=4 loops=41840)
                           Index Cond: (movie_id = mk.movie_id)
               ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..0.45 rows=1 width=4) (actual time=0.001..0.001 rows=0 loops=148552)
                     Index Cond: (id = mc.company_id)
                     Filter: ((country_code)::text = '[sm]'::text)
                     Rows Removed by Filter: 1
         ->  Index Scan using title_pkey on title t  (cost=0.43..0.49 rows=1 width=21) (never executed)
               Index Cond: (id = mk.movie_id)
 Planning Time: 1.668 ms
 Execution Time: 358.199 ms
(24 rows)


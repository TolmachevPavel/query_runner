                                                                                      QUERY PLAN                                                                                       
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=4208.09..4208.10 rows=1 width=64) (actual time=900.241..900.246 rows=1 loops=1)
   ->  Nested Loop  (cost=9.38..4203.94 rows=831 width=33) (actual time=3.676..869.641 rows=249455 loops=1)
         Join Filter: (an.person_id = n.id)
         ->  Nested Loop  (cost=8.95..4040.96 rows=335 width=25) (actual time=3.649..582.468 rows=169273 loops=1)
               ->  Nested Loop  (cost=8.52..3890.49 rows=335 width=21) (actual time=3.632..346.750 rows=169273 loops=1)
                     Join Filter: (ci.movie_id = t.id)
                     ->  Nested Loop  (cost=8.08..3859.79 rows=17 width=29) (actual time=3.615..193.319 rows=6766 loops=1)
                           ->  Nested Loop  (cost=7.66..3838.83 rows=47 width=33) (actual time=3.365..178.823 rows=8661 loops=1)
                                 Join Filter: (mc.movie_id = t.id)
                                 ->  Nested Loop  (cost=7.23..3833.42 rows=9 width=25) (actual time=3.305..165.857 rows=5385 loops=1)
                                       ->  Nested Loop  (cost=6.80..3816.68 rows=34 width=4) (actual time=3.292..52.293 rows=41840 loops=1)
                                             ->  Seq Scan on keyword k  (cost=0.00..2685.12 rows=1 width=4) (actual time=0.375..6.919 rows=1 loops=1)
                                                   Filter: (keyword = 'character-name-in-title'::text)
                                                   Rows Removed by Filter: 134169
                                             ->  Bitmap Heap Scan on movie_keyword mk  (cost=6.80..1128.50 rows=306 width=8) (actual time=2.916..42.372 rows=41840 loops=1)
                                                   Recheck Cond: (k.id = keyword_id)
                                                   Heap Blocks: exact=11541
                                                   ->  Bitmap Index Scan on keyword_id_movie_keyword  (cost=0.00..6.73 rows=306 width=0) (actual time=1.775..1.776 rows=41840 loops=1)
                                                         Index Cond: (keyword_id = k.id)
                                       ->  Index Scan using title_pkey on title t  (cost=0.43..0.49 rows=1 width=21) (actual time=0.003..0.003 rows=0 loops=41840)
                                             Index Cond: (id = mk.movie_id)
                                             Filter: ((episode_nr >= 5) AND (episode_nr < 100))
                                             Rows Removed by Filter: 1
                                 ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..0.54 rows=5 width=8) (actual time=0.002..0.002 rows=2 loops=5385)
                                       Index Cond: (movie_id = mk.movie_id)
                           ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..0.45 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=8661)
                                 Index Cond: (id = mc.company_id)
                                 Filter: ((country_code)::text = '[us]'::text)
                                 Rows Removed by Filter: 0
                     ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..1.34 rows=37 width=8) (actual time=0.002..0.020 rows=25 loops=6766)
                           Index Cond: (movie_id = mk.movie_id)
               ->  Index Only Scan using name_pkey on name n  (cost=0.43..0.45 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=169273)
                     Index Cond: (id = ci.person_id)
                     Heap Fetches: 0
         ->  Index Scan using person_id_aka_name on aka_name an  (cost=0.42..0.46 rows=2 width=20) (actual time=0.001..0.001 rows=1 loops=169273)
               Index Cond: (person_id = ci.person_id)
 Planning Time: 5.967 ms
 Execution Time: 900.466 ms
(38 rows)


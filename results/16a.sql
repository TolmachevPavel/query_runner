                                                                                      QUERY PLAN                                                                                       
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=3872.10..3872.11 rows=1 width=64) (actual time=199.676..199.681 rows=1 loops=1)
   ->  Nested Loop  (cost=9.38..3871.67 rows=85 width=33) (actual time=10.431..199.588 rows=385 loops=1)
         Join Filter: (an.person_id = n.id)
         ->  Nested Loop  (cost=8.95..3855.13 rows=34 width=25) (actual time=10.393..197.920 rows=323 loops=1)
               ->  Nested Loop  (cost=8.52..3839.86 rows=34 width=21) (actual time=10.363..196.557 rows=323 loops=1)
                     Join Filter: (ci.movie_id = t.id)
                     ->  Nested Loop  (cost=8.08..3836.25 rows=2 width=29) (actual time=10.327..195.540 rows=25 loops=1)
                           ->  Nested Loop  (cost=7.66..3834.02 rows=5 width=33) (actual time=10.138..195.200 rows=54 loops=1)
                                 Join Filter: (mc.movie_id = t.id)
                                 ->  Nested Loop  (cost=7.23..3833.42 rows=1 width=25) (actual time=8.226..194.736 rows=146 loops=1)
                                       ->  Nested Loop  (cost=6.80..3816.68 rows=34 width=4) (actual time=3.330..57.991 rows=41840 loops=1)
                                             ->  Seq Scan on keyword k  (cost=0.00..2685.12 rows=1 width=4) (actual time=0.373..6.782 rows=1 loops=1)
                                                   Filter: (keyword = 'character-name-in-title'::text)
                                                   Rows Removed by Filter: 134169
                                             ->  Bitmap Heap Scan on movie_keyword mk  (cost=6.80..1128.50 rows=306 width=8) (actual time=2.956..48.317 rows=41840 loops=1)
                                                   Recheck Cond: (k.id = keyword_id)
                                                   Heap Blocks: exact=11541
                                                   ->  Bitmap Index Scan on keyword_id_movie_keyword  (cost=0.00..6.73 rows=306 width=0) (actual time=1.822..1.822 rows=41840 loops=1)
                                                         Index Cond: (keyword_id = k.id)
                                       ->  Index Scan using title_pkey on title t  (cost=0.43..0.49 rows=1 width=21) (actual time=0.003..0.003 rows=0 loops=41840)
                                             Index Cond: (id = mk.movie_id)
                                             Filter: ((episode_nr >= 50) AND (episode_nr < 100))
                                             Rows Removed by Filter: 1
                                 ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..0.54 rows=5 width=8) (actual time=0.003..0.003 rows=0 loops=146)
                                       Index Cond: (movie_id = mk.movie_id)
                           ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..0.45 rows=1 width=4) (actual time=0.006..0.006 rows=0 loops=54)
                                 Index Cond: (id = mc.company_id)
                                 Filter: ((country_code)::text = '[us]'::text)
                                 Rows Removed by Filter: 1
                     ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..1.34 rows=37 width=8) (actual time=0.009..0.039 rows=13 loops=25)
                           Index Cond: (movie_id = mk.movie_id)
               ->  Index Only Scan using name_pkey on name n  (cost=0.43..0.45 rows=1 width=4) (actual time=0.004..0.004 rows=1 loops=323)
                     Index Cond: (id = ci.person_id)
                     Heap Fetches: 0
         ->  Index Scan using person_id_aka_name on aka_name an  (cost=0.42..0.46 rows=2 width=20) (actual time=0.004..0.005 rows=1 loops=323)
               Index Cond: (person_id = ci.person_id)
 Planning Time: 14.352 ms
 Execution Time: 199.905 ms
(38 rows)


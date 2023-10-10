                                                                                      QUERY PLAN                                                                                       
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=4346.75..4346.76 rows=1 width=64) (actual time=1092.570..1092.574 rows=1 loops=1)
   ->  Nested Loop  (cost=9.38..4341.07 rows=1136 width=33) (actual time=3.700..1053.167 rows=319932 loops=1)
         Join Filter: (an.person_id = n.id)
         ->  Nested Loop  (cost=8.95..4118.75 rows=457 width=25) (actual time=3.665..691.200 rows=221609 loops=1)
               ->  Nested Loop  (cost=8.52..3913.48 rows=457 width=21) (actual time=3.646..387.162 rows=221609 loops=1)
                     Join Filter: (ci.movie_id = t.id)
                     ->  Nested Loop  (cost=8.08..3870.14 rows=24 width=29) (actual time=3.630..196.979 rows=8538 loops=1)
                           ->  Nested Loop  (cost=7.66..3841.15 rows=65 width=33) (actual time=3.338..178.282 rows=11406 loops=1)
                                 Join Filter: (mc.movie_id = t.id)
                                 ->  Nested Loop  (cost=7.23..3833.33 rows=13 width=25) (actual time=3.280..161.958 rows=6926 loops=1)
                                       ->  Nested Loop  (cost=6.80..3816.68 rows=34 width=4) (actual time=3.267..50.149 rows=41840 loops=1)
                                             ->  Seq Scan on keyword k  (cost=0.00..2685.12 rows=1 width=4) (actual time=0.378..6.589 rows=1 loops=1)
                                                   Filter: (keyword = 'character-name-in-title'::text)
                                                   Rows Removed by Filter: 134169
                                             ->  Bitmap Heap Scan on movie_keyword mk  (cost=6.80..1128.50 rows=306 width=8) (actual time=2.887..40.230 rows=41840 loops=1)
                                                   Recheck Cond: (k.id = keyword_id)
                                                   Heap Blocks: exact=11541
                                                   ->  Bitmap Index Scan on keyword_id_movie_keyword  (cost=0.00..6.73 rows=306 width=0) (actual time=1.743..1.743 rows=41840 loops=1)
                                                         Index Cond: (keyword_id = k.id)
                                       ->  Index Scan using title_pkey on title t  (cost=0.43..0.49 rows=1 width=21) (actual time=0.003..0.003 rows=0 loops=41840)
                                             Index Cond: (id = mk.movie_id)
                                             Filter: (episode_nr < 100)
                                             Rows Removed by Filter: 1
                                 ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..0.54 rows=5 width=8) (actual time=0.002..0.002 rows=2 loops=6926)
                                       Index Cond: (movie_id = mk.movie_id)
                           ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..0.45 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=11406)
                                 Index Cond: (id = mc.company_id)
                                 Filter: ((country_code)::text = '[us]'::text)
                                 Rows Removed by Filter: 0
                     ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..1.34 rows=37 width=8) (actual time=0.002..0.020 rows=26 loops=8538)
                           Index Cond: (movie_id = mk.movie_id)
               ->  Index Only Scan using name_pkey on name n  (cost=0.43..0.45 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=221609)
                     Index Cond: (id = ci.person_id)
                     Heap Fetches: 0
         ->  Index Scan using person_id_aka_name on aka_name an  (cost=0.42..0.46 rows=2 width=20) (actual time=0.001..0.001 rows=1 loops=221609)
               Index Cond: (person_id = ci.person_id)
 Planning Time: 5.845 ms
 Execution Time: 1092.794 ms
(38 rows)


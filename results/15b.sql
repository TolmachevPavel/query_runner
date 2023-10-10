                                                                                                      QUERY PLAN                                                                                                      
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Finalize Aggregate  (cost=6478.80..6478.81 rows=1 width=64) (actual time=19.862..23.480 rows=1 loops=1)
   ->  Gather  (cost=6478.68..6478.79 rows=1 width=64) (actual time=19.745..23.474 rows=2 loops=1)
         Workers Planned: 1
         Workers Launched: 1
         ->  Partial Aggregate  (cost=5478.68..5478.69 rows=1 width=64) (actual time=17.747..17.751 rows=1 loops=2)
               ->  Nested Loop  (cost=2.86..5478.66 rows=5 width=60) (actual time=13.222..17.741 rows=18 loops=2)
                     ->  Nested Loop  (cost=2.44..5476.47 rows=5 width=64) (actual time=13.205..17.662 rows=18 loops=2)
                           ->  Nested Loop  (cost=2.01..5474.58 rows=1 width=76) (actual time=11.461..17.628 rows=2 loops=2)
                                 ->  Nested Loop  (cost=1.87..5474.26 rows=1 width=80) (actual time=11.448..17.613 rows=2 loops=2)
                                       ->  Nested Loop  (cost=1.43..5471.88 rows=1 width=29) (actual time=10.130..16.962 rows=13 loops=2)
                                             ->  Nested Loop  (cost=1.00..5470.93 rows=1 width=8) (actual time=10.112..16.785 rows=14 loops=2)
                                                   ->  Nested Loop  (cost=0.85..5470.76 rows=1 width=12) (actual time=10.098..16.759 rows=14 loops=2)
                                                         ->  Nested Loop  (cost=0.43..5470.07 rows=1 width=8) (actual time=9.866..16.154 rows=139 loops=2)
                                                               ->  Parallel Seq Scan on company_name cn  (cost=0.00..5113.50 rows=1 width=4) (actual time=9.832..13.456 rows=0 loops=2)
                                                                     Filter: (((country_code)::text = '[us]'::text) AND (name = 'YouTube'::text))
                                                                     Rows Removed by Filter: 117498
                                                               ->  Index Scan using company_id_movie_companies on movie_companies mc  (cost=0.43..356.55 rows=1 width=12) (actual time=0.066..5.368 rows=278 loops=1)
                                                                     Index Cond: (company_id = cn.id)
                                                                     Filter: ((note ~~ '%(200%)%'::text) AND (note ~~ '%(worldwide)%'::text))
                                                                     Rows Removed by Filter: 1180
                                                         ->  Index Only Scan using movie_id_aka_title on aka_title at  (cost=0.42..0.67 rows=3 width=4) (actual time=0.004..0.004 rows=0 loops=278)
                                                               Index Cond: (movie_id = mc.movie_id)
                                                               Heap Fetches: 0
                                                   ->  Index Only Scan using company_type_pkey on company_type ct  (cost=0.15..0.17 rows=1 width=4) (actual time=0.002..0.002 rows=1 loops=27)
                                                         Index Cond: (id = mc.company_type_id)
                                                         Heap Fetches: 27
                                             ->  Index Scan using title_pkey on title t  (cost=0.43..0.95 rows=1 width=21) (actual time=0.013..0.013 rows=1 loops=27)
                                                   Index Cond: (id = at.movie_id)
                                                   Filter: ((production_year >= 2005) AND (production_year <= 2010))
                                                   Rows Removed by Filter: 0
                                       ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..2.37 rows=1 width=51) (actual time=0.047..0.050 rows=0 loops=26)
                                             Index Cond: (movie_id = t.id)
                                             Filter: ((note ~~ '%internet%'::text) AND (info ~~ 'USA:% 200%'::text))
                                             Rows Removed by Filter: 19
                                 ->  Index Scan using info_type_pkey on info_type it1  (cost=0.14..0.23 rows=1 width=4) (actual time=0.009..0.009 rows=1 loops=3)
                                       Index Cond: (id = mi.info_type_id)
                                       Filter: ((info)::text = 'release dates'::text)
                           ->  Index Scan using movie_id_movie_keyword on movie_keyword mk  (cost=0.43..1.42 rows=47 width=8) (actual time=0.019..0.021 rows=12 loops=3)
                                 Index Cond: (movie_id = t.id)
                     ->  Index Only Scan using keyword_pkey on keyword k  (cost=0.42..0.44 rows=1 width=4) (actual time=0.004..0.004 rows=1 loops=37)
                           Index Cond: (id = mk.keyword_id)
                           Heap Fetches: 0
 Planning Time: 11.248 ms
 Execution Time: 23.654 ms
(44 rows)


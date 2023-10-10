                                                                                         QUERY PLAN                                                                                          
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=19269.70..19269.71 rows=1 width=64) (actual time=49.548..51.610 rows=1 loops=1)
   ->  Nested Loop  (cost=1004.43..19269.69 rows=1 width=60) (actual time=48.188..51.595 rows=10 loops=1)
         ->  Nested Loop  (cost=1004.29..19269.51 rows=1 width=64) (actual time=48.110..50.913 rows=1210 loops=1)
               Join Filter: (mi.movie_id = t.id)
               ->  Nested Loop  (cost=1003.85..19267.57 rows=1 width=29) (actual time=48.089..50.479 rows=10 loops=1)
                     ->  Gather  (cost=1003.43..19267.12 rows=1 width=33) (actual time=48.071..50.246 rows=33 loops=1)
                           Workers Planned: 2
                           Workers Launched: 2
                           ->  Nested Loop  (cost=3.44..18267.02 rows=1 width=33) (actual time=45.675..45.714 rows=11 loops=3)
                                 ->  Nested Loop  (cost=3.29..18266.67 rows=2 width=37) (actual time=45.666..45.698 rows=11 loops=3)
                                       Join Filter: (mc.movie_id = t.id)
                                       ->  Nested Loop  (cost=2.86..18266.02 rows=1 width=25) (actual time=45.660..45.680 rows=1 loops=3)
                                             ->  Hash Join  (cost=2.43..15286.60 rows=5089 width=4) (actual time=45.619..45.622 rows=3 loops=3)
                                                   Hash Cond: (mi_idx.info_type_id = it2.id)
                                                   ->  Parallel Seq Scan on movie_info_idx mi_idx  (cost=0.00..13718.15 rows=575015 width=8) (actual time=0.013..22.711 rows=460012 loops=3)
                                                   ->  Hash  (cost=2.41..2.41 rows=1 width=4) (actual time=0.022..0.022 rows=1 loops=3)
                                                         Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                         ->  Seq Scan on info_type it2  (cost=0.00..2.41 rows=1 width=4) (actual time=0.014..0.015 rows=1 loops=3)
                                                               Filter: ((info)::text = 'bottom 10 rank'::text)
                                                               Rows Removed by Filter: 112
                                             ->  Index Scan using title_pkey on title t  (cost=0.43..0.59 rows=1 width=21) (actual time=0.016..0.016 rows=0 loops=10)
                                                   Index Cond: (id = mi_idx.movie_id)
                                                   Filter: ((production_year > 2000) AND ((title ~~ 'Birdemic%'::text) OR (title ~~ '%Movie%'::text)))
                                                   Rows Removed by Filter: 1
                                       ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..0.59 rows=5 width=12) (actual time=0.016..0.023 rows=16 loops=2)
                                             Index Cond: (movie_id = mi_idx.movie_id)
                                 ->  Index Scan using company_type_pkey on company_type ct  (cost=0.15..0.17 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=33)
                                       Index Cond: (id = mc.company_type_id)
                                       Filter: ((kind IS NOT NULL) AND (((kind)::text = 'production companies'::text) OR ((kind)::text = 'distributors'::text)))
                     ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..0.45 rows=1 width=4) (actual time=0.007..0.007 rows=0 loops=33)
                           Index Cond: (id = mc.company_id)
                           Filter: ((country_code)::text = '[us]'::text)
                           Rows Removed by Filter: 1
               ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..1.43 rows=41 width=51) (actual time=0.004..0.032 rows=121 loops=10)
                     Index Cond: (movie_id = mc.movie_id)
         ->  Index Scan using info_type_pkey on info_type it1  (cost=0.14..0.16 rows=1 width=4) (actual time=0.000..0.000 rows=0 loops=1210)
               Index Cond: (id = mi.info_type_id)
               Filter: ((info)::text = 'budget'::text)
               Rows Removed by Filter: 1
 Planning Time: 5.347 ms
 Execution Time: 51.756 ms
(41 rows)


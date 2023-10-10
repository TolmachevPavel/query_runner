                                                                                                            QUERY PLAN                                                                                                            
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=1524.41..1524.42 rows=1 width=192) (actual time=11.573..11.576 rows=1 loops=1)
   ->  Nested Loop  (cost=23.76..1524.39 rows=1 width=82) (actual time=1.797..11.529 rows=114 loops=1)
         ->  Nested Loop  (cost=23.61..1524.22 rows=1 width=86) (actual time=1.476..11.432 rows=133 loops=1)
               Join Filter: (ml.linked_movie_id = t2.id)
               ->  Nested Loop  (cost=23.18..1523.68 rows=1 width=77) (actual time=1.447..11.062 rows=218 loops=1)
                     ->  Nested Loop  (cost=22.76..1523.24 rows=1 width=62) (actual time=1.429..10.475 rows=293 loops=1)
                           ->  Nested Loop  (cost=22.33..1522.63 rows=1 width=70) (actual time=1.409..10.138 rows=84 loops=1)
                                 Join Filter: (it1.id = mi_idx1.info_type_id)
                                 Rows Removed by Join Filter: 168
                                 ->  Nested Loop  (cost=21.90..1519.96 rows=5 width=65) (actual time=1.396..9.944 rows=97 loops=1)
                                       ->  Nested Loop  (cost=21.48..1517.74 rows=5 width=50) (actual time=1.376..9.475 rows=97 loops=1)
                                             Join Filter: (mc2.movie_id = ml.linked_movie_id)
                                             ->  Nested Loop  (cost=21.05..1517.03 rows=1 width=42) (actual time=1.342..9.017 rows=47 loops=1)
                                                   ->  Nested Loop  (cost=20.90..1516.00 rows=6 width=46) (actual time=1.329..8.966 rows=47 loops=1)
                                                         ->  Nested Loop  (cost=20.47..1489.17 rows=6 width=21) (actual time=1.300..8.630 rows=47 loops=1)
                                                               ->  Index Scan using info_type_pkey on info_type it1  (cost=0.14..14.12 rows=1 width=4) (actual time=0.012..0.014 rows=1 loops=1)
                                                                     Filter: ((info)::text = 'rating'::text)
                                                                     Rows Removed by Filter: 112
                                                               ->  Nested Loop  (cost=20.33..1474.99 rows=6 width=17) (actual time=1.288..8.612 rows=47 loops=1)
                                                                     Join Filter: (it2.id = mi_idx2.info_type_id)
                                                                     Rows Removed by Join Filter: 3018
                                                                     ->  Seq Scan on info_type it2  (cost=0.00..2.41 rows=1 width=4) (actual time=0.008..0.009 rows=1 loops=1)
                                                                           Filter: ((info)::text = 'rating'::text)
                                                                           Rows Removed by Filter: 112
                                                                     ->  Nested Loop  (cost=20.33..1463.70 rows=710 width=21) (actual time=0.063..8.496 rows=3065 loops=1)
                                                                           ->  Hash Join  (cost=19.90..562.08 rows=465 width=8) (actual time=0.042..3.403 rows=2315 loops=1)
                                                                                 Hash Cond: (ml.link_type_id = lt.id)
                                                                                 ->  Seq Scan on movie_link ml  (cost=0.00..462.97 rows=29997 width=12) (actual time=0.002..1.595 rows=29997 loops=1)
                                                                                 ->  Hash  (cost=19.76..19.76 rows=11 width=4) (actual time=0.023..0.023 rows=2 loops=1)
                                                                                       Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                                                       ->  Seq Scan on link_type lt  (cost=0.00..19.76 rows=11 width=4) (actual time=0.015..0.017 rows=2 loops=1)
                                                                                             Filter: ((link)::text = ANY ('{sequel,follows,"followed by"}'::text[]))
                                                                                             Rows Removed by Filter: 16
                                                                           ->  Index Scan using movie_id_movie_info_idx on movie_info_idx mi_idx2  (cost=0.43..1.92 rows=2 width=13) (actual time=0.002..0.002 rows=1 loops=2315)
                                                                                 Index Cond: (movie_id = ml.linked_movie_id)
                                                                                 Filter: (info < '3.5'::text)
                                                                                 Rows Removed by Filter: 1
                                                         ->  Index Scan using title_pkey on title t1  (cost=0.43..4.47 rows=1 width=25) (actual time=0.007..0.007 rows=1 loops=47)
                                                               Index Cond: (id = ml.movie_id)
                                                   ->  Index Scan using kind_type_pkey on kind_type kt1  (cost=0.15..0.17 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=47)
                                                         Index Cond: (id = t1.kind_id)
                                                         Filter: ((kind)::text = ANY ('{"tv series",episode}'::text[]))
                                             ->  Index Scan using movie_id_movie_companies on movie_companies mc2  (cost=0.43..0.65 rows=5 width=8) (actual time=0.008..0.009 rows=2 loops=47)
                                                   Index Cond: (movie_id = mi_idx2.movie_id)
                                       ->  Index Scan using company_name_pkey on company_name cn2  (cost=0.42..0.44 rows=1 width=23) (actual time=0.005..0.005 rows=1 loops=97)
                                             Index Cond: (id = mc2.company_id)
                                 ->  Index Scan using movie_id_movie_info_idx on movie_info_idx mi_idx1  (cost=0.43..0.50 rows=3 width=13) (actual time=0.001..0.002 rows=3 loops=97)
                                       Index Cond: (movie_id = t1.id)
                           ->  Index Scan using movie_id_movie_companies on movie_companies mc1  (cost=0.43..0.56 rows=5 width=8) (actual time=0.002..0.004 rows=3 loops=84)
                                 Index Cond: (movie_id = t1.id)
                     ->  Index Scan using company_name_pkey on company_name cn1  (cost=0.42..0.45 rows=1 width=23) (actual time=0.002..0.002 rows=1 loops=293)
                           Index Cond: (id = mc1.company_id)
                           Filter: ((country_code)::text <> '[us]'::text)
                           Rows Removed by Filter: 0
               ->  Index Scan using title_pkey on title t2  (cost=0.43..0.52 rows=1 width=25) (actual time=0.001..0.001 rows=1 loops=218)
                     Index Cond: (id = mc2.movie_id)
                     Filter: ((production_year >= 2000) AND (production_year <= 2010))
                     Rows Removed by Filter: 0
         ->  Index Scan using kind_type_pkey on kind_type kt2  (cost=0.15..0.17 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=133)
               Index Cond: (id = t2.kind_id)
               Filter: ((kind)::text = ANY ('{"tv series",episode}'::text[]))
               Rows Removed by Filter: 0
 Planning Time: 50.987 ms
 Execution Time: 11.853 ms
(64 rows)


                                                                                                            QUERY PLAN                                                                                                            
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=1570.27..1570.28 rows=1 width=192) (actual time=22.153..22.158 rows=1 loops=1)
   ->  Nested Loop  (cost=23.62..1570.26 rows=1 width=82) (actual time=3.934..22.149 rows=8 loops=1)
         Join Filter: ((ml.movie_id = t1.id) AND (kt1.id = t1.kind_id))
         ->  Nested Loop  (cost=23.19..1569.72 rows=1 width=81) (actual time=3.919..22.124 rows=8 loops=1)
               ->  Nested Loop  (cost=23.04..1569.54 rows=1 width=85) (actual time=0.448..21.635 rows=807 loops=1)
                     Join Filter: (mi_idx2.movie_id = t2.id)
                     ->  Nested Loop  (cost=22.62..1568.51 rows=2 width=88) (actual time=0.438..20.870 rows=465 loops=1)
                           ->  Nested Loop  (cost=22.20..1567.62 rows=2 width=73) (actual time=0.425..19.964 rows=465 loops=1)
                                 ->  Nested Loop  (cost=21.77..1566.06 rows=2 width=65) (actual time=0.421..19.653 rows=58 loops=1)
                                       ->  Nested Loop  (cost=21.35..1563.83 rows=5 width=50) (actual time=0.396..18.713 rows=265 loops=1)
                                             ->  Nested Loop  (cost=21.35..1541.03 rows=1 width=46) (actual time=0.395..18.437 rows=265 loops=1)
                                                   ->  Nested Loop  (cost=21.19..1539.70 rows=10 width=50) (actual time=0.141..18.171 rows=1185 loops=1)
                                                         Join Filter: (mc1.movie_id = ml.movie_id)
                                                         ->  Nested Loop  (cost=20.76..1538.40 rows=2 width=42) (actual time=0.127..17.052 rows=210 loops=1)
                                                               ->  Nested Loop  (cost=20.33..1484.68 rows=12 width=17) (actual time=0.073..8.177 rows=2064 loops=1)
                                                                     Join Filter: (it1.id = mi_idx1.info_type_id)
                                                                     Rows Removed by Join Filter: 4128
                                                                     ->  Seq Scan on info_type it1  (cost=0.00..2.41 rows=1 width=4) (actual time=0.010..0.011 rows=1 loops=1)
                                                                           Filter: ((info)::text = 'rating'::text)
                                                                           Rows Removed by Filter: 112
                                                                     ->  Nested Loop  (cost=20.33..1464.87 rows=1392 width=21) (actual time=0.062..7.842 rows=6192 loops=1)
                                                                           ->  Hash Join  (cost=19.90..562.08 rows=465 width=8) (actual time=0.045..3.632 rows=2315 loops=1)
                                                                                 Hash Cond: (ml.link_type_id = lt.id)
                                                                                 ->  Seq Scan on movie_link ml  (cost=0.00..462.97 rows=29997 width=12) (actual time=0.008..1.861 rows=29997 loops=1)
                                                                                 ->  Hash  (cost=19.76..19.76 rows=11 width=4) (actual time=0.022..0.023 rows=2 loops=1)
                                                                                       Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                                                       ->  Seq Scan on link_type lt  (cost=0.00..19.76 rows=11 width=4) (actual time=0.015..0.016 rows=2 loops=1)
                                                                                             Filter: ((link)::text = ANY ('{sequel,follows,"followed by"}'::text[]))
                                                                                             Rows Removed by Filter: 16
                                                                           ->  Index Scan using movie_id_movie_info_idx on movie_info_idx mi_idx1  (cost=0.43..1.91 rows=3 width=13) (actual time=0.001..0.001 rows=3 loops=2315)
                                                                                 Index Cond: (movie_id = ml.movie_id)
                                                               ->  Index Scan using title_pkey on title t2  (cost=0.43..4.48 rows=1 width=25) (actual time=0.004..0.004 rows=0 loops=2064)
                                                                     Index Cond: (id = ml.linked_movie_id)
                                                                     Filter: ((production_year >= 2005) AND (production_year <= 2008))
                                                                     Rows Removed by Filter: 1
                                                         ->  Index Scan using movie_id_movie_companies on movie_companies mc1  (cost=0.43..0.59 rows=5 width=8) (actual time=0.003..0.005 rows=6 loops=210)
                                                               Index Cond: (movie_id = mi_idx1.movie_id)
                                                   ->  Memoize  (cost=0.16..0.18 rows=1 width=4) (actual time=0.000..0.000 rows=0 loops=1185)
                                                         Cache Key: t2.kind_id
                                                         Cache Mode: logical
                                                         Hits: 1179  Misses: 6  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                                         ->  Index Scan using kind_type_pkey on kind_type kt2  (cost=0.15..0.17 rows=1 width=4) (actual time=0.004..0.004 rows=0 loops=6)
                                                               Index Cond: (id = t2.kind_id)
                                                               Filter: ((kind)::text = 'tv series'::text)
                                                               Rows Removed by Filter: 1
                                             ->  Seq Scan on kind_type kt1  (cost=0.00..22.75 rows=5 width=4) (actual time=0.000..0.001 rows=1 loops=265)
                                                   Filter: ((kind)::text = 'tv series'::text)
                                                   Rows Removed by Filter: 6
                                       ->  Index Scan using company_name_pkey on company_name cn1  (cost=0.42..0.45 rows=1 width=23) (actual time=0.003..0.003 rows=0 loops=265)
                                             Index Cond: (id = mc1.company_id)
                                             Filter: ((country_code)::text = '[us]'::text)
                                             Rows Removed by Filter: 1
                                 ->  Index Scan using movie_id_movie_companies on movie_companies mc2  (cost=0.43..0.73 rows=5 width=8) (actual time=0.003..0.004 rows=8 loops=58)
                                       Index Cond: (movie_id = t2.id)
                           ->  Index Scan using company_name_pkey on company_name cn2  (cost=0.42..0.44 rows=1 width=23) (actual time=0.002..0.002 rows=1 loops=465)
                                 Index Cond: (id = mc2.company_id)
                     ->  Index Scan using movie_id_movie_info_idx on movie_info_idx mi_idx2  (cost=0.43..0.50 rows=1 width=13) (actual time=0.001..0.001 rows=2 loops=465)
                           Index Cond: (movie_id = mc2.movie_id)
                           Filter: (info < '3.0'::text)
                           Rows Removed by Filter: 1
               ->  Index Scan using info_type_pkey on info_type it2  (cost=0.14..0.16 rows=1 width=4) (actual time=0.000..0.000 rows=0 loops=807)
                     Index Cond: (id = mi_idx2.info_type_id)
                     Filter: ((info)::text = 'rating'::text)
                     Rows Removed by Filter: 1
         ->  Index Scan using title_pkey on title t1  (cost=0.43..0.52 rows=1 width=25) (actual time=0.003..0.003 rows=1 loops=8)
               Index Cond: (id = mc1.movie_id)
 Planning Time: 50.826 ms
 Execution Time: 22.388 ms
(68 rows)


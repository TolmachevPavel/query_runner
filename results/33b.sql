                                                                                                            QUERY PLAN                                                                                                            
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=361.73..361.74 rows=1 width=192) (actual time=9.716..9.720 rows=1 loops=1)
   ->  Nested Loop  (cost=26.68..361.72 rows=1 width=82) (actual time=1.161..9.714 rows=4 loops=1)
         ->  Nested Loop  (cost=26.26..361.27 rows=1 width=67) (actual time=1.156..9.704 rows=4 loops=1)
               Join Filter: (mc2.movie_id = t2.id)
               ->  Nested Loop  (cost=25.83..360.55 rows=1 width=75) (actual time=1.148..9.694 rows=1 loops=1)
                     ->  Nested Loop  (cost=25.69..360.37 rows=1 width=79) (actual time=1.116..9.688 rows=3 loops=1)
                           ->  Nested Loop  (cost=25.27..359.92 rows=1 width=64) (actual time=1.106..9.659 rows=12 loops=1)
                                 ->  Nested Loop  (cost=24.84..359.31 rows=1 width=72) (actual time=1.093..9.622 rows=6 loops=1)
                                       Join Filter: ((ml.movie_id = t1.id) AND (kt1.id = t1.kind_id))
                                       ->  Nested Loop  (cost=24.41..356.35 rows=5 width=55) (actual time=1.080..9.586 rows=6 loops=1)
                                             ->  Nested Loop  (cost=24.41..333.55 rows=1 width=51) (actual time=1.077..9.577 rows=6 loops=1)
                                                   ->  Nested Loop  (cost=24.26..333.03 rows=3 width=55) (actual time=1.062..9.556 rows=6 loops=1)
                                                         ->  Nested Loop  (cost=23.83..331.09 rows=1 width=42) (actual time=1.052..9.542 rows=2 loops=1)
                                                               Join Filter: (ml.linked_movie_id = t2.id)
                                                               ->  Nested Loop  (cost=23.40..330.35 rows=1 width=17) (actual time=1.038..9.307 rows=34 loops=1)
                                                                     ->  Nested Loop  (cost=23.25..327.90 rows=60 width=21) (actual time=0.106..8.737 rows=2902 loops=1)
                                                                           ->  Nested Loop  (cost=22.82..246.88 rows=42 width=8) (actual time=0.077..1.031 rows=2315 loops=1)
                                                                                 ->  Seq Scan on link_type lt  (cost=0.00..18.88 rows=1 width=4) (actual time=0.017..0.021 rows=2 loops=1)
                                                                                       Filter: ((link)::text ~~ '%follow%'::text)
                                                                                       Rows Removed by Filter: 16
                                                                                 ->  Bitmap Heap Scan on movie_link ml  (cost=22.82..209.26 rows=1875 width=12) (actual time=0.042..0.421 rows=1158 loops=2)
                                                                                       Recheck Cond: (lt.id = link_type_id)
                                                                                       Heap Blocks: exact=191
                                                                                       ->  Bitmap Index Scan on link_type_id_movie_link  (cost=0.00..22.35 rows=1875 width=0) (actual time=0.032..0.032 rows=1158 loops=2)
                                                                                             Index Cond: (link_type_id = lt.id)
                                                                           ->  Index Scan using movie_id_movie_info_idx on movie_info_idx mi_idx2  (cost=0.43..1.92 rows=1 width=13) (actual time=0.003..0.003 rows=1 loops=2315)
                                                                                 Index Cond: (movie_id = ml.linked_movie_id)
                                                                                 Filter: (info < '3.0'::text)
                                                                                 Rows Removed by Filter: 1
                                                                     ->  Memoize  (cost=0.15..0.17 rows=1 width=4) (actual time=0.000..0.000 rows=0 loops=2902)
                                                                           Cache Key: mi_idx2.info_type_id
                                                                           Cache Mode: logical
                                                                           Hits: 2899  Misses: 3  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                                                           ->  Index Scan using info_type_pkey on info_type it2  (cost=0.14..0.16 rows=1 width=4) (actual time=0.003..0.003 rows=0 loops=3)
                                                                                 Index Cond: (id = mi_idx2.info_type_id)
                                                                                 Filter: ((info)::text = 'rating'::text)
                                                                                 Rows Removed by Filter: 1
                                                               ->  Index Scan using title_pkey on title t2  (cost=0.43..0.72 rows=1 width=25) (actual time=0.007..0.007 rows=0 loops=34)
                                                                     Index Cond: (id = mi_idx2.movie_id)
                                                                     Filter: (production_year = 2007)
                                                                     Rows Removed by Filter: 1
                                                         ->  Index Scan using movie_id_movie_info_idx on movie_info_idx mi_idx1  (cost=0.43..1.91 rows=3 width=13) (actual time=0.005..0.006 rows=3 loops=2)
                                                               Index Cond: (movie_id = ml.movie_id)
                                                   ->  Index Scan using kind_type_pkey on kind_type kt2  (cost=0.15..0.17 rows=1 width=4) (actual time=0.003..0.003 rows=1 loops=6)
                                                         Index Cond: (id = t2.kind_id)
                                                         Filter: ((kind)::text = 'tv series'::text)
                                             ->  Seq Scan on kind_type kt1  (cost=0.00..22.75 rows=5 width=4) (actual time=0.001..0.001 rows=1 loops=6)
                                                   Filter: ((kind)::text = 'tv series'::text)
                                                   Rows Removed by Filter: 6
                                       ->  Index Scan using title_pkey on title t1  (cost=0.43..0.58 rows=1 width=25) (actual time=0.005..0.005 rows=1 loops=6)
                                             Index Cond: (id = mi_idx1.movie_id)
                                 ->  Index Scan using movie_id_movie_companies on movie_companies mc1  (cost=0.43..0.56 rows=5 width=8) (actual time=0.005..0.006 rows=2 loops=6)
                                       Index Cond: (movie_id = t1.id)
                           ->  Index Scan using company_name_pkey on company_name cn1  (cost=0.42..0.45 rows=1 width=23) (actual time=0.002..0.002 rows=0 loops=12)
                                 Index Cond: (id = mc1.company_id)
                                 Filter: ((country_code)::text = '[nl]'::text)
                                 Rows Removed by Filter: 1
                     ->  Index Scan using info_type_pkey on info_type it1  (cost=0.14..0.16 rows=1 width=4) (actual time=0.002..0.002 rows=0 loops=3)
                           Index Cond: (id = mi_idx1.info_type_id)
                           Filter: ((info)::text = 'rating'::text)
                           Rows Removed by Filter: 1
               ->  Index Scan using movie_id_movie_companies on movie_companies mc2  (cost=0.43..0.66 rows=5 width=8) (actual time=0.008..0.009 rows=4 loops=1)
                     Index Cond: (movie_id = mi_idx2.movie_id)
         ->  Index Scan using company_name_pkey on company_name cn2  (cost=0.42..0.44 rows=1 width=23) (actual time=0.002..0.002 rows=1 loops=4)
               Index Cond: (id = mc2.company_id)
 Planning Time: 49.621 ms
 Execution Time: 9.985 ms
(67 rows)


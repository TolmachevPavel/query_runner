                                                                                        QUERY PLAN                                                                                         
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=407.88..407.89 rows=1 width=96) (actual time=6.650..6.651 rows=1 loops=1)
   ->  Nested Loop  (cost=25.11..407.87 rows=1 width=118) (actual time=4.823..6.637 rows=14 loops=1)
         ->  Nested Loop  (cost=24.69..407.41 rows=1 width=122) (actual time=4.796..6.567 rows=56 loops=1)
               Join Filter: (mk.movie_id = ml.movie_id)
               ->  Nested Loop  (cost=24.26..405.47 rows=1 width=130) (actual time=4.777..6.528 rows=14 loops=1)
                     Join Filter: (ml.movie_id = t.id)
                     ->  Nested Loop  (cost=23.83..404.86 rows=1 width=109) (actual time=0.240..5.859 rows=450 loops=1)
                           ->  Nested Loop  (cost=23.41..404.40 rows=1 width=94) (actual time=0.074..3.367 rows=1793 loops=1)
                                 ->  Nested Loop  (cost=23.25..401.30 rows=104 width=98) (actual time=0.058..2.919 rows=2077 loops=1)
                                       ->  Nested Loop  (cost=22.82..246.88 rows=42 width=86) (actual time=0.047..0.467 rows=1158 loops=1)
                                             ->  Seq Scan on link_type lt  (cost=0.00..18.88 rows=1 width=86) (actual time=0.006..0.008 rows=1 loops=1)
                                                   Filter: ((link)::text ~~ '%follows%'::text)
                                                   Rows Removed by Filter: 17
                                             ->  Bitmap Heap Scan on movie_link ml  (cost=22.82..209.26 rows=1875 width=8) (actual time=0.040..0.376 rows=1158 loops=1)
                                                   Recheck Cond: (lt.id = link_type_id)
                                                   Heap Blocks: exact=95
                                                   ->  Bitmap Index Scan on link_type_id_movie_link  (cost=0.00..22.35 rows=1875 width=0) (actual time=0.030..0.030 rows=1158 loops=1)
                                                         Index Cond: (link_type_id = lt.id)
                                       ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..3.66 rows=2 width=12) (actual time=0.002..0.002 rows=2 loops=1158)
                                             Index Cond: (movie_id = ml.movie_id)
                                             Filter: (note IS NULL)
                                             Rows Removed by Filter: 2
                                 ->  Memoize  (cost=0.16..0.18 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=2077)
                                       Cache Key: mc.company_type_id
                                       Cache Mode: logical
                                       Hits: 2075  Misses: 2  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                       ->  Index Scan using company_type_pkey on company_type ct  (cost=0.15..0.17 rows=1 width=4) (actual time=0.006..0.006 rows=0 loops=2)
                                             Index Cond: (id = mc.company_type_id)
                                             Filter: ((kind)::text = 'production companies'::text)
                                             Rows Removed by Filter: 0
                           ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..0.46 rows=1 width=23) (actual time=0.001..0.001 rows=0 loops=1793)
                                 Index Cond: (id = mc.company_id)
                                 Filter: (((country_code)::text <> '[pl]'::text) AND ((name ~~ '%Film%'::text) OR (name ~~ '%Warner%'::text)))
                                 Rows Removed by Filter: 1
                     ->  Index Scan using title_pkey on title t  (cost=0.43..0.59 rows=1 width=21) (actual time=0.001..0.001 rows=0 loops=450)
                           Index Cond: (id = mc.movie_id)
                           Filter: ((title ~~ '%Money%'::text) AND (production_year = 1998))
                           Rows Removed by Filter: 1
               ->  Index Scan using movie_id_movie_keyword on movie_keyword mk  (cost=0.43..1.35 rows=47 width=8) (actual time=0.002..0.002 rows=4 loops=14)
                     Index Cond: (movie_id = mc.movie_id)
         ->  Index Scan using keyword_pkey on keyword k  (cost=0.42..0.44 rows=1 width=4) (actual time=0.001..0.001 rows=0 loops=56)
               Index Cond: (id = mk.keyword_id)
               Filter: (keyword = 'sequel'::text)
               Rows Removed by Filter: 1
 Planning Time: 4.292 ms
 Execution Time: 6.800 ms
(46 rows)


                                                                             QUERY PLAN                                                                             
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=36212.30..36212.31 rows=1 width=32) (actual time=73.312..75.758 rows=1 loops=1)
   ->  Gather  (cost=1019.93..36212.29 rows=2 width=17) (actual time=73.309..75.754 rows=0 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         ->  Nested Loop  (cost=19.93..35212.09 rows=1 width=17) (actual time=70.450..70.453 rows=0 loops=3)
               ->  Nested Loop  (cost=19.79..35211.93 rows=1 width=21) (actual time=70.450..70.452 rows=0 loops=3)
                     ->  Nested Loop  (cost=19.36..35207.36 rows=2 width=25) (actual time=70.450..70.452 rows=0 loops=3)
                           ->  Hash Join  (cost=18.93..35153.19 rows=7 width=4) (actual time=70.449..70.451 rows=0 loops=3)
                                 Hash Cond: (mc.company_type_id = ct.id)
                                 ->  Parallel Seq Scan on movie_companies mc  (cost=0.00..35131.06 rows=1212 width=8) (actual time=2.295..69.977 rows=8008 loops=3)
                                       Filter: ((note ~~ '%(theatrical)%'::text) AND (note ~~ '%(France)%'::text))
                                       Rows Removed by Filter: 861701
                                 ->  Hash  (cost=18.88..18.88 rows=4 width=4) (actual time=0.017..0.018 rows=1 loops=3)
                                       Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                       ->  Seq Scan on company_type ct  (cost=0.00..18.88 rows=4 width=4) (actual time=0.009..0.010 rows=1 loops=3)
                                             Filter: ((kind)::text = 'production companies'::text)
                                             Rows Removed by Filter: 3
                           ->  Index Scan using title_pkey on title t  (cost=0.43..7.74 rows=1 width=21) (never executed)
                                 Index Cond: (id = mc.movie_id)
                                 Filter: (production_year > 2005)
                     ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..2.27 rows=1 width=8) (never executed)
                           Index Cond: (movie_id = t.id)
                           Filter: (info = ANY ('{Sweden,Norway,Germany,Denmark,Swedish,Denish,Norwegian,German}'::text[]))
               ->  Index Only Scan using info_type_pkey on info_type it  (cost=0.14..0.16 rows=1 width=4) (never executed)
                     Index Cond: (id = mi.info_type_id)
                     Heap Fetches: 0
 Planning Time: 1.898 ms
 Execution Time: 75.868 ms
(28 rows)


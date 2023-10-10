                                                                                             QUERY PLAN                                                                                              
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=2474.67..2474.68 rows=1 width=32) (actual time=35613.099..35613.106 rows=1 loops=1)
   ->  Nested Loop  (cost=21.78..2474.67 rows=1 width=17) (actual time=13508.490..35613.071 rows=17 loops=1)
         ->  Nested Loop  (cost=21.35..2474.21 rows=1 width=21) (actual time=7564.018..35612.930 rows=33 loops=1)
               ->  Nested Loop  (cost=20.93..2473.75 rows=1 width=25) (actual time=7558.034..35609.527 rows=1280 loops=1)
                     ->  Nested Loop  (cost=20.50..2473.29 rows=1 width=29) (actual time=0.196..13299.277 rows=41145539 loops=1)
                           Join Filter: (ci.movie_id = t.id)
                           ->  Nested Loop  (cost=20.06..2471.49 rows=1 width=33) (actual time=0.175..493.092 rows=294672 loops=1)
                                 ->  Nested Loop  (cost=19.63..2469.68 rows=1 width=25) (actual time=0.151..390.323 rows=4696 loops=1)
                                       ->  Nested Loop  (cost=19.48..2469.50 rows=1 width=29) (actual time=0.136..370.396 rows=23557 loops=1)
                                             ->  Nested Loop  (cost=19.05..2467.72 rows=1 width=4) (actual time=0.060..64.569 rows=85941 loops=1)
                                                   ->  Hash Join  (cost=18.89..2462.46 rows=190 width=8) (actual time=0.044..32.959 rows=135086 loops=1)
                                                         Hash Cond: (cc.status_id = cct2.id)
                                                         ->  Seq Scan on complete_cast cc  (cost=0.00..2086.86 rows=135086 width=12) (actual time=0.009..9.504 rows=135086 loops=1)
                                                         ->  Hash  (cost=18.88..18.88 rows=1 width=4) (actual time=0.021..0.023 rows=2 loops=1)
                                                               Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                               ->  Seq Scan on comp_cast_type cct2  (cost=0.00..18.88 rows=1 width=4) (actual time=0.015..0.016 rows=2 loops=1)
                                                                     Filter: ((kind)::text ~~ '%complete%'::text)
                                                                     Rows Removed by Filter: 2
                                                   ->  Memoize  (cost=0.16..0.18 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=135086)
                                                         Cache Key: cc.subject_id
                                                         Cache Mode: logical
                                                         Hits: 135084  Misses: 2  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                                         ->  Index Scan using comp_cast_type_pkey on comp_cast_type cct1  (cost=0.15..0.17 rows=1 width=4) (actual time=0.010..0.010 rows=0 loops=2)
                                                               Index Cond: (id = cc.subject_id)
                                                               Filter: ((kind)::text = 'cast'::text)
                                                               Rows Removed by Filter: 0
                                             ->  Index Scan using title_pkey on title t  (cost=0.43..1.78 rows=1 width=25) (actual time=0.003..0.003 rows=0 loops=85941)
                                                   Index Cond: (id = cc.movie_id)
                                                   Filter: (production_year > 2000)
                                                   Rows Removed by Filter: 1
                                       ->  Index Scan using kind_type_pkey on kind_type kt  (cost=0.15..0.17 rows=1 width=4) (actual time=0.001..0.001 rows=0 loops=23557)
                                             Index Cond: (id = t.kind_id)
                                             Filter: ((kind)::text = 'movie'::text)
                                             Rows Removed by Filter: 1
                                 ->  Index Scan using movie_id_movie_keyword on movie_keyword mk  (cost=0.43..1.34 rows=47 width=8) (actual time=0.006..0.015 rows=63 loops=4696)
                                       Index Cond: (movie_id = t.id)
                           ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..1.34 rows=37 width=12) (actual time=0.001..0.031 rows=140 loops=294672)
                                 Index Cond: (movie_id = mk.movie_id)
                     ->  Index Scan using char_name_pkey on char_name chn  (cost=0.43..0.46 rows=1 width=4) (actual time=0.000..0.000 rows=0 loops=41145539)
                           Index Cond: (id = ci.person_role_id)
                           Filter: ((name !~~ '%Sherlock%'::text) AND ((name ~~ '%Tony%Stark%'::text) OR (name ~~ '%Iron%Man%'::text)))
                           Rows Removed by Filter: 0
               ->  Index Scan using keyword_pkey on keyword k  (cost=0.42..0.45 rows=1 width=4) (actual time=0.002..0.002 rows=0 loops=1280)
                     Index Cond: (id = mk.keyword_id)
                     Filter: (keyword = ANY ('{superhero,sequel,second-part,marvel-comics,based-on-comic,tv-special,fight,violence}'::text[]))
                     Rows Removed by Filter: 1
         ->  Index Scan using name_pkey on name n  (cost=0.43..0.46 rows=1 width=4) (actual time=0.004..0.004 rows=1 loops=33)
               Index Cond: (id = ci.person_id)
               Filter: (name ~~ '%Downey%Robert%'::text)
               Rows Removed by Filter: 0
 Planning Time: 10.332 ms
 Execution Time: 35613.267 ms
(52 rows)


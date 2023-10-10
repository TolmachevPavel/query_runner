                                                                                             QUERY PLAN                                                                                              
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=2474.63..2474.64 rows=1 width=32) (actual time=86159.550..86159.557 rows=1 loops=1)
   ->  Nested Loop  (cost=21.78..2474.62 rows=1 width=17) (actual time=18629.316..86159.520 rows=33 loops=1)
         ->  Nested Loop  (cost=21.35..2474.17 rows=1 width=21) (actual time=18629.292..86159.376 rows=33 loops=1)
               ->  Nested Loop  (cost=20.93..2473.72 rows=1 width=25) (actual time=18623.508..86155.690 rows=1314 loops=1)
                     ->  Nested Loop  (cost=20.50..2473.26 rows=1 width=29) (actual time=0.172..30091.947 rows=87986607 loops=1)
                           Join Filter: (ci.movie_id = t.id)
                           ->  Nested Loop  (cost=20.06..2471.45 rows=1 width=33) (actual time=0.149..856.978 rows=978322 loops=1)
                                 ->  Nested Loop  (cost=19.63..2469.68 rows=1 width=25) (actual time=0.123..534.144 rows=28583 loops=1)
                                       ->  Nested Loop  (cost=19.48..2469.50 rows=1 width=29) (actual time=0.102..468.149 rows=73560 loops=1)
                                             ->  Nested Loop  (cost=19.05..2467.72 rows=1 width=4) (actual time=0.070..84.151 rows=85941 loops=1)
                                                   ->  Hash Join  (cost=18.89..2462.46 rows=190 width=8) (actual time=0.054..44.935 rows=135086 loops=1)
                                                         Hash Cond: (cc.status_id = cct2.id)
                                                         ->  Seq Scan on complete_cast cc  (cost=0.00..2086.86 rows=135086 width=12) (actual time=0.017..12.381 rows=135086 loops=1)
                                                         ->  Hash  (cost=18.88..18.88 rows=1 width=4) (actual time=0.028..0.029 rows=2 loops=1)
                                                               Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                               ->  Seq Scan on comp_cast_type cct2  (cost=0.00..18.88 rows=1 width=4) (actual time=0.020..0.021 rows=2 loops=1)
                                                                     Filter: ((kind)::text ~~ '%complete%'::text)
                                                                     Rows Removed by Filter: 2
                                                   ->  Memoize  (cost=0.16..0.18 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=135086)
                                                         Cache Key: cc.subject_id
                                                         Cache Mode: logical
                                                         Hits: 135084  Misses: 2  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                                         ->  Index Scan using comp_cast_type_pkey on comp_cast_type cct1  (cost=0.15..0.17 rows=1 width=4) (actual time=0.010..0.011 rows=0 loops=2)
                                                               Index Cond: (id = cc.subject_id)
                                                               Filter: ((kind)::text = 'cast'::text)
                                                               Rows Removed by Filter: 0
                                             ->  Index Scan using title_pkey on title t  (cost=0.43..1.78 rows=1 width=25) (actual time=0.004..0.004 rows=1 loops=85941)
                                                   Index Cond: (id = cc.movie_id)
                                                   Filter: (production_year > 1950)
                                                   Rows Removed by Filter: 0
                                       ->  Index Scan using kind_type_pkey on kind_type kt  (cost=0.15..0.17 rows=1 width=4) (actual time=0.001..0.001 rows=0 loops=73560)
                                             Index Cond: (id = t.kind_id)
                                             Filter: ((kind)::text = 'movie'::text)
                                             Rows Removed by Filter: 1
                                 ->  Index Scan using movie_id_movie_keyword on movie_keyword mk  (cost=0.43..1.31 rows=47 width=8) (actual time=0.003..0.008 rows=34 loops=28583)
                                       Index Cond: (movie_id = t.id)
                           ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..1.34 rows=37 width=12) (actual time=0.001..0.022 rows=90 loops=978322)
                                 Index Cond: (movie_id = mk.movie_id)
                     ->  Index Scan using char_name_pkey on char_name chn  (cost=0.43..0.46 rows=1 width=4) (actual time=0.001..0.001 rows=0 loops=87986607)
                           Index Cond: (id = ci.person_role_id)
                           Filter: ((name !~~ '%Sherlock%'::text) AND ((name ~~ '%Tony%Stark%'::text) OR (name ~~ '%Iron%Man%'::text)))
                           Rows Removed by Filter: 0
               ->  Index Scan using keyword_pkey on keyword k  (cost=0.42..0.45 rows=1 width=4) (actual time=0.003..0.003 rows=0 loops=1314)
                     Index Cond: (id = mk.keyword_id)
                     Filter: (keyword = ANY ('{superhero,sequel,second-part,marvel-comics,based-on-comic,tv-special,fight,violence}'::text[]))
                     Rows Removed by Filter: 1
         ->  Index Only Scan using name_pkey on name n  (cost=0.43..0.45 rows=1 width=4) (actual time=0.004..0.004 rows=1 loops=33)
               Index Cond: (id = ci.person_id)
               Heap Fetches: 0
 Planning Time: 10.749 ms
 Execution Time: 86159.726 ms
(51 rows)


                                                                                             QUERY PLAN                                                                                              
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=2474.68..2474.69 rows=1 width=64) (actual time=36941.326..36941.332 rows=1 loops=1)
   ->  Nested Loop  (cost=21.80..2474.68 rows=1 width=32) (actual time=54.488..36938.002 rows=5406 loops=1)
         ->  Nested Loop  (cost=21.38..2474.22 rows=1 width=21) (actual time=54.454..36902.425 rows=5406 loops=1)
               ->  Nested Loop  (cost=20.93..2473.75 rows=1 width=25) (actual time=44.124..35476.370 rows=1146265 loops=1)
                     ->  Nested Loop  (cost=20.50..2473.29 rows=1 width=29) (actual time=0.203..13481.845 rows=41145539 loops=1)
                           Join Filter: (ci.movie_id = t.id)
                           ->  Nested Loop  (cost=20.06..2471.49 rows=1 width=33) (actual time=0.180..477.402 rows=294672 loops=1)
                                 ->  Nested Loop  (cost=19.63..2469.68 rows=1 width=25) (actual time=0.158..381.657 rows=4696 loops=1)
                                       ->  Nested Loop  (cost=19.48..2469.50 rows=1 width=29) (actual time=0.141..361.999 rows=23557 loops=1)
                                             ->  Nested Loop  (cost=19.05..2467.72 rows=1 width=4) (actual time=0.060..62.095 rows=85941 loops=1)
                                                   ->  Hash Join  (cost=18.89..2462.46 rows=190 width=8) (actual time=0.039..31.991 rows=135086 loops=1)
                                                         Hash Cond: (cc.status_id = cct2.id)
                                                         ->  Seq Scan on complete_cast cc  (cost=0.00..2086.86 rows=135086 width=12) (actual time=0.011..9.339 rows=135086 loops=1)
                                                         ->  Hash  (cost=18.88..18.88 rows=1 width=4) (actual time=0.019..0.020 rows=2 loops=1)
                                                               Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                               ->  Seq Scan on comp_cast_type cct2  (cost=0.00..18.88 rows=1 width=4) (actual time=0.012..0.012 rows=2 loops=1)
                                                                     Filter: ((kind)::text ~~ '%complete%'::text)
                                                                     Rows Removed by Filter: 2
                                                   ->  Memoize  (cost=0.16..0.18 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=135086)
                                                         Cache Key: cc.subject_id
                                                         Cache Mode: logical
                                                         Hits: 135084  Misses: 2  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                                         ->  Index Scan using comp_cast_type_pkey on comp_cast_type cct1  (cost=0.15..0.17 rows=1 width=4) (actual time=0.012..0.012 rows=0 loops=2)
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
                                 ->  Index Scan using movie_id_movie_keyword on movie_keyword mk  (cost=0.43..1.34 rows=47 width=8) (actual time=0.005..0.014 rows=63 loops=4696)
                                       Index Cond: (movie_id = t.id)
                           ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..1.34 rows=37 width=12) (actual time=0.001..0.032 rows=140 loops=294672)
                                 Index Cond: (movie_id = mk.movie_id)
                     ->  Index Scan using char_name_pkey on char_name chn  (cost=0.43..0.46 rows=1 width=4) (actual time=0.000..0.000 rows=0 loops=41145539)
                           Index Cond: (id = ci.person_role_id)
                           Filter: ((name IS NOT NULL) AND ((name ~~ '%man%'::text) OR (name ~~ '%Man%'::text)))
                           Rows Removed by Filter: 0
               ->  Index Scan using keyword_pkey on keyword k  (cost=0.45..0.47 rows=1 width=4) (actual time=0.001..0.001 rows=0 loops=1146265)
                     Index Cond: (id = mk.keyword_id)
                     Filter: (keyword = ANY ('{superhero,marvel-comics,based-on-comic,tv-special,fight,violence,magnet,web,claw,laser}'::text[]))
                     Rows Removed by Filter: 1
         ->  Index Scan using name_pkey on name n  (cost=0.43..0.46 rows=1 width=19) (actual time=0.006..0.006 rows=1 loops=5406)
               Index Cond: (id = ci.person_id)
 Planning Time: 11.415 ms
 Execution Time: 36941.501 ms
(50 rows)


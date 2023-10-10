                                                                                                   QUERY PLAN                                                                                                    
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=2487.34..2487.35 rows=1 width=96) (actual time=2199.605..2199.610 rows=1 loops=1)
   ->  Nested Loop  (cost=22.37..2487.33 rows=1 width=38) (actual time=7.838..2197.818 rows=5400 loops=1)
         ->  Nested Loop  (cost=22.23..2487.15 rows=1 width=42) (actual time=7.828..2186.513 rows=16596 loops=1)
               Join Filter: (mi_idx.movie_id = t.id)
               ->  Nested Loop  (cost=21.80..2486.63 rows=1 width=49) (actual time=7.804..2173.427 rows=5406 loops=1)
                     ->  Nested Loop  (cost=21.38..2480.22 rows=14 width=37) (actual time=0.983..1867.417 rows=189844 loops=1)
                           ->  Nested Loop  (cost=20.95..2473.94 rows=14 width=41) (actual time=0.965..1397.557 rows=189844 loops=1)
                                 Join Filter: (ci.movie_id = t.id)
                                 ->  Nested Loop  (cost=20.50..2472.13 rows=1 width=29) (actual time=0.941..1017.497 rows=1267 loops=1)
                                       ->  Nested Loop  (cost=20.06..2471.66 rows=1 width=33) (actual time=0.187..585.012 rows=294672 loops=1)
                                             ->  Nested Loop  (cost=19.91..2471.31 rows=2 width=37) (actual time=0.167..385.281 rows=365390 loops=1)
                                                   ->  Nested Loop  (cost=19.48..2469.50 rows=1 width=29) (actual time=0.138..283.362 rows=23557 loops=1)
                                                         ->  Nested Loop  (cost=19.05..2467.72 rows=1 width=4) (actual time=0.059..53.369 rows=85941 loops=1)
                                                               ->  Hash Join  (cost=18.89..2462.46 rows=190 width=8) (actual time=0.044..26.601 rows=135086 loops=1)
                                                                     Hash Cond: (cc.status_id = cct2.id)
                                                                     ->  Seq Scan on complete_cast cc  (cost=0.00..2086.86 rows=135086 width=12) (actual time=0.009..7.901 rows=135086 loops=1)
                                                                     ->  Hash  (cost=18.88..18.88 rows=1 width=4) (actual time=0.024..0.025 rows=2 loops=1)
                                                                           Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                                           ->  Seq Scan on comp_cast_type cct2  (cost=0.00..18.88 rows=1 width=4) (actual time=0.011..0.011 rows=2 loops=1)
                                                                                 Filter: ((kind)::text ~~ '%complete%'::text)
                                                                                 Rows Removed by Filter: 2
                                                               ->  Memoize  (cost=0.16..0.18 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=135086)
                                                                     Cache Key: cc.subject_id
                                                                     Cache Mode: logical
                                                                     Hits: 135084  Misses: 2  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                                                     ->  Index Scan using comp_cast_type_pkey on comp_cast_type cct1  (cost=0.15..0.17 rows=1 width=4) (actual time=0.009..0.009 rows=0 loops=2)
                                                                           Index Cond: (id = cc.subject_id)
                                                                           Filter: ((kind)::text = 'cast'::text)
                                                                           Rows Removed by Filter: 0
                                                         ->  Index Scan using title_pkey on title t  (cost=0.43..1.78 rows=1 width=25) (actual time=0.003..0.003 rows=0 loops=85941)
                                                               Index Cond: (id = cc.movie_id)
                                                               Filter: (production_year > 2000)
                                                               Rows Removed by Filter: 1
                                                   ->  Index Scan using movie_id_movie_keyword on movie_keyword mk  (cost=0.43..1.34 rows=47 width=8) (actual time=0.002..0.003 rows=16 loops=23557)
                                                         Index Cond: (movie_id = t.id)
                                             ->  Index Scan using kind_type_pkey on kind_type kt  (cost=0.15..0.17 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=365390)
                                                   Index Cond: (id = t.kind_id)
                                                   Filter: ((kind)::text = 'movie'::text)
                                                   Rows Removed by Filter: 0
                                       ->  Index Scan using keyword_pkey on keyword k  (cost=0.45..0.47 rows=1 width=4) (actual time=0.001..0.001 rows=0 loops=294672)
                                             Index Cond: (id = mk.keyword_id)
                                             Filter: (keyword = ANY ('{superhero,marvel-comics,based-on-comic,tv-special,fight,violence,magnet,web,claw,laser}'::text[]))
                                             Rows Removed by Filter: 1
                                 ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..1.34 rows=37 width=12) (actual time=0.006..0.281 rows=150 loops=1267)
                                       Index Cond: (movie_id = mk.movie_id)
                           ->  Index Only Scan using name_pkey on name n  (cost=0.43..0.45 rows=1 width=4) (actual time=0.002..0.002 rows=1 loops=189844)
                                 Index Cond: (id = ci.person_id)
                                 Heap Fetches: 0
                     ->  Index Scan using char_name_pkey on char_name chn  (cost=0.43..0.46 rows=1 width=20) (actual time=0.001..0.001 rows=0 loops=189844)
                           Index Cond: (id = ci.person_role_id)
                           Filter: ((name IS NOT NULL) AND ((name ~~ '%man%'::text) OR (name ~~ '%Man%'::text)))
                           Rows Removed by Filter: 0
               ->  Index Scan using movie_id_movie_info_idx on movie_info_idx mi_idx  (cost=0.43..0.48 rows=3 width=13) (actual time=0.002..0.002 rows=3 loops=5406)
                     Index Cond: (movie_id = ci.movie_id)
         ->  Index Scan using info_type_pkey on info_type it2  (cost=0.14..0.16 rows=1 width=4) (actual time=0.001..0.001 rows=0 loops=16596)
               Index Cond: (id = mi_idx.info_type_id)
               Filter: ((info)::text = 'rating'::text)
               Rows Removed by Filter: 1
 Planning Time: 39.855 ms
 Execution Time: 2199.783 ms
(60 rows)


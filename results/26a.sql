                                                                                                   QUERY PLAN                                                                                                    
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=2488.76..2488.77 rows=1 width=128) (actual time=9012.978..9012.983 rows=1 loops=1)
   ->  Nested Loop  (cost=22.37..2488.75 rows=1 width=53) (actual time=142.335..9011.892 rows=1728 loops=1)
         ->  Nested Loop  (cost=22.22..2488.57 rows=1 width=57) (actual time=142.314..9009.760 rows=1844 loops=1)
               ->  Nested Loop  (cost=21.78..2487.63 rows=2 width=61) (actual time=59.482..8482.112 rows=398523 loops=1)
                     ->  Nested Loop  (cost=21.35..2485.82 rows=1 width=73) (actual time=19.154..8406.805 rows=6694 loops=1)
                           ->  Nested Loop  (cost=20.92..2485.36 rows=1 width=61) (actual time=19.128..7823.978 rows=356241 loops=1)
                                 ->  Nested Loop  (cost=20.77..2485.18 rows=1 width=65) (actual time=0.223..7513.345 rows=481079 loops=1)
                                       Join Filter: (mi_idx.movie_id = t.id)
                                       ->  Nested Loop  (cost=20.35..2478.17 rows=14 width=52) (actual time=0.197..6190.936 rows=1113925 loops=1)
                                             ->  Nested Loop  (cost=19.92..2471.79 rows=14 width=41) (actual time=0.178..2325.080 rows=1113925 loops=1)
                                                   ->  Nested Loop  (cost=19.48..2469.50 rows=1 width=29) (actual time=0.141..369.536 rows=23557 loops=1)
                                                         ->  Nested Loop  (cost=19.05..2467.72 rows=1 width=4) (actual time=0.066..64.057 rows=85941 loops=1)
                                                               ->  Hash Join  (cost=18.89..2462.46 rows=190 width=8) (actual time=0.045..33.915 rows=135086 loops=1)
                                                                     Hash Cond: (cc.status_id = cct2.id)
                                                                     ->  Seq Scan on complete_cast cc  (cost=0.00..2086.86 rows=135086 width=12) (actual time=0.013..9.419 rows=135086 loops=1)
                                                                     ->  Hash  (cost=18.88..18.88 rows=1 width=4) (actual time=0.018..0.019 rows=2 loops=1)
                                                                           Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                                           ->  Seq Scan on comp_cast_type cct2  (cost=0.00..18.88 rows=1 width=4) (actual time=0.011..0.011 rows=2 loops=1)
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
                                                   ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..1.92 rows=37 width=12) (actual time=0.004..0.078 rows=47 loops=23557)
                                                         Index Cond: (movie_id = t.id)
                                             ->  Index Scan using name_pkey on name n  (cost=0.43..0.46 rows=1 width=19) (actual time=0.003..0.003 rows=1 loops=1113925)
                                                   Index Cond: (id = ci.person_id)
                                       ->  Index Scan using movie_id_movie_info_idx on movie_info_idx mi_idx  (cost=0.43..0.49 rows=1 width=13) (actual time=0.001..0.001 rows=0 loops=1113925)
                                             Index Cond: (movie_id = ci.movie_id)
                                             Filter: (info > '7.0'::text)
                                             Rows Removed by Filter: 2
                                 ->  Index Scan using info_type_pkey on info_type it2  (cost=0.14..0.16 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=481079)
                                       Index Cond: (id = mi_idx.info_type_id)
                                       Filter: ((info)::text = 'rating'::text)
                                       Rows Removed by Filter: 0
                           ->  Index Scan using char_name_pkey on char_name chn  (cost=0.43..0.46 rows=1 width=20) (actual time=0.001..0.001 rows=0 loops=356241)
                                 Index Cond: (id = ci.person_role_id)
                                 Filter: ((name IS NOT NULL) AND ((name ~~ '%man%'::text) OR (name ~~ '%Man%'::text)))
                                 Rows Removed by Filter: 0
                     ->  Index Scan using movie_id_movie_keyword on movie_keyword mk  (cost=0.43..1.34 rows=47 width=8) (actual time=0.002..0.007 rows=60 loops=6694)
                           Index Cond: (movie_id = t.id)
               ->  Index Scan using keyword_pkey on keyword k  (cost=0.45..0.47 rows=1 width=4) (actual time=0.001..0.001 rows=0 loops=398523)
                     Index Cond: (id = mk.keyword_id)
                     Filter: (keyword = ANY ('{superhero,marvel-comics,based-on-comic,tv-special,fight,violence,magnet,web,claw,laser}'::text[]))
                     Rows Removed by Filter: 1
         ->  Index Scan using kind_type_pkey on kind_type kt  (cost=0.15..0.17 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=1844)
               Index Cond: (id = t.kind_id)
               Filter: ((kind)::text = 'movie'::text)
               Rows Removed by Filter: 0
 Planning Time: 39.697 ms
 Execution Time: 9013.179 ms
(60 rows)


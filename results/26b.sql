                                                                                                   QUERY PLAN                                                                                                    
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=2488.97..2488.98 rows=1 width=96) (actual time=3759.725..3759.731 rows=1 loops=1)
   ->  Nested Loop  (cost=22.35..2488.96 rows=1 width=38) (actual time=1589.077..3759.676 rows=93 loops=1)
         ->  Nested Loop  (cost=22.20..2488.78 rows=1 width=42) (actual time=471.548..3759.472 rows=111 loops=1)
               ->  Nested Loop  (cost=21.78..2487.89 rows=2 width=46) (actual time=40.058..3699.165 rows=42176 loops=1)
                     ->  Nested Loop  (cost=21.35..2486.04 rows=1 width=58) (actual time=40.036..3689.934 rows=978 loops=1)
                           ->  Nested Loop  (cost=20.92..2485.59 rows=1 width=46) (actual time=39.721..3591.732 rows=59778 loops=1)
                                 ->  Nested Loop  (cost=20.77..2485.40 rows=1 width=50) (actual time=18.012..3526.753 rows=103209 loops=1)
                                       Join Filter: (mi_idx.movie_id = t.id)
                                       ->  Nested Loop  (cost=20.35..2478.39 rows=14 width=37) (actual time=0.194..2753.054 rows=695928 loops=1)
                                             ->  Nested Loop  (cost=19.92..2472.10 rows=14 width=41) (actual time=0.178..1409.109 rows=695928 loops=1)
                                                   ->  Nested Loop  (cost=19.48..2469.50 rows=1 width=29) (actual time=0.139..317.263 rows=15465 loops=1)
                                                         ->  Nested Loop  (cost=19.05..2467.72 rows=1 width=4) (actual time=0.065..58.698 rows=85941 loops=1)
                                                               ->  Hash Join  (cost=18.89..2462.46 rows=190 width=8) (actual time=0.043..30.562 rows=135086 loops=1)
                                                                     Hash Cond: (cc.status_id = cct2.id)
                                                                     ->  Seq Scan on complete_cast cc  (cost=0.00..2086.86 rows=135086 width=12) (actual time=0.010..8.480 rows=135086 loops=1)
                                                                     ->  Hash  (cost=18.88..18.88 rows=1 width=4) (actual time=0.021..0.022 rows=2 loops=1)
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
                                                               Filter: (production_year > 2005)
                                                               Rows Removed by Filter: 1
                                                   ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..2.23 rows=37 width=12) (actual time=0.003..0.066 rows=45 loops=15465)
                                                         Index Cond: (movie_id = t.id)
                                             ->  Index Only Scan using name_pkey on name n  (cost=0.43..0.45 rows=1 width=4) (actual time=0.002..0.002 rows=1 loops=695928)
                                                   Index Cond: (id = ci.person_id)
                                                   Heap Fetches: 0
                                       ->  Index Scan using movie_id_movie_info_idx on movie_info_idx mi_idx  (cost=0.43..0.49 rows=1 width=13) (actual time=0.001..0.001 rows=0 loops=695928)
                                             Index Cond: (movie_id = ci.movie_id)
                                             Filter: (info > '8.0'::text)
                                             Rows Removed by Filter: 2
                                 ->  Index Scan using info_type_pkey on info_type it2  (cost=0.14..0.16 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=103209)
                                       Index Cond: (id = mi_idx.info_type_id)
                                       Filter: ((info)::text = 'rating'::text)
                                       Rows Removed by Filter: 0
                           ->  Index Scan using char_name_pkey on char_name chn  (cost=0.43..0.46 rows=1 width=20) (actual time=0.002..0.002 rows=0 loops=59778)
                                 Index Cond: (id = ci.person_role_id)
                                 Filter: ((name IS NOT NULL) AND ((name ~~ '%man%'::text) OR (name ~~ '%Man%'::text)))
                                 Rows Removed by Filter: 0
                     ->  Index Scan using movie_id_movie_keyword on movie_keyword mk  (cost=0.43..1.37 rows=47 width=8) (actual time=0.003..0.006 rows=43 loops=978)
                           Index Cond: (movie_id = t.id)
               ->  Index Scan using keyword_pkey on keyword k  (cost=0.42..0.44 rows=1 width=4) (actual time=0.001..0.001 rows=0 loops=42176)
                     Index Cond: (id = mk.keyword_id)
                     Filter: (keyword = ANY ('{superhero,marvel-comics,based-on-comic,fight}'::text[]))
                     Rows Removed by Filter: 1
         ->  Index Scan using kind_type_pkey on kind_type kt  (cost=0.15..0.17 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=111)
               Index Cond: (id = t.kind_id)
               Filter: ((kind)::text = 'movie'::text)
               Rows Removed by Filter: 0
 Planning Time: 40.139 ms
 Execution Time: 3759.943 ms
(61 rows)


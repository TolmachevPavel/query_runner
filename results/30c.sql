                                                                                                   QUERY PLAN                                                                                                    
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=2525.50..2525.51 rows=1 width=128) (actual time=2237.108..2237.113 rows=1 loops=1)
   ->  Nested Loop  (cost=22.39..2525.49 rows=1 width=80) (actual time=1.079..2234.239 rows=8024 loops=1)
         ->  Nested Loop  (cost=21.96..2524.39 rows=1 width=69) (actual time=1.050..2202.144 rows=11863 loops=1)
               Join Filter: (ci.movie_id = t.id)
               ->  Nested Loop  (cost=21.52..2509.03 rows=1 width=85) (actual time=0.722..1262.961 rows=14655 loops=1)
                     ->  Nested Loop  (cost=21.38..2508.85 rows=1 width=89) (actual time=0.714..1248.669 rows=18333 loops=1)
                           Join Filter: (mi.movie_id = t.id)
                           ->  Nested Loop  (cost=20.95..2496.96 rows=1 width=38) (actual time=0.553..794.464 rows=12476 loops=1)
                                 ->  Nested Loop  (cost=20.52..2495.54 rows=2 width=42) (actual time=0.143..367.168 rows=739378 loops=1)
                                       ->  Nested Loop  (cost=20.08..2493.46 rows=1 width=34) (actual time=0.119..195.989 rows=17018 loops=1)
                                             ->  Nested Loop  (cost=19.94..2493.11 rows=2 width=38) (actual time=0.111..163.173 rows=51249 loops=1)
                                                   ->  Nested Loop  (cost=19.52..2489.91 rows=4 width=25) (actual time=0.084..112.375 rows=17879 loops=1)
                                                         ->  Nested Loop  (cost=19.09..2482.02 rows=4 width=4) (actual time=0.060..38.452 rows=17879 loops=1)
                                                               ->  Hash Join  (cost=18.93..2462.50 rows=761 width=8) (actual time=0.041..22.531 rows=85941 loops=1)
                                                                     Hash Cond: (cc.subject_id = cct1.id)
                                                                     ->  Seq Scan on complete_cast cc  (cost=0.00..2086.86 rows=135086 width=12) (actual time=0.010..7.586 rows=135086 loops=1)
                                                                     ->  Hash  (cost=18.88..18.88 rows=4 width=4) (actual time=0.018..0.018 rows=1 loops=1)
                                                                           Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                                           ->  Seq Scan on comp_cast_type cct1  (cost=0.00..18.88 rows=4 width=4) (actual time=0.011..0.011 rows=1 loops=1)
                                                                                 Filter: ((kind)::text = 'cast'::text)
                                                                                 Rows Removed by Filter: 3
                                                               ->  Memoize  (cost=0.16..0.18 rows=1 width=4) (actual time=0.000..0.000 rows=0 loops=85941)
                                                                     Cache Key: cc.status_id
                                                                     Cache Mode: logical
                                                                     Hits: 85939  Misses: 2  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                                                     ->  Index Scan using comp_cast_type_pkey on comp_cast_type cct2  (cost=0.15..0.17 rows=1 width=4) (actual time=0.009..0.009 rows=0 loops=2)
                                                                           Index Cond: (id = cc.status_id)
                                                                           Filter: ((kind)::text = 'complete+verified'::text)
                                                                           Rows Removed by Filter: 0
                                                         ->  Index Scan using title_pkey on title t  (cost=0.43..1.97 rows=1 width=21) (actual time=0.004..0.004 rows=1 loops=17879)
                                                               Index Cond: (id = cc.movie_id)
                                                   ->  Index Scan using movie_id_movie_info_idx on movie_info_idx mi_idx  (cost=0.43..0.77 rows=3 width=13) (actual time=0.002..0.002 rows=3 loops=17879)
                                                         Index Cond: (movie_id = t.id)
                                             ->  Index Scan using info_type_pkey on info_type it2  (cost=0.14..0.16 rows=1 width=4) (actual time=0.000..0.000 rows=0 loops=51249)
                                                   Index Cond: (id = mi_idx.info_type_id)
                                                   Filter: ((info)::text = 'votes'::text)
                                                   Rows Removed by Filter: 1
                                       ->  Index Scan using movie_id_movie_keyword on movie_keyword mk  (cost=0.43..1.61 rows=47 width=8) (actual time=0.003..0.007 rows=43 loops=17018)
                                             Index Cond: (movie_id = t.id)
                                 ->  Memoize  (cost=0.43..0.70 rows=1 width=4) (actual time=0.000..0.000 rows=0 loops=739378)
                                       Cache Key: mk.keyword_id
                                       Cache Mode: logical
                                       Hits: 678807  Misses: 60571  Evictions: 0  Overflows: 0  Memory Usage: 4023kB
                                       ->  Index Scan using keyword_pkey on keyword k  (cost=0.42..0.69 rows=1 width=4) (actual time=0.002..0.002 rows=0 loops=60571)
                                             Index Cond: (id = mk.keyword_id)
                                             Filter: (keyword = ANY ('{murder,violence,blood,gore,death,female-nudity,hospital}'::text[]))
                                             Rows Removed by Filter: 1
                           ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..11.88 rows=1 width=51) (actual time=0.034..0.036 rows=1 loops=12476)
                                 Index Cond: (movie_id = mk.movie_id)
                                 Filter: (info = ANY ('{Horror,Action,Sci-Fi,Thriller,Crime,War}'::text[]))
                                 Rows Removed by Filter: 130
                     ->  Index Scan using info_type_pkey on info_type it1  (cost=0.14..0.16 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=18333)
                           Index Cond: (id = mi.info_type_id)
                           Filter: ((info)::text = 'genres'::text)
                           Rows Removed by Filter: 0
               ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..15.35 rows=1 width=8) (actual time=0.049..0.064 rows=1 loops=14655)
                     Index Cond: (movie_id = mk.movie_id)
                     Filter: (note = ANY ('{(writer),"(head writer)","(written by)",(story),"(story editor)"}'::text[]))
                     Rows Removed by Filter: 83
         ->  Index Scan using name_pkey on name n  (cost=0.43..1.09 rows=1 width=19) (actual time=0.002..0.002 rows=1 loops=11863)
               Index Cond: (id = ci.person_id)
               Filter: ((gender)::text = 'm'::text)
               Rows Removed by Filter: 0
 Planning Time: 42.486 ms
 Execution Time: 2238.013 ms
(65 rows)


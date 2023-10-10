                                                                                                   QUERY PLAN                                                                                                    
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=2531.57..2531.58 rows=1 width=128) (actual time=118.356..118.364 rows=1 loops=1)
   ->  Nested Loop  (cost=22.39..2531.56 rows=1 width=80) (actual time=30.855..118.340 rows=28 loops=1)
         ->  Nested Loop  (cost=22.25..2531.38 rows=1 width=84) (actual time=30.848..118.312 rows=28 loops=1)
               Join Filter: (mi.movie_id = t.id)
               ->  Nested Loop  (cost=21.82..2519.70 rows=1 width=57) (actual time=30.675..117.223 rows=20 loops=1)
                     ->  Nested Loop  (cost=21.39..2518.28 rows=2 width=61) (actual time=30.624..115.694 rows=686 loops=1)
                           Join Filter: (mk.movie_id = t.id)
                           ->  Nested Loop  (cost=20.95..2516.05 rows=1 width=53) (actual time=30.598..115.536 rows=5 loops=1)
                                 ->  Nested Loop  (cost=20.52..2514.95 rows=1 width=42) (actual time=30.569..115.473 rows=5 loops=1)
                                       Join Filter: (ci.movie_id = t.id)
                                       ->  Nested Loop  (cost=20.08..2499.15 rows=1 width=34) (actual time=30.339..114.626 rows=2 loops=1)
                                             ->  Nested Loop  (cost=19.94..2498.97 rows=1 width=38) (actual time=30.330..114.607 rows=6 loops=1)
                                                   Join Filter: (mi_idx.movie_id = t.id)
                                                   ->  Nested Loop  (cost=19.52..2497.89 rows=1 width=25) (actual time=30.291..114.545 rows=2 loops=1)
                                                         ->  Nested Loop  (cost=19.09..2482.02 rows=8 width=4) (actual time=0.053..22.499 rows=24592 loops=1)
                                                               ->  Hash Join  (cost=18.93..2462.50 rows=761 width=8) (actual time=0.039..17.089 rows=24592 loops=1)
                                                                     Hash Cond: (cc.status_id = cct2.id)
                                                                     ->  Seq Scan on complete_cast cc  (cost=0.00..2086.86 rows=135086 width=12) (actual time=0.009..7.575 rows=135086 loops=1)
                                                                     ->  Hash  (cost=18.88..18.88 rows=4 width=4) (actual time=0.018..0.019 rows=1 loops=1)
                                                                           Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                                           ->  Seq Scan on comp_cast_type cct2  (cost=0.00..18.88 rows=4 width=4) (actual time=0.010..0.011 rows=1 loops=1)
                                                                                 Filter: ((kind)::text = 'complete+verified'::text)
                                                                                 Rows Removed by Filter: 3
                                                               ->  Memoize  (cost=0.16..0.18 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=24592)
                                                                     Cache Key: cc.subject_id
                                                                     Cache Mode: logical
                                                                     Hits: 24590  Misses: 2  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                                                     ->  Index Scan using comp_cast_type_pkey on comp_cast_type cct1  (cost=0.15..0.17 rows=1 width=4) (actual time=0.009..0.009 rows=1 loops=2)
                                                                           Index Cond: (id = cc.subject_id)
                                                                           Filter: ((kind)::text = ANY ('{cast,crew}'::text[]))
                                                         ->  Index Scan using title_pkey on title t  (cost=0.43..1.98 rows=1 width=21) (actual time=0.004..0.004 rows=0 loops=24592)
                                                               Index Cond: (id = cc.movie_id)
                                                               Filter: ((production_year > 2000) AND ((title ~~ '%Freddy%'::text) OR (title ~~ '%Jason%'::text) OR (title ~~ 'Saw%'::text)))
                                                               Rows Removed by Filter: 1
                                                   ->  Index Scan using movie_id_movie_info_idx on movie_info_idx mi_idx  (cost=0.43..1.04 rows=3 width=13) (actual time=0.027..0.027 rows=3 loops=2)
                                                         Index Cond: (movie_id = cc.movie_id)
                                             ->  Index Scan using info_type_pkey on info_type it2  (cost=0.14..0.16 rows=1 width=4) (actual time=0.002..0.002 rows=0 loops=6)
                                                   Index Cond: (id = mi_idx.info_type_id)
                                                   Filter: ((info)::text = 'votes'::text)
                                                   Rows Removed by Filter: 1
                                       ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..15.79 rows=1 width=8) (actual time=0.187..0.421 rows=2 loops=2)
                                             Index Cond: (movie_id = mi_idx.movie_id)
                                             Filter: (note = ANY ('{(writer),"(head writer)","(written by)",(story),"(story editor)"}'::text[]))
                                             Rows Removed by Filter: 95
                                 ->  Index Scan using name_pkey on name n  (cost=0.43..1.09 rows=1 width=19) (actual time=0.012..0.012 rows=1 loops=5)
                                       Index Cond: (id = ci.person_id)
                                       Filter: ((gender)::text = 'm'::text)
                           ->  Index Scan using movie_id_movie_keyword on movie_keyword mk  (cost=0.43..1.65 rows=47 width=8) (actual time=0.008..0.018 rows=137 loops=5)
                                 Index Cond: (movie_id = mi_idx.movie_id)
                     ->  Memoize  (cost=0.43..0.70 rows=1 width=4) (actual time=0.002..0.002 rows=0 loops=686)
                           Cache Key: mk.keyword_id
                           Cache Mode: logical
                           Hits: 411  Misses: 275  Evictions: 0  Overflows: 0  Memory Usage: 19kB
                           ->  Index Scan using keyword_pkey on keyword k  (cost=0.42..0.69 rows=1 width=4) (actual time=0.005..0.005 rows=0 loops=275)
                                 Index Cond: (id = mk.keyword_id)
                                 Filter: (keyword = ANY ('{murder,violence,blood,gore,death,female-nudity,hospital}'::text[]))
                                 Rows Removed by Filter: 1
               ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..11.67 rows=1 width=51) (actual time=0.054..0.054 rows=1 loops=20)
                     Index Cond: (movie_id = mk.movie_id)
                     Filter: (info = ANY ('{Horror,Thriller}'::text[]))
                     Rows Removed by Filter: 451
         ->  Index Scan using info_type_pkey on info_type it1  (cost=0.14..0.16 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=28)
               Index Cond: (id = mi.info_type_id)
               Filter: ((info)::text = 'genres'::text)
 Planning Time: 40.494 ms
 Execution Time: 118.548 ms
(66 rows)


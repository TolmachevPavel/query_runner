                                                                                                   QUERY PLAN                                                                                                    
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=2533.72..2533.73 rows=1 width=128) (actual time=683.068..683.073 rows=1 loops=1)
   ->  Nested Loop  (cost=22.39..2533.71 rows=1 width=80) (actual time=5.216..682.694 rows=757 loops=1)
         ->  Nested Loop  (cost=22.25..2533.53 rows=1 width=84) (actual time=5.209..682.043 rows=757 loops=1)
               Join Filter: (mi.movie_id = t.id)
               ->  Nested Loop  (cost=21.82..2521.84 rows=1 width=57) (actual time=0.813..627.809 rows=1235 loops=1)
                     ->  Nested Loop  (cost=21.39..2520.42 rows=2 width=61) (actual time=0.547..553.381 rows=85244 loops=1)
                           ->  Nested Loop  (cost=20.95..2518.31 rows=1 width=53) (actual time=0.520..535.011 rows=1256 loops=1)
                                 ->  Nested Loop  (cost=20.52..2517.22 rows=1 width=42) (actual time=0.496..523.599 rows=1839 loops=1)
                                       ->  Nested Loop  (cost=20.08..2501.42 rows=1 width=34) (actual time=0.141..128.363 rows=1875 loops=1)
                                             ->  Nested Loop  (cost=19.94..2501.07 rows=2 width=38) (actual time=0.134..123.979 rows=5654 loops=1)
                                                   ->  Nested Loop  (cost=19.52..2497.82 rows=4 width=25) (actual time=0.106..114.510 rows=2083 loops=1)
                                                         ->  Nested Loop  (cost=19.09..2482.02 rows=8 width=4) (actual time=0.053..22.766 rows=24592 loops=1)
                                                               ->  Hash Join  (cost=18.93..2462.50 rows=761 width=8) (actual time=0.038..16.792 rows=24592 loops=1)
                                                                     Hash Cond: (cc.status_id = cct2.id)
                                                                     ->  Seq Scan on complete_cast cc  (cost=0.00..2086.86 rows=135086 width=12) (actual time=0.010..7.055 rows=135086 loops=1)
                                                                     ->  Hash  (cost=18.88..18.88 rows=4 width=4) (actual time=0.017..0.018 rows=1 loops=1)
                                                                           Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                                           ->  Seq Scan on comp_cast_type cct2  (cost=0.00..18.88 rows=4 width=4) (actual time=0.010..0.010 rows=1 loops=1)
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
                                                               Filter: (production_year > 2000)
                                                               Rows Removed by Filter: 1
                                                   ->  Index Scan using movie_id_movie_info_idx on movie_info_idx mi_idx  (cost=0.43..0.78 rows=3 width=13) (actual time=0.004..0.004 rows=3 loops=2083)
                                                         Index Cond: (movie_id = t.id)
                                             ->  Index Scan using info_type_pkey on info_type it2  (cost=0.14..0.16 rows=1 width=4) (actual time=0.001..0.001 rows=0 loops=5654)
                                                   Index Cond: (id = mi_idx.info_type_id)
                                                   Filter: ((info)::text = 'votes'::text)
                                                   Rows Removed by Filter: 1
                                       ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..15.79 rows=1 width=8) (actual time=0.149..0.210 rows=1 loops=1875)
                                             Index Cond: (movie_id = t.id)
                                             Filter: (note = ANY ('{(writer),"(head writer)","(written by)",(story),"(story editor)"}'::text[]))
                                             Rows Removed by Filter: 94
                                 ->  Index Scan using name_pkey on name n  (cost=0.43..1.09 rows=1 width=19) (actual time=0.006..0.006 rows=1 loops=1839)
                                       Index Cond: (id = ci.person_id)
                                       Filter: ((gender)::text = 'm'::text)
                                       Rows Removed by Filter: 0
                           ->  Index Scan using movie_id_movie_keyword on movie_keyword mk  (cost=0.43..1.65 rows=47 width=8) (actual time=0.004..0.009 rows=68 loops=1256)
                                 Index Cond: (movie_id = t.id)
                     ->  Memoize  (cost=0.43..0.70 rows=1 width=4) (actual time=0.001..0.001 rows=0 loops=85244)
                           Cache Key: mk.keyword_id
                           Cache Mode: logical
                           Hits: 68158  Misses: 17086  Evictions: 0  Overflows: 0  Memory Usage: 1135kB
                           ->  Index Scan using keyword_pkey on keyword k  (cost=0.42..0.69 rows=1 width=4) (actual time=0.003..0.003 rows=0 loops=17086)
                                 Index Cond: (id = mk.keyword_id)
                                 Filter: (keyword = ANY ('{murder,violence,blood,gore,death,female-nudity,hospital}'::text[]))
                                 Rows Removed by Filter: 1
               ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..11.67 rows=1 width=51) (actual time=0.044..0.044 rows=1 loops=1235)
                     Index Cond: (movie_id = mk.movie_id)
                     Filter: (info = ANY ('{Horror,Thriller}'::text[]))
                     Rows Removed by Filter: 238
         ->  Index Scan using info_type_pkey on info_type it1  (cost=0.14..0.16 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=757)
               Index Cond: (id = mi.info_type_id)
               Filter: ((info)::text = 'genres'::text)
 Planning Time: 43.215 ms
 Execution Time: 683.445 ms
(64 rows)


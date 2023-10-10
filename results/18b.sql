                                                                                      QUERY PLAN                                                                                      
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=17170.56..17170.57 rows=1 width=96) (actual time=144.048..144.141 rows=1 loops=1)
   ->  Nested Loop  (cost=1004.30..17170.56 rows=1 width=65) (actual time=64.517..144.113 rows=11 loops=1)
         ->  Nested Loop  (cost=1003.87..17169.81 rows=1 width=69) (actual time=21.098..141.914 rows=268 loops=1)
               ->  Gather  (cost=1003.43..17159.95 rows=1 width=77) (actual time=8.009..102.314 rows=358 loops=1)
                     Workers Planned: 2
                     Workers Launched: 2
                     ->  Nested Loop  (cost=3.43..16159.85 rows=1 width=77) (actual time=4.911..113.936 rows=119 loops=3)
                           ->  Nested Loop  (cost=3.29..16158.53 rows=8 width=81) (actual time=4.894..113.777 rows=119 loops=3)
                                 ->  Nested Loop  (cost=2.86..15878.28 rows=59 width=30) (actual time=0.781..72.565 rows=2051 loops=3)
                                       ->  Hash Join  (cost=2.43..15216.60 rows=190 width=9) (actual time=0.099..40.527 rows=5283 loops=3)
                                             Hash Cond: (mi_idx.info_type_id = it2.id)
                                             ->  Parallel Seq Scan on movie_info_idx mi_idx  (cost=0.00..15155.68 rows=21477 width=13) (actual time=0.023..39.053 rows=17883 loops=3)
                                                   Filter: (info > '8.0'::text)
                                                   Rows Removed by Filter: 442129
                                             ->  Hash  (cost=2.41..2.41 rows=1 width=4) (actual time=0.022..0.023 rows=1 loops=3)
                                                   Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                   ->  Seq Scan on info_type it2  (cost=0.00..2.41 rows=1 width=4) (actual time=0.012..0.013 rows=1 loops=3)
                                                         Filter: ((info)::text = 'rating'::text)
                                                         Rows Removed by Filter: 112
                                       ->  Index Scan using title_pkey on title t  (cost=0.43..3.48 rows=1 width=21) (actual time=0.006..0.006 rows=0 loops=15849)
                                             Index Cond: (id = mi_idx.movie_id)
                                             Filter: ((production_year >= 2008) AND (production_year <= 2014))
                                             Rows Removed by Filter: 1
                                 ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..4.74 rows=1 width=51) (actual time=0.020..0.020 rows=0 loops=6152)
                                       Index Cond: (movie_id = t.id)
                                       Filter: ((note IS NULL) AND (info = ANY ('{Horror,Thriller}'::text[])))
                                       Rows Removed by Filter: 18
                           ->  Index Scan using info_type_pkey on info_type it1  (cost=0.14..0.16 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=358)
                                 Index Cond: (id = mi.info_type_id)
                                 Filter: ((info)::text = 'genres'::text)
               ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..9.84 rows=1 width=8) (actual time=0.084..0.110 rows=1 loops=358)
                     Index Cond: (movie_id = t.id)
                     Filter: (note = ANY ('{(writer),"(head writer)","(written by)",(story),"(story editor)"}'::text[]))
                     Rows Removed by Filter: 34
         ->  Index Scan using name_pkey on name n  (cost=0.43..0.75 rows=1 width=4) (actual time=0.008..0.008 rows=0 loops=268)
               Index Cond: (id = ci.person_id)
               Filter: ((gender IS NOT NULL) AND ((gender)::text = 'f'::text))
               Rows Removed by Filter: 1
 Planning Time: 3.631 ms
 Execution Time: 144.287 ms
(40 rows)


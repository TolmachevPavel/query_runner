                                                                                          QUERY PLAN                                                                                          
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Finalize Aggregate  (cost=39800.34..39800.35 rows=1 width=96) (actual time=4459.546..4468.468 rows=1 loops=1)
   ->  Gather  (cost=39800.12..39800.33 rows=2 width=96) (actual time=4458.937..4468.457 rows=3 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         ->  Partial Aggregate  (cost=38800.12..38800.13 rows=1 width=96) (actual time=4456.325..4456.332 rows=1 loops=3)
               ->  Nested Loop  (cost=6.59..38800.04 rows=10 width=65) (actual time=8.078..4451.754 rows=9358 loops=3)
                     ->  Nested Loop  (cost=6.16..38782.83 rows=23 width=69) (actual time=4.173..4327.782 rows=18052 loops=3)
                           ->  Nested Loop  (cost=5.72..38612.24 rows=19 width=77) (actual time=0.419..1240.118 rows=34172 loops=3)
                                 Join Filter: (mi.movie_id = t.id)
                                 ->  Hash Join  (cost=5.29..38601.02 rows=19 width=56) (actual time=0.387..1109.680 rows=34172 loops=3)
                                       Hash Cond: (mi.info_type_id = it1.id)
                                       ->  Nested Loop  (cost=2.86..38592.80 rows=2129 width=60) (actual time=0.324..1102.243 rows=34964 loops=3)
                                             ->  Hash Join  (cost=2.43..15286.60 rows=5089 width=9) (actual time=0.036..82.196 rows=153308 loops=3)
                                                   Hash Cond: (mi_idx.info_type_id = it2.id)
                                                   ->  Parallel Seq Scan on movie_info_idx mi_idx  (cost=0.00..13718.15 rows=575015 width=13) (actual time=0.012..30.370 rows=460012 loops=3)
                                                   ->  Hash  (cost=2.41..2.41 rows=1 width=4) (actual time=0.009..0.010 rows=1 loops=3)
                                                         Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                         ->  Seq Scan on info_type it2  (cost=0.00..2.41 rows=1 width=4) (actual time=0.005..0.006 rows=1 loops=3)
                                                               Filter: ((info)::text = 'votes'::text)
                                                               Rows Removed by Filter: 112
                                             ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..4.57 rows=1 width=51) (actual time=0.006..0.006 rows=0 loops=459925)
                                                   Index Cond: (movie_id = mi_idx.movie_id)
                                                   Filter: (info = ANY ('{Horror,Action,Sci-Fi,Thriller,Crime,War}'::text[]))
                                                   Rows Removed by Filter: 15
                                       ->  Hash  (cost=2.41..2.41 rows=1 width=4) (actual time=0.025..0.026 rows=1 loops=3)
                                             Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                             ->  Seq Scan on info_type it1  (cost=0.00..2.41 rows=1 width=4) (actual time=0.015..0.019 rows=1 loops=3)
                                                   Filter: ((info)::text = 'genres'::text)
                                                   Rows Removed by Filter: 112
                                 ->  Index Scan using title_pkey on title t  (cost=0.43..0.58 rows=1 width=21) (actual time=0.003..0.003 rows=1 loops=102516)
                                       Index Cond: (id = mi_idx.movie_id)
                           ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..8.97 rows=1 width=8) (actual time=0.077..0.090 rows=1 loops=102516)
                                 Index Cond: (movie_id = t.id)
                                 Filter: (note = ANY ('{(writer),"(head writer)","(written by)",(story),"(story editor)"}'::text[]))
                                 Rows Removed by Filter: 39
                     ->  Index Scan using name_pkey on name n  (cost=0.43..0.75 rows=1 width=4) (actual time=0.007..0.007 rows=1 loops=54155)
                           Index Cond: (id = ci.person_id)
                           Filter: ((gender)::text = 'm'::text)
                           Rows Removed by Filter: 0
 Planning Time: 3.683 ms
 Execution Time: 4468.638 ms
(41 rows)


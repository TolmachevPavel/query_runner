                                                                                       QUERY PLAN                                                                                       
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=55142.23..55142.24 rows=1 width=96) (actual time=3539.694..3547.531 rows=1 loops=1)
   ->  Nested Loop  (cost=1006.58..55142.22 rows=1 width=65) (actual time=130.396..3546.687 rows=410 loops=1)
         ->  Gather  (cost=1006.15..55141.76 rows=1 width=60) (actual time=130.367..3542.705 rows=410 loops=1)
               Workers Planned: 2
               Workers Launched: 2
               ->  Nested Loop  (cost=6.16..54141.66 rows=1 width=60) (actual time=77.929..3533.642 rows=137 loops=3)
                     ->  Nested Loop  (cost=5.73..51858.82 rows=3574 width=64) (actual time=0.475..3243.533 rows=35780 loops=3)
                           ->  Hash Join  (cost=5.29..39511.93 rows=1449 width=56) (actual time=0.354..1159.328 rows=15144 loops=3)
                                 Hash Cond: (mi.info_type_id = it1.id)
                                 ->  Nested Loop  (cost=2.86..39063.53 rows=163755 width=60) (actual time=0.070..1055.886 rows=2310111 loops=3)
                                       ->  Hash Join  (cost=2.43..15286.60 rows=5089 width=9) (actual time=0.035..73.496 rows=153308 loops=3)
                                             Hash Cond: (mi_idx.info_type_id = it2.id)
                                             ->  Parallel Seq Scan on movie_info_idx mi_idx  (cost=0.00..13718.15 rows=575015 width=13) (actual time=0.012..28.609 rows=460012 loops=3)
                                             ->  Hash  (cost=2.41..2.41 rows=1 width=4) (actual time=0.010..0.011 rows=1 loops=3)
                                                   Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                   ->  Seq Scan on info_type it2  (cost=0.00..2.41 rows=1 width=4) (actual time=0.006..0.007 rows=1 loops=3)
                                                         Filter: ((info)::text = 'votes'::text)
                                                         Rows Removed by Filter: 112
                                       ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..4.26 rows=41 width=51) (actual time=0.001..0.005 rows=15 loops=459925)
                                             Index Cond: (movie_id = mi_idx.movie_id)
                                 ->  Hash  (cost=2.41..2.41 rows=1 width=4) (actual time=0.023..0.024 rows=1 loops=3)
                                       Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                       ->  Seq Scan on info_type it1  (cost=0.00..2.41 rows=1 width=4) (actual time=0.016..0.017 rows=1 loops=3)
                                             Filter: ((info)::text = 'budget'::text)
                                             Rows Removed by Filter: 112
                           ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..8.50 rows=2 width=8) (actual time=0.080..0.137 rows=2 loops=45431)
                                 Index Cond: (movie_id = mi.movie_id)
                                 Filter: (note = ANY ('{(producer),"(executive producer)"}'::text[]))
                                 Rows Removed by Filter: 38
                     ->  Index Scan using name_pkey on name n  (cost=0.43..0.64 rows=1 width=4) (actual time=0.008..0.008 rows=0 loops=107339)
                           Index Cond: (id = ci.person_id)
                           Filter: ((name ~~ '%Tim%'::text) AND ((gender)::text = 'm'::text))
                           Rows Removed by Filter: 1
         ->  Index Scan using title_pkey on title t  (cost=0.43..0.46 rows=1 width=21) (actual time=0.009..0.009 rows=1 loops=410)
               Index Cond: (id = mi.movie_id)
 Planning Time: 3.605 ms
 Execution Time: 3547.682 ms
(37 rows)


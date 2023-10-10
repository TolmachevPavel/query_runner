                                                                                                      QUERY PLAN                                                                                                      
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=9598.23..9598.24 rows=1 width=128) (actual time=867.668..867.779 rows=1 loops=1)
   ->  Nested Loop  (cost=1012.80..9598.22 rows=1 width=80) (actual time=55.670..867.173 rows=1273 loops=1)
         Join Filter: (mi.movie_id = t.id)
         ->  Nested Loop  (cost=1012.37..9597.08 rows=1 width=83) (actual time=55.647..863.325 rows=1273 loops=1)
               ->  Nested Loop  (cost=1011.94..9595.73 rows=1 width=72) (actual time=50.102..856.870 rows=1556 loops=1)
                     ->  Nested Loop  (cost=1011.80..9595.55 rows=1 width=76) (actual time=50.081..855.350 rows=1616 loops=1)
                           Join Filter: (mi.movie_id = mi_idx.movie_id)
                           ->  Nested Loop  (cost=1011.37..9578.21 rows=1 width=25) (actual time=17.115..797.976 rows=1471 loops=1)
                                 Join Filter: (ci.movie_id = mi_idx.movie_id)
                                 ->  Gather  (cost=1010.93..9557.99 rows=1 width=17) (actual time=16.915..541.456 rows=1547 loops=1)
                                       Workers Planned: 2
                                       Workers Launched: 2
                                       ->  Nested Loop  (cost=10.93..8557.89 rows=1 width=17) (actual time=10.033..553.628 rows=516 loops=3)
                                             ->  Nested Loop  (cost=10.51..8545.08 rows=13 width=21) (actual time=2.827..284.602 rows=199419 loops=3)
                                                   Join Filter: (mc.movie_id = mi_idx.movie_id)
                                                   ->  Hash Join  (cost=10.08..8540.78 rows=2 width=13) (actual time=2.798..160.585 rows=21234 loops=3)
                                                         Hash Cond: (mi_idx.info_type_id = it2.id)
                                                         ->  Nested Loop  (cost=7.65..8537.55 rows=294 width=17) (actual time=2.690..154.584 rows=63896 loops=3)
                                                               ->  Nested Loop  (cost=7.22..8431.48 rows=98 width=4) (actual time=2.661..84.615 rows=25571 loops=3)
                                                                     ->  Parallel Index Scan using keyword_pkey on keyword k  (cost=0.42..5152.39 rows=3 width=4) (actual time=0.297..14.659 rows=2 loops=3)
                                                                           Filter: (keyword = ANY ('{murder,violence,blood,gore,death,female-nudity,hospital}'::text[]))
                                                                           Rows Removed by Filter: 44721
                                                                     ->  Bitmap Heap Scan on movie_keyword mk  (cost=6.80..1089.97 rows=306 width=8) (actual time=1.823..28.967 rows=10959 loops=7)
                                                                           Recheck Cond: (k.id = keyword_id)
                                                                           Heap Blocks: exact=12389
                                                                           ->  Bitmap Index Scan on keyword_id_movie_keyword  (cost=0.00..6.73 rows=306 width=0) (actual time=1.049..1.050 rows=10959 loops=7)
                                                                                 Index Cond: (keyword_id = k.id)
                                                               ->  Index Scan using movie_id_movie_info_idx on movie_info_idx mi_idx  (cost=0.43..1.05 rows=3 width=13) (actual time=0.002..0.002 rows=2 loops=76714)
                                                                     Index Cond: (movie_id = mk.movie_id)
                                                         ->  Hash  (cost=2.41..2.41 rows=1 width=4) (actual time=0.032..0.033 rows=1 loops=3)
                                                               Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                               ->  Seq Scan on info_type it2  (cost=0.00..2.41 rows=1 width=4) (actual time=0.021..0.022 rows=1 loops=3)
                                                                     Filter: ((info)::text = 'votes'::text)
                                                                     Rows Removed by Filter: 112
                                                   ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..2.08 rows=5 width=8) (actual time=0.003..0.005 rows=9 loops=63701)
                                                         Index Cond: (movie_id = mk.movie_id)
                                             ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..0.98 rows=1 width=4) (actual time=0.001..0.001 rows=0 loops=598256)
                                                   Index Cond: (id = mc.company_id)
                                                   Filter: (name ~~ 'Lionsgate%'::text)
                                                   Rows Removed by Filter: 1
                                 ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..20.21 rows=1 width=8) (actual time=0.120..0.165 rows=1 loops=1547)
                                       Index Cond: (movie_id = mk.movie_id)
                                       Filter: (note = ANY ('{(writer),"(head writer)","(written by)",(story),"(story editor)"}'::text[]))
                                       Rows Removed by Filter: 119
                           ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..17.33 rows=1 width=51) (actual time=0.038..0.039 rows=1 loops=1471)
                                 Index Cond: (movie_id = mk.movie_id)
                                 Filter: (info = ANY ('{Horror,Thriller}'::text[]))
                                 Rows Removed by Filter: 173
                     ->  Index Scan using info_type_pkey on info_type it1  (cost=0.14..0.16 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=1616)
                           Index Cond: (id = mi.info_type_id)
                           Filter: ((info)::text = 'genres'::text)
                           Rows Removed by Filter: 0
               ->  Index Scan using name_pkey on name n  (cost=0.43..1.35 rows=1 width=19) (actual time=0.004..0.004 rows=1 loops=1556)
                     Index Cond: (id = ci.person_id)
                     Filter: ((gender)::text = 'm'::text)
                     Rows Removed by Filter: 0
         ->  Index Scan using title_pkey on title t  (cost=0.43..1.12 rows=1 width=21) (actual time=0.003..0.003 rows=1 loops=1273)
               Index Cond: (id = mk.movie_id)
 Planning Time: 39.596 ms
 Execution Time: 868.031 ms
(60 rows)


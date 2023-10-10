                                                                                                      QUERY PLAN                                                                                                      
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=9598.43..9598.44 rows=1 width=128) (actual time=857.579..857.710 rows=1 loops=1)
   ->  Nested Loop  (cost=1012.80..9598.42 rows=1 width=80) (actual time=32.396..856.737 rows=2825 loops=1)
         Join Filter: (mi.movie_id = t.id)
         ->  Nested Loop  (cost=1012.37..9597.28 rows=1 width=83) (actual time=32.377..850.905 rows=2825 loops=1)
               ->  Nested Loop  (cost=1011.94..9595.94 rows=1 width=72) (actual time=32.350..842.930 rows=2825 loops=1)
                     ->  Nested Loop  (cost=1011.80..9595.75 rows=1 width=76) (actual time=32.318..840.402 rows=3007 loops=1)
                           Join Filter: (mi.movie_id = mi_idx.movie_id)
                           ->  Nested Loop  (cost=1011.37..9578.21 rows=1 width=25) (actual time=17.084..772.995 rows=1471 loops=1)
                                 Join Filter: (ci.movie_id = mi_idx.movie_id)
                                 ->  Gather  (cost=1010.93..9557.99 rows=1 width=17) (actual time=16.904..512.357 rows=1547 loops=1)
                                       Workers Planned: 2
                                       Workers Launched: 2
                                       ->  Nested Loop  (cost=10.93..8557.89 rows=1 width=17) (actual time=10.110..548.162 rows=516 loops=3)
                                             ->  Nested Loop  (cost=10.51..8545.08 rows=13 width=21) (actual time=2.581..281.747 rows=199419 loops=3)
                                                   Join Filter: (mc.movie_id = mi_idx.movie_id)
                                                   ->  Hash Join  (cost=10.08..8540.78 rows=2 width=13) (actual time=2.550..158.138 rows=21234 loops=3)
                                                         Hash Cond: (mi_idx.info_type_id = it2.id)
                                                         ->  Nested Loop  (cost=7.65..8537.55 rows=294 width=17) (actual time=2.476..152.154 rows=63896 loops=3)
                                                               ->  Nested Loop  (cost=7.22..8431.48 rows=98 width=4) (actual time=2.441..82.515 rows=25571 loops=3)
                                                                     ->  Parallel Index Scan using keyword_pkey on keyword k  (cost=0.42..5152.39 rows=3 width=4) (actual time=0.210..12.557 rows=2 loops=3)
                                                                           Filter: (keyword = ANY ('{murder,violence,blood,gore,death,female-nudity,hospital}'::text[]))
                                                                           Rows Removed by Filter: 44721
                                                                     ->  Bitmap Heap Scan on movie_keyword mk  (cost=6.80..1089.97 rows=306 width=8) (actual time=1.702..28.997 rows=10959 loops=7)
                                                                           Recheck Cond: (k.id = keyword_id)
                                                                           Heap Blocks: exact=12389
                                                                           ->  Bitmap Index Scan on keyword_id_movie_keyword  (cost=0.00..6.73 rows=306 width=0) (actual time=0.944..0.944 rows=10959 loops=7)
                                                                                 Index Cond: (keyword_id = k.id)
                                                               ->  Index Scan using movie_id_movie_info_idx on movie_info_idx mi_idx  (cost=0.43..1.05 rows=3 width=13) (actual time=0.002..0.002 rows=2 loops=76714)
                                                                     Index Cond: (movie_id = mk.movie_id)
                                                         ->  Hash  (cost=2.41..2.41 rows=1 width=4) (actual time=0.024..0.024 rows=1 loops=3)
                                                               Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                               ->  Seq Scan on info_type it2  (cost=0.00..2.41 rows=1 width=4) (actual time=0.016..0.017 rows=1 loops=3)
                                                                     Filter: ((info)::text = 'votes'::text)
                                                                     Rows Removed by Filter: 112
                                                   ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..2.08 rows=5 width=8) (actual time=0.003..0.005 rows=9 loops=63701)
                                                         Index Cond: (movie_id = mk.movie_id)
                                             ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..0.98 rows=1 width=4) (actual time=0.001..0.001 rows=0 loops=598256)
                                                   Index Cond: (id = mc.company_id)
                                                   Filter: (name ~~ 'Lionsgate%'::text)
                                                   Rows Removed by Filter: 1
                                 ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..20.21 rows=1 width=8) (actual time=0.122..0.168 rows=1 loops=1547)
                                       Index Cond: (movie_id = mk.movie_id)
                                       Filter: (note = ANY ('{(writer),"(head writer)","(written by)",(story),"(story editor)"}'::text[]))
                                       Rows Removed by Filter: 119
                           ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..17.53 rows=1 width=51) (actual time=0.044..0.045 rows=2 loops=1471)
                                 Index Cond: (movie_id = mk.movie_id)
                                 Filter: (info = ANY ('{Horror,Action,Sci-Fi,Thriller,Crime,War}'::text[]))
                                 Rows Removed by Filter: 172
                     ->  Index Scan using info_type_pkey on info_type it1  (cost=0.14..0.16 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=3007)
                           Index Cond: (id = mi.info_type_id)
                           Filter: ((info)::text = 'genres'::text)
                           Rows Removed by Filter: 0
               ->  Index Scan using name_pkey on name n  (cost=0.43..1.35 rows=1 width=19) (actual time=0.003..0.003 rows=1 loops=2825)
                     Index Cond: (id = ci.person_id)
         ->  Index Scan using title_pkey on title t  (cost=0.43..1.12 rows=1 width=21) (actual time=0.002..0.002 rows=1 loops=2825)
               Index Cond: (id = mk.movie_id)
 Planning Time: 41.730 ms
 Execution Time: 857.989 ms
(58 rows)


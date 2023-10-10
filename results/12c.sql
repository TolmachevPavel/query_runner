                                                                                            QUERY PLAN                                                                                             
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=17171.31..17171.32 rows=1 width=96) (actual time=452.376..461.667 rows=1 loops=1)
   ->  Gather  (cost=1023.21..17171.30 rows=1 width=41) (actual time=1.428..460.625 rows=4711 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         ->  Nested Loop  (cost=23.21..16171.20 rows=1 width=41) (actual time=2.860..449.183 rows=1570 loops=3)
               ->  Nested Loop  (cost=23.07..16170.86 rows=2 width=45) (actual time=2.849..447.897 rows=1570 loops=3)
                     Join Filter: (mi.movie_id = t.id)
                     ->  Nested Loop  (cost=22.63..16165.92 rows=3 width=53) (actual time=0.262..299.356 rows=14111 loops=3)
                           Join Filter: (mi_idx.movie_id = t.id)
                           ->  Nested Loop  (cost=22.20..16161.65 rows=8 width=32) (actual time=0.177..226.370 rows=30438 loops=3)
                                 ->  Hash Join  (cost=21.78..16152.73 rows=20 width=17) (actual time=0.155..145.122 rows=51498 loops=3)
                                       Hash Cond: (mc.company_type_id = ct.id)
                                       ->  Nested Loop  (cost=2.86..16124.34 rows=3584 width=21) (actual time=0.118..134.748 rows=127672 loops=3)
                                             ->  Hash Join  (cost=2.43..15373.39 rows=700 width=9) (actual time=0.089..49.856 rows=40524 loops=3)
                                                   Hash Cond: (mi_idx.info_type_id = it2.id)
                                                   ->  Parallel Seq Scan on movie_info_idx mi_idx  (cost=0.00..15155.68 rows=79045 width=13) (actual time=0.022..43.585 rows=64632 loops=3)
                                                         Filter: (info > '7.0'::text)
                                                         Rows Removed by Filter: 395380
                                                   ->  Hash  (cost=2.41..2.41 rows=1 width=4) (actual time=0.019..0.020 rows=1 loops=3)
                                                         Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                         ->  Seq Scan on info_type it2  (cost=0.00..2.41 rows=1 width=4) (actual time=0.014..0.014 rows=1 loops=3)
                                                               Filter: ((info)::text = 'rating'::text)
                                                               Rows Removed by Filter: 112
                                             ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..1.02 rows=5 width=12) (actual time=0.001..0.002 rows=3 loops=121572)
                                                   Index Cond: (movie_id = mi_idx.movie_id)
                                       ->  Hash  (cost=18.88..18.88 rows=4 width=4) (actual time=0.013..0.013 rows=1 loops=3)
                                             Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                             ->  Seq Scan on company_type ct  (cost=0.00..18.88 rows=4 width=4) (actual time=0.010..0.010 rows=1 loops=3)
                                                   Filter: ((kind)::text = 'production companies'::text)
                                                   Rows Removed by Filter: 3
                                 ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..0.45 rows=1 width=23) (actual time=0.001..0.001 rows=1 loops=154495)
                                       Index Cond: (id = mc.company_id)
                                       Filter: ((country_code)::text = '[us]'::text)
                                       Rows Removed by Filter: 0
                           ->  Index Scan using title_pkey on title t  (cost=0.43..0.52 rows=1 width=21) (actual time=0.002..0.002 rows=0 loops=91314)
                                 Index Cond: (id = mc.movie_id)
                                 Filter: ((production_year >= 2000) AND (production_year <= 2010))
                                 Rows Removed by Filter: 1
                     ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..1.63 rows=1 width=8) (actual time=0.010..0.010 rows=0 loops=42332)
                           Index Cond: (movie_id = mc.movie_id)
                           Filter: (info = ANY ('{Drama,Horror,Western,Family}'::text[]))
                           Rows Removed by Filter: 29
               ->  Index Scan using info_type_pkey on info_type it1  (cost=0.14..0.16 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=4711)
                     Index Cond: (id = mi.info_type_id)
                     Filter: ((info)::text = 'genres'::text)
 Planning Time: 4.996 ms
 Execution Time: 461.821 ms
(47 rows)


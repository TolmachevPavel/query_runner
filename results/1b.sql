                                                                                   QUERY PLAN                                                                                    
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Finalize Aggregate  (cost=20151.59..20151.60 rows=1 width=68) (actual time=115.481..118.160 rows=1 loops=1)
   ->  Gather  (cost=20151.36..20151.57 rows=2 width=68) (actual time=115.475..118.156 rows=3 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         ->  Partial Aggregate  (cost=19151.36..19151.37 rows=1 width=68) (actual time=112.488..112.492 rows=1 loops=3)
               ->  Hash Join  (cost=4.35..19143.91 rows=993 width=45) (actual time=112.481..112.486 rows=1 loops=3)
                     Hash Cond: (mc.company_type_id = ct.id)
                     ->  Nested Loop  (cost=3.29..19121.38 rows=3972 width=49) (actual time=112.375..112.407 rows=22 loops=3)
                           Join Filter: (t.id = mc.movie_id)
                           ->  Nested Loop  (cost=2.86..18189.65 rows=1463 width=29) (actual time=112.367..112.380 rows=1 loops=3)
                                 ->  Hash Join  (cost=2.43..15253.60 rows=5089 width=4) (actual time=112.331..112.335 rows=3 loops=3)
                                       Hash Cond: (mi_idx.info_type_id = it.id)
                                       ->  Parallel Seq Scan on movie_info_idx mi_idx  (cost=0.00..13685.15 rows=575015 width=8) (actual time=0.348..57.098 rows=460012 loops=3)
                                       ->  Hash  (cost=2.41..2.41 rows=1 width=4) (actual time=0.026..0.027 rows=1 loops=3)
                                             Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                             ->  Seq Scan on info_type it  (cost=0.00..2.41 rows=1 width=4) (actual time=0.023..0.024 rows=1 loops=3)
                                                   Filter: ((info)::text = 'bottom 10 rank'::text)
                                                   Rows Removed by Filter: 112
                                 ->  Index Scan using title_pkey on title t  (cost=0.43..0.58 rows=1 width=25) (actual time=0.012..0.012 rows=0 loops=10)
                                       Index Cond: (id = mi_idx.movie_id)
                                       Filter: ((production_year >= 2005) AND (production_year <= 2010))
                                       Rows Removed by Filter: 1
                           ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..0.60 rows=3 width=32) (actual time=0.011..0.017 rows=16 loops=4)
                                 Index Cond: (movie_id = mi_idx.movie_id)
                                 Filter: (note !~~ '%(as Metro-Goldwyn-Mayer Pictures)%'::text)
                                 Rows Removed by Filter: 2
                     ->  Hash  (cost=1.05..1.05 rows=1 width=4) (actual time=0.023..0.023 rows=1 loops=3)
                           Buckets: 1024  Batches: 1  Memory Usage: 9kB
                           ->  Seq Scan on company_type ct  (cost=0.00..1.05 rows=1 width=4) (actual time=0.013..0.014 rows=1 loops=3)
                                 Filter: ((kind)::text = 'production companies'::text)
                                 Rows Removed by Filter: 3
 Planning Time: 1.895 ms
 Execution Time: 118.298 ms
(33 rows)


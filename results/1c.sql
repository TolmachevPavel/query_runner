                                                                                     QUERY PLAN                                                                                     
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Finalize Aggregate  (cost=19432.95..19432.96 rows=1 width=68) (actual time=88.337..89.024 rows=1 loops=1)
   ->  Gather  (cost=19432.72..19432.93 rows=2 width=68) (actual time=88.328..89.017 rows=3 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         ->  Partial Aggregate  (cost=18432.72..18432.73 rows=1 width=68) (actual time=84.200..84.204 rows=1 loops=3)
               ->  Nested Loop  (cost=4.35..18432.70 rows=3 width=45) (actual time=83.557..84.198 rows=1 loops=3)
                     Join Filter: (mc.movie_id = t.id)
                     ->  Hash Join  (cost=3.92..18419.79 rows=22 width=32) (actual time=82.967..84.160 rows=8 loops=3)
                           Hash Cond: (mc.company_type_id = ct.id)
                           ->  Nested Loop  (cost=2.86..18418.25 rows=89 width=36) (actual time=82.900..84.090 rows=8 loops=3)
                                 ->  Hash Join  (cost=2.43..15253.60 rows=5089 width=4) (actual time=82.429..82.458 rows=83 loops=3)
                                       Hash Cond: (mi_idx.info_type_id = it.id)
                                       ->  Parallel Seq Scan on movie_info_idx mi_idx  (cost=0.00..13685.15 rows=575015 width=8) (actual time=0.318..44.755 rows=460012 loops=3)
                                       ->  Hash  (cost=2.41..2.41 rows=1 width=4) (actual time=0.021..0.022 rows=1 loops=3)
                                             Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                             ->  Seq Scan on info_type it  (cost=0.00..2.41 rows=1 width=4) (actual time=0.018..0.019 rows=1 loops=3)
                                                   Filter: ((info)::text = 'top 250 rank'::text)
                                                   Rows Removed by Filter: 112
                                 ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..0.61 rows=1 width=32) (actual time=0.019..0.019 rows=0 loops=250)
                                       Index Cond: (movie_id = mi_idx.movie_id)
                                       Filter: ((note !~~ '%(as Metro-Goldwyn-Mayer Pictures)%'::text) AND (note ~~ '%(co-production)%'::text))
                                       Rows Removed by Filter: 33
                           ->  Hash  (cost=1.05..1.05 rows=1 width=4) (actual time=0.022..0.023 rows=1 loops=3)
                                 Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                 ->  Seq Scan on company_type ct  (cost=0.00..1.05 rows=1 width=4) (actual time=0.013..0.014 rows=1 loops=3)
                                       Filter: ((kind)::text = 'production companies'::text)
                                       Rows Removed by Filter: 3
                     ->  Index Scan using title_pkey on title t  (cost=0.43..0.57 rows=1 width=25) (actual time=0.004..0.004 rows=0 loops=23)
                           Index Cond: (id = mi_idx.movie_id)
                           Filter: (production_year > 2010)
                           Rows Removed by Filter: 1
 Planning Time: 1.753 ms
 Execution Time: 89.167 ms
(33 rows)


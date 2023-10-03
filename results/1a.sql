                                                                                     QUERY PLAN                                                                                     
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Finalize Aggregate  (cost=19504.01..19504.02 rows=1 width=68) (actual time=157.738..160.147 rows=1 loops=1)
   ->  Gather  (cost=19503.78..19503.99 rows=2 width=68) (actual time=152.226..160.135 rows=3 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         ->  Partial Aggregate  (cost=18503.78..18503.79 rows=1 width=68) (actual time=151.735..151.739 rows=1 loops=3)
               ->  Nested Loop  (cost=4.35..18503.53 rows=34 width=45) (actual time=149.092..151.713 rows=47 loops=3)
                     Join Filter: (mc.movie_id = t.id)
                     ->  Hash Join  (cost=3.92..18483.66 rows=34 width=32) (actual time=148.856..150.575 rows=47 loops=3)
                           Hash Cond: (mc.company_type_id = ct.id)
                           ->  Nested Loop  (cost=2.86..18481.86 rows=136 width=36) (actual time=148.672..150.380 rows=49 loops=3)
                                 ->  Hash Join  (cost=2.43..15253.60 rows=5089 width=4) (actual time=148.624..148.650 rows=83 loops=3)
                                       Hash Cond: (mi_idx.info_type_id = it.id)
                                       ->  Parallel Seq Scan on movie_info_idx mi_idx  (cost=0.00..13685.15 rows=575015 width=8) (actual time=0.544..109.372 rows=460012 loops=3)
                                       ->  Hash  (cost=2.41..2.41 rows=1 width=4) (actual time=0.022..0.023 rows=1 loops=3)
                                             Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                             ->  Seq Scan on info_type it  (cost=0.00..2.41 rows=1 width=4) (actual time=0.017..0.018 rows=1 loops=3)
                                                   Filter: ((info)::text = 'top 250 rank'::text)
                                                   Rows Removed by Filter: 112
                                 ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..0.62 rows=1 width=32) (actual time=0.020..0.020 rows=1 loops=250)
                                       Index Cond: (movie_id = mi_idx.movie_id)
                                       Filter: ((note !~~ '%(as Metro-Goldwyn-Mayer Pictures)%'::text) AND ((note ~~ '%(co-production)%'::text) OR (note ~~ '%(presents)%'::text)))
                                       Rows Removed by Filter: 33
                           ->  Hash  (cost=1.05..1.05 rows=1 width=4) (actual time=0.138..0.138 rows=1 loops=3)
                                 Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                 ->  Seq Scan on company_type ct  (cost=0.00..1.05 rows=1 width=4) (actual time=0.012..0.012 rows=1 loops=3)
                                       Filter: ((kind)::text = 'production companies'::text)
                                       Rows Removed by Filter: 3
                     ->  Index Scan using title_pkey on title t  (cost=0.43..0.57 rows=1 width=25) (actual time=0.024..0.024 rows=1 loops=142)
                           Index Cond: (id = mi_idx.movie_id)
 Planning Time: 4.132 ms
 Execution Time: 160.689 ms
(31 rows)


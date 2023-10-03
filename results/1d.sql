                                                                                   QUERY PLAN                                                                                    
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Finalize Aggregate  (cost=20984.95..20984.96 rows=1 width=68) (actual time=100.050..102.111 rows=1 loops=1)
   ->  Gather  (cost=20984.72..20984.93 rows=2 width=68) (actual time=98.856..102.095 rows=3 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         ->  Partial Aggregate  (cost=19984.72..19984.73 rows=1 width=68) (actual time=95.461..95.470 rows=1 loops=3)
               ->  Hash Join  (cost=4.35..19970.55 rows=1890 width=45) (actual time=95.444..95.464 rows=1 loops=3)
                     Hash Cond: (mc.company_type_id = ct.id)
                     ->  Nested Loop  (cost=3.29..19928.62 rows=7559 width=49) (actual time=95.033..95.370 rows=26 loops=3)
                           ->  Nested Loop  (cost=2.86..18176.93 rows=2784 width=29) (actual time=95.022..95.052 rows=2 loops=3)
                                 ->  Hash Join  (cost=2.43..15253.60 rows=5089 width=4) (actual time=94.995..95.002 rows=3 loops=3)
                                       Hash Cond: (mi_idx.info_type_id = it.id)
                                       ->  Parallel Seq Scan on movie_info_idx mi_idx  (cost=0.00..13685.15 rows=575015 width=8) (actual time=0.472..48.732 rows=460012 loops=3)
                                       ->  Hash  (cost=2.41..2.41 rows=1 width=4) (actual time=0.035..0.038 rows=1 loops=3)
                                             Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                             ->  Seq Scan on info_type it  (cost=0.00..2.41 rows=1 width=4) (actual time=0.031..0.032 rows=1 loops=3)
                                                   Filter: ((info)::text = 'bottom 10 rank'::text)
                                                   Rows Removed by Filter: 112
                                 ->  Index Scan using title_pkey on title t  (cost=0.43..0.57 rows=1 width=25) (actual time=0.013..0.013 rows=1 loops=10)
                                       Index Cond: (id = mi_idx.movie_id)
                                       Filter: (production_year > 2000)
                                       Rows Removed by Filter: 0
                           ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..0.60 rows=3 width=32) (actual time=0.152..0.157 rows=13 loops=6)
                                 Index Cond: (movie_id = t.id)
                                 Filter: (note !~~ '%(as Metro-Goldwyn-Mayer Pictures)%'::text)
                                 Rows Removed by Filter: 2
                     ->  Hash  (cost=1.05..1.05 rows=1 width=4) (actual time=0.028..0.028 rows=1 loops=3)
                           Buckets: 1024  Batches: 1  Memory Usage: 9kB
                           ->  Seq Scan on company_type ct  (cost=0.00..1.05 rows=1 width=4) (actual time=0.015..0.017 rows=1 loops=3)
                                 Filter: ((kind)::text = 'production companies'::text)
                                 Rows Removed by Filter: 3
 Planning Time: 3.322 ms
 Execution Time: 102.328 ms
(32 rows)


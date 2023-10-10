                                                                                  QUERY PLAN                                                                                  
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=19455.22..19455.23 rows=1 width=68) (actual time=50.732..53.292 rows=1 loops=1)
   ->  Nested Loop  (cost=1003.44..19455.21 rows=1 width=45) (actual time=50.623..53.276 rows=3 loops=1)
         Join Filter: (mc.movie_id = t.id)
         ->  Gather  (cost=1003.01..19454.62 rows=1 width=32) (actual time=49.356..53.066 rows=23 loops=1)
               Workers Planned: 2
               Workers Launched: 2
               ->  Nested Loop  (cost=3.02..18454.52 rows=1 width=32) (actual time=45.933..46.932 rows=8 loops=3)
                     ->  Nested Loop  (cost=2.86..18451.75 rows=90 width=36) (actual time=45.923..46.920 rows=8 loops=3)
                           ->  Hash Join  (cost=2.43..15286.60 rows=5089 width=4) (actual time=45.474..45.496 rows=83 loops=3)
                                 Hash Cond: (mi_idx.info_type_id = it.id)
                                 ->  Parallel Seq Scan on movie_info_idx mi_idx  (cost=0.00..13718.15 rows=575015 width=8) (actual time=0.016..22.425 rows=460012 loops=3)
                                 ->  Hash  (cost=2.41..2.41 rows=1 width=4) (actual time=0.025..0.025 rows=1 loops=3)
                                       Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                       ->  Seq Scan on info_type it  (cost=0.00..2.41 rows=1 width=4) (actual time=0.016..0.016 rows=1 loops=3)
                                             Filter: ((info)::text = 'top 250 rank'::text)
                                             Rows Removed by Filter: 112
                           ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..0.61 rows=1 width=32) (actual time=0.017..0.017 rows=0 loops=250)
                                 Index Cond: (movie_id = mi_idx.movie_id)
                                 Filter: ((note !~~ '%(as Metro-Goldwyn-Mayer Pictures)%'::text) AND (note ~~ '%(co-production)%'::text))
                                 Rows Removed by Filter: 33
                     ->  Memoize  (cost=0.16..0.19 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=23)
                           Cache Key: mc.company_type_id
                           Cache Mode: logical
                           Worker 0:  Hits: 0  Misses: 1  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                           Worker 1:  Hits: 21  Misses: 1  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                           ->  Index Scan using company_type_pkey on company_type ct  (cost=0.15..0.18 rows=1 width=4) (actual time=0.010..0.010 rows=1 loops=2)
                                 Index Cond: (id = mc.company_type_id)
                                 Filter: ((kind)::text = 'production companies'::text)
         ->  Index Scan using title_pkey on title t  (cost=0.43..0.58 rows=1 width=25) (actual time=0.008..0.008 rows=0 loops=23)
               Index Cond: (id = mi_idx.movie_id)
               Filter: (production_year > 2010)
               Rows Removed by Filter: 1
 Planning Time: 1.537 ms
 Execution Time: 53.450 ms
(34 rows)


                                                                                  QUERY PLAN                                                                                  
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=19519.88..19519.89 rows=1 width=68) (actual time=53.905..53.981 rows=1 loops=1)
   ->  Gather  (cost=1003.45..19519.87 rows=2 width=45) (actual time=48.363..53.915 rows=142 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         ->  Nested Loop  (cost=3.45..18519.67 rows=1 width=45) (actual time=45.959..48.738 rows=47 loops=3)
               Join Filter: (mc.movie_id = t.id)
               ->  Nested Loop  (cost=3.02..18519.08 rows=1 width=32) (actual time=45.932..48.233 rows=47 loops=3)
                     ->  Nested Loop  (cost=2.86..18515.36 rows=128 width=36) (actual time=45.917..48.200 rows=49 loops=3)
                           ->  Hash Join  (cost=2.43..15286.60 rows=5089 width=4) (actual time=45.858..45.882 rows=83 loops=3)
                                 Hash Cond: (mi_idx.info_type_id = it.id)
                                 ->  Parallel Seq Scan on movie_info_idx mi_idx  (cost=0.00..13718.15 rows=575015 width=8) (actual time=0.013..22.849 rows=460012 loops=3)
                                 ->  Hash  (cost=2.41..2.41 rows=1 width=4) (actual time=0.023..0.024 rows=1 loops=3)
                                       Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                       ->  Seq Scan on info_type it  (cost=0.00..2.41 rows=1 width=4) (actual time=0.014..0.015 rows=1 loops=3)
                                             Filter: ((info)::text = 'top 250 rank'::text)
                                             Rows Removed by Filter: 112
                           ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..0.62 rows=1 width=32) (actual time=0.027..0.028 rows=1 loops=250)
                                 Index Cond: (movie_id = mi_idx.movie_id)
                                 Filter: ((note !~~ '%(as Metro-Goldwyn-Mayer Pictures)%'::text) AND ((note ~~ '%(co-production)%'::text) OR (note ~~ '%(presents)%'::text)))
                                 Rows Removed by Filter: 33
                     ->  Memoize  (cost=0.16..0.18 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=147)
                           Cache Key: mc.company_type_id
                           Cache Mode: logical
                           Hits: 94  Misses: 1  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                           Worker 1:  Hits: 50  Misses: 2  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                           ->  Index Scan using company_type_pkey on company_type ct  (cost=0.15..0.17 rows=1 width=4) (actual time=0.013..0.013 rows=1 loops=3)
                                 Index Cond: (id = mc.company_type_id)
                                 Filter: ((kind)::text = 'production companies'::text)
                                 Rows Removed by Filter: 0
               ->  Index Scan using title_pkey on title t  (cost=0.43..0.58 rows=1 width=25) (actual time=0.010..0.010 rows=1 loops=142)
                     Index Cond: (id = mi_idx.movie_id)
 Planning Time: 2.034 ms
 Execution Time: 54.094 ms
(33 rows)


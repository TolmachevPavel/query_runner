                                                                                 QUERY PLAN                                                                                  
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=38864.60..38864.61 rows=1 width=32) (actual time=68.114..70.503 rows=1 loops=1)
   ->  Nested Loop  (cost=1001.17..38864.60 rows=1 width=17) (actual time=68.111..70.500 rows=0 loops=1)
         ->  Nested Loop  (cost=1001.02..38864.44 rows=1 width=21) (actual time=68.111..70.499 rows=0 loops=1)
               ->  Nested Loop  (cost=1000.59..38861.34 rows=1 width=25) (actual time=68.110..70.499 rows=0 loops=1)
                     ->  Gather  (cost=1000.16..38852.89 rows=1 width=4) (actual time=68.110..70.498 rows=0 loops=1)
                           Workers Planned: 2
                           Workers Launched: 2
                           ->  Nested Loop  (cost=0.16..37852.79 rows=1 width=4) (actual time=65.774..65.776 rows=0 loops=3)
                                 ->  Parallel Seq Scan on movie_companies mc  (cost=0.00..37848.90 rows=20 width=8) (actual time=0.933..65.639 rows=473 loops=3)
                                       Filter: ((note ~~ '%(VHS)%'::text) AND (note ~~ '%(USA)%'::text) AND (note ~~ '%(1994)%'::text))
                                       Rows Removed by Filter: 869237
                                 ->  Memoize  (cost=0.16..1.18 rows=1 width=4) (actual time=0.000..0.000 rows=0 loops=1418)
                                       Cache Key: mc.company_type_id
                                       Cache Mode: logical
                                       Hits: 461  Misses: 1  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                       Worker 0:  Hits: 488  Misses: 1  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                       Worker 1:  Hits: 466  Misses: 1  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                       ->  Index Scan using company_type_pkey on company_type ct  (cost=0.15..1.17 rows=1 width=4) (actual time=0.016..0.016 rows=0 loops=3)
                                             Index Cond: (id = mc.company_type_id)
                                             Filter: ((kind)::text = 'production companies'::text)
                                             Rows Removed by Filter: 1
                     ->  Index Scan using title_pkey on title t  (cost=0.43..8.45 rows=1 width=21) (never executed)
                           Index Cond: (id = mc.movie_id)
                           Filter: (production_year > 2010)
               ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..3.08 rows=2 width=8) (never executed)
                     Index Cond: (movie_id = t.id)
                     Filter: (info = ANY ('{USA,America}'::text[]))
         ->  Index Only Scan using info_type_pkey on info_type it  (cost=0.14..0.16 rows=1 width=4) (never executed)
               Index Cond: (id = mi.info_type_id)
               Heap Fetches: 0
 Planning Time: 1.449 ms
 Execution Time: 70.599 ms
(32 rows)


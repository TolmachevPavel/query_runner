                                                                                          QUERY PLAN                                                                                          
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=43727.36..43727.37 rows=1 width=64) (actual time=94.823..97.544 rows=1 loops=1)
   ->  Nested Loop  (cost=1002.30..43727.35 rows=1 width=33) (actual time=93.647..97.527 rows=6 loops=1)
         ->  Nested Loop  (cost=1002.15..43727.17 rows=1 width=37) (actual time=93.625..97.500 rows=6 loops=1)
               ->  Nested Loop  (cost=1001.73..43726.41 rows=1 width=45) (actual time=93.148..96.974 rows=171 loops=1)
                     ->  Nested Loop  (cost=1001.30..43725.36 rows=1 width=25) (actual time=93.130..96.388 rows=104 loops=1)
                           Join Filter: (ci.movie_id = t.id)
                           ->  Gather  (cost=1000.86..43579.18 rows=1 width=25) (actual time=93.094..95.813 rows=4 loops=1)
                                 Workers Planned: 2
                                 Workers Launched: 2
                                 ->  Nested Loop  (cost=0.86..42579.08 rows=1 width=25) (actual time=72.596..90.689 rows=1 loops=3)
                                       ->  Nested Loop  (cost=0.42..42512.66 rows=8 width=4) (actual time=0.207..73.787 rows=2832 loops=3)
                                             ->  Parallel Seq Scan on movie_companies mc  (cost=0.00..40566.74 rows=280 width=8) (actual time=0.183..68.439 rows=2856 loops=3)
                                                   Filter: ((note ~~ '%(Japan)%'::text) AND (note !~~ '%(USA)%'::text) AND ((note ~~ '%(2006)%'::text) OR (note ~~ '%(2007)%'::text)))
                                                   Rows Removed by Filter: 866853
                                             ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..6.95 rows=1 width=4) (actual time=0.002..0.002 rows=1 loops=8569)
                                                   Index Cond: (id = mc.company_id)
                                                   Filter: ((country_code)::text = '[jp]'::text)
                                                   Rows Removed by Filter: 0
                                       ->  Memoize  (cost=0.44..8.29 rows=1 width=21) (actual time=0.006..0.006 rows=0 loops=8495)
                                             Cache Key: mc.movie_id
                                             Cache Mode: logical
                                             Hits: 738  Misses: 2219  Evictions: 0  Overflows: 0  Memory Usage: 148kB
                                             Worker 0:  Hits: 800  Misses: 1937  Evictions: 0  Overflows: 0  Memory Usage: 129kB
                                             Worker 1:  Hits: 590  Misses: 2211  Evictions: 0  Overflows: 0  Memory Usage: 147kB
                                             ->  Index Scan using title_pkey on title t  (cost=0.43..8.28 rows=1 width=21) (actual time=0.007..0.007 rows=0 loops=6367)
                                                   Index Cond: (id = mc.movie_id)
                                                   Filter: ((production_year >= 2006) AND (production_year <= 2007) AND ((title ~~ 'One Piece%'::text) OR (title ~~ 'Dragon Ball Z%'::text)))
                                                   Rows Removed by Filter: 1
                           ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..146.17 rows=1 width=12) (actual time=0.041..0.140 rows=26 loops=4)
                                 Index Cond: (movie_id = mc.movie_id)
                                 Filter: (note = '(voice: English version)'::text)
                                 Rows Removed by Filter: 17
                     ->  Index Scan using person_id_aka_name on aka_name an  (cost=0.42..1.03 rows=2 width=20) (actual time=0.005..0.005 rows=2 loops=104)
                           Index Cond: (person_id = ci.person_id)
               ->  Index Scan using name_pkey on name n  (cost=0.43..0.77 rows=1 width=4) (actual time=0.003..0.003 rows=0 loops=171)
                     Index Cond: (id = an.person_id)
                     Filter: ((name ~~ '%Yo%'::text) AND (name !~~ '%Yu%'::text))
                     Rows Removed by Filter: 1
         ->  Index Scan using role_type_pkey on role_type rt  (cost=0.15..0.17 rows=1 width=4) (actual time=0.004..0.004 rows=1 loops=6)
               Index Cond: (id = ci.role_id)
               Filter: ((role)::text = 'actress'::text)
 Planning Time: 3.167 ms
 Execution Time: 97.738 ms
(43 rows)


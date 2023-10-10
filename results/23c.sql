                                                                                        QUERY PLAN                                                                                        
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=3856.14..3856.15 rows=1 width=64) (actual time=363.444..363.451 rows=1 loops=1)
   ->  Nested Loop  (cost=21.95..3856.13 rows=1 width=65) (actual time=81.225..363.333 rows=628 loops=1)
         ->  Nested Loop  (cost=21.52..3855.69 rows=1 width=69) (actual time=81.212..362.176 rows=628 loops=1)
               ->  Nested Loop  (cost=21.38..3855.40 rows=1 width=73) (actual time=81.205..361.772 rows=628 loops=1)
                     ->  Nested Loop  (cost=21.23..3855.24 rows=1 width=77) (actual time=81.175..361.366 rows=628 loops=1)
                           ->  Nested Loop  (cost=20.81..3854.79 rows=1 width=81) (actual time=81.150..360.727 rows=628 loops=1)
                                 Join Filter: (mc.movie_id = t.id)
                                 ->  Nested Loop  (cost=20.38..3854.19 rows=1 width=89) (actual time=81.127..360.020 rows=625 loops=1)
                                       ->  Nested Loop  (cost=19.95..3852.40 rows=1 width=81) (actual time=81.105..359.812 rows=6 loops=1)
                                             ->  Nested Loop  (cost=19.52..3833.58 rows=10 width=73) (actual time=0.105..114.356 rows=5053 loops=1)
                                                   ->  Nested Loop  (cost=19.36..3819.22 rows=527 width=29) (actual time=0.084..112.220 rows=6424 loops=1)
                                                         ->  Hash Join  (cost=18.93..2462.50 rows=761 width=4) (actual time=0.040..17.391 rows=24592 loops=1)
                                                               Hash Cond: (cc.status_id = cct1.id)
                                                               ->  Seq Scan on complete_cast cc  (cost=0.00..2086.86 rows=135086 width=8) (actual time=0.010..7.588 rows=135086 loops=1)
                                                               ->  Hash  (cost=18.88..18.88 rows=4 width=4) (actual time=0.017..0.018 rows=1 loops=1)
                                                                     Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                                     ->  Seq Scan on comp_cast_type cct1  (cost=0.00..18.88 rows=4 width=4) (actual time=0.011..0.011 rows=1 loops=1)
                                                                           Filter: ((kind)::text = 'complete+verified'::text)
                                                                           Rows Removed by Filter: 3
                                                         ->  Index Scan using title_pkey on title t  (cost=0.43..1.78 rows=1 width=25) (actual time=0.004..0.004 rows=0 loops=24592)
                                                               Index Cond: (id = cc.movie_id)
                                                               Filter: (production_year > 1990)
                                                               Rows Removed by Filter: 1
                                                   ->  Memoize  (cost=0.16..0.18 rows=1 width=52) (actual time=0.000..0.000 rows=1 loops=6424)
                                                         Cache Key: t.kind_id
                                                         Cache Mode: logical
                                                         Hits: 6419  Misses: 5  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                                         ->  Index Scan using kind_type_pkey on kind_type kt  (cost=0.15..0.17 rows=1 width=52) (actual time=0.005..0.005 rows=1 loops=5)
                                                               Index Cond: (id = t.kind_id)
                                                               Filter: ((kind)::text = ANY ('{movie,"tv movie","video movie","video game"}'::text[]))
                                                               Rows Removed by Filter: 0
                                             ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..1.87 rows=1 width=8) (actual time=0.048..0.048 rows=0 loops=5053)
                                                   Index Cond: (movie_id = t.id)
                                                   Filter: ((info IS NOT NULL) AND (note ~~ '%internet%'::text) AND ((info ~~ 'USA:% 199%'::text) OR (info ~~ 'USA:% 200%'::text)))
                                                   Rows Removed by Filter: 123
                                       ->  Index Scan using movie_id_movie_keyword on movie_keyword mk  (cost=0.43..1.32 rows=47 width=8) (actual time=0.009..0.025 rows=104 loops=6)
                                             Index Cond: (movie_id = t.id)
                                 ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..0.54 rows=5 width=12) (actual time=0.001..0.001 rows=1 loops=625)
                                       Index Cond: (movie_id = mk.movie_id)
                           ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..0.45 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=628)
                                 Index Cond: (id = mc.company_id)
                                 Filter: ((country_code)::text = '[us]'::text)
                     ->  Index Only Scan using company_type_pkey on company_type ct  (cost=0.15..0.17 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=628)
                           Index Cond: (id = mc.company_type_id)
                           Heap Fetches: 628
               ->  Index Scan using info_type_pkey on info_type it1  (cost=0.14..0.22 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=628)
                     Index Cond: (id = mi.info_type_id)
                     Filter: ((info)::text = 'release dates'::text)
         ->  Index Only Scan using keyword_pkey on keyword k  (cost=0.42..0.44 rows=1 width=4) (actual time=0.002..0.002 rows=1 loops=628)
               Index Cond: (id = mk.keyword_id)
               Heap Fetches: 0
 Planning Time: 27.472 ms
 Execution Time: 363.642 ms
(53 rows)


                                                                                        QUERY PLAN                                                                                        
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=3838.40..3838.41 rows=1 width=64) (actual time=188.680..188.686 rows=1 loops=1)
   ->  Nested Loop  (cost=21.95..3838.40 rows=1 width=65) (actual time=121.547..188.672 rows=16 loops=1)
         ->  Nested Loop  (cost=21.52..3837.94 rows=1 width=69) (actual time=120.131..187.249 rows=618 loops=1)
               ->  Nested Loop  (cost=21.38..3837.63 rows=1 width=73) (actual time=120.122..186.826 rows=618 loops=1)
                     ->  Nested Loop  (cost=21.23..3837.46 rows=1 width=77) (actual time=120.083..186.438 rows=618 loops=1)
                           ->  Nested Loop  (cost=20.81..3837.01 rows=1 width=81) (actual time=120.061..185.843 rows=618 loops=1)
                                 Join Filter: (mc.movie_id = t.id)
                                 ->  Nested Loop  (cost=20.38..3836.41 rows=1 width=89) (actual time=120.044..185.197 rows=615 loops=1)
                                       ->  Nested Loop  (cost=19.95..3834.60 rows=1 width=81) (actual time=120.023..185.050 rows=5 loops=1)
                                             ->  Nested Loop  (cost=19.52..3830.83 rows=2 width=73) (actual time=0.129..103.130 rows=1033 loops=1)
                                                   ->  Nested Loop  (cost=19.36..3819.22 rows=417 width=29) (actual time=0.108..102.349 rows=2083 loops=1)
                                                         ->  Hash Join  (cost=18.93..2462.50 rows=761 width=4) (actual time=0.042..16.289 rows=24592 loops=1)
                                                               Hash Cond: (cc.status_id = cct1.id)
                                                               ->  Seq Scan on complete_cast cc  (cost=0.00..2086.86 rows=135086 width=8) (actual time=0.011..7.143 rows=135086 loops=1)
                                                               ->  Hash  (cost=18.88..18.88 rows=4 width=4) (actual time=0.019..0.020 rows=1 loops=1)
                                                                     Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                                     ->  Seq Scan on comp_cast_type cct1  (cost=0.00..18.88 rows=4 width=4) (actual time=0.011..0.011 rows=1 loops=1)
                                                                           Filter: ((kind)::text = 'complete+verified'::text)
                                                                           Rows Removed by Filter: 3
                                                         ->  Index Scan using title_pkey on title t  (cost=0.43..1.78 rows=1 width=25) (actual time=0.003..0.003 rows=0 loops=24592)
                                                               Index Cond: (id = cc.movie_id)
                                                               Filter: (production_year > 2000)
                                                               Rows Removed by Filter: 1
                                                   ->  Memoize  (cost=0.16..0.18 rows=1 width=52) (actual time=0.000..0.000 rows=0 loops=2083)
                                                         Cache Key: t.kind_id
                                                         Cache Mode: logical
                                                         Hits: 2078  Misses: 5  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                                         ->  Index Scan using kind_type_pkey on kind_type kt  (cost=0.15..0.17 rows=1 width=52) (actual time=0.005..0.005 rows=0 loops=5)
                                                               Index Cond: (id = t.kind_id)
                                                               Filter: ((kind)::text = 'movie'::text)
                                                               Rows Removed by Filter: 1
                                             ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..1.88 rows=1 width=8) (actual time=0.079..0.079 rows=0 loops=1033)
                                                   Index Cond: (movie_id = t.id)
                                                   Filter: ((note ~~ '%internet%'::text) AND (info ~~ 'USA:% 200%'::text))
                                                   Rows Removed by Filter: 211
                                       ->  Index Scan using movie_id_movie_keyword on movie_keyword mk  (cost=0.43..1.34 rows=47 width=8) (actual time=0.007..0.019 rows=123 loops=5)
                                             Index Cond: (movie_id = t.id)
                                 ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..0.54 rows=5 width=12) (actual time=0.001..0.001 rows=1 loops=615)
                                       Index Cond: (movie_id = mk.movie_id)
                           ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..0.45 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=618)
                                 Index Cond: (id = mc.company_id)
                                 Filter: ((country_code)::text = '[us]'::text)
                     ->  Index Only Scan using company_type_pkey on company_type ct  (cost=0.15..0.17 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=618)
                           Index Cond: (id = mc.company_type_id)
                           Heap Fetches: 618
               ->  Index Scan using info_type_pkey on info_type it1  (cost=0.14..0.23 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=618)
                     Index Cond: (id = mi.info_type_id)
                     Filter: ((info)::text = 'release dates'::text)
         ->  Index Scan using keyword_pkey on keyword k  (cost=0.42..0.44 rows=1 width=4) (actual time=0.002..0.002 rows=0 loops=618)
               Index Cond: (id = mk.keyword_id)
               Filter: (keyword = ANY ('{nerd,loner,alienation,dignity}'::text[]))
               Rows Removed by Filter: 1
 Planning Time: 25.303 ms
 Execution Time: 188.874 ms
(54 rows)


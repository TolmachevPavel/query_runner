                                                                                                         QUERY PLAN                                                                                                          
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=2495.18..2495.19 rows=1 width=96) (actual time=3083.696..3083.705 rows=1 loops=1)
   ->  Nested Loop  (cost=22.66..2495.17 rows=1 width=41) (actual time=1.908..3081.409 rows=8373 loops=1)
         ->  Nested Loop  (cost=22.24..2494.28 rows=2 width=45) (actual time=1.349..1832.470 rows=1151351 loops=1)
               ->  Nested Loop  (cost=21.81..2492.43 rows=1 width=61) (actual time=1.320..1653.565 rows=11455 loops=1)
                     ->  Nested Loop  (cost=21.66..2492.26 rows=1 width=65) (actual time=1.302..1643.472 rows=11823 loops=1)
                           Join Filter: (mi.movie_id = t.id)
                           ->  Nested Loop  (cost=21.23..2491.66 rows=1 width=40) (actual time=0.514..1584.277 rows=28523 loops=1)
                                 ->  Nested Loop  (cost=21.09..2491.32 rows=2 width=44) (actual time=0.507..1558.565 rows=34753 loops=1)
                                       ->  Nested Loop  (cost=20.65..2489.10 rows=1 width=36) (actual time=0.253..496.303 rows=34765 loops=1)
                                             ->  Nested Loop  (cost=20.51..2488.59 rows=3 width=40) (actual time=0.244..429.421 rows=103875 loops=1)
                                                   ->  Nested Loop  (cost=20.09..2487.78 rows=1 width=27) (actual time=0.212..344.878 rows=37861 loops=1)
                                                         ->  Nested Loop  (cost=19.94..2487.61 rows=1 width=31) (actual time=0.183..319.098 rows=37861 loops=1)
                                                               ->  Nested Loop  (cost=19.52..2487.07 rows=1 width=16) (actual time=0.160..227.634 rows=41140 loops=1)
                                                                     ->  Nested Loop  (cost=19.09..2482.02 rows=4 width=4) (actual time=0.060..49.120 rows=68062 loops=1)
                                                                           ->  Hash Join  (cost=18.93..2462.50 rows=761 width=8) (actual time=0.042..26.540 rows=110494 loops=1)
                                                                                 Hash Cond: (cc.status_id = cct2.id)
                                                                                 ->  Seq Scan on complete_cast cc  (cost=0.00..2086.86 rows=135086 width=12) (actual time=0.011..8.114 rows=135086 loops=1)
                                                                                 ->  Hash  (cost=18.88..18.88 rows=4 width=4) (actual time=0.018..0.020 rows=1 loops=1)
                                                                                       Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                                                       ->  Seq Scan on comp_cast_type cct2  (cost=0.00..18.88 rows=4 width=4) (actual time=0.011..0.011 rows=1 loops=1)
                                                                                             Filter: ((kind)::text = 'complete'::text)
                                                                                             Rows Removed by Filter: 3
                                                                           ->  Memoize  (cost=0.16..0.18 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=110494)
                                                                                 Cache Key: cc.subject_id
                                                                                 Cache Mode: logical
                                                                                 Hits: 110492  Misses: 2  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                                                                 ->  Index Scan using comp_cast_type_pkey on comp_cast_type cct1  (cost=0.15..0.17 rows=1 width=4) (actual time=0.011..0.011 rows=0 loops=2)
                                                                                       Index Cond: (id = cc.subject_id)
                                                                                       Filter: ((kind)::text = 'cast'::text)
                                                                                       Rows Removed by Filter: 0
                                                                     ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..1.25 rows=1 width=12) (actual time=0.002..0.002 rows=1 loops=68062)
                                                                           Index Cond: (movie_id = cc.movie_id)
                                                                           Filter: ((note !~~ '%(USA)%'::text) AND (note ~~ '%(200%)%'::text))
                                                                           Rows Removed by Filter: 3
                                                               ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..0.55 rows=1 width=23) (actual time=0.002..0.002 rows=1 loops=41140)
                                                                     Index Cond: (id = mc.company_id)
                                                                     Filter: ((country_code)::text <> '[us]'::text)
                                                                     Rows Removed by Filter: 0
                                                         ->  Index Only Scan using company_type_pkey on company_type ct  (cost=0.15..0.17 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=37861)
                                                               Index Cond: (id = mc.company_type_id)
                                                               Heap Fetches: 37861
                                                   ->  Index Scan using movie_id_movie_info_idx on movie_info_idx mi_idx  (cost=0.43..0.78 rows=3 width=13) (actual time=0.002..0.002 rows=3 loops=37861)
                                                         Index Cond: (movie_id = mc.movie_id)
                                                         Filter: (info < '8.5'::text)
                                                         Rows Removed by Filter: 0
                                             ->  Index Scan using info_type_pkey on info_type it2  (cost=0.14..0.16 rows=1 width=4) (actual time=0.000..0.000 rows=0 loops=103875)
                                                   Index Cond: (id = mi_idx.info_type_id)
                                                   Filter: ((info)::text = 'rating'::text)
                                                   Rows Removed by Filter: 1
                                       ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..2.20 rows=2 width=8) (actual time=0.026..0.030 rows=1 loops=34765)
                                             Index Cond: (movie_id = mi_idx.movie_id)
                                             Filter: (info = ANY ('{Sweden,Norway,Germany,Denmark,Swedish,Danish,Norwegian,German,USA,American}'::text[]))
                                             Rows Removed by Filter: 121
                                 ->  Index Scan using info_type_pkey on info_type it1  (cost=0.14..0.16 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=34753)
                                       Index Cond: (id = mi.info_type_id)
                                       Filter: ((info)::text = 'countries'::text)
                                       Rows Removed by Filter: 0
                           ->  Index Scan using title_pkey on title t  (cost=0.43..0.58 rows=1 width=25) (actual time=0.002..0.002 rows=0 loops=28523)
                                 Index Cond: (id = mi_idx.movie_id)
                                 Filter: (production_year > 2005)
                                 Rows Removed by Filter: 1
                     ->  Index Scan using kind_type_pkey on kind_type kt  (cost=0.15..0.17 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=11823)
                           Index Cond: (id = t.kind_id)
                           Filter: ((kind)::text = ANY ('{movie,episode}'::text[]))
                           Rows Removed by Filter: 0
               ->  Index Scan using movie_id_movie_keyword on movie_keyword mk  (cost=0.43..1.37 rows=47 width=8) (actual time=0.002..0.009 rows=101 loops=11455)
                     Index Cond: (movie_id = t.id)
         ->  Index Scan using keyword_pkey on keyword k  (cost=0.42..0.44 rows=1 width=4) (actual time=0.001..0.001 rows=0 loops=1151351)
               Index Cond: (id = mk.keyword_id)
               Filter: (keyword = ANY ('{murder,murder-in-title,blood,violence}'::text[]))
               Rows Removed by Filter: 1
 Planning Time: 51.707 ms
 Execution Time: 3083.912 ms
(73 rows)


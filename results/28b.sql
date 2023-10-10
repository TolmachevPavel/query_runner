                                                                                                            QUERY PLAN                                                                                                            
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=3104.90..3104.91 rows=1 width=96) (actual time=2270.825..2270.831 rows=1 loops=1)
   ->  Nested Loop  (cost=22.51..3104.89 rows=1 width=41) (actual time=554.496..2270.761 rows=148 loops=1)
         ->  Nested Loop  (cost=22.36..3104.72 rows=1 width=45) (actual time=554.484..2270.550 rows=240 loops=1)
               ->  Nested Loop  (cost=22.22..3104.54 rows=1 width=49) (actual time=554.471..2270.252 rows=333 loops=1)
                     Join Filter: (mi.movie_id = t.id)
                     ->  Nested Loop  (cost=21.79..3103.01 rows=1 width=65) (actual time=149.837..2203.524 rows=1485 loops=1)
                           ->  Nested Loop  (cost=21.64..3102.84 rows=1 width=69) (actual time=149.816..2202.211 rows=1502 loops=1)
                                 ->  Nested Loop  (cost=21.21..3102.35 rows=1 width=44) (actual time=10.126..2180.142 rows=12790 loops=1)
                                       ->  Nested Loop  (cost=20.79..3097.90 rows=10 width=48) (actual time=9.772..506.006 rows=1554247 loops=1)
                                             ->  Nested Loop  (cost=20.35..3095.78 rows=1 width=40) (actual time=9.741..247.194 rows=17958 loops=1)
                                                   ->  Nested Loop  (cost=20.20..3095.61 rows=1 width=44) (actual time=9.706..234.820 rows=17958 loops=1)
                                                         ->  Nested Loop  (cost=19.78..3095.06 rows=1 width=29) (actual time=9.689..196.408 rows=18881 loops=1)
                                                               ->  Nested Loop  (cost=19.35..3091.57 rows=4 width=17) (actual time=9.650..111.699 rows=18297 loops=1)
                                                                     Join Filter: (it2.id = mi_idx.info_type_id)
                                                                     Rows Removed by Join Filter: 6593
                                                                     ->  Seq Scan on info_type it2  (cost=0.00..2.41 rows=1 width=4) (actual time=0.012..0.014 rows=1 loops=1)
                                                                           Filter: ((info)::text = 'rating'::text)
                                                                           Rows Removed by Filter: 112
                                                                     ->  Nested Loop  (cost=19.35..3083.00 rows=493 width=21) (actual time=9.637..109.768 rows=24890 loops=1)
                                                                           ->  Hash Join  (cost=18.93..2462.50 rows=761 width=8) (actual time=9.562..20.530 rows=49145 loops=1)
                                                                                 Hash Cond: (cc.subject_id = cct1.id)
                                                                                 ->  Seq Scan on complete_cast cc  (cost=0.00..2086.86 rows=135086 width=12) (actual time=0.009..8.753 rows=135086 loops=1)
                                                                                 ->  Hash  (cost=18.88..18.88 rows=4 width=4) (actual time=0.018..0.019 rows=1 loops=1)
                                                                                       Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                                                       ->  Seq Scan on comp_cast_type cct1  (cost=0.00..18.88 rows=4 width=4) (actual time=0.009..0.010 rows=1 loops=1)
                                                                                             Filter: ((kind)::text = 'crew'::text)
                                                                                             Rows Removed by Filter: 3
                                                                           ->  Index Scan using movie_id_movie_info_idx on movie_info_idx mi_idx  (cost=0.43..0.81 rows=1 width=13) (actual time=0.002..0.002 rows=1 loops=49145)
                                                                                 Index Cond: (movie_id = cc.movie_id)
                                                                                 Filter: (info > '6.5'::text)
                                                                                 Rows Removed by Filter: 2
                                                               ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..0.86 rows=1 width=12) (actual time=0.003..0.004 rows=1 loops=18297)
                                                                     Index Cond: (movie_id = mi_idx.movie_id)
                                                                     Filter: ((note !~~ '%(USA)%'::text) AND (note ~~ '%(200%)%'::text))
                                                                     Rows Removed by Filter: 5
                                                         ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..0.55 rows=1 width=23) (actual time=0.002..0.002 rows=1 loops=18881)
                                                               Index Cond: (id = mc.company_id)
                                                               Filter: ((country_code)::text <> '[us]'::text)
                                                               Rows Removed by Filter: 0
                                                   ->  Index Only Scan using company_type_pkey on company_type ct  (cost=0.15..0.17 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=17958)
                                                         Index Cond: (id = mc.company_type_id)
                                                         Heap Fetches: 17958
                                             ->  Index Scan using movie_id_movie_keyword on movie_keyword mk  (cost=0.43..1.65 rows=47 width=8) (actual time=0.002..0.008 rows=87 loops=17958)
                                                   Index Cond: (movie_id = mi_idx.movie_id)
                                       ->  Index Scan using keyword_pkey on keyword k  (cost=0.42..0.44 rows=1 width=4) (actual time=0.001..0.001 rows=0 loops=1554247)
                                             Index Cond: (id = mk.keyword_id)
                                             Filter: (keyword = ANY ('{murder,murder-in-title,blood,violence}'::text[]))
                                             Rows Removed by Filter: 1
                                 ->  Index Scan using title_pkey on title t  (cost=0.43..0.49 rows=1 width=25) (actual time=0.002..0.002 rows=0 loops=12790)
                                       Index Cond: (id = mk.movie_id)
                                       Filter: (production_year > 2005)
                                       Rows Removed by Filter: 1
                           ->  Index Scan using kind_type_pkey on kind_type kt  (cost=0.15..0.17 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=1502)
                                 Index Cond: (id = t.kind_id)
                                 Filter: ((kind)::text = ANY ('{movie,episode}'::text[]))
                                 Rows Removed by Filter: 0
                     ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..1.52 rows=1 width=8) (actual time=0.041..0.045 rows=0 loops=1485)
                           Index Cond: (movie_id = mk.movie_id)
                           Filter: (info = ANY ('{Sweden,Germany,Swedish,German}'::text[]))
                           Rows Removed by Filter: 349
               ->  Index Scan using info_type_pkey on info_type it1  (cost=0.14..0.16 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=333)
                     Index Cond: (id = mi.info_type_id)
                     Filter: ((info)::text = 'countries'::text)
                     Rows Removed by Filter: 0
         ->  Index Scan using comp_cast_type_pkey on comp_cast_type cct2  (cost=0.15..0.17 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=240)
               Index Cond: (id = cc.status_id)
               Filter: ((kind)::text <> 'complete+verified'::text)
               Rows Removed by Filter: 0
 Planning Time: 51.347 ms
 Execution Time: 2271.044 ms
(70 rows)


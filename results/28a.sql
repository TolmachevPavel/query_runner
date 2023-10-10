                                                                                                            QUERY PLAN                                                                                                            
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=3159.99..3160.00 rows=1 width=96) (actual time=2475.547..2475.552 rows=1 loops=1)
   ->  Nested Loop  (cost=22.51..3159.99 rows=1 width=41) (actual time=128.587..2474.132 rows=4803 loops=1)
         ->  Nested Loop  (cost=22.36..3159.81 rows=1 width=45) (actual time=18.150..2469.446 rows=6156 loops=1)
               ->  Nested Loop  (cost=22.21..3159.64 rows=1 width=49) (actual time=18.132..2464.373 rows=6332 loops=1)
                     ->  Nested Loop  (cost=21.79..3158.74 rows=2 width=53) (actual time=12.133..1491.953 rows=887521 loops=1)
                           ->  Nested Loop  (cost=21.36..3156.93 rows=1 width=69) (actual time=11.741..1349.126 rows=10103 loops=1)
                                 Join Filter: (mi.movie_id = t.id)
                                 ->  Nested Loop  (cost=20.93..3156.34 rows=1 width=44) (actual time=10.086..1301.344 rows=19838 loops=1)
                                       ->  Nested Loop  (cost=20.78..3156.17 rows=1 width=48) (actual time=10.058..1286.198 rows=19838 loops=1)
                                             ->  Nested Loop  (cost=20.36..3155.62 rows=1 width=33) (actual time=10.036..1233.668 rows=22380 loops=1)
                                                   ->  Nested Loop  (cost=20.22..3154.14 rows=9 width=37) (actual time=10.028..1201.229 rows=44868 loops=1)
                                                         ->  Nested Loop  (cost=19.78..3140.81 rows=6 width=29) (actual time=9.818..245.931 rows=27109 loops=1)
                                                               ->  Nested Loop  (cost=19.35..3128.33 rows=20 width=17) (actual time=9.692..123.812 rows=33339 loops=1)
                                                                     Join Filter: (it2.id = mi_idx.info_type_id)
                                                                     Rows Removed by Join Filter: 65679
                                                                     ->  Seq Scan on info_type it2  (cost=0.00..2.41 rows=1 width=4) (actual time=0.012..0.014 rows=1 loops=1)
                                                                           Filter: ((info)::text = 'rating'::text)
                                                                           Rows Removed by Filter: 112
                                                                     ->  Nested Loop  (cost=19.35..3098.22 rows=2216 width=21) (actual time=9.678..118.451 rows=99018 loops=1)
                                                                           ->  Hash Join  (cost=18.93..2462.50 rows=761 width=8) (actual time=9.647..22.124 rows=49145 loops=1)
                                                                                 Hash Cond: (cc.subject_id = cct1.id)
                                                                                 ->  Seq Scan on complete_cast cc  (cost=0.00..2086.86 rows=135086 width=12) (actual time=0.015..8.950 rows=135086 loops=1)
                                                                                 ->  Hash  (cost=18.88..18.88 rows=4 width=4) (actual time=0.017..0.018 rows=1 loops=1)
                                                                                       Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                                                       ->  Seq Scan on comp_cast_type cct1  (cost=0.00..18.88 rows=4 width=4) (actual time=0.009..0.009 rows=1 loops=1)
                                                                                             Filter: ((kind)::text = 'crew'::text)
                                                                                             Rows Removed by Filter: 3
                                                                           ->  Index Scan using movie_id_movie_info_idx on movie_info_idx mi_idx  (cost=0.43..0.81 rows=3 width=13) (actual time=0.001..0.002 rows=2 loops=49145)
                                                                                 Index Cond: (movie_id = cc.movie_id)
                                                                                 Filter: (info < '8.5'::text)
                                                                                 Rows Removed by Filter: 0
                                                               ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..0.61 rows=1 width=12) (actual time=0.003..0.003 rows=1 loops=33339)
                                                                     Index Cond: (movie_id = mi_idx.movie_id)
                                                                     Filter: ((note !~~ '%(USA)%'::text) AND (note ~~ '%(200%)%'::text))
                                                                     Rows Removed by Filter: 5
                                                         ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..2.20 rows=2 width=8) (actual time=0.027..0.035 rows=2 loops=27109)
                                                               Index Cond: (movie_id = mi_idx.movie_id)
                                                               Filter: (info = ANY ('{Sweden,Norway,Germany,Denmark,Swedish,Danish,Norwegian,German,USA,American}'::text[]))
                                                               Rows Removed by Filter: 135
                                                   ->  Index Scan using info_type_pkey on info_type it1  (cost=0.14..0.16 rows=1 width=4) (actual time=0.001..0.001 rows=0 loops=44868)
                                                         Index Cond: (id = mi.info_type_id)
                                                         Filter: ((info)::text = 'countries'::text)
                                                         Rows Removed by Filter: 1
                                             ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..0.55 rows=1 width=23) (actual time=0.002..0.002 rows=1 loops=22380)
                                                   Index Cond: (id = mc.company_id)
                                                   Filter: ((country_code)::text <> '[us]'::text)
                                                   Rows Removed by Filter: 0
                                       ->  Index Only Scan using company_type_pkey on company_type ct  (cost=0.15..0.17 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=19838)
                                             Index Cond: (id = mc.company_type_id)
                                             Heap Fetches: 19838
                                 ->  Index Scan using title_pkey on title t  (cost=0.43..0.58 rows=1 width=25) (actual time=0.002..0.002 rows=1 loops=19838)
                                       Index Cond: (id = mi_idx.movie_id)
                                       Filter: (production_year > 2000)
                                       Rows Removed by Filter: 0
                           ->  Index Scan using movie_id_movie_keyword on movie_keyword mk  (cost=0.43..1.34 rows=47 width=8) (actual time=0.001..0.008 rows=88 loops=10103)
                                 Index Cond: (movie_id = t.id)
                     ->  Index Scan using keyword_pkey on keyword k  (cost=0.42..0.44 rows=1 width=4) (actual time=0.001..0.001 rows=0 loops=887521)
                           Index Cond: (id = mk.keyword_id)
                           Filter: (keyword = ANY ('{murder,murder-in-title,blood,violence}'::text[]))
                           Rows Removed by Filter: 1
               ->  Index Scan using kind_type_pkey on kind_type kt  (cost=0.15..0.17 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=6332)
                     Index Cond: (id = t.kind_id)
                     Filter: ((kind)::text = ANY ('{movie,episode}'::text[]))
                     Rows Removed by Filter: 0
         ->  Index Scan using comp_cast_type_pkey on comp_cast_type cct2  (cost=0.15..0.17 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=6156)
               Index Cond: (id = cc.status_id)
               Filter: ((kind)::text <> 'complete+verified'::text)
               Rows Removed by Filter: 0
 Planning Time: 52.756 ms
 Execution Time: 2475.756 ms
(70 rows)


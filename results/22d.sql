                                                                                               QUERY PLAN                                                                                                
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=7594.03..7594.04 rows=1 width=96) (actual time=1595.410..1595.415 rows=1 loops=1)
   ->  Nested Loop  (cost=8.95..7594.02 rows=1 width=41) (actual time=4.370..1586.184 rows=46281 loops=1)
         Join Filter: (it2.id = mi_idx.info_type_id)
         Rows Removed by Join Filter: 93201
         ->  Nested Loop  (cost=8.95..7591.60 rows=1 width=45) (actual time=3.819..895.204 rows=139482 loops=1)
               Join Filter: (mi_idx.movie_id = t.id)
               ->  Nested Loop  (cost=8.52..7591.06 rows=1 width=52) (actual time=3.797..805.500 rows=47475 loops=1)
                     Join Filter: (ct.id = mc.company_type_id)
                     Rows Removed by Join Filter: 4948
                     ->  Nested Loop  (cost=8.52..7565.09 rows=1 width=56) (actual time=3.788..775.131 rows=47475 loops=1)
                           ->  Nested Loop  (cost=8.10..7564.64 rows=1 width=41) (actual time=2.670..640.151 rows=68049 loops=1)
                                 Join Filter: (mc.movie_id = t.id)
                                 ->  Nested Loop  (cost=7.67..7564.04 rows=1 width=29) (actual time=2.641..591.386 rows=5316 loops=1)
                                       Join Filter: (it1.id = mi.info_type_id)
                                       Rows Removed by Join Filter: 701
                                       ->  Nested Loop  (cost=7.67..7561.62 rows=1 width=33) (actual time=2.636..577.725 rows=6017 loops=1)
                                             Join Filter: (mi.movie_id = t.id)
                                             ->  Nested Loop  (cost=7.23..7559.77 rows=1 width=25) (actual time=2.586..258.837 rows=8073 loops=1)
                                                   Join Filter: (kt.id = t.kind_id)
                                                   Rows Removed by Join Filter: 4332
                                                   ->  Nested Loop  (cost=7.23..7528.89 rows=54 width=29) (actual time=2.525..256.175 rows=9739 loops=1)
                                                         ->  Nested Loop  (cost=6.80..7462.77 rows=135 width=4) (actual time=2.499..113.487 rows=37091 loops=1)
                                                               ->  Seq Scan on keyword k  (cost=0.00..3020.55 rows=4 width=4) (actual time=0.630..12.005 rows=3 loops=1)
                                                                     Filter: (keyword = ANY ('{murder,murder-in-title,blood,violence}'::text[]))
                                                                     Rows Removed by Filter: 134167
                                                               ->  Bitmap Heap Scan on movie_keyword mk  (cost=6.80..1107.50 rows=306 width=8) (actual time=1.849..32.702 rows=12364 loops=3)
                                                                     Recheck Cond: (k.id = keyword_id)
                                                                     Heap Blocks: exact=26312
                                                                     ->  Bitmap Index Scan on keyword_id_movie_keyword  (cost=0.00..6.73 rows=306 width=0) (actual time=0.978..0.978 rows=12364 loops=3)
                                                                           Index Cond: (keyword_id = k.id)
                                                         ->  Index Scan using title_pkey on title t  (cost=0.43..0.49 rows=1 width=25) (actual time=0.004..0.004 rows=0 loops=37091)
                                                               Index Cond: (id = mk.movie_id)
                                                               Filter: (production_year > 2005)
                                                               Rows Removed by Filter: 1
                                                   ->  Materialize  (cost=0.00..22.80 rows=10 width=4) (actual time=0.000..0.000 rows=1 loops=9739)
                                                         ->  Seq Scan on kind_type kt  (cost=0.00..22.75 rows=10 width=4) (actual time=0.019..0.020 rows=2 loops=1)
                                                               Filter: ((kind)::text = ANY ('{movie,episode}'::text[]))
                                                               Rows Removed by Filter: 5
                                             ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..1.82 rows=2 width=8) (actual time=0.034..0.039 rows=1 loops=8073)
                                                   Index Cond: (movie_id = mk.movie_id)
                                                   Filter: (info = ANY ('{Sweden,Norway,Germany,Denmark,Swedish,Danish,Norwegian,German,USA,American}'::text[]))
                                                   Rows Removed by Filter: 57
                                       ->  Seq Scan on info_type it1  (cost=0.00..2.41 rows=1 width=4) (actual time=0.001..0.002 rows=1 loops=6017)
                                             Filter: ((info)::text = 'countries'::text)
                                             Rows Removed by Filter: 19
                                 ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..0.54 rows=5 width=12) (actual time=0.005..0.008 rows=13 loops=5316)
                                       Index Cond: (movie_id = mk.movie_id)
                           ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..0.45 rows=1 width=23) (actual time=0.002..0.002 rows=1 loops=68049)
                                 Index Cond: (id = mc.company_id)
                                 Filter: ((country_code)::text <> '[us]'::text)
                                 Rows Removed by Filter: 0
                     ->  Seq Scan on company_type ct  (cost=0.00..17.10 rows=710 width=4) (actual time=0.000..0.000 rows=1 loops=47475)
               ->  Index Scan using movie_id_movie_info_idx on movie_info_idx mi_idx  (cost=0.43..0.50 rows=3 width=13) (actual time=0.001..0.002 rows=3 loops=47475)
                     Index Cond: (movie_id = mk.movie_id)
                     Filter: (info < '8.5'::text)
                     Rows Removed by Filter: 0
         ->  Seq Scan on info_type it2  (cost=0.00..2.41 rows=1 width=4) (actual time=0.004..0.005 rows=1 loops=139482)
               Filter: ((info)::text = 'rating'::text)
               Rows Removed by Filter: 108
 Planning Time: 32.964 ms
 Execution Time: 1595.585 ms
(61 rows)


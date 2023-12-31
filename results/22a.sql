                                                                                               QUERY PLAN                                                                                                
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=7590.95..7590.96 rows=1 width=96) (actual time=520.651..520.657 rows=1 loops=1)
   ->  Nested Loop  (cost=8.95..7590.94 rows=1 width=41) (actual time=10.801..520.028 rows=2851 loops=1)
         Join Filter: (it2.id = mi_idx.info_type_id)
         Rows Removed by Join Filter: 7729
         ->  Nested Loop  (cost=8.95..7588.52 rows=1 width=45) (actual time=6.711..468.518 rows=10580 loops=1)
               Join Filter: (mi_idx.movie_id = t.id)
               ->  Nested Loop  (cost=8.52..7587.98 rows=1 width=52) (actual time=6.691..459.643 rows=3994 loops=1)
                     Join Filter: (it1.id = mi.info_type_id)
                     Rows Removed by Join Filter: 380
                     ->  Nested Loop  (cost=8.52..7585.56 rows=1 width=56) (actual time=6.687..451.097 rows=4374 loops=1)
                           Join Filter: (mi.movie_id = t.id)
                           ->  Nested Loop  (cost=8.08..7584.01 rows=1 width=48) (actual time=4.148..324.759 rows=4302 loops=1)
                                 Join Filter: (ct.id = mc.company_type_id)
                                 ->  Nested Loop  (cost=8.08..7558.04 rows=1 width=52) (actual time=4.139..321.826 rows=4302 loops=1)
                                       ->  Nested Loop  (cost=7.66..7557.49 rows=1 width=37) (actual time=4.121..306.901 rows=4808 loops=1)
                                             Join Filter: (mc.movie_id = t.id)
                                             ->  Nested Loop  (cost=7.23..7556.92 rows=1 width=25) (actual time=2.582..265.506 rows=4832 loops=1)
                                                   Join Filter: (kt.id = t.kind_id)
                                                   Rows Removed by Join Filter: 2286
                                                   ->  Nested Loop  (cost=7.23..7528.89 rows=35 width=29) (actual time=2.552..264.072 rows=5606 loops=1)
                                                         ->  Nested Loop  (cost=6.80..7462.77 rows=135 width=4) (actual time=2.490..118.717 rows=37091 loops=1)
                                                               ->  Seq Scan on keyword k  (cost=0.00..3020.55 rows=4 width=4) (actual time=0.604..12.241 rows=3 loops=1)
                                                                     Filter: (keyword = ANY ('{murder,murder-in-title,blood,violence}'::text[]))
                                                                     Rows Removed by Filter: 134167
                                                               ->  Bitmap Heap Scan on movie_keyword mk  (cost=6.80..1107.50 rows=306 width=8) (actual time=1.918..34.416 rows=12364 loops=3)
                                                                     Recheck Cond: (k.id = keyword_id)
                                                                     Heap Blocks: exact=26312
                                                                     ->  Bitmap Index Scan on keyword_id_movie_keyword  (cost=0.00..6.73 rows=306 width=0) (actual time=1.035..1.035 rows=12364 loops=3)
                                                                           Index Cond: (keyword_id = k.id)
                                                         ->  Index Scan using title_pkey on title t  (cost=0.43..0.49 rows=1 width=25) (actual time=0.004..0.004 rows=0 loops=37091)
                                                               Index Cond: (id = mk.movie_id)
                                                               Filter: (production_year > 2008)
                                                               Rows Removed by Filter: 1
                                                   ->  Materialize  (cost=0.00..22.80 rows=10 width=4) (actual time=0.000..0.000 rows=1 loops=5606)
                                                         ->  Seq Scan on kind_type kt  (cost=0.00..22.75 rows=10 width=4) (actual time=0.013..0.014 rows=2 loops=1)
                                                               Filter: ((kind)::text = ANY ('{movie,episode}'::text[]))
                                                               Rows Removed by Filter: 5
                                             ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..0.56 rows=1 width=12) (actual time=0.007..0.008 rows=1 loops=4832)
                                                   Index Cond: (movie_id = mk.movie_id)
                                                   Filter: ((note !~~ '%(USA)%'::text) AND (note ~~ '%(200%)%'::text))
                                                   Rows Removed by Filter: 8
                                       ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..0.55 rows=1 width=23) (actual time=0.003..0.003 rows=1 loops=4808)
                                             Index Cond: (id = mc.company_id)
                                             Filter: ((country_code)::text <> '[us]'::text)
                                             Rows Removed by Filter: 0
                                 ->  Seq Scan on company_type ct  (cost=0.00..17.10 rows=710 width=4) (actual time=0.000..0.000 rows=1 loops=4302)
                           ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..1.52 rows=2 width=8) (actual time=0.025..0.029 rows=1 loops=4302)
                                 Index Cond: (movie_id = mk.movie_id)
                                 Filter: (info = ANY ('{Germany,German,USA,American}'::text[]))
                                 Rows Removed by Filter: 185
                     ->  Seq Scan on info_type it1  (cost=0.00..2.41 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=4374)
                           Filter: ((info)::text = 'countries'::text)
                           Rows Removed by Filter: 16
               ->  Index Scan using movie_id_movie_info_idx on movie_info_idx mi_idx  (cost=0.43..0.50 rows=3 width=13) (actual time=0.001..0.002 rows=3 loops=3994)
                     Index Cond: (movie_id = mk.movie_id)
                     Filter: (info < '7.0'::text)
                     Rows Removed by Filter: 0
         ->  Seq Scan on info_type it2  (cost=0.00..2.41 rows=1 width=4) (actual time=0.004..0.004 rows=1 loops=10580)
               Filter: ((info)::text = 'rating'::text)
               Rows Removed by Filter: 109
 Planning Time: 30.190 ms
 Execution Time: 520.830 ms
(62 rows)


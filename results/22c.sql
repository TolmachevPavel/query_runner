                                                                                               QUERY PLAN                                                                                                
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=7594.11..7594.12 rows=1 width=96) (actual time=1742.282..1742.287 rows=1 loops=1)
   ->  Nested Loop  (cost=8.95..7594.10 rows=1 width=41) (actual time=3.923..1737.803 rows=21489 loops=1)
         Join Filter: (it2.id = mi_idx.info_type_id)
         Rows Removed by Join Filter: 43139
         ->  Nested Loop  (cost=8.95..7591.67 rows=1 width=45) (actual time=3.503..1429.492 rows=64628 loops=1)
               Join Filter: (mi_idx.movie_id = t.id)
               ->  Nested Loop  (cost=8.52..7591.14 rows=1 width=52) (actual time=3.483..1383.570 rows=21827 loops=1)
                     Join Filter: (it1.id = mi.info_type_id)
                     Rows Removed by Join Filter: 3193
                     ->  Nested Loop  (cost=8.52..7588.71 rows=1 width=56) (actual time=3.478..1331.672 rows=25020 loops=1)
                           Join Filter: (mi.movie_id = t.id)
                           ->  Nested Loop  (cost=8.08..7586.86 rows=1 width=48) (actual time=3.392..408.929 rows=23902 loops=1)
                                 Join Filter: (ct.id = mc.company_type_id)
                                 ->  Nested Loop  (cost=8.08..7560.89 rows=1 width=52) (actual time=3.384..392.994 rows=23902 loops=1)
                                       ->  Nested Loop  (cost=7.66..7560.34 rows=1 width=37) (actual time=3.359..332.364 rows=25853 loops=1)
                                             Join Filter: (mc.movie_id = t.id)
                                             ->  Nested Loop  (cost=7.23..7559.77 rows=1 width=25) (actual time=2.519..263.556 rows=8073 loops=1)
                                                   Join Filter: (kt.id = t.kind_id)
                                                   Rows Removed by Join Filter: 4332
                                                   ->  Nested Loop  (cost=7.23..7528.89 rows=54 width=29) (actual time=2.473..261.098 rows=9739 loops=1)
                                                         ->  Nested Loop  (cost=6.80..7462.77 rows=135 width=4) (actual time=2.456..114.791 rows=37091 loops=1)
                                                               ->  Seq Scan on keyword k  (cost=0.00..3020.55 rows=4 width=4) (actual time=0.622..11.940 rows=3 loops=1)
                                                                     Filter: (keyword = ANY ('{murder,murder-in-title,blood,violence}'::text[]))
                                                                     Rows Removed by Filter: 134167
                                                               ->  Bitmap Heap Scan on movie_keyword mk  (cost=6.80..1107.50 rows=306 width=8) (actual time=1.838..33.102 rows=12364 loops=3)
                                                                     Recheck Cond: (k.id = keyword_id)
                                                                     Heap Blocks: exact=26312
                                                                     ->  Bitmap Index Scan on keyword_id_movie_keyword  (cost=0.00..6.73 rows=306 width=0) (actual time=0.979..0.979 rows=12364 loops=3)
                                                                           Index Cond: (keyword_id = k.id)
                                                         ->  Index Scan using title_pkey on title t  (cost=0.43..0.49 rows=1 width=25) (actual time=0.004..0.004 rows=0 loops=37091)
                                                               Index Cond: (id = mk.movie_id)
                                                               Filter: (production_year > 2005)
                                                               Rows Removed by Filter: 1
                                                   ->  Materialize  (cost=0.00..22.80 rows=10 width=4) (actual time=0.000..0.000 rows=1 loops=9739)
                                                         ->  Seq Scan on kind_type kt  (cost=0.00..22.75 rows=10 width=4) (actual time=0.009..0.009 rows=2 loops=1)
                                                               Filter: ((kind)::text = ANY ('{movie,episode}'::text[]))
                                                               Rows Removed by Filter: 5
                                             ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..0.56 rows=1 width=12) (actual time=0.006..0.008 rows=3 loops=8073)
                                                   Index Cond: (movie_id = mk.movie_id)
                                                   Filter: ((note !~~ '%(USA)%'::text) AND (note ~~ '%(200%)%'::text))
                                                   Rows Removed by Filter: 7
                                       ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..0.55 rows=1 width=23) (actual time=0.002..0.002 rows=1 loops=25853)
                                             Index Cond: (id = mc.company_id)
                                             Filter: ((country_code)::text <> '[us]'::text)
                                             Rows Removed by Filter: 0
                                 ->  Seq Scan on company_type ct  (cost=0.00..17.10 rows=710 width=4) (actual time=0.000..0.000 rows=1 loops=23902)
                           ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..1.82 rows=2 width=8) (actual time=0.032..0.038 rows=1 loops=23902)
                                 Index Cond: (movie_id = mk.movie_id)
                                 Filter: (info = ANY ('{Sweden,Norway,Germany,Denmark,Swedish,Danish,Norwegian,German,USA,American}'::text[]))
                                 Rows Removed by Filter: 184
                     ->  Seq Scan on info_type it1  (cost=0.00..2.41 rows=1 width=4) (actual time=0.001..0.002 rows=1 loops=25020)
                           Filter: ((info)::text = 'countries'::text)
                           Rows Removed by Filter: 20
               ->  Index Scan using movie_id_movie_info_idx on movie_info_idx mi_idx  (cost=0.43..0.50 rows=3 width=13) (actual time=0.001..0.002 rows=3 loops=21827)
                     Index Cond: (movie_id = mk.movie_id)
                     Filter: (info < '8.5'::text)
                     Rows Removed by Filter: 0
         ->  Seq Scan on info_type it2  (cost=0.00..2.41 rows=1 width=4) (actual time=0.004..0.004 rows=1 loops=64628)
               Filter: ((info)::text = 'rating'::text)
               Rows Removed by Filter: 108
 Planning Time: 31.126 ms
 Execution Time: 1742.463 ms
(62 rows)


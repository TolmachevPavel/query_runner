                                                                                      QUERY PLAN                                                                                       
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=7560.47..7560.48 rows=1 width=64) (actual time=354.217..354.220 rows=1 loops=1)
   ->  Nested Loop  (cost=8.10..7560.46 rows=1 width=22) (actual time=10.862..354.015 rows=761 loops=1)
         Join Filter: (it2.id = mi_idx.info_type_id)
         Rows Removed by Join Filter: 1501
         ->  Nested Loop  (cost=8.10..7558.04 rows=1 width=26) (actual time=10.172..343.469 rows=2262 loops=1)
               Join Filter: (mi_idx.movie_id = t.id)
               ->  Nested Loop  (cost=7.67..7557.50 rows=1 width=29) (actual time=10.138..336.293 rows=1281 loops=1)
                     Join Filter: (it1.id = mi.info_type_id)
                     Rows Removed by Join Filter: 164
                     ->  Nested Loop  (cost=7.67..7555.08 rows=1 width=33) (actual time=10.133..333.189 rows=1445 loops=1)
                           Join Filter: (mi.movie_id = t.id)
                           ->  Nested Loop  (cost=7.23..7553.23 rows=1 width=25) (actual time=10.050..249.543 rows=1966 loops=1)
                                 Join Filter: (kt.id = t.kind_id)
                                 Rows Removed by Join Filter: 616
                                 ->  Nested Loop  (cost=7.23..7528.89 rows=21 width=29) (actual time=2.614..248.905 rows=2582 loops=1)
                                       ->  Nested Loop  (cost=6.80..7462.77 rows=135 width=4) (actual time=2.443..113.263 rows=37091 loops=1)
                                             ->  Seq Scan on keyword k  (cost=0.00..3020.55 rows=4 width=4) (actual time=0.628..11.701 rows=3 loops=1)
                                                   Filter: (keyword = ANY ('{murder,murder-in-title,blood,violence}'::text[]))
                                                   Rows Removed by Filter: 134167
                                             ->  Bitmap Heap Scan on movie_keyword mk  (cost=6.80..1107.50 rows=306 width=8) (actual time=1.774..32.781 rows=12364 loops=3)
                                                   Recheck Cond: (k.id = keyword_id)
                                                   Heap Blocks: exact=26312
                                                   ->  Bitmap Index Scan on keyword_id_movie_keyword  (cost=0.00..6.73 rows=306 width=0) (actual time=0.945..0.945 rows=12364 loops=3)
                                                         Index Cond: (keyword_id = k.id)
                                       ->  Index Scan using title_pkey on title t  (cost=0.43..0.49 rows=1 width=25) (actual time=0.003..0.003 rows=0 loops=37091)
                                             Index Cond: (id = mk.movie_id)
                                             Filter: (production_year > 2010)
                                             Rows Removed by Filter: 1
                                 ->  Materialize  (cost=0.00..22.77 rows=5 width=4) (actual time=0.000..0.000 rows=1 loops=2582)
                                       ->  Seq Scan on kind_type kt  (cost=0.00..22.75 rows=5 width=4) (actual time=0.007..0.007 rows=1 loops=1)
                                             Filter: ((kind)::text = 'movie'::text)
                                             Rows Removed by Filter: 6
                           ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..1.82 rows=2 width=8) (actual time=0.036..0.042 rows=1 loops=1966)
                                 Index Cond: (movie_id = mk.movie_id)
                                 Filter: (info = ANY ('{Sweden,Norway,Germany,Denmark,Swedish,Denish,Norwegian,German,USA,American}'::text[]))
                                 Rows Removed by Filter: 47
                     ->  Seq Scan on info_type it1  (cost=0.00..2.41 rows=1 width=4) (actual time=0.001..0.002 rows=1 loops=1445)
                           Filter: ((info)::text = 'countries'::text)
                           Rows Removed by Filter: 19
               ->  Index Scan using movie_id_movie_info_idx on movie_info_idx mi_idx  (cost=0.43..0.50 rows=3 width=13) (actual time=0.005..0.005 rows=2 loops=1281)
                     Index Cond: (movie_id = mk.movie_id)
                     Filter: (info < '8.5'::text)
                     Rows Removed by Filter: 0
         ->  Seq Scan on info_type it2  (cost=0.00..2.41 rows=1 width=4) (actual time=0.004..0.004 rows=1 loops=2262)
               Filter: ((info)::text = 'rating'::text)
               Rows Removed by Filter: 108
 Planning Time: 4.847 ms
 Execution Time: 354.362 ms
(48 rows)


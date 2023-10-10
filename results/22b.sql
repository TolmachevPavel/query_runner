                                                                                               QUERY PLAN                                                                                                
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=7589.90..7589.91 rows=1 width=96) (actual time=288.193..288.199 rows=1 loops=1)
   ->  Nested Loop  (cost=8.95..7589.89 rows=1 width=41) (actual time=12.946..288.153 rows=31 loops=1)
         Join Filter: (it2.id = mi_idx.info_type_id)
         Rows Removed by Join Filter: 61
         ->  Nested Loop  (cost=8.95..7587.47 rows=1 width=45) (actual time=12.928..287.695 rows=92 loops=1)
               Join Filter: (mi_idx.movie_id = t.id)
               ->  Nested Loop  (cost=8.52..7586.93 rows=1 width=52) (actual time=12.902..287.421 rows=34 loops=1)
                     Join Filter: (it1.id = mi.info_type_id)
                     Rows Removed by Join Filter: 3
                     ->  Nested Loop  (cost=8.52..7584.51 rows=1 width=56) (actual time=12.897..287.310 rows=37 loops=1)
                           Join Filter: (mi.movie_id = t.id)
                           ->  Nested Loop  (cost=8.08..7582.96 rows=1 width=48) (actual time=12.822..284.368 rows=62 loops=1)
                                 Join Filter: (ct.id = mc.company_type_id)
                                 ->  Nested Loop  (cost=8.08..7556.99 rows=1 width=52) (actual time=12.811..284.247 rows=62 loops=1)
                                       ->  Nested Loop  (cost=7.66..7556.44 rows=1 width=37) (actual time=12.775..283.558 rows=95 loops=1)
                                             Join Filter: (mc.movie_id = t.id)
                                             ->  Nested Loop  (cost=7.23..7555.87 rows=1 width=25) (actual time=2.514..254.827 rows=3517 loops=1)
                                                   Join Filter: (kt.id = t.kind_id)
                                                   Rows Removed by Join Filter: 1618
                                                   ->  Nested Loop  (cost=7.23..7528.89 rows=28 width=29) (actual time=2.496..253.793 rows=4040 loops=1)
                                                         ->  Nested Loop  (cost=6.80..7462.77 rows=135 width=4) (actual time=2.437..115.939 rows=37091 loops=1)
                                                               ->  Seq Scan on keyword k  (cost=0.00..3020.55 rows=4 width=4) (actual time=0.609..11.739 rows=3 loops=1)
                                                                     Filter: (keyword = ANY ('{murder,murder-in-title,blood,violence}'::text[]))
                                                                     Rows Removed by Filter: 134167
                                                               ->  Bitmap Heap Scan on movie_keyword mk  (cost=6.80..1107.50 rows=306 width=8) (actual time=1.822..33.679 rows=12364 loops=3)
                                                                     Recheck Cond: (k.id = keyword_id)
                                                                     Heap Blocks: exact=26312
                                                                     ->  Bitmap Index Scan on keyword_id_movie_keyword  (cost=0.00..6.73 rows=306 width=0) (actual time=0.943..0.943 rows=12364 loops=3)
                                                                           Index Cond: (keyword_id = k.id)
                                                         ->  Index Scan using title_pkey on title t  (cost=0.43..0.49 rows=1 width=25) (actual time=0.004..0.004 rows=0 loops=37091)
                                                               Index Cond: (id = mk.movie_id)
                                                               Filter: (production_year > 2009)
                                                               Rows Removed by Filter: 1
                                                   ->  Materialize  (cost=0.00..22.80 rows=10 width=4) (actual time=0.000..0.000 rows=1 loops=4040)
                                                         ->  Seq Scan on kind_type kt  (cost=0.00..22.75 rows=10 width=4) (actual time=0.013..0.014 rows=2 loops=1)
                                                               Filter: ((kind)::text = ANY ('{movie,episode}'::text[]))
                                                               Rows Removed by Filter: 5
                                             ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..0.56 rows=1 width=12) (actual time=0.008..0.008 rows=0 loops=3517)
                                                   Index Cond: (movie_id = mk.movie_id)
                                                   Filter: ((note !~~ '%(USA)%'::text) AND (note ~~ '%(200%)%'::text))
                                                   Rows Removed by Filter: 8
                                       ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..0.55 rows=1 width=23) (actual time=0.007..0.007 rows=1 loops=95)
                                             Index Cond: (id = mc.company_id)
                                             Filter: ((country_code)::text <> '[us]'::text)
                                             Rows Removed by Filter: 0
                                 ->  Seq Scan on company_type ct  (cost=0.00..17.10 rows=710 width=4) (actual time=0.001..0.001 rows=1 loops=62)
                           ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..1.52 rows=2 width=8) (actual time=0.044..0.047 rows=1 loops=62)
                                 Index Cond: (movie_id = mk.movie_id)
                                 Filter: (info = ANY ('{Germany,German,USA,American}'::text[]))
                                 Rows Removed by Filter: 48
                     ->  Seq Scan on info_type it1  (cost=0.00..2.41 rows=1 width=4) (actual time=0.002..0.002 rows=1 loops=37)
                           Filter: ((info)::text = 'countries'::text)
                           Rows Removed by Filter: 16
               ->  Index Scan using movie_id_movie_info_idx on movie_info_idx mi_idx  (cost=0.43..0.50 rows=3 width=13) (actual time=0.007..0.007 rows=3 loops=34)
                     Index Cond: (movie_id = mk.movie_id)
                     Filter: (info < '7.0'::text)
                     Rows Removed by Filter: 0
         ->  Seq Scan on info_type it2  (cost=0.00..2.41 rows=1 width=4) (actual time=0.004..0.004 rows=1 loops=92)
               Filter: ((info)::text = 'rating'::text)
               Rows Removed by Filter: 108
 Planning Time: 30.826 ms
 Execution Time: 288.370 ms
(62 rows)


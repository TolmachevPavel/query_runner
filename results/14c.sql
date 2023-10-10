                                                                                      QUERY PLAN                                                                                       
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=7567.01..7567.02 rows=1 width=64) (actual time=649.473..649.477 rows=1 loops=1)
   ->  Nested Loop  (cost=8.10..7567.00 rows=1 width=22) (actual time=2.645..648.585 rows=4115 loops=1)
         Join Filter: (it2.id = mi_idx.info_type_id)
         Rows Removed by Join Filter: 8286
         ->  Nested Loop  (cost=8.10..7564.58 rows=1 width=26) (actual time=2.629..589.811 rows=12401 loops=1)
               Join Filter: (mi_idx.movie_id = t.id)
               ->  Nested Loop  (cost=7.67..7564.04 rows=1 width=29) (actual time=2.608..564.636 rows=5316 loops=1)
                     Join Filter: (it1.id = mi.info_type_id)
                     Rows Removed by Join Filter: 701
                     ->  Nested Loop  (cost=7.67..7561.62 rows=1 width=33) (actual time=2.605..551.605 rows=6017 loops=1)
                           Join Filter: (mi.movie_id = t.id)
                           ->  Nested Loop  (cost=7.23..7559.77 rows=1 width=25) (actual time=2.559..247.583 rows=8073 loops=1)
                                 Join Filter: (kt.id = t.kind_id)
                                 Rows Removed by Join Filter: 4332
                                 ->  Nested Loop  (cost=7.23..7528.89 rows=54 width=29) (actual time=2.512..245.198 rows=9739 loops=1)
                                       ->  Nested Loop  (cost=6.80..7462.77 rows=135 width=4) (actual time=2.495..109.986 rows=37091 loops=1)
                                             ->  Seq Scan on keyword k  (cost=0.00..3020.55 rows=4 width=4) (actual time=0.619..11.984 rows=3 loops=1)
                                                   Filter: ((keyword IS NOT NULL) AND (keyword = ANY ('{murder,murder-in-title,blood,violence}'::text[])))
                                                   Rows Removed by Filter: 134167
                                             ->  Bitmap Heap Scan on movie_keyword mk  (cost=6.80..1107.50 rows=306 width=8) (actual time=1.792..31.536 rows=12364 loops=3)
                                                   Recheck Cond: (k.id = keyword_id)
                                                   Heap Blocks: exact=26312
                                                   ->  Bitmap Index Scan on keyword_id_movie_keyword  (cost=0.00..6.73 rows=306 width=0) (actual time=0.957..0.957 rows=12364 loops=3)
                                                         Index Cond: (keyword_id = k.id)
                                       ->  Index Scan using title_pkey on title t  (cost=0.43..0.49 rows=1 width=25) (actual time=0.003..0.003 rows=0 loops=37091)
                                             Index Cond: (id = mk.movie_id)
                                             Filter: (production_year > 2005)
                                             Rows Removed by Filter: 1
                                 ->  Materialize  (cost=0.00..22.80 rows=10 width=4) (actual time=0.000..0.000 rows=1 loops=9739)
                                       ->  Seq Scan on kind_type kt  (cost=0.00..22.75 rows=10 width=4) (actual time=0.011..0.012 rows=2 loops=1)
                                             Filter: ((kind)::text = ANY ('{movie,episode}'::text[]))
                                             Rows Removed by Filter: 5
                           ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..1.82 rows=2 width=8) (actual time=0.032..0.037 rows=1 loops=8073)
                                 Index Cond: (movie_id = mk.movie_id)
                                 Filter: (info = ANY ('{Sweden,Norway,Germany,Denmark,Swedish,Danish,Norwegian,German,USA,American}'::text[]))
                                 Rows Removed by Filter: 57
                     ->  Seq Scan on info_type it1  (cost=0.00..2.41 rows=1 width=4) (actual time=0.001..0.002 rows=1 loops=6017)
                           Filter: ((info)::text = 'countries'::text)
                           Rows Removed by Filter: 19
               ->  Index Scan using movie_id_movie_info_idx on movie_info_idx mi_idx  (cost=0.43..0.50 rows=3 width=13) (actual time=0.004..0.004 rows=2 loops=5316)
                     Index Cond: (movie_id = mk.movie_id)
                     Filter: (info < '8.5'::text)
                     Rows Removed by Filter: 0
         ->  Seq Scan on info_type it2  (cost=0.00..2.41 rows=1 width=4) (actual time=0.004..0.004 rows=1 loops=12401)
               Filter: ((info)::text = 'rating'::text)
               Rows Removed by Filter: 108
 Planning Time: 4.691 ms
 Execution Time: 649.592 ms
(48 rows)


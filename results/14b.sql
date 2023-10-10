                                                                                      QUERY PLAN                                                                                       
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=4997.59..4997.60 rows=1 width=64) (actual time=143.192..143.196 rows=1 loops=1)
   ->  Nested Loop  (cost=8.10..4997.58 rows=1 width=22) (actual time=96.880..143.177 rows=1 loops=1)
         Join Filter: (kt.id = t.kind_id)
         Rows Removed by Join Filter: 1
         ->  Nested Loop  (cost=8.10..4974.77 rows=1 width=26) (actual time=4.877..143.151 rows=2 loops=1)
               Join Filter: (it2.id = mi_idx.info_type_id)
               Rows Removed by Join Filter: 1
               ->  Nested Loop  (cost=8.10..4972.35 rows=1 width=30) (actual time=4.866..143.132 rows=3 loops=1)
                     Join Filter: (mi_idx.movie_id = t.id)
                     ->  Nested Loop  (cost=7.67..4971.84 rows=1 width=33) (actual time=4.848..143.043 rows=8 loops=1)
                           Join Filter: (it1.id = mi.info_type_id)
                           ->  Nested Loop  (cost=7.67..4969.41 rows=1 width=37) (actual time=4.844..143.008 rows=8 loops=1)
                                 Join Filter: (mi.movie_id = t.id)
                                 ->  Nested Loop  (cost=7.23..4967.56 rows=1 width=29) (actual time=4.739..142.436 rows=15 loops=1)
                                       ->  Nested Loop  (cost=6.80..4934.24 rows=67 width=4) (actual time=3.296..63.788 rows=19528 loops=1)
                                             ->  Seq Scan on keyword k  (cost=0.00..2685.12 rows=2 width=4) (actual time=0.649..8.968 rows=1 loops=1)
                                                   Filter: (keyword = ANY ('{murder,murder-in-title}'::text[]))
                                                   Rows Removed by Filter: 134169
                                             ->  Bitmap Heap Scan on movie_keyword mk  (cost=6.80..1121.50 rows=306 width=8) (actual time=2.645..53.237 rows=19528 loops=1)
                                                   Recheck Cond: (k.id = keyword_id)
                                                   Heap Blocks: exact=12389
                                                   ->  Bitmap Index Scan on keyword_id_movie_keyword  (cost=0.00..6.73 rows=306 width=0) (actual time=1.417..1.417 rows=19528 loops=1)
                                                         Index Cond: (keyword_id = k.id)
                                       ->  Index Scan using title_pkey on title t  (cost=0.43..0.50 rows=1 width=25) (actual time=0.004..0.004 rows=0 loops=19528)
                                             Index Cond: (id = mk.movie_id)
                                             Filter: ((production_year > 2010) AND ((title ~~ '%murder%'::text) OR (title ~~ '%Murder%'::text) OR (title ~~ '%Mord%'::text)))
                                             Rows Removed by Filter: 1
                                 ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..1.82 rows=2 width=8) (actual time=0.035..0.037 rows=1 loops=15)
                                       Index Cond: (movie_id = mk.movie_id)
                                       Filter: (info = ANY ('{Sweden,Norway,Germany,Denmark,Swedish,Denish,Norwegian,German,USA,American}'::text[]))
                                       Rows Removed by Filter: 12
                           ->  Seq Scan on info_type it1  (cost=0.00..2.41 rows=1 width=4) (actual time=0.002..0.003 rows=1 loops=8)
                                 Filter: ((info)::text = 'countries'::text)
                                 Rows Removed by Filter: 7
                     ->  Index Scan using movie_id_movie_info_idx on movie_info_idx mi_idx  (cost=0.43..0.50 rows=1 width=13) (actual time=0.010..0.010 rows=0 loops=8)
                           Index Cond: (movie_id = mk.movie_id)
                           Filter: (info > '6.0'::text)
                           Rows Removed by Filter: 1
               ->  Seq Scan on info_type it2  (cost=0.00..2.41 rows=1 width=4) (actual time=0.004..0.005 rows=1 loops=3)
                     Filter: ((info)::text = 'rating'::text)
                     Rows Removed by Filter: 104
         ->  Seq Scan on kind_type kt  (cost=0.00..22.75 rows=5 width=4) (actual time=0.009..0.010 rows=1 loops=2)
               Filter: ((kind)::text = 'movie'::text)
               Rows Removed by Filter: 3
 Planning Time: 4.344 ms
 Execution Time: 143.398 ms
(46 rows)


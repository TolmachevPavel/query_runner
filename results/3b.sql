                                                                          QUERY PLAN                                                                          
--------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=16749.66..16749.67 rows=1 width=32) (actual time=106.673..106.675 rows=1 loops=1)
   ->  Nested Loop  (cost=7.67..16749.66 rows=1 width=17) (actual time=7.111..106.657 rows=5 loops=1)
         Join Filter: (mi.movie_id = t.id)
         ->  Nested Loop  (cost=7.23..16652.62 rows=68 width=25) (actual time=3.101..91.878 rows=405 loops=1)
               ->  Nested Loop  (cost=6.80..16438.09 rows=438 width=4) (actual time=1.894..40.258 rows=12951 loops=1)
                     ->  Seq Scan on keyword k  (cost=0.00..2685.12 rows=13 width=4) (actual time=0.659..11.367 rows=30 loops=1)
                           Filter: (keyword ~~ '%sequel%'::text)
                           Rows Removed by Filter: 134140
                     ->  Bitmap Heap Scan on movie_keyword mk  (cost=6.80..1054.86 rows=306 width=8) (actual time=0.054..0.926 rows=432 loops=30)
                           Recheck Cond: (k.id = keyword_id)
                           Heap Blocks: exact=6979
                           ->  Bitmap Index Scan on keyword_id_movie_keyword  (cost=0.00..6.73 rows=306 width=0) (actual time=0.031..0.031 rows=432 loops=30)
                                 Index Cond: (keyword_id = k.id)
               ->  Index Scan using title_pkey on title t  (cost=0.43..0.49 rows=1 width=21) (actual time=0.004..0.004 rows=0 loops=12951)
                     Index Cond: (id = mk.movie_id)
                     Filter: (production_year > 2010)
                     Rows Removed by Filter: 1
         ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..1.41 rows=1 width=4) (actual time=0.036..0.036 rows=0 loops=405)
               Index Cond: (movie_id = mk.movie_id)
               Filter: (info = 'Bulgaria'::text)
               Rows Removed by Filter: 63
 Planning Time: 1.477 ms
 Execution Time: 106.761 ms
(23 rows)


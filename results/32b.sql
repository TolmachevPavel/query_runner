                                                                                QUERY PLAN                                                                                 
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=3887.63..3887.64 rows=1 width=96) (actual time=132.663..132.668 rows=1 loops=1)
   ->  Nested Loop  (cost=8.10..3887.55 rows=11 width=116) (actual time=3.406..131.697 rows=4388 loops=1)
         ->  Nested Loop  (cost=7.67..3838.36 rows=11 width=103) (actual time=3.378..100.497 rows=4388 loops=1)
               ->  Nested Loop  (cost=7.24..3833.00 rows=11 width=94) (actual time=3.356..93.646 rows=4388 loops=1)
                     ->  Nested Loop  (cost=7.09..3831.14 rows=11 width=16) (actual time=3.330..90.877 rows=4388 loops=1)
                           ->  Nested Loop  (cost=6.80..3816.68 rows=34 width=4) (actual time=3.272..68.683 rows=41840 loops=1)
                                 ->  Seq Scan on keyword k  (cost=0.00..2685.12 rows=1 width=4) (actual time=0.351..7.623 rows=1 loops=1)
                                       Filter: (keyword = 'character-name-in-title'::text)
                                       Rows Removed by Filter: 134169
                                 ->  Bitmap Heap Scan on movie_keyword mk  (cost=6.80..1128.50 rows=306 width=8) (actual time=2.919..58.252 rows=41840 loops=1)
                                       Recheck Cond: (k.id = keyword_id)
                                       Heap Blocks: exact=11541
                                       ->  Bitmap Index Scan on keyword_id_movie_keyword  (cost=0.00..6.73 rows=306 width=0) (actual time=1.767..1.767 rows=41840 loops=1)
                                             Index Cond: (keyword_id = k.id)
                           ->  Index Scan using movie_id_movie_link on movie_link ml  (cost=0.29..0.38 rows=5 width=12) (actual time=0.000..0.000 rows=0 loops=41840)
                                 Index Cond: (movie_id = mk.movie_id)
                     ->  Index Scan using link_type_pkey on link_type lt  (cost=0.15..0.17 rows=1 width=86) (actual time=0.000..0.000 rows=1 loops=4388)
                           Index Cond: (id = ml.link_type_id)
               ->  Index Scan using title_pkey on title t1  (cost=0.43..0.49 rows=1 width=21) (actual time=0.001..0.001 rows=1 loops=4388)
                     Index Cond: (id = mk.movie_id)
         ->  Index Scan using title_pkey on title t2  (cost=0.43..4.47 rows=1 width=21) (actual time=0.007..0.007 rows=1 loops=4388)
               Index Cond: (id = ml.linked_movie_id)
 Planning Time: 1.781 ms
 Execution Time: 132.861 ms
(24 rows)


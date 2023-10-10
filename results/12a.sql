                                                                                           QUERY PLAN                                                                                            
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=16364.11..16364.12 rows=1 width=96) (actual time=274.857..274.861 rows=1 loops=1)
   ->  Nested Loop  (cost=3029.84..16364.10 rows=1 width=41) (actual time=23.448..274.712 rows=397 loops=1)
         ->  Nested Loop  (cost=3029.70..16363.92 rows=1 width=45) (actual time=23.439..274.377 rows=397 loops=1)
               Join Filter: (mi.movie_id = t.id)
               ->  Nested Loop  (cost=3029.26..16362.37 rows=1 width=53) (actual time=10.312..210.354 rows=5674 loops=1)
                     ->  Nested Loop  (cost=3028.84..16361.48 rows=2 width=38) (actual time=10.292..197.060 rows=6610 loops=1)
                           Join Filter: (mi_idx.movie_id = t.id)
                           ->  Hash Join  (cost=3028.41..16354.54 rows=13 width=17) (actual time=9.097..130.942 rows=24233 loops=1)
                                 Hash Cond: (mc.company_type_id = ct.id)
                                 ->  Nested Loop  (cost=3009.49..16329.45 rows=2336 width=21) (actual time=9.063..125.938 rows=64707 loops=1)
                                       ->  Nested Loop  (cost=3009.06..15222.66 rows=456 width=9) (actual time=9.053..76.525 rows=15849 loops=1)
                                             ->  Seq Scan on info_type it2  (cost=0.00..2.41 rows=1 width=4) (actual time=0.005..0.008 rows=1 loops=1)
                                                   Filter: ((info)::text = 'rating'::text)
                                                   Rows Removed by Filter: 112
                                             ->  Bitmap Heap Scan on movie_info_idx mi_idx  (cost=3009.06..15117.16 rows=10309 width=13) (actual time=9.046..75.499 rows=15849 loops=1)
                                                   Recheck Cond: (it2.id = info_type_id)
                                                   Filter: (info > '8.0'::text)
                                                   Rows Removed by Filter: 444076
                                                   Heap Blocks: exact=7934
                                                   ->  Bitmap Index Scan on info_type_id_movie_info_idx  (cost=0.00..3006.48 rows=276007 width=0) (actual time=8.241..8.241 rows=459925 loops=1)
                                                         Index Cond: (info_type_id = it2.id)
                                       ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..2.38 rows=5 width=12) (actual time=0.002..0.003 rows=4 loops=15849)
                                             Index Cond: (movie_id = mi_idx.movie_id)
                                 ->  Hash  (cost=18.88..18.88 rows=4 width=4) (actual time=0.017..0.018 rows=1 loops=1)
                                       Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                       ->  Seq Scan on company_type ct  (cost=0.00..18.88 rows=4 width=4) (actual time=0.011..0.011 rows=1 loops=1)
                                             Filter: ((kind)::text = 'production companies'::text)
                                             Rows Removed by Filter: 3
                           ->  Index Scan using title_pkey on title t  (cost=0.43..0.52 rows=1 width=21) (actual time=0.003..0.003 rows=0 loops=24233)
                                 Index Cond: (id = mc.movie_id)
                                 Filter: ((production_year >= 2005) AND (production_year <= 2008))
                                 Rows Removed by Filter: 1
                     ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..0.45 rows=1 width=23) (actual time=0.002..0.002 rows=1 loops=6610)
                           Index Cond: (id = mc.company_id)
                           Filter: ((country_code)::text = '[us]'::text)
                           Rows Removed by Filter: 0
               ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..1.53 rows=1 width=8) (actual time=0.011..0.011 rows=0 loops=5674)
                     Index Cond: (movie_id = mc.movie_id)
                     Filter: (info = ANY ('{Drama,Horror}'::text[]))
                     Rows Removed by Filter: 28
         ->  Index Scan using info_type_pkey on info_type it1  (cost=0.14..0.16 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=397)
               Index Cond: (id = mi.info_type_id)
               Filter: ((info)::text = 'genres'::text)
 Planning Time: 5.364 ms
 Execution Time: 275.083 ms
(45 rows)


                                                                                                QUERY PLAN                                                                                                
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=8093.14..8093.15 rows=1 width=128) (actual time=251.347..259.451 rows=1 loops=1)
   ->  Nested Loop  (cost=1011.95..8093.13 rows=1 width=80) (actual time=250.949..259.422 rows=6 loops=1)
         ->  Nested Loop  (cost=1011.52..8092.05 rows=1 width=69) (actual time=250.916..259.366 rows=6 loops=1)
               ->  Nested Loop  (cost=1011.38..8091.86 rows=1 width=73) (actual time=250.899..259.341 rows=6 loops=1)
                     Join Filter: (mi.movie_id = t.id)
                     ->  Nested Loop  (cost=1010.95..8080.39 rows=1 width=42) (actual time=250.818..259.196 rows=6 loops=1)
                           Join Filter: (ci.movie_id = t.id)
                           ->  Gather  (cost=1010.51..8065.21 rows=1 width=34) (actual time=126.549..258.683 rows=9 loops=1)
                                 Workers Planned: 2
                                 Workers Launched: 2
                                 ->  Nested Loop  (cost=10.51..7065.11 rows=1 width=34) (actual time=127.742..178.773 rows=3 loops=3)
                                       Join Filter: (mi_idx.movie_id = t.id)
                                       ->  Hash Join  (cost=10.08..7063.40 rows=2 width=13) (actual time=2.597..118.290 rows=16920 loops=3)
                                             Hash Cond: (mi_idx.info_type_id = it2.id)
                                             ->  Nested Loop  (cost=7.65..7060.40 rows=211 width=17) (actual time=2.517..114.221 rows=50907 loops=3)
                                                   ->  Nested Loop  (cost=7.22..7005.59 rows=70 width=4) (actual time=2.487..62.613 rows=20699 loops=3)
                                                         ->  Parallel Index Scan using keyword_pkey on keyword k  (cost=0.42..4798.50 rows=2 width=4) (actual time=0.173..11.785 rows=2 loops=3)
                                                               Filter: (keyword = ANY ('{murder,blood,gore,death,female-nudity}'::text[]))
                                                               Rows Removed by Filter: 44722
                                                         ->  Bitmap Heap Scan on movie_keyword mk  (cost=6.80..1100.49 rows=306 width=8) (actual time=1.901..29.449 rows=12419 loops=5)
                                                               Recheck Cond: (k.id = keyword_id)
                                                               Heap Blocks: exact=12389
                                                               ->  Bitmap Index Scan on keyword_id_movie_keyword  (cost=0.00..6.73 rows=306 width=0) (actual time=1.062..1.062 rows=12419 loops=5)
                                                                     Index Cond: (keyword_id = k.id)
                                                   ->  Index Scan using movie_id_movie_info_idx on movie_info_idx mi_idx  (cost=0.43..0.75 rows=3 width=13) (actual time=0.002..0.002 rows=2 loops=62096)
                                                         Index Cond: (movie_id = mk.movie_id)
                                             ->  Hash  (cost=2.41..2.41 rows=1 width=4) (actual time=0.028..0.028 rows=1 loops=3)
                                                   Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                   ->  Seq Scan on info_type it2  (cost=0.00..2.41 rows=1 width=4) (actual time=0.021..0.022 rows=1 loops=3)
                                                         Filter: ((info)::text = 'votes'::text)
                                                         Rows Removed by Filter: 112
                                       ->  Index Scan using title_pkey on title t  (cost=0.43..0.84 rows=1 width=21) (actual time=0.003..0.003 rows=0 loops=50760)
                                             Index Cond: (id = mk.movie_id)
                                             Filter: ((production_year > 2010) AND (title ~~ 'Vampire%'::text))
                                             Rows Removed by Filter: 1
                           ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..15.17 rows=1 width=8) (actual time=0.050..0.056 rows=1 loops=9)
                                 Index Cond: (movie_id = mk.movie_id)
                                 Filter: (note = ANY ('{(writer),"(head writer)","(written by)",(story),"(story editor)"}'::text[]))
                                 Rows Removed by Filter: 21
                     ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..11.46 rows=1 width=51) (actual time=0.023..0.023 rows=1 loops=6)
                           Index Cond: (movie_id = mk.movie_id)
                           Filter: (info = 'Horror'::text)
                           Rows Removed by Filter: 20
               ->  Index Scan using info_type_pkey on info_type it1  (cost=0.14..0.16 rows=1 width=4) (actual time=0.003..0.003 rows=1 loops=6)
                     Index Cond: (id = mi.info_type_id)
                     Filter: ((info)::text = 'genres'::text)
         ->  Index Scan using name_pkey on name n  (cost=0.43..1.08 rows=1 width=19) (actual time=0.008..0.008 rows=1 loops=6)
               Index Cond: (id = ci.person_id)
               Filter: ((gender)::text = 'm'::text)
 Planning Time: 9.827 ms
 Execution Time: 259.702 ms
(51 rows)


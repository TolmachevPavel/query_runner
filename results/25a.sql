                                                                                                QUERY PLAN                                                                                                
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=8103.76..8103.77 rows=1 width=128) (actual time=2060.706..2060.821 rows=1 loops=1)
   ->  Nested Loop  (cost=1011.95..8103.75 rows=1 width=80) (actual time=66.713..2058.581 rows=4407 loops=1)
         Join Filter: (mi.movie_id = t.id)
         ->  Nested Loop  (cost=1011.52..8102.90 rows=1 width=79) (actual time=66.672..2033.799 rows=4407 loops=1)
               ->  Nested Loop  (cost=1011.09..8101.82 rows=1 width=68) (actual time=12.614..1977.200 rows=7112 loops=1)
                     ->  Nested Loop  (cost=1010.95..8101.63 rows=1 width=72) (actual time=12.601..1969.626 rows=7740 loops=1)
                           Join Filter: (ci.movie_id = mi.movie_id)
                           ->  Gather  (cost=1010.51..8086.45 rows=1 width=64) (actual time=3.545..459.945 rows=12260 loops=1)
                                 Workers Planned: 2
                                 Workers Launched: 2
                                 ->  Nested Loop  (cost=10.51..7086.35 rows=1 width=64) (actual time=3.560..592.397 rows=4087 loops=3)
                                       Join Filter: (mi.movie_id = mi_idx.movie_id)
                                       ->  Hash Join  (cost=10.08..7063.40 rows=2 width=13) (actual time=2.732..134.413 rows=16920 loops=3)
                                             Hash Cond: (mi_idx.info_type_id = it2.id)
                                             ->  Nested Loop  (cost=7.65..7060.40 rows=211 width=17) (actual time=2.653..129.546 rows=50907 loops=3)
                                                   ->  Nested Loop  (cost=7.22..7005.59 rows=70 width=4) (actual time=2.627..71.040 rows=20699 loops=3)
                                                         ->  Parallel Index Scan using keyword_pkey on keyword k  (cost=0.42..4798.50 rows=2 width=4) (actual time=0.251..11.211 rows=2 loops=3)
                                                               Filter: (keyword = ANY ('{murder,blood,gore,death,female-nudity}'::text[]))
                                                               Rows Removed by Filter: 44722
                                                         ->  Bitmap Heap Scan on movie_keyword mk  (cost=6.80..1100.49 rows=306 width=8) (actual time=1.930..34.746 rows=12419 loops=5)
                                                               Recheck Cond: (k.id = keyword_id)
                                                               Heap Blocks: exact=12389
                                                               ->  Bitmap Index Scan on keyword_id_movie_keyword  (cost=0.00..6.73 rows=306 width=0) (actual time=1.112..1.113 rows=12419 loops=5)
                                                                     Index Cond: (keyword_id = k.id)
                                                   ->  Index Scan using movie_id_movie_info_idx on movie_info_idx mi_idx  (cost=0.43..0.75 rows=3 width=13) (actual time=0.002..0.002 rows=2 loops=62096)
                                                         Index Cond: (movie_id = mk.movie_id)
                                             ->  Hash  (cost=2.41..2.41 rows=1 width=4) (actual time=0.022..0.023 rows=1 loops=3)
                                                   Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                   ->  Seq Scan on info_type it2  (cost=0.00..2.41 rows=1 width=4) (actual time=0.016..0.017 rows=1 loops=3)
                                                         Filter: ((info)::text = 'votes'::text)
                                                         Rows Removed by Filter: 112
                                       ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..11.46 rows=1 width=51) (actual time=0.027..0.027 rows=0 loops=50760)
                                             Index Cond: (movie_id = mk.movie_id)
                                             Filter: (info = 'Horror'::text)
                                             Rows Removed by Filter: 56
                           ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..15.17 rows=1 width=8) (actual time=0.100..0.123 rows=1 loops=12260)
                                 Index Cond: (movie_id = mk.movie_id)
                                 Filter: (note = ANY ('{(writer),"(head writer)","(written by)",(story),"(story editor)"}'::text[]))
                                 Rows Removed by Filter: 47
                     ->  Index Scan using info_type_pkey on info_type it1  (cost=0.14..0.16 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=7740)
                           Index Cond: (id = mi.info_type_id)
                           Filter: ((info)::text = 'genres'::text)
                           Rows Removed by Filter: 0
               ->  Index Scan using name_pkey on name n  (cost=0.43..1.08 rows=1 width=19) (actual time=0.008..0.008 rows=1 loops=7112)
                     Index Cond: (id = ci.person_id)
                     Filter: ((gender)::text = 'm'::text)
                     Rows Removed by Filter: 0
         ->  Index Scan using title_pkey on title t  (cost=0.43..0.84 rows=1 width=21) (actual time=0.005..0.005 rows=1 loops=4407)
               Index Cond: (id = mk.movie_id)
 Planning Time: 10.191 ms
 Execution Time: 2061.068 ms
(51 rows)


                                                                                                QUERY PLAN                                                                                                
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=9338.08..9338.09 rows=1 width=128) (actual time=7108.248..7108.356 rows=1 loops=1)
   ->  Nested Loop  (cost=1011.96..9338.07 rows=1 width=80) (actual time=5.089..7097.403 rows=26153 loops=1)
         Join Filter: (mi.movie_id = t.id)
         ->  Nested Loop  (cost=1011.53..9337.22 rows=1 width=79) (actual time=5.070..7008.663 rows=26153 loops=1)
               ->  Nested Loop  (cost=1011.10..9336.14 rows=1 width=68) (actual time=5.033..6794.692 rows=42900 loops=1)
                     Join Filter: (ci.movie_id = mi.movie_id)
                     ->  Gather  (cost=1010.66..9320.96 rows=1 width=60) (actual time=3.956..561.204 rows=63386 loops=1)
                           Workers Planned: 2
                           Workers Launched: 2
                           ->  Nested Loop  (cost=10.66..8320.86 rows=1 width=60) (actual time=2.846..880.279 rows=21129 loops=3)
                                 ->  Nested Loop  (cost=10.51..8320.67 rows=1 width=64) (actual time=2.833..872.614 rows=22577 loops=3)
                                       Join Filter: (mi.movie_id = mi_idx.movie_id)
                                       ->  Hash Join  (cost=10.08..8297.31 rows=2 width=13) (actual time=2.768..177.271 rows=21234 loops=3)
                                             Hash Cond: (mi_idx.info_type_id = it2.id)
                                             ->  Nested Loop  (cost=7.65..8294.08 rows=294 width=17) (actual time=2.716..170.506 rows=63896 loops=3)
                                                   ->  Nested Loop  (cost=7.22..8217.35 rows=98 width=4) (actual time=2.688..90.794 rows=25571 loops=3)
                                                         ->  Parallel Index Scan using keyword_pkey on keyword k  (cost=0.42..4938.26 rows=3 width=4) (actual time=0.249..12.074 rows=2 loops=3)
                                                               Filter: (keyword = ANY ('{murder,violence,blood,gore,death,female-nudity,hospital}'::text[]))
                                                               Rows Removed by Filter: 44721
                                                         ->  Bitmap Heap Scan on movie_keyword mk  (cost=6.80..1089.97 rows=306 width=8) (actual time=1.784..32.581 rows=10959 loops=7)
                                                               Recheck Cond: (k.id = keyword_id)
                                                               Heap Blocks: exact=12389
                                                               ->  Bitmap Index Scan on keyword_id_movie_keyword  (cost=0.00..6.73 rows=306 width=0) (actual time=1.039..1.040 rows=10959 loops=7)
                                                                     Index Cond: (keyword_id = k.id)
                                                   ->  Index Scan using movie_id_movie_info_idx on movie_info_idx mi_idx  (cost=0.43..0.75 rows=3 width=13) (actual time=0.002..0.003 rows=2 loops=76714)
                                                         Index Cond: (movie_id = mk.movie_id)
                                             ->  Hash  (cost=2.41..2.41 rows=1 width=4) (actual time=0.024..0.025 rows=1 loops=3)
                                                   Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                   ->  Seq Scan on info_type it2  (cost=0.00..2.41 rows=1 width=4) (actual time=0.018..0.019 rows=1 loops=3)
                                                         Filter: ((info)::text = 'votes'::text)
                                                         Rows Removed by Filter: 112
                                       ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..11.67 rows=1 width=51) (actual time=0.031..0.032 rows=1 loops=63701)
                                             Index Cond: (movie_id = mk.movie_id)
                                             Filter: (info = ANY ('{Horror,Action,Sci-Fi,Thriller,Crime,War}'::text[]))
                                             Rows Removed by Filter: 58
                                 ->  Memoize  (cost=0.15..0.17 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=67732)
                                       Cache Key: mi.info_type_id
                                       Cache Mode: logical
                                       Hits: 19179  Misses: 2  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                       Worker 0:  Hits: 36449  Misses: 2  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                       Worker 1:  Hits: 12098  Misses: 2  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                       ->  Index Scan using info_type_pkey on info_type it1  (cost=0.14..0.16 rows=1 width=4) (actual time=0.007..0.007 rows=0 loops=6)
                                             Index Cond: (id = mi.info_type_id)
                                             Filter: ((info)::text = 'genres'::text)
                                             Rows Removed by Filter: 0
                     ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..15.17 rows=1 width=8) (actual time=0.078..0.098 rows=1 loops=63386)
                           Index Cond: (movie_id = mk.movie_id)
                           Filter: (note = ANY ('{(writer),"(head writer)","(written by)",(story),"(story editor)"}'::text[]))
                           Rows Removed by Filter: 63
               ->  Index Scan using name_pkey on name n  (cost=0.43..1.08 rows=1 width=19) (actual time=0.005..0.005 rows=1 loops=42900)
                     Index Cond: (id = ci.person_id)
                     Filter: ((gender)::text = 'm'::text)
                     Rows Removed by Filter: 0
         ->  Index Scan using title_pkey on title t  (cost=0.43..0.84 rows=1 width=21) (actual time=0.003..0.003 rows=1 loops=26153)
               Index Cond: (id = mk.movie_id)
 Planning Time: 10.693 ms
 Execution Time: 7108.619 ms
(57 rows)


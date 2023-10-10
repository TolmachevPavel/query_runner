                                                                                                      QUERY PLAN                                                                                                      
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=9586.89..9586.90 rows=1 width=128) (actual time=336.455..340.428 rows=1 loops=1)
   ->  Nested Loop  (cost=1012.80..9586.88 rows=1 width=80) (actual time=100.645..340.368 rows=84 loops=1)
         ->  Nested Loop  (cost=1012.37..9585.53 rows=1 width=69) (actual time=100.621..340.172 rows=84 loops=1)
               ->  Nested Loop  (cost=1012.23..9585.35 rows=1 width=73) (actual time=100.598..340.080 rows=84 loops=1)
                     Join Filter: (mi.movie_id = t.id)
                     ->  Nested Loop  (cost=1011.80..9568.01 rows=1 width=46) (actual time=100.422..338.076 rows=53 loops=1)
                           ->  Nested Loop  (cost=1011.38..9565.51 rows=1 width=50) (actual time=100.381..337.862 rows=119 loops=1)
                                 Join Filter: (mc.movie_id = t.id)
                                 ->  Nested Loop  (cost=1010.95..9563.40 rows=1 width=42) (actual time=61.833..337.319 rows=77 loops=1)
                                       Join Filter: (ci.movie_id = t.id)
                                       ->  Gather  (cost=1010.51..9543.18 rows=1 width=34) (actual time=47.263..331.344 rows=47 loops=1)
                                             Workers Planned: 2
                                             Workers Launched: 2
                                             ->  Nested Loop  (cost=10.51..8543.08 rows=1 width=34) (actual time=52.279..231.250 rows=16 loops=3)
                                                   Join Filter: (mi_idx.movie_id = t.id)
                                                   ->  Hash Join  (cost=10.08..8540.78 rows=2 width=13) (actual time=2.579..152.155 rows=21234 loops=3)
                                                         Hash Cond: (mi_idx.info_type_id = it2.id)
                                                         ->  Nested Loop  (cost=7.65..8537.55 rows=294 width=17) (actual time=2.493..146.713 rows=63896 loops=3)
                                                               ->  Nested Loop  (cost=7.22..8431.48 rows=98 width=4) (actual time=2.462..80.213 rows=25571 loops=3)
                                                                     ->  Parallel Index Scan using keyword_pkey on keyword k  (cost=0.42..5152.39 rows=3 width=4) (actual time=0.209..15.091 rows=2 loops=3)
                                                                           Filter: (keyword = ANY ('{murder,violence,blood,gore,death,female-nudity,hospital}'::text[]))
                                                                           Rows Removed by Filter: 44721
                                                                     ->  Bitmap Heap Scan on movie_keyword mk  (cost=6.80..1089.97 rows=306 width=8) (actual time=1.711..26.975 rows=10959 loops=7)
                                                                           Recheck Cond: (k.id = keyword_id)
                                                                           Heap Blocks: exact=12389
                                                                           ->  Bitmap Index Scan on keyword_id_movie_keyword  (cost=0.00..6.73 rows=306 width=0) (actual time=0.943..0.943 rows=10959 loops=7)
                                                                                 Index Cond: (keyword_id = k.id)
                                                               ->  Index Scan using movie_id_movie_info_idx on movie_info_idx mi_idx  (cost=0.43..1.05 rows=3 width=13) (actual time=0.002..0.002 rows=2 loops=76714)
                                                                     Index Cond: (movie_id = mk.movie_id)
                                                         ->  Hash  (cost=2.41..2.41 rows=1 width=4) (actual time=0.028..0.028 rows=1 loops=3)
                                                               Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                               ->  Seq Scan on info_type it2  (cost=0.00..2.41 rows=1 width=4) (actual time=0.020..0.021 rows=1 loops=3)
                                                                     Filter: ((info)::text = 'votes'::text)
                                                                     Rows Removed by Filter: 112
                                                   ->  Index Scan using title_pkey on title t  (cost=0.43..1.13 rows=1 width=21) (actual time=0.004..0.004 rows=0 loops=63701)
                                                         Index Cond: (id = mk.movie_id)
                                                         Filter: ((production_year > 2000) AND ((title ~~ '%Freddy%'::text) OR (title ~~ '%Jason%'::text) OR (title ~~ 'Saw%'::text)))
                                                         Rows Removed by Filter: 1
                                       ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..20.21 rows=1 width=8) (actual time=0.083..0.126 rows=2 loops=47)
                                             Index Cond: (movie_id = mk.movie_id)
                                             Filter: (note = ANY ('{(writer),"(head writer)","(written by)",(story),"(story editor)"}'::text[]))
                                             Rows Removed by Filter: 85
                                 ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..2.10 rows=1 width=8) (actual time=0.005..0.007 rows=2 loops=77)
                                       Index Cond: (movie_id = mk.movie_id)
                                       Filter: (note ~~ '%(Blu-ray)%'::text)
                                       Rows Removed by Filter: 24
                           ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..2.34 rows=1 width=4) (actual time=0.002..0.002 rows=0 loops=119)
                                 Index Cond: (id = mc.company_id)
                                 Filter: (name ~~ 'Lionsgate%'::text)
                                 Rows Removed by Filter: 1
                     ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..17.33 rows=1 width=51) (actual time=0.037..0.037 rows=2 loops=53)
                           Index Cond: (movie_id = mk.movie_id)
                           Filter: (info = ANY ('{Horror,Thriller}'::text[]))
                           Rows Removed by Filter: 292
               ->  Index Scan using info_type_pkey on info_type it1  (cost=0.14..0.16 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=84)
                     Index Cond: (id = mi.info_type_id)
                     Filter: ((info)::text = 'genres'::text)
         ->  Index Scan using name_pkey on name n  (cost=0.43..1.35 rows=1 width=19) (actual time=0.002..0.002 rows=1 loops=84)
               Index Cond: (id = ci.person_id)
               Filter: ((gender)::text = 'm'::text)
 Planning Time: 34.836 ms
 Execution Time: 340.699 ms
(62 rows)


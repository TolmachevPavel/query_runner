                                                                                 QUERY PLAN                                                                                 
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Finalize Aggregate  (cost=37416.15..37416.16 rows=1 width=32) (actual time=99.683..103.601 rows=1 loops=1)
   ->  Gather  (cost=37415.93..37416.14 rows=2 width=32) (actual time=99.558..103.595 rows=3 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         ->  Partial Aggregate  (cost=36415.93..36415.94 rows=1 width=32) (actual time=97.257..97.261 rows=1 loops=3)
               ->  Hash Join  (cost=23.36..36415.03 rows=363 width=17) (actual time=58.824..97.189 rows=223 loops=3)
                     Hash Cond: (mi.info_type_id = it.id)
                     ->  Nested Loop  (cost=19.82..36410.50 rows=363 width=21) (actual time=58.747..97.063 rows=223 loops=3)
                           ->  Nested Loop  (cost=19.36..35926.13 rows=267 width=25) (actual time=58.693..85.366 rows=256 loops=3)
                                 ->  Hash Join  (cost=18.93..35330.58 rows=385 width=4) (actual time=58.627..82.355 rows=266 loops=3)
                                       Hash Cond: (mc.company_type_id = ct.id)
                                       ->  Parallel Seq Scan on movie_companies mc  (cost=0.00..35131.06 rows=68391 width=8) (actual time=0.023..78.195 rows=98543 loops=3)
                                             Filter: ((note !~~ '%(TV)%'::text) AND (note ~~ '%(USA)%'::text))
                                             Rows Removed by Filter: 771167
                                       ->  Hash  (cost=18.88..18.88 rows=4 width=4) (actual time=0.008..0.008 rows=1 loops=3)
                                             Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                             ->  Seq Scan on company_type ct  (cost=0.00..18.88 rows=4 width=4) (actual time=0.006..0.006 rows=1 loops=3)
                                                   Filter: ((kind)::text = 'production companies'::text)
                                                   Rows Removed by Filter: 3
                                 ->  Index Scan using title_pkey on title t  (cost=0.43..1.55 rows=1 width=21) (actual time=0.011..0.011 rows=1 loops=798)
                                       Index Cond: (id = mc.movie_id)
                                       Filter: (production_year > 1990)
                                       Rows Removed by Filter: 0
                           ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.46..1.79 rows=2 width=8) (actual time=0.040..0.045 rows=1 loops=767)
                                 Index Cond: (movie_id = t.id)
                                 Filter: (info = ANY ('{Sweden,Norway,Germany,Denmark,Swedish,Denish,Norwegian,German,USA,American}'::text[]))
                                 Rows Removed by Filter: 10
                     ->  Hash  (cost=2.13..2.13 rows=113 width=4) (actual time=0.029..0.029 rows=113 loops=3)
                           Buckets: 1024  Batches: 1  Memory Usage: 12kB
                           ->  Seq Scan on info_type it  (cost=0.00..2.13 rows=113 width=4) (actual time=0.009..0.015 rows=113 loops=3)
 Planning Time: 1.462 ms
 Execution Time: 103.696 ms
(32 rows)


                                                                                          QUERY PLAN                                                                                          
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Finalize Aggregate  (cost=483769.85..483769.86 rows=1 width=128) (actual time=1796.192..1809.093 rows=1 loops=1)
   ->  Gather  (cost=483769.62..483769.83 rows=2 width=128) (actual time=1796.029..1809.073 rows=3 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         ->  Partial Aggregate  (cost=482769.62..482769.63 rows=1 width=128) (actual time=1782.950..1782.956 rows=1 loops=3)
               ->  Nested Loop  (cost=21.49..482764.25 rows=537 width=64) (actual time=283.953..1751.490 rows=161027 loops=3)
                     ->  Nested Loop  (cost=21.07..482648.01 rows=216 width=56) (actual time=283.669..1667.141 rows=57856 loops=3)
                           Join Filter: (ci.movie_id = t.id)
                           ->  Nested Loop  (cost=20.64..482533.75 rows=216 width=47) (actual time=283.630..1538.299 rows=57856 loops=3)
                                 ->  Nested Loop  (cost=20.21..482268.37 rows=595 width=51) (actual time=283.344..1328.130 rows=142133 loops=3)
                                       ->  Nested Loop  (cost=19.79..482118.02 rows=222 width=43) (actual time=283.309..1130.805 rows=85164 loops=3)
                                             ->  Nested Loop  (cost=19.36..481813.06 rows=458 width=31) (actual time=283.277..962.252 rows=92002 loops=3)
                                                   ->  Hash Join  (cost=18.93..480227.16 rows=2050 width=12) (actual time=283.215..846.630 rows=92055 loops=3)
                                                         Hash Cond: (ci.role_id = rt.id)
                                                         ->  Parallel Seq Scan on cast_info ci  (cost=0.00..479247.15 rows=363954 width=16) (actual time=18.777..821.827 rows=289159 loops=3)
                                                               Filter: (note = ANY ('{(voice),"(voice: Japanese version)","(voice) (uncredited)","(voice: English version)"}'::text[]))
                                                               Rows Removed by Filter: 11792289
                                                         ->  Hash  (cost=18.88..18.88 rows=4 width=4) (actual time=0.034..0.035 rows=1 loops=3)
                                                               Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                               ->  Seq Scan on role_type rt  (cost=0.00..18.88 rows=4 width=4) (actual time=0.026..0.026 rows=1 loops=3)
                                                                     Filter: ((role)::text = 'actress'::text)
                                                                     Rows Removed by Filter: 11
                                                   ->  Index Scan using name_pkey on name n  (cost=0.43..0.77 rows=1 width=19) (actual time=0.001..0.001 rows=1 loops=276166)
                                                         Index Cond: (id = ci.person_id)
                                                         Filter: ((gender)::text = 'f'::text)
                                                         Rows Removed by Filter: 0
                                             ->  Index Scan using char_name_pkey on char_name chn  (cost=0.43..0.67 rows=1 width=20) (actual time=0.002..0.002 rows=1 loops=276005)
                                                   Index Cond: (id = ci.person_role_id)
                                       ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..0.63 rows=5 width=8) (actual time=0.002..0.002 rows=2 loops=255493)
                                             Index Cond: (movie_id = ci.movie_id)
                                 ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..0.45 rows=1 width=4) (actual time=0.001..0.001 rows=0 loops=426400)
                                       Index Cond: (id = mc.company_id)
                                       Filter: ((country_code)::text = '[us]'::text)
                                       Rows Removed by Filter: 1
                           ->  Index Scan using title_pkey on title t  (cost=0.43..0.52 rows=1 width=21) (actual time=0.002..0.002 rows=1 loops=173567)
                                 Index Cond: (id = mc.movie_id)
                     ->  Index Scan using person_id_aka_name on aka_name an  (cost=0.42..0.52 rows=2 width=20) (actual time=0.001..0.001 rows=3 loops=173567)
                           Index Cond: (person_id = n.id)
 Planning Time: 6.081 ms
 JIT:
   Functions: 155
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 4.770 ms, Inlining 0.000 ms, Optimization 2.127 ms, Emission 50.670 ms, Total 57.567 ms
 Execution Time: 1824.831 ms
(44 rows)


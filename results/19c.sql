                                                                                             QUERY PLAN                                                                                             
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=276656.55..276656.56 rows=1 width=64) (actual time=5497.743..5502.581 rows=1 loops=1)
   ->  Nested Loop  (cost=1005.59..276656.54 rows=1 width=32) (actual time=201.668..5501.724 rows=3575 loops=1)
         ->  Nested Loop  (cost=1005.17..276655.37 rows=1 width=36) (actual time=201.642..5482.046 rows=11692 loops=1)
               ->  Nested Loop  (cost=1004.74..276652.72 rows=1 width=44) (actual time=201.623..5473.789 rows=3628 loops=1)
                     Join Filter: (an.person_id = n.id)
                     ->  Gather  (cost=1004.32..276651.86 rows=1 width=52) (actual time=201.594..5468.331 rows=2129 loops=1)
                           Workers Planned: 2
                           Workers Launched: 2
                           ->  Nested Loop  (cost=4.32..275651.76 rows=1 width=52) (actual time=199.081..5467.531 rows=710 loops=3)
                                 ->  Nested Loop  (cost=3.89..275648.60 rows=2 width=33) (actual time=144.281..5354.618 rows=42981 loops=3)
                                       ->  Nested Loop  (cost=3.46..275644.95 rows=4 width=37) (actual time=141.438..5158.467 rows=44885 loops=3)
                                             ->  Nested Loop  (cost=3.30..275625.38 rows=702 width=41) (actual time=126.935..5130.860 rows=124711 loops=3)
                                                   ->  Nested Loop  (cost=2.86..257117.66 rows=782 width=25) (actual time=124.023..906.152 rows=141523 loops=3)
                                                         ->  Hash Join  (cost=2.43..254812.49 rows=1426 width=4) (actual time=123.975..517.706 rows=150346 loops=3)
                                                               Hash Cond: (mi.info_type_id = it.id)
                                                               ->  Parallel Seq Scan on movie_info mi  (cost=0.00..254371.25 rows=161125 width=8) (actual time=59.972..496.303 rows=150368 loops=3)
                                                                     Filter: ((info IS NOT NULL) AND ((info ~~ 'Japan:%200%'::text) OR (info ~~ 'USA:%200%'::text)))
                                                                     Rows Removed by Filter: 4794872
                                                               ->  Hash  (cost=2.41..2.41 rows=1 width=4) (actual time=0.051..0.052 rows=1 loops=3)
                                                                     Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                                     ->  Seq Scan on info_type it  (cost=0.00..2.41 rows=1 width=4) (actual time=0.039..0.043 rows=1 loops=3)
                                                                           Filter: ((info)::text = 'release dates'::text)
                                                                           Rows Removed by Filter: 112
                                                         ->  Index Scan using title_pkey on title t  (cost=0.43..1.62 rows=1 width=21) (actual time=0.002..0.002 rows=1 loops=451039)
                                                               Index Cond: (id = mi.movie_id)
                                                               Filter: (production_year > 2000)
                                                               Rows Removed by Filter: 0
                                                   ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..23.66 rows=1 width=16) (actual time=0.026..0.030 rows=1 loops=424568)
                                                         Index Cond: (movie_id = t.id)
                                                         Filter: (note = ANY ('{(voice),"(voice: Japanese version)","(voice) (uncredited)","(voice: English version)"}'::text[]))
                                                         Rows Removed by Filter: 21
                                             ->  Memoize  (cost=0.16..0.18 rows=1 width=4) (actual time=0.000..0.000 rows=0 loops=374134)
                                                   Cache Key: ci.role_id
                                                   Cache Mode: logical
                                                   Hits: 116307  Misses: 4  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                                   Worker 0:  Hits: 134586  Misses: 4  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                                   Worker 1:  Hits: 123229  Misses: 4  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                                   ->  Index Scan using role_type_pkey on role_type rt  (cost=0.15..0.17 rows=1 width=4) (actual time=0.015..0.015 rows=0 loops=12)
                                                         Index Cond: (id = ci.role_id)
                                                         Filter: ((role)::text = 'actress'::text)
                                                         Rows Removed by Filter: 1
                                       ->  Index Only Scan using char_name_pkey on char_name chn  (cost=0.43..0.91 rows=1 width=4) (actual time=0.004..0.004 rows=1 loops=134654)
                                             Index Cond: (id = ci.person_role_id)
                                             Heap Fetches: 0
                                 ->  Index Scan using name_pkey on name n  (cost=0.43..1.58 rows=1 width=19) (actual time=0.002..0.002 rows=0 loops=128944)
                                       Index Cond: (id = ci.person_id)
                                       Filter: ((name ~~ '%An%'::text) AND ((gender)::text = 'f'::text))
                                       Rows Removed by Filter: 1
                     ->  Index Only Scan using person_id_aka_name on aka_name an  (cost=0.42..0.84 rows=2 width=4) (actual time=0.002..0.002 rows=2 loops=2129)
                           Index Cond: (person_id = ci.person_id)
                           Heap Fetches: 0
               ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..2.60 rows=5 width=8) (actual time=0.001..0.002 rows=3 loops=3628)
                     Index Cond: (movie_id = t.id)
         ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..1.17 rows=1 width=4) (actual time=0.002..0.002 rows=0 loops=11692)
               Index Cond: (id = mc.company_id)
               Filter: ((country_code)::text = '[us]'::text)
               Rows Removed by Filter: 1
 Planning Time: 19.744 ms
 JIT:
   Functions: 164
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 4.423 ms, Inlining 0.000 ms, Optimization 1.830 ms, Emission 45.141 ms, Total 51.394 ms
 Execution Time: 5517.686 ms
(63 rows)


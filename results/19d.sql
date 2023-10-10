                                                                                                QUERY PLAN                                                                                                
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Finalize Aggregate  (cost=487779.29..487779.30 rows=1 width=64) (actual time=3939.001..3951.870 rows=1 loops=1)
   ->  Gather  (cost=487779.07..487779.28 rows=2 width=64) (actual time=3938.809..3951.852 rows=3 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         ->  Partial Aggregate  (cost=486779.07..486779.08 rows=1 width=64) (actual time=3925.748..3925.755 rows=1 loops=3)
               ->  Nested Loop  (cost=24.35..486778.69 rows=76 width=32) (actual time=297.296..3859.953 rows=586882 loops=3)
                     ->  Nested Loop  (cost=23.93..486752.96 rows=30 width=40) (actual time=294.602..3568.685 rows=262348 loops=3)
                           ->  Nested Loop  (cost=23.50..486654.67 rows=84 width=44) (actual time=294.427..2354.752 rows=1076352 loops=3)
                                 Join Filter: (mc.movie_id = t.id)
                                 ->  Hash Join  (cost=23.07..486612.85 rows=16 width=52) (actual time=294.384..1980.260 rows=113945 loops=3)
                                       Hash Cond: (mi.info_type_id = it.id)
                                       ->  Nested Loop  (cost=20.65..486605.37 rows=1855 width=56) (actual time=275.864..1921.098 rows=540998 loops=3)
                                             ->  Nested Loop  (cost=20.21..483979.95 rows=122 width=48) (actual time=275.828..1470.713 rows=53102 loops=3)
                                                   ->  Nested Loop  (cost=19.79..483663.05 rows=222 width=27) (actual time=272.911..1143.850 rows=85164 loops=3)
                                                         ->  Nested Loop  (cost=19.36..482096.33 rows=992 width=8) (actual time=272.870..1028.601 rows=85217 loops=3)
                                                               ->  Hash Join  (cost=18.93..480227.16 rows=2050 width=12) (actual time=272.821..851.301 rows=92055 loops=3)
                                                                     Hash Cond: (ci.role_id = rt.id)
                                                                     ->  Parallel Seq Scan on cast_info ci  (cost=0.00..479247.15 rows=363954 width=16) (actual time=3.377..826.188 rows=289159 loops=3)
                                                                           Filter: (note = ANY ('{(voice),"(voice: Japanese version)","(voice) (uncredited)","(voice: English version)"}'::text[]))
                                                                           Rows Removed by Filter: 11792289
                                                                     ->  Hash  (cost=18.88..18.88 rows=4 width=4) (actual time=0.019..0.020 rows=1 loops=3)
                                                                           Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                                           ->  Seq Scan on role_type rt  (cost=0.00..18.88 rows=4 width=4) (actual time=0.016..0.017 rows=1 loops=3)
                                                                                 Filter: ((role)::text = 'actress'::text)
                                                                                 Rows Removed by Filter: 11
                                                               ->  Index Only Scan using char_name_pkey on char_name chn  (cost=0.43..0.91 rows=1 width=4) (actual time=0.002..0.002 rows=1 loops=276166)
                                                                     Index Cond: (id = ci.person_role_id)
                                                                     Heap Fetches: 0
                                                         ->  Index Scan using name_pkey on name n  (cost=0.43..1.58 rows=1 width=19) (actual time=0.001..0.001 rows=1 loops=255651)
                                                               Index Cond: (id = ci.person_id)
                                                               Filter: ((gender)::text = 'f'::text)
                                                               Rows Removed by Filter: 0
                                                   ->  Index Scan using title_pkey on title t  (cost=0.43..1.43 rows=1 width=21) (actual time=0.004..0.004 rows=1 loops=255493)
                                                         Index Cond: (id = ci.movie_id)
                                                         Filter: (production_year > 2000)
                                                         Rows Removed by Filter: 0
                                             ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..21.11 rows=41 width=8) (actual time=0.002..0.007 rows=10 loops=159307)
                                                   Index Cond: (movie_id = t.id)
                                       ->  Hash  (cost=2.41..2.41 rows=1 width=4) (actual time=18.446..18.447 rows=1 loops=3)
                                             Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                             ->  Seq Scan on info_type it  (cost=0.00..2.41 rows=1 width=4) (actual time=18.432..18.437 rows=1 loops=3)
                                                   Filter: ((info)::text = 'release dates'::text)
                                                   Rows Removed by Filter: 112
                                 ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..2.55 rows=5 width=8) (actual time=0.001..0.002 rows=9 loops=341836)
                                       Index Cond: (movie_id = mi.movie_id)
                           ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..1.17 rows=1 width=4) (actual time=0.001..0.001 rows=0 loops=3229056)
                                 Index Cond: (id = mc.company_id)
                                 Filter: ((country_code)::text = '[us]'::text)
                                 Rows Removed by Filter: 1
                     ->  Index Only Scan using person_id_aka_name on aka_name an  (cost=0.42..0.84 rows=2 width=4) (actual time=0.001..0.001 rows=2 loops=787043)
                           Index Cond: (person_id = n.id)
                           Heap Fetches: 0
 Planning Time: 20.936 ms
 JIT:
   Functions: 191
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 4.925 ms, Inlining 0.000 ms, Optimization 2.002 ms, Emission 53.503 ms, Total 60.430 ms
 Execution Time: 3967.073 ms
(58 rows)


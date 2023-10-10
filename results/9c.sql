                                                                                          QUERY PLAN                                                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Finalize Aggregate  (cost=133622.71..133622.72 rows=1 width=128) (actual time=287.980..297.416 rows=1 loops=1)
   ->  Gather  (cost=133622.48..133622.69 rows=2 width=128) (actual time=287.498..297.399 rows=3 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         ->  Partial Aggregate  (cost=132622.48..132622.49 rows=1 width=128) (actual time=274.445..274.449 rows=1 loops=3)
               ->  Nested Loop  (cost=81869.65..132622.32 rows=16 width=64) (actual time=156.571..273.703 rows=2715 loops=3)
                     Join Filter: (ci.movie_id = t.id)
                     ->  Nested Loop  (cost=81869.22..132613.85 rows=16 width=55) (actual time=156.526..268.226 rows=2715 loops=3)
                           ->  Nested Loop  (cost=81868.80..132593.78 rows=45 width=59) (actual time=155.951..256.804 rows=6115 loops=3)
                                 ->  Nested Loop  (cost=81868.37..132582.27 rows=17 width=51) (actual time=155.913..249.454 rows=2575 loops=3)
                                       ->  Hash Join  (cost=81867.94..132558.96 rows=35 width=39) (actual time=155.880..243.524 rows=2735 loops=3)
                                             Hash Cond: (ci.role_id = rt.id)
                                             ->  Nested Loop  (cost=81849.02..132523.88 rows=6119 width=43) (actual time=137.094..224.375 rows=2735 loops=3)
                                                   Join Filter: (ci.person_id = n.id)
                                                   ->  Parallel Hash Join  (cost=81848.58..98006.02 rows=2542 width=39) (actual time=136.132..186.317 rows=3508 loops=3)
                                                         Hash Cond: (an.person_id = n.id)
                                                         ->  Parallel Seq Scan on aka_name an  (cost=0.00..15171.60 rows=375560 width=20) (actual time=0.031..19.965 rows=300448 loops=3)
                                                         ->  Parallel Hash  (cost=81701.66..81701.66 rows=11753 width=19) (actual time=135.731..135.732 rows=16670 loops=3)
                                                               Buckets: 65536 (originally 32768)  Batches: 1 (originally 1)  Memory Usage: 3584kB
                                                               ->  Parallel Seq Scan on name n  (cost=0.00..81701.66 rows=11753 width=19) (actual time=54.316..131.272 rows=16670 loops=3)
                                                                     Filter: ((name ~~ '%An%'::text) AND ((gender)::text = 'f'::text))
                                                                     Rows Removed by Filter: 1372493
                                                   ->  Index Scan using person_id_cast_info on cast_info ci  (cost=0.44..13.42 rows=13 width=16) (actual time=0.010..0.011 rows=1 loops=10525)
                                                         Index Cond: (person_id = an.person_id)
                                                         Filter: (note = ANY ('{(voice),"(voice: Japanese version)","(voice) (uncredited)","(voice: English version)"}'::text[]))
                                                         Rows Removed by Filter: 44
                                             ->  Hash  (cost=18.88..18.88 rows=4 width=4) (actual time=18.717..18.718 rows=1 loops=3)
                                                   Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                   ->  Seq Scan on role_type rt  (cost=0.00..18.88 rows=4 width=4) (actual time=18.705..18.707 rows=1 loops=3)
                                                         Filter: ((role)::text = 'actress'::text)
                                                         Rows Removed by Filter: 11
                                       ->  Index Scan using char_name_pkey on char_name chn  (cost=0.43..0.67 rows=1 width=20) (actual time=0.002..0.002 rows=1 loops=8204)
                                             Index Cond: (id = ci.person_role_id)
                                 ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..0.63 rows=5 width=8) (actual time=0.002..0.003 rows=2 loops=7726)
                                       Index Cond: (movie_id = ci.movie_id)
                           ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..0.45 rows=1 width=4) (actual time=0.002..0.002 rows=0 loops=18345)
                                 Index Cond: (id = mc.company_id)
                                 Filter: ((country_code)::text = '[us]'::text)
                                 Rows Removed by Filter: 1
                     ->  Index Scan using title_pkey on title t  (cost=0.43..0.52 rows=1 width=21) (actual time=0.002..0.002 rows=1 loops=8144)
                           Index Cond: (id = mc.movie_id)
 Planning Time: 5.676 ms
 JIT:
   Functions: 170
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 4.817 ms, Inlining 0.000 ms, Optimization 2.467 ms, Emission 53.793 ms, Total 61.077 ms
 Execution Time: 312.760 ms
(47 rows)


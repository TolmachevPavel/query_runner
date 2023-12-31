                                                                                                  QUERY PLAN                                                                                                  
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=6664.05..6664.06 rows=1 width=96) (actual time=387.954..387.959 rows=1 loops=1)
   ->  Nested Loop  (cost=10.24..6664.04 rows=1 width=48) (actual time=58.906..387.875 rows=275 loops=1)
         Join Filter: (an.person_id = n.id)
         ->  Nested Loop  (cost=9.82..6663.02 rows=1 width=56) (actual time=24.278..387.565 rows=141 loops=1)
               ->  Nested Loop  (cost=9.39..6661.28 rows=1 width=44) (actual time=24.255..387.138 rows=143 loops=1)
                     ->  Nested Loop  (cost=8.96..6659.43 rows=1 width=25) (actual time=1.487..381.456 rows=2778 loops=1)
                           Join Filter: (ci.role_id = rt.id)
                           Rows Removed by Join Filter: 10980
                           ->  Nested Loop  (cost=8.96..6640.51 rows=1 width=29) (actual time=1.459..367.630 rows=13758 loops=1)
                                 Join Filter: (ci.movie_id = t.id)
                                 ->  Nested Loop  (cost=8.52..6612.03 rows=1 width=33) (actual time=0.764..158.698 rows=3406 loops=1)
                                       Join Filter: (it.id = mi.info_type_id)
                                       ->  Seq Scan on info_type it  (cost=0.00..2.41 rows=1 width=4) (actual time=0.009..0.014 rows=1 loops=1)
                                             Filter: ((info)::text = 'release dates'::text)
                                             Rows Removed by Filter: 112
                                       ->  Nested Loop  (cost=8.52..6609.60 rows=1 width=37) (actual time=0.754..158.321 rows=3406 loops=1)
                                             Join Filter: (mi.movie_id = t.id)
                                             ->  Nested Loop  (cost=8.08..6447.09 rows=6 width=29) (actual time=0.736..117.642 rows=1576 loops=1)
                                                   ->  Nested Loop  (cost=7.66..6421.97 rows=17 width=33) (actual time=0.720..100.509 rows=5566 loops=1)
                                                         Join Filter: (mc.movie_id = t.id)
                                                         ->  Nested Loop  (cost=7.23..6367.37 rows=16 width=25) (actual time=0.703..94.868 rows=495 loops=1)
                                                               ->  Nested Loop  (cost=6.80..6205.51 rows=101 width=4) (actual time=0.573..43.026 rows=9696 loops=1)
                                                                     ->  Seq Scan on keyword k  (cost=0.00..2852.84 rows=3 width=4) (actual time=0.012..10.909 rows=3 loops=1)
                                                                           Filter: (keyword = ANY ('{hero,martial-arts,hand-to-hand-combat}'::text[]))
                                                                           Rows Removed by Filter: 134167
                                                                     ->  Bitmap Heap Scan on movie_keyword mk  (cost=6.80..1114.50 rows=306 width=8) (actual time=0.526..10.376 rows=3232 loops=3)
                                                                           Recheck Cond: (k.id = keyword_id)
                                                                           Heap Blocks: exact=7446
                                                                           ->  Bitmap Index Scan on keyword_id_movie_keyword  (cost=0.00..6.73 rows=306 width=0) (actual time=0.307..0.307 rows=3232 loops=3)
                                                                                 Index Cond: (keyword_id = k.id)
                                                               ->  Index Scan using title_pkey on title t  (cost=0.43..1.60 rows=1 width=21) (actual time=0.005..0.005 rows=0 loops=9696)
                                                                     Index Cond: (id = mk.movie_id)
                                                                     Filter: (production_year > 2010)
                                                                     Rows Removed by Filter: 1
                                                         ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..3.35 rows=5 width=8) (actual time=0.007..0.010 rows=11 loops=495)
                                                               Index Cond: (movie_id = mk.movie_id)
                                                   ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..1.48 rows=1 width=4) (actual time=0.003..0.003 rows=0 loops=5566)
                                                         Index Cond: (id = mc.company_id)
                                                         Filter: ((country_code)::text = '[us]'::text)
                                                         Rows Removed by Filter: 1
                                             ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..27.07 rows=1 width=8) (actual time=0.008..0.025 rows=2 loops=1576)
                                                   Index Cond: (movie_id = mk.movie_id)
                                                   Filter: ((info IS NOT NULL) AND ((info ~~ 'Japan:%201%'::text) OR (info ~~ 'USA:%201%'::text)))
                                                   Rows Removed by Filter: 131
                                 ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..28.47 rows=1 width=16) (actual time=0.040..0.061 rows=4 loops=3406)
                                       Index Cond: (movie_id = mk.movie_id)
                                       Filter: (note = ANY ('{(voice),"(voice: Japanese version)","(voice) (uncredited)","(voice: English version)"}'::text[]))
                                       Rows Removed by Filter: 169
                           ->  Seq Scan on role_type rt  (cost=0.00..18.88 rows=4 width=4) (actual time=0.000..0.001 rows=1 loops=13758)
                                 Filter: ((role)::text = 'actress'::text)
                                 Rows Removed by Filter: 9
                     ->  Index Scan using name_pkey on name n  (cost=0.43..1.85 rows=1 width=19) (actual time=0.002..0.002 rows=0 loops=2778)
                           Index Cond: (id = ci.person_id)
                           Filter: ((name ~~ '%An%'::text) AND ((gender)::text = 'f'::text))
                           Rows Removed by Filter: 1
               ->  Index Scan using char_name_pkey on char_name chn  (cost=0.43..1.74 rows=1 width=20) (actual time=0.003..0.003 rows=1 loops=143)
                     Index Cond: (id = ci.person_role_id)
         ->  Index Only Scan using person_id_aka_name on aka_name an  (cost=0.42..0.99 rows=2 width=4) (actual time=0.002..0.002 rows=2 loops=141)
               Index Cond: (person_id = ci.person_id)
               Heap Fetches: 0
 Planning Time: 47.940 ms
 Execution Time: 388.195 ms
(62 rows)


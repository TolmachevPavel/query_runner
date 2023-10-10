                                                                                                   QUERY PLAN                                                                                                   
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=55715.41..55715.42 rows=1 width=64) (actual time=72.329..72.888 rows=1 loops=1)
   ->  Nested Loop  (cost=1003.30..55715.41 rows=1 width=32) (actual time=58.808..72.878 rows=15 loops=1)
         ->  Nested Loop  (cost=1003.15..55715.23 rows=1 width=36) (actual time=58.786..72.843 rows=15 loops=1)
               Join Filter: (ci.person_id = n.id)
               ->  Nested Loop  (cost=1002.72..55713.64 rows=1 width=29) (actual time=53.463..72.121 rows=275 loops=1)
                     ->  Nested Loop  (cost=1002.58..55713.44 rows=1 width=33) (actual time=53.455..71.907 rows=275 loops=1)
                           Join Filter: (mi.movie_id = t.id)
                           ->  Nested Loop  (cost=1002.14..55691.77 rows=1 width=41) (actual time=53.421..62.942 rows=275 loops=1)
                                 ->  Nested Loop  (cost=1001.72..55690.47 rows=1 width=45) (actual time=53.404..62.573 rows=275 loops=1)
                                       ->  Nested Loop  (cost=1001.30..55689.61 rows=1 width=41) (actual time=53.376..62.094 rows=99 loops=1)
                                             ->  Nested Loop  (cost=1000.87..55688.69 rows=1 width=45) (actual time=53.216..58.512 rows=100 loops=1)
                                                   Join Filter: (ci.movie_id = t.id)
                                                   ->  Gather  (cost=1000.43..55657.62 rows=1 width=29) (actual time=53.181..57.151 rows=4 loops=1)
                                                         Workers Planned: 2
                                                         Workers Launched: 2
                                                         ->  Nested Loop  (cost=0.43..54657.52 rows=1 width=29) (actual time=56.789..63.356 rows=1 loops=3)
                                                               ->  Parallel Seq Scan on title t  (cost=0.00..54443.61 rows=10 width=21) (actual time=8.358..63.272 rows=2 loops=3)
                                                                     Filter: ((production_year >= 2007) AND (production_year <= 2008) AND (title ~~ '%Kung%Fu%Panda%'::text))
                                                                     Rows Removed by Filter: 842768
                                                               ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..21.38 rows=1 width=8) (actual time=0.030..0.032 rows=1 loops=7)
                                                                     Index Cond: (movie_id = t.id)
                                                                     Filter: ((note ~~ '%(200%)%'::text) AND ((note ~~ '%(USA)%'::text) OR (note ~~ '%(worldwide)%'::text)))
                                                                     Rows Removed by Filter: 6
                                                   ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..31.06 rows=1 width=16) (actual time=0.011..0.335 rows=25 loops=4)
                                                         Index Cond: (movie_id = mc.movie_id)
                                                         Filter: (note = '(voice)'::text)
                                                         Rows Removed by Filter: 127
                                             ->  Index Only Scan using char_name_pkey on char_name chn  (cost=0.43..0.92 rows=1 width=4) (actual time=0.035..0.035 rows=1 loops=100)
                                                   Index Cond: (id = ci.person_role_id)
                                                   Heap Fetches: 0
                                       ->  Index Only Scan using person_id_aka_name on aka_name an  (cost=0.42..0.84 rows=2 width=4) (actual time=0.004..0.004 rows=3 loops=99)
                                             Index Cond: (person_id = ci.person_id)
                                             Heap Fetches: 0
                                 ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..1.29 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=275)
                                       Index Cond: (id = mc.company_id)
                                       Filter: ((country_code)::text = '[us]'::text)
                           ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..21.66 rows=1 width=8) (actual time=0.005..0.032 rows=1 loops=275)
                                 Index Cond: (movie_id = ci.movie_id)
                                 Filter: ((info IS NOT NULL) AND ((info ~~ 'Japan:%2007%'::text) OR (info ~~ 'USA:%2008%'::text)))
                                 Rows Removed by Filter: 295
                     ->  Index Scan using info_type_pkey on info_type it  (cost=0.14..0.17 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=275)
                           Index Cond: (id = mi.info_type_id)
                           Filter: ((info)::text = 'release dates'::text)
               ->  Index Scan using name_pkey on name n  (cost=0.43..1.57 rows=1 width=19) (actual time=0.002..0.002 rows=0 loops=275)
                     Index Cond: (id = an.person_id)
                     Filter: ((name ~~ '%Angel%'::text) AND ((gender)::text = 'f'::text))
                     Rows Removed by Filter: 1
         ->  Index Scan using role_type_pkey on role_type rt  (cost=0.15..0.17 rows=1 width=4) (actual time=0.002..0.002 rows=1 loops=15)
               Index Cond: (id = ci.role_id)
               Filter: ((role)::text = 'actress'::text)
 Planning Time: 13.806 ms
 Execution Time: 73.082 ms
(52 rows)


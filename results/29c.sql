                                                                                                                  QUERY PLAN                                                                                                                   
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=2747.81..2747.82 rows=1 width=96) (actual time=6990.932..6990.941 rows=1 loops=1)
   ->  Nested Loop  (cost=24.25..2747.80 rows=1 width=48) (actual time=1972.622..6988.802 rows=16308 loops=1)
         ->  Nested Loop  (cost=24.11..2747.62 rows=1 width=52) (actual time=1972.536..6951.337 rows=67827 loops=1)
               Join Filter: (n.id = pi.person_id)
               ->  Nested Loop  (cost=23.68..2727.85 rows=1 width=60) (actual time=1972.518..6940.175 rows=189 loops=1)
                     ->  Nested Loop  (cost=23.26..2725.82 rows=1 width=64) (actual time=1971.442..6938.953 rows=858 loops=1)
                           ->  Nested Loop  (cost=23.11..2725.08 rows=1 width=68) (actual time=1971.421..6938.359 rows=858 loops=1)
                                 ->  Nested Loop  (cost=22.68..2722.75 rows=1 width=49) (actual time=420.198..6870.665 rows=64937 loops=1)
                                       ->  Nested Loop  (cost=22.54..2722.56 rows=1 width=53) (actual time=420.189..6828.848 rows=64937 loops=1)
                                             Join Filter: (mi.movie_id = t.id)
                                             ->  Nested Loop  (cost=22.10..2684.66 rows=1 width=69) (actual time=420.151..6064.674 rows=19654 loops=1)
                                                   ->  Nested Loop  (cost=21.67..2676.49 rows=4 width=73) (actual time=0.585..4112.884 rows=11324314 loops=1)
                                                         ->  Nested Loop  (cost=21.24..2669.59 rows=2 width=65) (actual time=0.560..2293.336 rows=97095 loops=1)
                                                               ->  Nested Loop  (cost=20.82..2668.30 rows=1 width=61) (actual time=0.540..2245.688 rows=33857 loops=1)
                                                                     ->  Nested Loop  (cost=20.39..2663.45 rows=1 width=53) (actual time=0.513..2232.877 rows=2124 loops=1)
                                                                           ->  Nested Loop  (cost=19.96..2658.96 rows=2 width=41) (actual time=0.493..2219.835 rows=2309 loops=1)
                                                                                 ->  Nested Loop  (cost=19.53..2650.06 rows=4 width=20) (actual time=0.470..2200.116 rows=7127 loops=1)
                                                                                       ->  Nested Loop  (cost=19.09..2483.22 rows=4 width=4) (actual time=0.056..30.090 rows=17879 loops=1)
                                                                                             ->  Hash Join  (cost=18.93..2462.50 rows=761 width=8) (actual time=0.041..21.701 rows=24592 loops=1)
                                                                                                   Hash Cond: (cc.status_id = cct2.id)
                                                                                                   ->  Seq Scan on complete_cast cc  (cost=0.00..2086.86 rows=135086 width=12) (actual time=0.012..8.300 rows=135086 loops=1)
                                                                                                   ->  Hash  (cost=18.88..18.88 rows=4 width=4) (actual time=0.020..0.021 rows=1 loops=1)
                                                                                                         Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                                                                         ->  Seq Scan on comp_cast_type cct2  (cost=0.00..18.88 rows=4 width=4) (actual time=0.011..0.011 rows=1 loops=1)
                                                                                                               Filter: ((kind)::text = 'complete+verified'::text)
                                                                                                               Rows Removed by Filter: 3
                                                                                             ->  Memoize  (cost=0.16..0.58 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=24592)
                                                                                                   Cache Key: cc.subject_id
                                                                                                   Cache Mode: logical
                                                                                                   Hits: 24590  Misses: 2  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                                                                                   ->  Index Scan using comp_cast_type_pkey on comp_cast_type cct1  (cost=0.15..0.57 rows=1 width=4) (actual time=0.009..0.009 rows=0 loops=2)
                                                                                                         Index Cond: (id = cc.subject_id)
                                                                                                         Filter: ((kind)::text = 'cast'::text)
                                                                                                         Rows Removed by Filter: 0
                                                                                       ->  Index Scan using movie_id_cast_info on cast_info ci  (cost=0.44..41.70 rows=1 width=16) (actual time=0.106..0.121 rows=0 loops=17879)
                                                                                             Index Cond: (movie_id = cc.movie_id)
                                                                                             Filter: (note = ANY ('{(voice),"(voice: Japanese version)","(voice) (uncredited)","(voice: English version)"}'::text[]))
                                                                                             Rows Removed by Filter: 55
                                                                                 ->  Index Scan using title_pkey on title t  (cost=0.43..2.22 rows=1 width=21) (actual time=0.002..0.002 rows=0 loops=7127)
                                                                                       Index Cond: (id = ci.movie_id)
                                                                                       Filter: ((production_year >= 2000) AND (production_year <= 2010))
                                                                                       Rows Removed by Filter: 1
                                                                           ->  Index Scan using char_name_pkey on char_name chn  (cost=0.43..2.25 rows=1 width=20) (actual time=0.005..0.005 rows=1 loops=2309)
                                                                                 Index Cond: (id = ci.person_role_id)
                                                                     ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..4.80 rows=5 width=8) (actual time=0.002..0.004 rows=16 loops=2124)
                                                                           Index Cond: (movie_id = t.id)
                                                               ->  Index Only Scan using person_id_aka_name on aka_name an  (cost=0.42..1.27 rows=2 width=4) (actual time=0.001..0.001 rows=3 loops=33857)
                                                                     Index Cond: (person_id = ci.person_id)
                                                                     Heap Fetches: 0
                                                         ->  Index Scan using movie_id_movie_keyword on movie_keyword mk  (cost=0.43..2.98 rows=47 width=8) (actual time=0.001..0.009 rows=117 loops=97095)
                                                               Index Cond: (movie_id = t.id)
                                                   ->  Memoize  (cost=0.43..2.03 rows=1 width=4) (actual time=0.000..0.000 rows=0 loops=11324314)
                                                         Cache Key: mk.keyword_id
                                                         Cache Mode: logical
                                                         Hits: 11313848  Misses: 10466  Evictions: 0  Overflows: 0  Memory Usage: 696kB
                                                         ->  Index Scan using keyword_pkey on keyword k  (cost=0.42..2.02 rows=1 width=4) (actual time=0.004..0.004 rows=0 loops=10466)
                                                               Index Cond: (id = mk.keyword_id)
                                                               Filter: (keyword = 'computer-animation'::text)
                                                               Rows Removed by Filter: 1
                                             ->  Index Scan using movie_id_movie_info on movie_info mi  (cost=0.43..37.89 rows=1 width=8) (actual time=0.004..0.038 rows=3 loops=19654)
                                                   Index Cond: (movie_id = mk.movie_id)
                                                   Filter: ((info IS NOT NULL) AND ((info ~~ 'Japan:%200%'::text) OR (info ~~ 'USA:%200%'::text)))
                                                   Rows Removed by Filter: 373
                                       ->  Index Scan using info_type_pkey on info_type it  (cost=0.14..0.16 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=64937)
                                             Index Cond: (id = mi.info_type_id)
                                             Filter: ((info)::text = 'release dates'::text)
                                 ->  Index Scan using name_pkey on name n  (cost=0.43..2.34 rows=1 width=19) (actual time=0.001..0.001 rows=0 loops=64937)
                                       Index Cond: (id = ci.person_id)
                                       Filter: ((name ~~ '%An%'::text) AND ((gender)::text = 'f'::text))
                                       Rows Removed by Filter: 1
                           ->  Index Scan using role_type_pkey on role_type rt  (cost=0.15..0.57 rows=1 width=4) (actual time=0.000..0.000 rows=1 loops=858)
                                 Index Cond: (id = ci.role_id)
                                 Filter: ((role)::text = 'actress'::text)
                     ->  Index Scan using company_name_pkey on company_name cn  (cost=0.42..2.03 rows=1 width=4) (actual time=0.001..0.001 rows=0 loops=858)
                           Index Cond: (id = mc.company_id)
                           Filter: ((country_code)::text = '[us]'::text)
                           Rows Removed by Filter: 1
               ->  Index Scan using person_id_person_info on person_info pi  (cost=0.43..19.44 rows=26 width=8) (actual time=0.001..0.027 rows=359 loops=189)
                     Index Cond: (person_id = an.person_id)
         ->  Index Scan using info_type_pkey on info_type it3  (cost=0.14..0.16 rows=1 width=4) (actual time=0.000..0.000 rows=0 loops=67827)
               Index Cond: (id = pi.info_type_id)
               Filter: ((info)::text = 'trivia'::text)
               Rows Removed by Filter: 1
 Planning Time: 67.913 ms
 Execution Time: 6991.312 ms
(85 rows)


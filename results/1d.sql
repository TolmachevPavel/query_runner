                                                                                     QUERY PLAN                                                                                     
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Finalize Aggregate  (cost=19589.25..19589.26 rows=1 width=68) (actual time=48.550..50.806 rows=1 loops=1)
   ->  Gather  (cost=19589.02..19589.23 rows=2 width=68) (actual time=48.139..50.798 rows=3 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         ->  Partial Aggregate  (cost=18589.02..18589.03 rows=1 width=68) (actual time=45.890..45.893 rows=1 loops=3)
               ->  Nested Loop  (cost=22.21..18588.71 rows=42 width=45) (actual time=45.873..45.886 rows=1 loops=3)
                     ->  Hash Join  (cost=21.78..18544.34 rows=76 width=32) (actual time=45.836..45.862 rows=2 loops=3)
                           Hash Cond: (mc.company_type_id = ct.id)
                           ->  Nested Loop  (cost=2.86..18489.92 rows=13441 width=36) (actual time=45.785..45.839 rows=33 loops=3)
                                 ->  Hash Join  (cost=2.43..15286.60 rows=5089 width=4) (actual time=45.767..45.769 rows=3 loops=3)
                                       Hash Cond: (mi_idx.info_type_id = it.id)
                                       ->  Parallel Seq Scan on movie_info_idx mi_idx  (cost=0.00..13718.15 rows=575015 width=8) (actual time=0.014..22.528 rows=460012 loops=3)
                                       ->  Hash  (cost=2.41..2.41 rows=1 width=4) (actual time=0.023..0.023 rows=1 loops=3)
                                             Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                             ->  Seq Scan on info_type it  (cost=0.00..2.41 rows=1 width=4) (actual time=0.017..0.018 rows=1 loops=3)
                                                   Filter: ((info)::text = 'bottom 10 rank'::text)
                                                   Rows Removed by Filter: 112
                                 ->  Index Scan using movie_id_movie_companies on movie_companies mc  (cost=0.43..0.60 rows=3 width=32) (actual time=0.016..0.019 rows=10 loops=10)
                                       Index Cond: (movie_id = mi_idx.movie_id)
                                       Filter: (note !~~ '%(as Metro-Goldwyn-Mayer Pictures)%'::text)
                                       Rows Removed by Filter: 2
                           ->  Hash  (cost=18.88..18.88 rows=4 width=4) (actual time=0.039..0.039 rows=1 loops=1)
                                 Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                 ->  Seq Scan on company_type ct  (cost=0.00..18.88 rows=4 width=4) (actual time=0.029..0.029 rows=1 loops=1)
                                       Filter: ((kind)::text = 'production companies'::text)
                                       Rows Removed by Filter: 3
                     ->  Index Scan using title_pkey on title t  (cost=0.43..0.58 rows=1 width=25) (actual time=0.014..0.014 rows=1 loops=5)
                           Index Cond: (id = mc.movie_id)
                           Filter: (production_year > 2000)
                           Rows Removed by Filter: 0
 Planning Time: 1.602 ms
 Execution Time: 50.931 ms
(32 rows)


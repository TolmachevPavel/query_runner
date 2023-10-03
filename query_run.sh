#!/bin/bash
#название директории где лежат запросы (для удобства, можно другой каталог с запросами подставить)
job_dir="join-order-benchmark2"

#Очистка прошлых результатов
rm -rf results/*
rm -rf PlanTime
rm -rf ExecTime

#Выполняю запросы из списка list
for var in $(ls ~/$job_dir | grep '^[1-9]')
  do
	psql -d imdb -f ~/$job_dir/$var -o results/$var
  done
  
#Вырезаю нужные строки, сортирую по названию файла, итоговое время сохраняю в файлы
grep -r "Planning Time:" results/ | sed 's|.*/||' | sort -n | awk '{print $4}' > PlanTime
grep -r "Execution Time:" results/ | sed 's|.*/||' | sort -n | awk '{print $4}' > ExecTime

#!/bin/bash
#название директории где лежат запросы (для удобства, можно другой каталог с запросами подставить)
job_dir="join-order-benchmark"

#Очистка прошлых результатов
rm -rf results/*
rm -rf PlanTime
rm -rf ExecTime
rm -rf PE_Time.jpeg

#Выполняю запросы из списка list
for var in $(ls ~/$job_dir | grep '^[1-9]')
  do
	psql -d imdb -f ~/$job_dir/$var -o results/$var
  done
  
#Вырезаю нужные строки, сортирую по названию файла, итоговое время сохраняю в файлы
grep -r "Planning Time:" results/ | sed 's|.*/||' | sort -n | awk '{print $4}' > PlanTime
grep -r "Execution Time:" results/ | sed 's|.*/||' | sort -n | awk '{print $4}' > ExecTime

#Добавляю нулевую точку в начало и конец файлов результатов - нужно для построения графика
sed -i -e '1 s/^/0\n/;' PlanTime
sed -i -e '1 s/^/0\n/;' ExecTime
echo 0 >> PlanTime
echo 0 >> ExecTime

#Запускаю скрипт построения графика. Результат сохраняется в файл PE_Time.jpeg
gnuplot -e "load 'gn_graph.gpi'"

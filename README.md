# query_runner
A means of executing a large number of queries

Первая задача - средство запуска [join order benchmark](https://github.com/gregrahn/join-order-benchmark)'a.
Далее хочется сделать этот инструмент универсальным, чтобы собиралось больше данных (BUFFERS например) и можно было бы запускать другие наборы запросов.

Как запустить:

 - Установить по инструкции [join order benchmark](https://github.com/gregrahn/join-order-benchmark) (должна появится база imdb);
 - Получить путь до директории с запросами JOB, там 113 запросов (по умолчанию будет join-order-benchmark);
 - В скрипте query_runner.sh указать адрес до этой директории в переменной job_dir;
 - Запустить ./query_runner.sh;
 - После окончания работы скрипта сформируется картинка с графиками PE_Time.jpeg.
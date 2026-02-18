/* Оптимизация с помощью партиций
К созданной витрине часто обращаются с запросами, содержащими дату полета.
Создаем таблицу fct_flight_part, которая будет партицирована по месяцам scheduled_departure
Все партиции называем в формате <название_таблицы>_год_месяц. Например, fct_flight_part_2016_01.
*/

--Отображение столбца год-дата из витрины
select to_char(scheduled_departure, 'YYYY-MM') as year_month, COUNT(*)
from fct_flights
GROUP BY year_month
fct_flight_part BY year_month ASC

--Создание таблицы с партицированием
CREATE TABLE fct_flight_part (
	LIKE fct_flights INCLUDING ALL
	)
PARTITION BY RANGE (scheduled_departure);

--Проверка таблицы
select *
from fct_flight_part ffp ;

--Создание партиций
CREATE TABLE fct_flight_part_2016_01 PARTITION OF fct_flight_part
	FOR VALUES FROM ('2016_01-01'::date) TO ('2016_02-01'::date);
CREATE TABLE fct_flight_part_2016_02 PARTITION OF fct_flight_part
	FOR VALUES FROM ('2016_02-01'::date) TO ('2016_03-01'::date);
CREATE TABLE fct_flight_part_2016_03 PARTITION OF fct_flight_part
	FOR VALUES FROM ('2016_03-01'::date) TO ('2016_04-01'::date);
CREATE TABLE fct_flight_part_2016_04 PARTITION OF fct_flight_part
	FOR VALUES FROM ('2016_04-01'::date) TO ('2016_05-01'::date);
CREATE TABLE fct_flight_part_2016_05 PARTITION OF fct_flight_part
	FOR VALUES FROM ('2016_05-01'::date) TO ('2016_06-01'::date);
CREATE TABLE fct_flight_part_2016_06 PARTITION OF fct_flight_part
	FOR VALUES FROM ('2016_06-01'::date) TO ('2016_07-01'::date);
CREATE TABLE fct_flight_part_2016_07 PARTITION OF fct_flight_part
	FOR VALUES FROM ('2016_07-01'::date) TO ('2016_08-01'::date);
CREATE TABLE fct_flight_part_2016_08 PARTITION OF fct_flight_part
	FOR VALUES FROM ('2016_08-01'::date) TO ('2016_09-01'::date);
CREATE TABLE fct_flight_part_2016_09 PARTITION OF fct_flight_part
	FOR VALUES FROM ('2016_09-01'::date) TO ('2016_10-01'::date);
CREATE TABLE fct_flight_part_2016_10 PARTITION OF fct_flight_part
	FOR VALUES FROM ('2016_10-01'::date) TO ('2016_11-01'::date);
CREATE TABLE fct_flight_part_2016_11 PARTITION OF fct_flight_part
	FOR VALUES FROM ('2016_11-01'::date) TO ('2016_12-01'::date);
CREATE TABLE fct_flight_part_2016_12 PARTITION OF fct_flight_part
	FOR VALUES FROM ('2016_12-01'::date) TO ('2016_12-31'::date);

--Проверка наличия партиций в системных таблицах
SELECT
	inhrelid::regclass AS partition_name,
	inhparent::regclass AS parent_table
FROM pg_inherits
WHERE inhparent = 'fct_flight_part'::regclass;

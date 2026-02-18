/*Оптимизируем таблицу fct_flights_weather_mart_opt
Оптимизация на базе запросов
>>  Шаг 1
Большая часть запросов идет с использованием даты scheduled_departure
Добавим партицию по месяцу в таблицу
>>  Шаг 2
Часть запросов используют единичные flight_id
Для ускорения таких запросов добавим первичный ключ и сортировку по flight_id
>>  Шаг  3
Аналитики часто фильтруют по аэропорту прилета и вылета
Добавим скип индекс по этим полям
*/

CREATE OR REPLACE TABLE startde_student_data.marija_shkurat_wrn7887_fct_flights_weather_mart_opt
(
	--flights
	flight_id 					UInt32,
    flight_no 					String,
    scheduled_departure			DateTime,
    scheduled_arrival 			DateTime,
    departure_airport 			String,
    arrival_airport 			String,
    status 						String,
    aircraft_code 				String,
    actual_departure 			DateTime,
    actual_arrival 				DateTime,
    
    --ticket_flights_raw
	fare_conditions 			String,
	amount 						String,

	--tickets_raw
	ticket_no 					String,
	book_ref 					String,
	passenger_id 				String,
	passenger_name 				String,
	contact_data 				String,
	
	--bookings_raw
	book_date 					String NOT NUll,
	total_amount 				String NOT NULL,
	
	--weather_data_hourly
	departure_temperature		Float32, 
	departure_humidity 			UInt8, 
	departure_wind_speed 		Float32,
	departure_condition			String,
	
	arrival_temperature			Float32, 
	arrival_humidity 			UInt8, 
	arrival_wind_speed 			Float32,
	arrival_condition			String
)
ENGINE = MergeTree
PARTITION BY toYYYYMM(scheduled_departure)
PRIMARY KEY flight_id
ORDER BY (flight_id);

INSERT INTO startde_student_data.marija_shkurat_wrn7887_fct_flights_weather_mart_opt
SELECT *
FROM startde_student_data.marija_shkurat_wrn7887_fct_flights_weather_mart;

ALTER TABLE startde_student_data.marija_shkurat_wrn7887_fct_flights_weather_mart_opt
ADD INDEX departure_airport_idx (departure_airport) TYPE ngrambf_v1(3, 256, 2, 1) GRANULARITY 4;

ALTER TABLE startde_student_data.marija_shkurat_wrn7887_fct_flights_weather_mart_opt
ADD INDEX arrival_airport_idx (arrival_airport) TYPE ngrambf_v1(3, 256, 2,  1) GRANULARITY 4;


EXPLAIN indexes = 1 
SELECT *
FROM startde_student_data.marija_shkurat_wrn7887_fct_flights_weather_mart_opt;


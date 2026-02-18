/*Создаем представление, которое объединяет информацию об аэропортах вылета и прилета для всех рейсов. 
Это представление будет служить важным инструментом для анализа и мониторинга полетов, 
облегчающим доступ к ключевой информации о каждом рейсе.*/

create view marija_shkurat_wrn7887.flight_airport_info as 
select 
	   f.flight_no,									--номер рейса
	   f.flight_id,									--id рейса
	   f.scheduled_departure,						--запланированное время вылета
	   f.scheduled_arrival,							--запланированное время прибытия
	   f.aircraft_code,								--код воздушного судна
	   f.actual_departure,							--актуальное время вылета
	   f.actual_arrival,							--актуальное время прибытия
	   f.status,									--статус рейса
	   
	   --вся информация об аэропортах прилета
	   fa.airport_code 	as arrival_airport,	--id аэропорта
	   fa.airport_name 	as arrival_airport_name,	--имя аэропорта
	   fa.city 			as arrival_city,			--город
	   fa.longitude 	as arrival_longitude,		--широта 
	   fa.latitude 		as arrival_latitude,		--долгота
	   fa.timezone 		as arrival_timezone,		--часовой пояс
	   
	   --вся информация об аэропортах вылета
	   faf.airport_code as departure_airport,	--id аэропорта
	   faf.airport_name as departure_airport_name,	--имя аэропорта
	   faf.city 		as departure_city,			--город
	   faf.longitude 	as departure_longitude,		--широта 
	   faf.latitude 	as departure_latitude,		--долгота
	   faf.timezone 	as departure_timezone		--часовой пояс
from   bookings.flights f 
join   bookings.airports fa on f.arrival_airport = fa.airport_code		--к рейсам джойним аэропорты прибытия
join   bookings.airports faf on f.departure_airport = faf.airport_code  --джойним аэропорты вылета

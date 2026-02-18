-- Создаем централизованное место хранения всей информация о маршрутах
create table routes (
	flight_no 			char(6) primary key, 		-- номер рейса
	departure_airport 	char(3),		    	  -- код аэропорта вылета
	arrival_airport 	char(3),				  -- код аэропорта прилета
	aircraft_code 		char(3), 			   		--код самолета
	duration 			interval 					        /*продолжительность полета, 
													                которая будет рассчитана как разница между запланированными временами вылета и прилета*/
);

--Заполняем таблицу данными
insert into routes (flight_no,departure_airport,arrival_airport,aircraft_code,duration)
select 
		distinct flight_no	::char(6),
		departure_airport 	::char(3),
		arrival_airport		  ::char(3),
		aircraft_code 	  	::char(3),
		(scheduled_arrival - scheduled_departure) ::interval as duration
from 	bookings.flights	

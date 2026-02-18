/*Создание функции для обработки информации о местах в самолете и создание таблицы 
для хранения данных о посадочных талонах.*/

-- Функция get_row — принимает на вход seat 
--(номер места в формате, например, "12A") и возвращает соответствующий ряд (например, 12)

create or replace function get_row(seat text) returns integer
language sql
as $$ select substring(seat from '^[0-9]+')::integer;
$$
;

-- Функция get_seat — принимает на вход seat 
-- и возвращает номер кресла (например, из "12А" она вернет "А")

create or replace function get_seat(seat text) returns char(1)
language sql
as $$ select substring(seat from '[A-Za-z]+$')::char(1);
$$;

-- создание таблицы
create table boarding_passes(
	ticket_no bpchar(13),
	flight_id int4,
	boarding_no int4,
	seat_no varchar(4),
	row integer,
	seat char(1)
); 

insert into boarding_passes(ticket_no,flight_id,boarding_no,seat_no,"row",seat)
select 
	ticket_no,
	flight_id,
	boarding_no,
	seat_no,
	get_row(seat_no),
	get_seat(seat_no)
from bookings.boarding_passes;



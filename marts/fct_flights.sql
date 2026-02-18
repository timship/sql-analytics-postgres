/*Сбор информации о рейсах, тарифных условиях, пассажирах, бронированиях и, если доступно, посадочных талонах для всех рейсов, которые:
запланированы не ранее 1 января 2016 года,
имеют статус "Arrived".*/

create table fct_flights  as
select f.*, tf.fare_conditions , tf.amount , t.* , b.book_date, b.total_amount, bp.boarding_no , bp.seat_no
from flight_airport_info f
inner join bookings.ticket_flights tf on tf.flight_id = f.flight_id
inner join bookings.tickets t on t.ticket_no = tf.ticket_no
inner join bookings.bookings b on b.book_ref = t.book_ref
left join bookings.boarding_passes bp on bp.ticket_no = tf.ticket_no and bp.flight_id = tf.flight_id
where f.scheduled_departure >= '2016-01-01' and f.status = 'Arrived';

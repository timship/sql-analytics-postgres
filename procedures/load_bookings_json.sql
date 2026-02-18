/*Процедура load_bookings_json последовательно:
- заполняет bookings
- заполняет tickets_raw
- заполняет ticket_flights_raw */

CREATE OR REPLACE PROCEDURE public.load_bookings_json()
LANGUAGE plpgsql
AS $$
BEGIN

  -- Обновление или вставка данных в таблицу bookings
  MERGE INTO public.bookings AS tgt
  USING (
      SELECT
          book_ref,
          book_date,
          total_amount
      FROM
          bookings.bookings_json
     LIMIT 100
  ) AS src
  ON tgt.book_ref = src.book_ref
  WHEN MATCHED THEN
      UPDATE SET
          book_date = src.book_date,
          total_amount = src.total_amount,
          _etl_updated_dttm = now()
  WHEN NOT MATCHED THEN
      INSERT (book_ref, book_date, total_amount, _etl_updated_dttm)
      VALUES (src.book_ref, src.book_date, src.total_amount, now());



  -- Обновление или вставка данных в таблицу tickets
  WITH extracted_tickets AS (
      SELECT
          tickets ->> 'ticket_no' AS ticket_no,
          bj.book_ref AS book_ref,
          tickets ->> 'passenger_id' AS passenger_id,
          tickets ->> 'passenger_name' AS passenger_name,
          tickets -> 'contact_data' AS contact_data
      FROM bookings.bookings_json bj, json_array_elements(bj.json_data) AS tickets
      LIMIT 100
  )
  MERGE INTO public.tickets_raw AS tgt
  USING extracted_tickets AS src
  ON tgt.ticket_no = src.ticket_no
  WHEN MATCHED THEN
      UPDATE SET
          book_ref = src.book_ref,
          passenger_id = src.passenger_id,
          passenger_name = src.passenger_name,
          contact_data = src.contact_data,
          _etl_updated_dttm = now()
  WHEN NOT MATCHED THEN
      INSERT (ticket_no, book_ref, passenger_id, passenger_name, contact_data, _etl_updated_dttm)
      VALUES (src.ticket_no, src.book_ref, src.passenger_id, src.passenger_name, src.contact_data, now());


  -- Обновление или вставка данных в таблицу ticket_flights
  WITH step_1 AS (
      SELECT
          tickets ->> 'ticket_no' AS ticket_no,
          json_data AS flights
      FROM bookings.bookings_json bj, json_array_elements(bj.json_data) AS tickets
  ), extracted_flights AS (
      SELECT
          ticket_no,
          flights ->> 'flight_id' AS flight_id,
          flights ->> 'fare_conditions' AS fare_conditions,
          flights ->> 'amount' AS amount
      FROM step_1, json_array_elements(step_1.flights) AS flights
      LIMIT 100
  )
  MERGE INTO public.ticket_flights_raw AS tf
  USING extracted_flights AS ef
  ON tf.ticket_no = ef.ticket_no AND tf.flight_id = ef.flight_id
  WHEN MATCHED THEN
      UPDATE SET
          fare_conditions = ef.fare_conditions,
          amount = ef.amount,
          _etl_updated_dttm = now()
  WHEN NOT MATCHED THEN
      INSERT (ticket_no, flight_id, fare_conditions, amount, _etl_updated_dttm)
      VALUES (ef.ticket_no, ef.flight_id, ef.fare_conditions, ef.amount, now());
END;
$$;

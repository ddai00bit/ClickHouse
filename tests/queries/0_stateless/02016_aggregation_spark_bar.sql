DROP TABLE IF EXISTS spark_bar_test;

CREATE TABLE spark_bar_test (`cnt` UInt64,`event_date` Date) ENGINE = MergeTree ORDER BY event_date SETTINGS index_granularity = 8192;

INSERT INTO spark_bar_test VALUES(1,'2020-01-01'),(4,'2020-01-02'),(5,'2020-01-03'),(2,'2020-01-04'),(3,'2020-01-05'),(7,'2020-01-06'),(6,'2020-01-07'),(8,'2020-01-08'),(2,'2020-01-11');

SELECT sparkbar(1)(event_date,cnt) FROM spark_bar_test;
SELECT sparkbar(2)(event_date,cnt) FROM spark_bar_test;
SELECT sparkbar(3)(event_date,cnt) FROM spark_bar_test;
SELECT sparkbar(4)(event_date,cnt) FROM spark_bar_test;
SELECT sparkbar(5)(event_date,cnt) FROM spark_bar_test;
SELECT sparkbar(6)(event_date,cnt) FROM spark_bar_test;
SELECT sparkbar(7)(event_date,cnt) FROM spark_bar_test;
SELECT sparkbar(8)(event_date,cnt) FROM spark_bar_test;
SELECT sparkbar(9)(event_date,cnt) FROM spark_bar_test;
SELECT sparkbar(10)(event_date,cnt) FROM spark_bar_test;
SELECT sparkbar(11)(event_date,cnt) FROM spark_bar_test;

SELECT sparkbar(11,2,5)(event_date,cnt) FROM spark_bar_test;
SELECT sparkbar(11,3,7)(event_date,cnt) FROM spark_bar_test;
SELECT sparkbar(11,4,11)(event_date,cnt) FROM spark_bar_test;

SELECT sparkbar(11,toDate('2020-01-02'),toDate('2020-01-02'))(event_date,cnt) FROM spark_bar_test;
SELECT sparkbar(11,toDate('2020-01-02'),toDate('2020-01-05'))(event_date,cnt) FROM spark_bar_test;
SELECT sparkbar(11,toDate('2020-01-03'),toDate('2020-01-07'))(event_date,cnt) FROM spark_bar_test;
SELECT sparkbar(11,toDate('2020-01-04'),toDate('2020-01-11'))(event_date,cnt) FROM spark_bar_test;

SELECT sparkbar(2,toDate('2020-01-01'),toDate('2020-01-08'))(event_date,cnt) FROM spark_bar_test;
SELECT sparkbar(2,toDate('2020-01-02'),toDate('2020-01-09'))(event_date,cnt) FROM spark_bar_test;
SELECT sparkbar(3,toDate('2020-01-01'),toDate('2020-01-09'))(event_date,cnt) FROM spark_bar_test;
SELECT sparkbar(3,toDate('2020-01-01'),toDate('2020-01-10'))(event_date,cnt) FROM spark_bar_test;
SELECT sparkbar(4,toDate('2020-01-01'),toDate('2020-01-08'))(event_date,cnt) FROM spark_bar_test;
SELECT sparkbar(5,toDate('2020-01-01'),toDate('2020-01-10'))(event_date,cnt) FROM spark_bar_test;

DROP TABLE IF EXISTS spark_bar_test;

WITH number DIV 50 AS k, number % 50 AS value SELECT k, sparkbar(50, 0, 99)(number, value) FROM numbers(100) GROUP BY k ORDER BY k;

-- OOM guard
DROP TABLE IF EXISTS spark_bar_oom;
CREATE TABLE spark_bar_oom (x UInt64, y UInt8) Engine=MergeTree ORDER BY tuple();
INSERT INTO spark_bar_oom VALUES (18446744073709551615,255),(0,0),(0,0),(4036797895307271799,163);
SELECT sparkbar(9)(x,y) FROM spark_bar_oom SETTINGS max_memory_usage = 100000000; -- { serverError 241 }
DROP TABLE IF EXISTS spark_bar_oom;

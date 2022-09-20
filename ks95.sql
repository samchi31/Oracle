-- 잔여좌석 = TOTAL - 예약 수
-- 예약 수 = COURSE_ID 별로
-- COURSE의 AIRPLANE_ID 와 AIRPLANE의 AIRPLANE_ID
UPDATE airplane a
    SET
        ( a.seat_remain ) = (
            SELECT
                a.seat_total - b.bsum
            FROM
                (
                    SELECT
                        COUNT(c.reserv_id) AS bsum,
                        d.airplane_id AS bid
                    FROM
                        reservation c,
                        course d
                    WHERE
                        c.course_id = d.course_id
                    GROUP BY
                        d.airplane_id
                ) b
            WHERE
                b.bid = a.airplane_id
        )
WHERE
    a.airplane_id IN (
        SELECT
            f.airplane_id
        FROM
            reservation e,
            course f
        WHERE
            e.course_id = f.course_id
    )
-- 예약 시 마일리지 COURSE_PRICE * 0.01 * 탑승 수 만큼 update
commit;
ROLLBACK;

UPDATE member c SET     ( c.mem_mileage) = C.MEM_MILEAGE + (
                        SELECT  A.COURSE_PRICE * 0.01 * COUNT(B.MEM_ID)
                        FROM    COURSE A, RESERVATION B
                        WHERE   A.COURSE_ID = B.COURSE_ID
                        AND     B.MEM_ID = 'B001'
                        GROUP   by A.COURSE_PRICE)
where   MEM_ID = 'B001';
                        
                        
select  mem_id,
        password,
from    member
where   mem_id = ? SELECT
    a.course_id,
    a.dep_location,
    a.dep_date,
    a.dep_time,
    a.airport_id,
    a.arr_time,
    a.airplane_id,
    a.price,
    a.distance,
    b.airline,
    b.seat_remain
FROM
    course a,
    airplane b
WHERE
    a.airplane_id = b.airplane_id
    AND   a.airport_id = 'HAN'
        AND   a.dep_date = TO_DATE('2022/09/16','YYYY/MM/DD')
            AND   b.seat_remain >= 3
            
                
SELECT seat_no
FROM
    reservation a,
    course b
WHERE
    a.course_id = b.course_id
    AND   a.course_id =?;
    
    
INSERT INTO reservation (
    reserv_id,
    mem_id,
    course_id,
    seat_no,
    pass_name,
    pass_phone,
    pass_reg,
    cancel
) VALUES (
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?
);


SELECT ");
		builder.append("    a.cancel, ");
		builder.append("    a.reserv_id, ");
		builder.append("    a.pass_name, ");
		builder.append("    a.course_id, ");
		builder.append("    a.seat_no, ");
		builder.append("    b.dep_location, ");
		builder.append("    b.dep_date, ");
		builder.append("    b.dep_time, ");
		builder.append("    b.airport_id, ");
		builder.append("    b.arr_time,  ");
		builder.append("    c.airline, ");
		builder.append("    b.airplane_id ");
		builder.append("FROM ");
		builder.append("    reservation a, ");
		builder.append("    course b, ");
		builder.append("    airplane c ");
		builder.append("WHERE ");
		builder.append("    a.mem_id = ? ");
		builder.append("    AND	  a.course_id = ? ");
		builder.append("    AND	  a.cancel = 'N' ");
		builder.append("    AND   a.course_id = b.course_id ");
		builder.append("    AND   b.airplane_id = c.airplane_id ");
		builder.append("ORDER BY ");
		builder.append("    1 
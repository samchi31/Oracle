SELECT
    nvl(MAX(reserv_id) + 1,TO_CHAR(SYSDATE,'YYYYMMDD')
    || '00001')
FROM
    reservation
WHERE
    substr(reserv_id,1,8) = TO_CHAR(SYSDATE,'YYYYMMDD');

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
    (
        SELECT
            nvl(MAX(reserv_id) + 1,TO_CHAR(SYSDATE,'YYYYMMDD')
            || '00001')
        FROM
            reservation
        WHERE
            substr(reserv_id,1,8) = TO_CHAR(SYSDATE,'YYYYMMDD')
    ),
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?
);
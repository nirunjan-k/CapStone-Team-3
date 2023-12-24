--calander dimension

drop table if exists Calendar_dim;


CREATE TABLE Calendar_Dim (
CalendarKey INT NOT NULL identity,
FullDate datetime,
Dayoftheweek varchar(max),
DayType varchar(max),
Dayofthemonth int,
Month varchar(max),
Quarter varchar(max),
Year int);

CREATE TABLE temp1 (
    orderdate DATETIME
);


IF NOT EXISTS (SELECT 1 FROM Calendar_Dim)
BEGIN

    INSERT INTO Calendar_Dim (FullDate, Dayoftheweek, DayType, Dayofthemonth, [Month], Quarter, [Year])
    SELECT distinct
        orderdate AS FullDate,
        FORMAT(orderdate, 'dddd') AS Dayoftheweek,
        CASE WHEN DATEPART(dw, orderdate) IN (1, 7) THEN 'Weekend' ELSE 'Weekday' END AS DayType,
        DAY(orderdate) AS Dayofthemonth,
        FORMAT(orderdate, 'MMMM') AS [Month],
        'Q' + CAST(DATEPART(QUARTER, orderdate) AS CHAR) AS Quarter,
        YEAR(orderdate) AS [Year]
    FROM
        STG_Orders;
END
ELSE
BEGIN
    INSERT INTO temp1 (orderdate)
    SELECT distinct orderdate
    FROM STG_Orders
    WHERE orderdate > (SELECT MAX(FullDate) FROM Calendar_Dim);

    INSERT INTO Calendar_Dim (FullDate, Dayoftheweek, DayType, Dayofthemonth, [Month], Quarter, [Year])
    SELECT
        orderdate AS FullDate,
        FORMAT(orderdate, 'dddd') AS Dayoftheweek,
        CASE WHEN DATEPART(dw, orderdate) IN (1, 7) THEN 'Weekend' ELSE 'Weekday' END AS DayType,
        DAY(orderdate) AS Dayofthemonth,
        FORMAT(orderdate, 'MMMM') AS [Month],
        'Q' + CAST(DATEPART(QUARTER, orderdate) AS CHAR) AS Quarter,
        YEAR(orderdate) AS [Year]
    FROM
        temp1;
END

DROP TABLE temp1;
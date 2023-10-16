Use tass; 


SELECT c.CustomerID, CONCAT(FirstName, " " , LastName) AS FullName, table1.PhoneNo 
FROM (SELECT cpe.CustomerID, CONCAT(cpe.CountryCode, "-", cpe.AreaCode, "-", cpe.LocalNumber) AS PhoneNo
FROM (SELECT *
FROM CustomerPhone cp
WHERE cp.CustomerID NOT IN 
(SELECT CustomerID
FROM CustomerEmail ce)) AS cpe
GROUP BY cpe.CustomerID
HAVING COUNT(cpe.LocalNumber) = 1) AS table1
INNER JOIN customer c
ON table1.CustomerID = c.CustomerID;


SELECT tab1.CountryName, tab1.CityName, tab1.TotalSales
FROM(
SELECT CountryName, CityName, SUM(TotalPrice) AS TotalSales
FROM Booking b
INNER JOIN `Status` s
ON (b.StatusID = s.StatusID
AND NOT s.`Status` = "Canceled")
INNER JOIN BookingOffice bo
ON bo.OfficeID = b.OfficeID
INNER JOIN City ci
ON bo.CityCode = ci.CityCode
INNER JOIN Country co
ON ci.CountryCode = co.CountryCode
GROUP BY CityName
ORDER BY CityName
) AS tab1
INNER JOIN (
SELECT CountryName, CityName, MAX(TotalSales) AS TotalSales
FROM (
SELECT CountryName, CityName, SUM(TotalPrice) AS TotalSales
FROM Booking b
INNER JOIN `Status` s
ON (b.StatusID = s.StatusID
AND NOT s.`Status` = "Canceled")
INNER JOIN BookingOffice bo
ON bo.OfficeID = b.OfficeID
INNER JOIN City ci
ON bo.CityCode = ci.CityCode
INNER JOIN Country co
ON ci.CountryCode = co.CountryCode
GROUP BY CityName
ORDER BY CityName
) AS temp
GROUP BY CountryName
) AS tab2
ON tab1.CountryName = tab2.CountryName AND tab1.TotalSales = tab2.TotalSales;

-- Question 1
SELECT CustomerID, FirstName, LastName FROM tass.customer WHERE Country = "Begonia" ORDER BY CustomerID;

-- Question 2 
SELECT DISTINCT FlightNumber FROM Booking WHERE 
BookingDate BETWEEN DATE("2022-11-01") AND DATE("2022-11-30") AND 
DepartureDateTime BETWEEN DATE("2023-01-01") AND DATE ("2023-01-31");

-- Question 3
SELECT FromCurrency, ToCurrency, AVG (ExchangeRate) AS AverageExchangeRate FROM `Exchange`
WHERE FromCurrency = "BegoniaDollar"
GROUP BY FromCurrency, ToCurrency
HAVING AVG(ExchangeRate) > 1
ORDER BY AVG(ExchangeRate) ;

-- Question 4
SELECT FlightNumber, COUNT(FlightNumber) as NumberOfFlights
FROM FlightAvailability
WHERE (OriginAirportCode = "AP09" and DestinationAirportCode = "AP02")
OR (OriginAirportCode = "AP02" and DestinationAirportCode = "AP09")
GROUP BY FlightNumber;

-- Question 5
SELECT AirlineCode, COUNT(FlightNumber) AS NumberOfFlightNumbers
FROM flight
GROUP BY AirlineCode;

-- Question 6
SELECT AirlineName, BusinessClassIndicator,  COUNT(FlightNumber) AS NumberOfFlightNumbers
FROM airline A INNER JOIN Flight F
ON F.AirlineCode = A.AirlineCode 
WHERE AirlineName LIKE "%u%" 
GROUP BY AirlineName, BusinessClassIndicator;

-- Question 7
SELECT OfficeID, COUNT(BookingID) AS NumberOfBookings
FROM booking
GROUP BY OfficeID
ORDER BY COUNT(BookingID) DESC LIMIT 3;

-- Question 8
SELECT FlightNumber
FROM flightavailability
GROUP BY FlightNumber
ORDER BY AVG(  (BookedBusinessSeats + BookedEconomySeats) / (TotalBusinessSeats + TotalEconomySeats) ) LIMIT 5;

-- Question 9
SELECT AVG(NumberOfPayments) AS AvgNumberOfPayments FROM (
SELECT BookingID, COUNT(PaymentID) AS NumberOfPayments
FROM payment
WHERE BookingID in (SELECT BookingID
FROM booking 
WHERE StatusID = "ST01")
GROUP BY BookingID ) as table1 ;

-- Question 10
SELECT ( CONCAT (ROUND((Foreigner / Total) * 100, 2), "%")) AS ForeignerPercent FROM
(SELECT COUNT(CustomerID) AS Total
FROM Customer ) AS table1, 
(SELECT COUNT(CustomerID) AS Foreigner
FROM customer
WHERE Nationality != Country) AS table2;



-- Question 11
SELECT BookingID
FROM booking 
WHERE BookingDate BETWEEN DATE("2022-10-16") AND DATE("2022-11-15") AND BookingID 
NOT IN (SELECT BookingID 
FROM payment);

-- Question 12
SELECT c.CustomerID, FirstName, LastName, MAX(PaymentDate) AS LatestPayment
FROM customer c 
LEFT JOIN payment p
ON c.CustomerID = p.CustomerID
WHERE Nationality = "Begonia"
GROUP BY c.CustomerID;


-- Question 13
SELECT table1.CustomerID, COUNT(DISTINCT(BookingID)) AS NumberOfBookings, COUNT(DISTINCT(Email)) AS NumberOfEmails,
COUNT(DISTINCT(LocalNumber)) AS NumberOfPhones
FROM (SELECT CustomerID
FROM customer
ORDER BY CustomerID LIMIT 5) AS table1 LEFT JOIN booking
ON table1.CustomerID = booking.CustomerID
LEFT JOIN customeremail
On table1.CustomerID = customeremail.CustomerID
LEFT JOIN customerphone
ON table1.CustomerID = customerphone.customerID
GROUP BY table1.CustomerID;

-- Question 14
SELECT flightavailability.FlightNumber, StdFlightPrice, AVG(TotalBusinessSeats - BookedBusinessSeats) AS AvgAvailableBusinessSeats,
AVG(TotalEconomySeats - BookedEconomySeats) AS AvgAvailableEconomySeats FROM
(SELECT FlightNumber, STD(FlightPrice) AS StdFlightPrice
FROM booking
GROUP BY FlightNumber
ORDER BY StdFlightPrice DESC LIMIT 5) AS table1
INNER JOIN flightavailability
ON flightavailability.FlightNumber = table1.FlightNumber
GROUP BY FlightNumber;

-- Question 15
SELECT customer.CustomerID, ( CONCAT(CONCAT(FirstName, " "), LastName)) AS FullName, 
( CONCAT(CONCAT(CONCAT(CONCAT(CountryCode, "-"), AreaCode), "-"),LocalNumber)) AS `PhoneNo.` 
FROM
(SELECT CustomerID
FROM customerphone 
WHERE CustomerID NOT IN(
SELECT DISTINCT(CustomerID)
FROM customeremail)
GROUP BY CustomerID
HAVING COUNT(LocalNumber) = 1) as table1 
INNER JOIN customer
ON customer.CustomerID = table1.CustomerID
INNER JOIN customerphone 
On customer.CustomerID = customerphone.CustomerID;

-- Question 16
SELECT table2.CountryName, CityName, table2.TotalSales FROM
(SELECT CountryName, MAX(TotalSales) AS TotalSales FROM (
SELECT CountryName, CityName, SUM(TotalPrice) AS TotalSales
FROM country co INNER JOIN city c
ON co.CountryCode = c.CountryCode
INNER JOIN bookingoffice bo
ON c.CityCode = bo.CityCode
INNER JOIN booking b 
ON b.OfficeID = bo.OfficeId
INNER JOIN status s
ON b.StatusID = s.StatusID
WHERE `Status` != "Canceled"
GROUP BY CountryName, CityName) as table1
GROUP BY CountryName) as table2

INNER JOIN (SELECT CountryName, CityName, SUM(TotalPrice) AS TotalSales
FROM country co INNER JOIN city c
ON co.CountryCode = c.CountryCode
INNER JOIN bookingoffice bo
ON c.CityCode = bo.CityCode
INNER JOIN booking b 
ON b.OfficeID = bo.OfficeId
INNER JOIN status s
ON b.StatusID = s.StatusID
WHERE `Status` != "Canceled"
GROUP BY CountryName, CityName) as table3
ON table2.TotalSales = table3.TotalSales;

-- Question 17
SELECT BookingID, FlightNumber, ArrivalDateTime, DepartureDateTime, OriginCityCode, DestinationCityCode FROM (
SELECT Distinct(BookingID), b.FlightNumber, b.ArrivalDateTime, b.DepartureDateTime, FlightPrice, 
(a.CityCode) AS OriginCityCode, (a2.CityCode) AS DestinationCityCode
FROM booking b 
LEFT JOIN `status` s
ON b.StatusID = s.StatusID
LEFT JOIN flightavailability fa
ON b.FlightNumber = fa.FlightNumber
LEFT JOIN airport a
ON fa.OriginAirportCode = a.AirportCode
LEFT JOIN airport a2
ON fa.DestinationAirportCode = a2.AirportCode
WHERE `Status` = "canceled"
ORDER BY FlightPrice DESC LIMIT 5) AS table1;

-- Question 18
SELECT COUNT(DISTINCT(table1.FlightNumber)) AS NumberOfPotentialAffected FROM (
SELECT DISTINCT(FlightNumber) 
FROM booking b
INNER JOIN bookingoffice bo
ON b.OfficeID = bo.OfficeID
INNER JOIN city c
ON bo.CityCode = c.CityCode
INNER JOIN country co
ON c.CountryCode = co.CountryCode
WHERE CountryName = "Carnation") AS table1
INNER JOIN flightavailability fa
ON table1.FlightNumber = fa.FlightNumber
INNER JOIN airport a
ON fa.OriginAirportCode = a.AirportCode
INNER JOIN city c2
ON a.CityCode = c2.CityCode
INNER JOIN country co2
ON c2.CountryCode = co2.CountryCode
INNER JOIN airport a2
ON fa.DestinationAirportCode = a2.AirportCode
INNER JOIN city c3
ON a2.CityCode = c3.CityCode
INNER JOIN country co3
ON c3.CountryCode = co3.CountryCode
WHERE co2.CountryName = "ROSE" OR co3.CountryName = "ROSE";

-- Question 19

SELECT table1.AirportCode, DENSE_RANK() OVER (ORDER BY (ArrivalCount + DepartureCount) DESC) AS `Rank` FROM (
SELECT DestinationAirportCode AS AirportCode, Count(FlightNumber) AS DepartureCount FROM
flightavailability fa2
WHERE WEEKDAY(ArrivalDateTime) BETWEEN 0 AND 4
GROUP BY DestinationAirportCode) as table1 INNER JOIN 
(SELECT OriginAirportCode as AirportCode, COUNT(FlightNumber) AS ArrivalCount 
from flightavailability fa
WHERE WEEKDAY(DepartureDateTime) BETWEEN 0 AND 4
GROUP BY OriginAirportCode) AS table2
ON table1.AirportCode = table2.AirportCode;






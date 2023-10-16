USE tass;

CREATE TABLE Country(
CountryCode VARCHAR(4) NOT NULL,
CountryName VARCHAR(60) NOT NULL,
PRIMARY KEY (CountryCode));

CREATE TABLE City(
CityCode VARCHAR(4) NOT NULL,
CityName VARCHAR(60) NOT NULL,
CountryCode VARCHAR(4) NOT NULL,
PRIMARY KEY (CityCode),
FOREIGN KEY (CountryCode)    REFERENCES Country(CountryCode));


CREATE TABLE Airline(
AirLineCode VARCHAR(4) NOT NULL,
AirLineName VARCHAR(30) NOT NULL,
CountryCode VARCHAR(4) NOT NULL,
PRIMARY KEY (AirlineCode),
FOREIGN KEY (CountryCode) REFERENCES Country(CountryCode));

 
CREATE TABLE Flight(
FlightNumber VARCHAR(5) NOT NULL,
BusinessClassIndicator VARCHAR(3) NOT NULL,
AirlineCode VARCHAR(4) NOT NULL,
PRIMARY KEY (FlightNumber),
FOREIGN KEY (AirlineCode) REFERENCES Airline(AirlineCode));

CREATE TABLE BookingOffice(
OfficeID VARCHAR (4) NOT NULL,
CityCode VARCHAR(4) NOT NULL,
PRIMARY KEY (OfficeID),
FOREIGN KEY (CityCode) REFERENCES City(CityCode));

CREATE TABLE Currency(
Currency VARCHAR(60) NOT NULL,
Abbreviation VARCHAR (3) NOT NULL,
CountryCode VARCHAR (4) NOT NULL,
PRIMARY KEY (Currency),
FOREIGN KEY (CountryCode) REFERENCES Country(CountryCode));

CREATE TABLE Airport(
AirportCode VARCHAR(4) NOT NULL,
AirportName VARCHAR (30) NOT NULL,
AirportTax SMALLINT NOT NULL,
CityCode VARCHAR(4) NOT NULL,
PRIMARY KEY (AirportCode),
FOREIGN KEY (CityCode) REFERENCES City(CityCode));

CREATE TABLE FlightAvailability(
FlightNumber VARCHAR(5) NOT NULL,
ArrivalDateTime DATETIME NOT NULL,
DepartureDateTime DATETIME NOT NULL,
TotalBusinessSeats SMALLINT NOT NULL,
BookedBusinessSeats SMALLINT NOT NULL,
TotalEconomySeats SMALLINT NOT NULL,
BookedEconomySeats SMALLINT NOT NULL,
OriginAirportCode VARCHAR(4) NOT NULL,
DestinationAirportCode VARCHAR(4) NOT NULL,
PRIMARY KEY (FlightNumber, ArrivalDateTime, DepartureDateTime),
FOREIGN KEY (FlightNumber) REFERENCES Flight(FlightNumber),
FOREIGN KEY (OriginAirportCode) references Airport(AirportCode),
FOREIGN KEY (DestinationAirportCode) references Airport(AirportCode));


CREATE TABLE Class(
ClassID  VARCHAR(4),
Class VARCHAR(8),
PRIMARY KEY (ClassID));

CREATE TABLE `Status`(
StatusID VARCHAR(4) NOT NULL,
Status VARCHAR (9) NOT NULL,
PRIMARY KEY (StatusID));

CREATE TABLE Customer(
CustomerID VARCHAR(5) NOT NULL,
FirstName VARCHAR (30) NOT NULL,
LastName VARCHAR (30) NOT NULL,
Nationality VARCHAR(30) NOT NULL,
Street VARCHAR (80) NOT NULL,
City VARCHAR (80) NOT NULL,
Province VARCHAR (80) NOT NULL,
Country VARCHAR (60) NOT NULL,
PostalCode VARCHAR (6) NOT NULL,
PRIMARY KEY (CustomerID));

CREATE TABLE CustomerEmail(
CustomerID VARCHAR(5) NOT NULL,
Email VARCHAR (20) NOT NULL,
PRIMARY KEY (CustomerID,Email),
FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID));

CREATE TABLE CustomerPhone(
CustomerID VARCHAR(5) NOT NULL,
LocalNumber VARCHAR (6) NOT NULL,
CountryCode VARCHAR (2) NOT NULL,
AreaCode VARCHAR (3) NOT NULL,
PRIMARY KEY (CustomerID,LocalNumber,CountryCode),
FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID));

CREATE TABLE `Exchange`(
FromCurrency VARCHAR(20) NOT NULL,
ToCurrency VARCHAR (20) NOT NULL,
`Date` DATE NOT NULL,
ExchangeRate FLOAT NOT NULL,
PRIMARY KEY (FromCurrency, ToCurrency, `Date`),
FOREIGN KEY (FromCurrency) REFERENCES Currency(Currency),
FOREIGN KEY (ToCurrency) REFERENCES Currency(Currency));


CREATE TABLE Booking(
BookingID VARCHAR(5) NOT NULL,
BookingDate DATE NOT NULL,
FlightPrice FLOAT NOT NULL,
TotalPrice FLOAT NOT NULL,
FlightNumber VARCHAR(5) NOT NULL,
ArrivalDateTime DATETIME NOT NULL,
DepartureDateTime DATETIME NOT NULL,
ClassID VARCHAR(4) NOT NULL,
StatusID VARCHAR(4) NOT NULL,
OfficeID VARCHAR(4) NOT NULL,
CustomerID VARCHAR(5) NOT NULL,
PRIMARY KEY (BookingID),
FOREIGN KEY (FlightNumber, ArrivalDateTime,DepartureDateTime) REFERENCES FlightAvailability(FlightNumber, ArrivalDateTime, DepartureDateTime),
FOREIGN KEY (ClassID) REFERENCES Class(ClassID),
FOREIGN KEY (StatusID) REFERENCES `Status`(StatusID),
FOREIGN KEY (OfficeID) REFERENCES BookingOffice(OfficeID),
FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID));


CREATE TABLE Payment(
PaymentID VARCHAR(5) NOT NULL,
PaymentDate DATETIME NOT NULL,
PaidAmount FLOAT NOT NULL,
Balance FLOAT NOT NULL,
CustomerID VARCHAR(5) NOT NULL,
BookingID VARCHAR(5) NOT NULL,
PRIMARY KEY (PaymentID),
FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
FOREIGN KEY (BookingID) REFERENCES Booking(BookingID));


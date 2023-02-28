CREATE DATABASE HotelDB;

CREATE TABLE IF NOT EXISTS Hotel_Chain(
	chainname TEXT PRIMARY KEY,
	country TEXT NOT NULL,
	postal_code VARCHAR(6) NOT NULL,
	address TEXT NOT NULL,
	phonenumber VARCHAR(11) NOT NULL,
	email TEXT UNIQUE NOT NULL,
	region TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS Hotel(
	region TEXT UNIQUE NOT NULL,
	street_name TEXT UNIQUE NOT NULL,
	country TEXT UNIQUE NOT NULL,
	postal_code VARCHAR(6) UNIQUE NOT NULL,
	street_number NUMERIC(4,0) UNIQUE NOT NULL,
	email TEXT UNIQUE NOT NULL,
	constraint pk_location PRIMARY KEY (region,street_name,country,postal_code,street_number),
	rating NUMERIC(2,1),
	number_rooms INT,
	chainname TEXT
);

ALTER TABLE Hotel 
	DROP CONSTRAINT IF EXISTS fk_chainname;
	
ALTER TABLE Hotel
	ADD CONSTRAINT fk_chainname
    FOREIGN KEY (chainname)
	REFERENCES hotel_chain(chainname);
	
CREATE TYPE sceneries AS ENUM ('sea','mountain'); 

CREATE TABLE IF NOT EXISTS Room(
	room_number INT PRIMARY KEY,
	issues TEXT[],
	scenary sceneries NOT NULL,
	extendable BOOL NOT NULL,
	price FLOAT NOT NULL,
	amenities TEXT[] NOT NULL,
	capacity INT NOT NULL,
	--foreigns
	region TEXT NOT NULL,
	street_name TEXT NOT NULL,
	country TEXT NOT NULL,
	postal_code VARCHAR(6) NOT NULL,
	street_number NUMERIC(4,0) NOT NULL
);

ALTER TABLE Room
	DROP CONSTRAINT IF EXISTS fk_location;
	
ALTER TABLE Room
	ADD CONSTRAINT fk_location
    FOREIGN KEY (region,street_name, country, postal_code, street_number)
	REFERENCES hotel(region,street_name, country, postal_code, street_number);
	
CREATE TABLE IF NOT EXISTS customer(
	ssn NUMERIC (9,0) PRIMARY KEY,
	registration_date DATE NOT NULL,
	first_name TEXT NOT NULL,
	last_name TEXT NOT NULL,
	region TEXT NOT NULL,
	street_name TEXT NOT NULL,
	country TEXT NOT NULL,
	postal_code VARCHAR(6) NOT NULL,
	street_number NUMERIC(4,0) NOT NULL
);

CREATE TYPE job AS ENUM ('concierge', 'room service', 'bus boy', 'waiter', 'manager', 'laundry aide'); 

CREATE TABLE IF NOT EXISTS Employee(
	ssn NUMERIC (9,0) PRIMARY KEY,
	first_name TEXT NOT NULL,
	last_name TEXT NOT NULL,
	is_employed BOOL NOT NULL,
	job_type job NOT NULL,
	--foreign for works at
	region TEXT NOT NULL,
	street_name TEXT NOT NULL,
	country TEXT NOT NULL,
	postal_code VARCHAR(6) NOT NULL,
	street_number NUMERIC(4,0) NOT NULL
);

ALTER TABLE Employee
	DROP CONSTRAINT IF EXISTS fk_works_at;
	
ALTER TABLE Employee
	ADD CONSTRAINT fk_works_at
    FOREIGN KEY (region,street_name, country, postal_code, street_number)
	REFERENCES hotel(region,street_name, country, postal_code, street_number);
	
CREATE TABLE IF NOT EXISTS Archive(
	date_booked DATE NOT NULL,
	room_number INT NOT NULL,
	date_rented_start DATE NOT NULL,
	date_rented_end DATE NOT NULL,
	hotel_chain TEXT NOT NULL,
	employee NUMERIC (9,0) NOT NULL,
	street_number NUMERIC(4,0) NOT NULL,
	street_name TEXT NOT NULL,
	region TEXT NOT NULL,
	postal_code VARCHAR(6) NOT NULL,
	country TEXT NOT NULL,
	constraint pk_archive PRIMARY KEY (date_booked,room_number,date_rented_start,date_rented_end,hotel_chain,
									  employee,street_number,street_name,region,postal_code,country)
);

CREATE TABLE IF NOT EXISTS Renting(
	date_rented_start DATE NOT NULL,
	date_rented_end DATE NOT NULL,
	employee_ssn NUMERIC (9,0) UNIQUE NOT NULL,
	customer_ssn NUMERIC (9,0) UNIQUE NOT NULL,
	room_number INT NOT NULL
);
ALTER TABLE Renting
	DROP CONSTRAINT IF EXISTS fk_employee_ssn;
	
ALTER TABLE Renting
	ADD CONSTRAINT fk_employee_ssn
    FOREIGN KEY (employee_ssn)
	REFERENCES Employee(ssn);
	
ALTER TABLE Renting
	DROP CONSTRAINT IF EXISTS fk_customer_ssn;
	
ALTER TABLE Renting
	ADD CONSTRAINT fk_customer_ssn
    FOREIGN KEY (customer_ssn)
	REFERENCES customer(ssn);
	
ALTER TABLE Renting
	DROP CONSTRAINT IF EXISTS fk_room_number;
	
ALTER TABLE Renting
	ADD CONSTRAINT fk_room_number
    FOREIGN KEY (room_number)
	REFERENCES room(room_number);

CREATE TABLE IF NOT EXISTS Booking(
	date_booked DATE NOT NULL,
	renting_start DATE NOT NULL,
	renting_end DATE NOT NULL,
	customer_ssn NUMERIC (9,0) UNIQUE NOT NULL,
	room_number INT NOT NULL
);

ALTER TABLE Booking
	DROP CONSTRAINT IF EXISTS fk_customer_ssn;
	
ALTER TABLE Booking
	ADD CONSTRAINT fk_customer_ssn
    FOREIGN KEY (customer_ssn)
	REFERENCES customer(ssn);
	
ALTER TABLE Booking
	DROP CONSTRAINT IF EXISTS fk_room_number;
	
ALTER TABLE Booking
	ADD CONSTRAINT fk_room_number
    FOREIGN KEY (room_number)
	REFERENCES room(room_number);
create database AgroYield_DB;

go
use AgroYield_DB;
go

create table Crop_Yield 
( 
	Crop varchar(50), 
	Crop_Year int, 
	Season varchar(30), 
	State varchar(50), 
	Area Float, 
	Production Float, 
	Annual_Rainfall Float, 
	Fertilizer Float, 
	Pesticide Float, 
	Yield Float,
	Production_per_Hect Float,
	Fertilizer_per_Hect Float,
	Pesticide_per_Hect Float,
	Yield_per_Hect Float
);
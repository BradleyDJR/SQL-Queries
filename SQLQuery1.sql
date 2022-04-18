--First time using sql on a data set that I prepared myself, hopefully able to expand and show my skills in this area.
--Also happy to understand the point of comments haha!

-- Testing table to ensure only columns I preserved are in the dataset
select *
from PortfolioProject.dbo.Energy$

--Realizing that I only put a filter on for Excel, does not transfer said filter into SQL. Time for some clauses!
select iso_code, country, year
from PortfolioProject.dbo.Energy$
where  iso_code='BRA' OR iso_code='IND' OR iso_code='USA' OR iso_code='CHN' OR iso_code='DEU'


--Learning MicrosoftSQL as I do this, not a fan of the where clause but good to know how it works now rather than later. Let's attempt to get data about production for these countries.
select iso_code, country, year, electricity_generation
from PortfolioProject.dbo.Energy$
where iso_code='BRA' AND year>2000
	OR iso_code='IND' AND year>2000
	OR iso_code='USA' AND year>2000
	OR iso_code='CHN' AND year>2000
	OR iso_code='DEU' AND year>2000

-- Absolutely despising the 'where' clause needing a clause per code or per argument. But, the show must go on!
-- Let's find out the demand of these countries, as well as the efficiency of their generation
select iso_code, country, year, electricity_generation, electricity_demand, (electricity_demand/electricity_generation * 100) as efficiency
from PortfolioProject.dbo.Energy$
where iso_code='BRA' AND year>2000
	OR iso_code='IND' AND year>2000
	OR iso_code='USA' AND year>2000
	OR iso_code='CHN' AND year>2000
	OR iso_code='DEU' AND year>2000
	
-- Well all numericals went into the table as nvarchar, let's change the immediate ones I have to work with
ALTER TABLE dbo.Energy$ 
ALTER COLUMN electricity_generation INT

-- Apparently had to create the table to change values? Getting the "does not exist error", will visit later. Changed in the table properties.

-- Let's try this again, looking for efficiency
select iso_code, country, year, electricity_generation, electricity_demand, (electricity_demand/electricity_generation * 100) as efficiency
from PortfolioProject.dbo.Energy$
where iso_code='BRA' AND year>2000
	OR iso_code='IND' AND year>2000
	OR iso_code='USA' AND year>2000
	OR iso_code='CHN' AND year>2000
	OR iso_code='DEU' AND year>2000
-- Seems Germany is the only one to have dropped below 98% during the last two decade
-- Anything above 100% is just making too much for what they need. Nice!

-- Let's see the share of that being renewable energy over the last two decades
select iso_code, country, year, electricity_generation, hydro_electricity, wind_electricity, solar_electricity
from PortfolioProject.dbo.Energy$
where iso_code='BRA' AND year>2000
	OR iso_code='IND' AND year>2000
	OR iso_code='USA' AND year>2000
	OR iso_code='CHN' AND year>2000
	OR iso_code='DEU' AND year>2000

-- I'm going to attempt to make a new table with the information I pulled from above, call it renewable energy table.
select iso_code, country, year, electricity_generation, hydro_electricity, wind_electricity, solar_electricity 
into dbo.renewable_energy
from PortfolioProject.dbo.Energy$
where iso_code='BRA' AND year>2000
	OR iso_code='IND' AND year>2000
	OR iso_code='USA' AND year>2000
	OR iso_code='CHN' AND year>2000
	OR iso_code='DEU' AND year>2000

-- And to test it...
select *
from dbo.renewable_energy
-- YES excitement when things go right

--Alright let's stop looking at JUST the top people, let's actually find the most generated electrcity out of all the countries in this list for the year 2000 and 2015
select country, year, MAX(electricity_generation) as top_generation
from PortfolioProject..Energy$
where year=2000
OR year=2015
group by country, year
order by 3 DESC
-- While that does bring in the totals for regions (i.e. Asia Pacific, Middle East, European_Union), this does still have the countries,
-- in which I'd have to be careful about bringing the information to where it's needed.
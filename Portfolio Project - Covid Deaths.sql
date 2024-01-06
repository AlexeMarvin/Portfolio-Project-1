-- These are SQL scripts used to query a dataset 
-- imported from an online source
-- Our World In Data, Coronavirus (COVID-19) Deaths (20-Jan-01 - 24-Jan-02)
-- Author: Alex 
-- 1/5/24

select * 
from [dbo].[covid deaths]
where [continent] is not null
order by 3 desc, 4;

-- working with vaccinations later
--select *
--from [dbo].[covid vaccinations]
--where [continent] is not null
--order by 3 desc, 4;


-- Focusing on a subset of the Covid Deaths table for analysis
select continent as Continent,
location as Location, 
date as Date, 
total_cases as 'Total Cases', 
total_deaths as 'Total Deaths', 
population as Population
from [dbo].[covid deaths]
where [continent] is not null
order by 1, 2;



/* Things to Note About Dataset
1. Populations are static across the time period for each Location in the dataset
2. Rows containing NULLs are included
*/


/* TABLE OF CONTENTS – Section: Covid Deaths
-- COUNTRY NUMBERS
-- Likelihood of Dying if You Contract Covid in Your Country
-- Countries with Highest Infection Rate (pct-pop)
-- Countries with Highest Death Count
-- BREAKING THINGS DOWN BY CONTINENT
-- Continents or Grouping of Countries by Highest Death Count
-- Continents with the Highest Death Count (pct-pop)
-- GLOBAL NUMBERS
-- Global Percentage of Population that got Covid (pct-pop)
-- Global Percentage of Population that Died from Covid (Death Count / Cases)
-- Global Likelihood of Dying if You Contract Covid (Death Count / Cases)
-- UNITED STATES
-- Percentage of US Population that got Covid (pct-pop)
-- Percentage of US Population that Died from Covid (Death Count / Cases)
-- Likelihood of Dying if You Contract Covid in the US (Death Count / Cases)
-- Additional date-wise analysis (World & US)
*/



-- COUNTRY NUMBERS
-- Likelihood of Dying if You Contract Covid in Your Country
select location as Location, 
date as Date, 
total_cases as 'Total Cases', 
total_deaths as 'Total Deaths', 
100*(CAST(total_deaths as decimal) / total_cases) as 'Death Rate %'
from [dbo].[covid deaths]
where [continent] is not null
/*
and Location like 'Costa%'
or Location like '%States'
or ...
*/
order by 1, 2;

-- Countries with Highest Infection Rate (pct-pop)
select location as Location, 
population as Population, 
MAX(total_cases) as 'Highest Infection Count', 
MAX((CAST(total_cases as decimal) / population))*100 as 'Highest Case Rate %'
from [dbo].[covid deaths]
where continent is not null
group by Location, Population
order by 'Highest Case Rate %' desc;

-- Countries with Highest Death Count
select location as Location, 
Max(total_deaths) as 'Total Death Count'
from [dbo].[covid deaths]
where [continent] is not null
group by Location
order by 'Total Death Count' desc;



-- BREAKING THINGS DOWN BY CONTINENT
-- Continents or Grouping of Countries by Highest Death Count
select location as Location, 
Max(total_deaths) as 'Total Death Count'
from [dbo].[covid deaths]
where [continent] is null
group by Location
order by 'Total Death Count' desc;

-- Continents with the Highest Death Count (pct-pop)
select location as Location,  
MAX(date) as 'Latest Date', 
MAX(total_cases) as 'Total Cases',
MAX(total_deaths) as 'Total Death Count', 
100*(CAST(MAX(total_deaths) as decimal(30,2)) / MAX(total_cases)) as 'Death Rate %'
from [dbo].[covid deaths]
where [continent] is null
and [location] not like 'World'
and [location] not like 'High income' 
and [location] not like 'Upper middle income' 
and [location] not like 'Lower middle income' 
and [location] not like 'European Union' 
and [location] not like 'Low income' 
group by Location
order by 'Total Death Count' desc;



-- GLOBAL NUMBERS
-- Global Percentage of Population that got Covid (pct-pop)
select location as Location, 
date as Date, 
total_cases as 'Total Cases', 
100*(CAST(total_cases as decimal) / population) as 'Case Rate %'
from [dbo].[covid deaths]
where Location like 'World'
and continent is null
order by 2;

-- Global Percentage of Population that Died from Covid (Death Count / Cases)
select location as Location, 
date as Date, 
total_cases as 'Total Cases', 
total_deaths as 'Total Deaths', 
100*(CAST(total_deaths as decimal(30,2)) / total_cases) as 'Death Rate %'
from [dbo].[covid deaths]
where Location like 'World'
and continent is null
order by 2;

-- Global Likelihood of Dying if You Contract Covid (Death Count / Cases)
 select location as Location, 
 MAX(date) as 'Latest Date', 
  100*(CAST(MAX(total_cases) as decimal (30,2)) / MAX(population)) as 'Case Rate %', 
 100*(CAST(MAX(total_deaths) as decimal(30,2)) / MAX(total_cases)) as 'Death Rate %'
from [dbo].[covid deaths]
where [continent] is null
and [location] like 'World'
group by Location
order by 1, 2;



-- UNITED STATES
-- Percentage of US Population that got Covid (pct-pop)
select location as Location, 
date as Date, 
population as Population, 
total_cases as 'Total Cases',
100*(CAST(total_cases as decimal) / population) as 'Case Rate %'
from [dbo].[covid deaths]
where Location like '%states'
and continent is not null
order by 1, 2;

-- Percentage of US Population that Died from Covid (Death Count / Cases)
select location as Location, 
date as Date, 
population as Population, 
total_cases as 'Total Cases',
total_deaths as 'Total Deaths', 
100*(CAST(total_deaths as decimal) / total_cases) as 'Death Rate %' 
from [dbo].[covid deaths]
where Location like '%states'
and continent is not null
order by 1, 2;

-- Likelihood of Dying if You Contract Covid in the US (Death Count / Cases)
 select location as Location, 
 MAX(date) as 'Latest Date', 
  100*(CAST(MAX(total_cases) as decimal (30,2)) / MAX(population)) as 'Case Rate %', 
 100*(CAST(MAX(total_deaths) as decimal(30,2)) / MAX(total_cases)) as 'Death Rate %'
from [dbo].[covid deaths]
where [continent] is not null
and [location] like '%States'
group by Location
order by 1, 2;



-- Additional date-wise analysis (Global & United States)
-- Global Percentage of Population that got Covid (pct-pop) and Died from Covid (Death Count / Cases)
select location as Location, 
date as Date, 
population as Population, 
total_cases as 'Total Cases', 
total_deaths as 'Total Deaths', 
100*(CAST(total_cases as decimal) / population) as 'Case Rate', 
100*(CAST(total_deaths as decimal) / total_cases) as 'Death Rate'
from [dbo].[covid deaths]
where Location like 'World'
and continent is null
order by 2;

-- Percentage of US Population that got Covid (pct-pop) and Died from Covid (Death Count / Cases)
select location as Location, 
date as Date, 
population as Population, 
total_cases as 'Total Cases',
total_deaths as 'Total Deaths', 
100*(CAST(total_cases as decimal) / population) as 'Case Rate %',
100*(CAST(total_deaths as decimal) / total_cases) as 'Death Rate %' 
from [dbo].[covid deaths]
where Location like '%states'
and continent is not null
order by 1, 2;


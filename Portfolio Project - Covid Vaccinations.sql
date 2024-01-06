-- These are SQL scripts used to query data 
-- imported from an online scource
-- Our World In Data, Coronavirus (COVID-19) Vaccinations (20-Jan-01 - 24-Jan-02)
-- Author: Alex 
-- 1/5/24

-- now working with vaccinations
--select * 
--from [dbo].[covid deaths] 
--where [continent] is not null 
--order by 3 desc, 4;


select * 
from [dbo].[covid vaccinations] 
where [continent] is not null 
order by 3 desc, 4;



/* Things to Note About Dataset
1. Populations are static across the time period for each Location in the dataset
2. Rows containing NULLs are included
*/


/* TABLE OF CONTENTS – Section: Covid Vaccinations
-- Joining the Covid Vaccinations and Deaths Tables
-- Total Population vs Vaccinations
-- Adding a Rolling Count of new_vaccinations (A Total of Vaccinations by Country)
-- Percent Number of Vaccinations to Population 
-- USING Common Table Expression (CTE) to Calculate and Reference Aaggregated Variables in a Subsequent Query
-- Creating View to Store Data for Later Use
*/



-- Joining the Covid Vaccinations and Deaths Tables
select * 
from [dbo].[covid deaths] dea 
join [dbo].[covid vaccinations] vac 
on dea.location = vac.location 
and dea.date = vac.date;

-- Total Population vs Vaccinations
select 
dea.continent, 
dea.location, 
dea.date, 
dea.population, 
vac.new_vaccinations 
from [dbo].[covid deaths] dea 
join [dbo].[covid vaccinations] vac  
on dea.location = vac.location 
and dea.date = vac.date 
where dea.continent is not null 
order by 2, 3;



-- Adding a Rolling Count of new_vaccinations (A Total of Vaccinations by Country)
select 
dea.continent, 
dea.location, 
dea.date, 
dea.population, 
vac.new_vaccinations, 
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by  dea.Location order by dea.location, dea.date) as 'Rolling Count Vaccinations'
from [dbo].[covid deaths] dea 
join [dbo].[covid vaccinations] vac  
on dea.location = vac.location 
and dea.date = vac.date 
where dea.continent is not null 
order by 2, 3;



-- Percent Number of Vaccinations to Population 
-- USING Common Table Expression (CTE) to Calculate and Reference Aaggregated Variables in a Subsequent Query
with PopvsVac (continent, location, date, population, new_vaccinations, RollingCountVaccinations)
as
(
select 
dea.continent, 
dea.location, 
dea.date, 
dea.population, 
vac.new_vaccinations, 
SUM(CONVERT(bigint, vac.new_vaccinations)) 
OVER (Partition by dea.Location order by dea.location, dea.date) as RollingCountVaccinations
from [dbo].[covid deaths] dea 
join [dbo].[covid vaccinations] vac  
on dea.location = vac.location 
and dea.date = vac.date 
where dea.continent is not null 
and dea.location like '%states'
--order by 2, 3;
)
select *, 100*(CAST(RollingCountVaccinations as decimal(30,2))/population) as 'Vac. to Pop. %'
from PopvsVac;



-- Creating View to Store Data for Later Use
drop view if exists PercentPopulationVaccinated;
create view PercentPopulationVaccinated as
select 
dea.continent, 
dea.location, 
dea.date, 
dea.population, 
vac.new_vaccinations, 
SUM(CONVERT(bigint, vac.new_vaccinations)) 
OVER (Partition by  dea.Location order by dea.location, dea.date) as 'Rolling Count Vaccinations'
from [dbo].[covid deaths] dea 
join [dbo].[covid vaccinations] vac  
on dea.location = vac.location 
and dea.date = vac.date 
where dea.continent is not null 
--order by 2, 3
;











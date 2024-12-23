select *
from [Portfolio Project ]..CovidDeaths
where continent is not null
order by 3,4

select location,date, total_cases ,new_cases ,total_deaths,population
from [Portfolio Project ]..CovidDeaths
where continent is not null
order by 1,2

select location,date, total_cases ,new_cases ,total_deaths,(total_deaths/total_cases)*100 as DeathPercetage
from [Portfolio Project ]..CovidDeaths
Where location like '%iran%'
and continent is not null
order by 1,2

select location,date, population,total_cases ,new_cases ,(total_cases/population)*100 as DeathPercetage
from [Portfolio Project ]..CovidDeaths
Where location like '%iran%'
and continent is not null
order by 1,2


select location, population,max(total_cases) as HighestInfectionCount ,max(total_cases/population)*100 as PercentPopulationInfected
from [Portfolio Project ]..CovidDeaths
where continent is not null
group by location,population
order by PercentPopulationInfected desc

select location ,max(cast(total_deaths as int)) as TotalDeathCount
from [Portfolio Project ]..CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc


select 
date,
sum(new_cases) as total_cases ,
sum(cast(new_deaths as int)) as total_deaths ,
sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from [Portfolio Project ]..CovidDeaths
where continent is not null
group by date
order by 1,2

with PopvsVac (continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(int,vac.new_vaccinations))over (partition by dea.location ,dea.date) as RollingPeopleVaccinated
from [Portfolio Project ]..CovidDeaths dea
join [Portfolio Project ]..CovidVaccinations vac
    on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select * ,(RollingPeopleVaccinated/population)*100
from PopvsVac




drop table if exists #PercentPopulationVaccinated

create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime ,
population numeric,
new_vaccinations numeric,
rollingpeoplevaccinated numeric
)

insert into #PercentPopulationVaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations))over (partition by dea.location ,dea.date) as RollingPeopleVaccinated
from [Portfolio Project ]..CovidDeaths dea
join [Portfolio Project ]..CovidVaccinations vac
    on dea.location=vac.location
	and dea.date=vac.date
--where dea.continent is not null
--order by 2,3

select * ,(RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated




create view PercentPopulationVaccinated as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(int,vac.new_vaccinations))over (partition by dea.location ,dea.date) as RollingPeopleVaccinated
from [Portfolio Project ]..CovidDeaths dea
join [Portfolio Project ]..CovidVaccinations vac
    on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
--order by 2,3


select *
from PercentPopulationVaccinated
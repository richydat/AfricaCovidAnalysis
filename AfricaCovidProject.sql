-- TAKING A LOOK AT THE DEATHS DATA

SELECT *
FROM PortfolioProject..[CovidDeaths.Africa]
ORDER BY 3,4




-- Looking at Total Cases vs Total Deaths
-- shows the likelihood of dying in Ghana

SELECT location, 
	   date, 
	   total_cases, 
	   total_deaths, 
	   (total_deaths/total_cases)*100 AS death_percentage
FROM PortfolioProject..[CovidDeaths.Africa]
WHERE location like '%Ghana%'
ORDER BY 1,2



-- Looking at the Total Cases vs Population
-- shows the percentage of population contracting the virus

SELECT location, 
	   date, 
	   total_cases, 
	   total_deaths, 
	   population, 
	   (total_deaths/population)*100 AS death_percentage
FROM PortfolioProject..[CovidDeaths.Africa]
WHERE location like '%Ghana%'
ORDER BY 1,2



-- Looking at the Total Cases vs Population
-- Looking at countries with highest infection Rate compared to population

SELECT location, 
	   population,
	   MAX(total_cases) AS highest_infection_count, 
	   MAX((total_cases/population))*100 AS '%population_infected'
FROM PortfolioProject..[CovidDeaths.Africa]
-- WHERE location like '%Ghana%'
GROUP BY location, population
ORDER BY '%population_infected' DESC



-- Looking at the Total Deaths vs Population
-- Looking at countries with Highest Death Rate per population

SELECT location, 
	   population,
	   MAX(total_deaths) AS highest_death_count, 
	   MAX((total_deaths/population))*100 AS '%population_dead'
FROM PortfolioProject..[CovidDeaths.Africa]
-- WHERE location like '%Ghana%'
GROUP BY location, population
ORDER BY '%population_dead' DESC



-- Showing countries with Highest Death Count  per population

SELECT location, 
	   MAX(CAST(total_deaths AS int)) as total_death_count
FROM PortfolioProject..[CovidDeaths.Africa]
-- WHERE location like '%Ghana%'
GROUP BY location
ORDER BY total_death_count DESC



-- Showing demographic location with the highest death count per population

SELECT position_demography, 
	   MAX(CAST(total_deaths AS int)) as total_death_count
FROM PortfolioProject..[CovidDeaths.Africa]
-- WHERE location like '%Ghana%'
GROUP BY position_demography
ORDER BY total_death_count DESC



-- TOTAL CASES AND DEATHS OF AFRICAN CONTINENT

SELECT 
	SUM(new_cases) AS total_cases, 
	SUM(CAST(new_deaths AS int)) AS total_deaths, 
	SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS death_percentage
FROM PortfolioProject..[CovidDeaths.Africa]
WHERE continent IS NOT null
-- GROUP BY date
ORDER BY 1,2








---------------------------------------------------------------------------------------------------
-- TAKING A LOOK AT THE VACCINATION DATA

SELECT *
FROM PortfolioProject..[CovidVaccinations.Africa]
ORDER BY 3,4



-- Looking at Total Population vs Total vaccinations
-- shows the vaccination rate

Select dea.position_demography, 
	   dea.location, 
	   dea.date, 
	   dea.population, 
	   vacc.new_vaccinations,
	   (CAST(vacc.total_vaccinations AS int)) AS total_vaccinations_upd
FROM PortfolioProject..[CovidDeaths.Africa] dea
JOIN PortfolioProject..[CovidVaccinations.Africa] vacc
	ON dea.location = vacc.location
	AND dea.date = vacc.date
WHERE dea.position_demography IS NOT null



-- USING CTE

WITH PopulationVsVaccination (position_demography, location, date, population, total_vaccinations_upd)
AS
(
Select dea.position_demography, 
	   dea.location, 
	   dea.date, 
	   dea.population,
	   (CAST(vacc.total_vaccinations AS int)) AS total_vaccinations_upd
FROM PortfolioProject..[CovidDeaths.Africa] dea
JOIN PortfolioProject..[CovidVaccinations.Africa] vacc
	ON dea.location = vacc.location
	AND dea.date = vacc.date
WHERE dea.position_demography IS NOT null
)
SELECT *,
	   (total_vaccinations_upd/population) AS vaccination_rate
FROM PopulationVsVaccination



-- Looking at the Total Tests vs Population
-- shows the percentage of population testing for the virus

Select dea.position_demography, 
	   dea.location, 
	   dea.date, 
	   dea.population,
	   vacc.total_tests,
	   (CAST(vacc.total_tests AS int)/population) AS tests_rate
FROM PortfolioProject..[CovidDeaths.Africa] dea
JOIN PortfolioProject..[CovidVaccinations.Africa] vacc
	ON dea.location = vacc.location
	AND dea.date = vacc.date
WHERE dea.position_demography IS NOT null



-- Looking at the Total Vaccination vs Population
-- Looking at countries with highest vaccination Rate compared to population
SELECT dea.location, 
	   dea.population,
	   MAX(total_vaccinations) AS HighestVaccinationCount, 
	   MAX((total_vaccinations/population))*100 AS '%Population_vaccinated'
FROM PortfolioProject..[CovidDeaths.Africa] dea
JOIN PortfolioProject..[CovidVaccinations.Africa] vacc
	ON dea.location = vacc.location
	AND dea.date = vacc.date
-- WHERE location like '%Ghana%'
GROUP BY dea.location, dea.population
ORDER BY '%Population_vaccinated' DESC



-- Showing countries with Highest Vaccination Count  per population
SELECT location, 
	   MAX(CAST(total_vaccinations AS int)) AS total_vacination_count,
	   MAX(CAST(total_tests AS int)) AS total_tests_count,
	   (MAX(CAST(total_vaccinations AS int))-MAX(CAST(total_tests AS int))) AS not_tested_count
FROM PortfolioProject..[CovidVaccinations.Africa]
-- WHERE location like '%Ghana%'
GROUP BY location
ORDER BY total_vacination_count DESC


-- Showing demographic location with the highest vacination count per population
SELECT position_demography, 
	   MAX(CAST(total_vaccinations AS int)) AS total_vacination_count
FROM PortfolioProject..[CovidVaccinations.Africa]
-- WHERE location like '%Ghana%'
GROUP BY position_demography
ORDER BY total_vacination_count DESC


-- TOTAL CASES AND VACCINATIONS OF AFRICAN CONTINENT

SELECT 
	SUM(new_cases) AS total_cases, 
	SUM(CAST(new_vaccinations AS int)) AS total_vaccinations, 
	SUM(CAST(new_vaccinations AS int))/SUM(new_cases)*100 AS vaccination_percentage
FROM PortfolioProject..[CovidDeaths.Africa] dea
JOIN PortfolioProject..[CovidVaccinations.Africa] vacc
	ON dea.location = vacc.location
	AND dea.date = vacc.date









---------------------------------------------------------------------------------------


-- Looking at Total Population vs Vaccinations

Select dea.position_demography, 
	   dea.location, dea.date, 
	   dea.population, 
	   vacc.new_vaccinations,
	   SUM(CAST(vacc.new_vaccinations AS int)) 
			OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS cummulative_people_vaccinated
FROM PortfolioProject..[CovidDeaths.Africa] dea
JOIN PortfolioProject..[CovidVaccinations.Africa] vacc
	ON dea.location = vacc.location
	AND dea.date = vacc.date
WHERE dea.position_demography IS NOT null
ORDER BY 2,3




-- USE CTE

WITH PopVsVac (position_demography, location, date, population, new_vaccinations, cummulative_people_vaccinated)
AS
(
Select dea.position_demography, 
	   dea.location, 
	   dea.date, 
	   dea.population, 
	   vacc.new_vaccinations,
	SUM(CAST(vacc.new_vaccinations AS int)) 
		OVER (PARTITION BY dea.location 
		ORDER BY dea.location, dea.date) AS cummulative_people_vaccinated
		-- (RollingPeopleVaccinated/population)*100
FROM PortfolioProject..[CovidDeaths.Africa] dea
JOIN PortfolioProject..[CovidVaccinations.Africa] vacc
	ON dea.location = vacc.location
	AND dea.date = vacc.date
WHERE dea.position_demography IS NOT null
)
SELECT *, 
	   (cummulative_people_vaccinated/population)*100 AS '%ofrolling_people_vaccinated'
FROM PopVsVac




-- CREATING A TABLE
-- TEMP TABLE

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rolling_people_vaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
Select dea.continent,  
	   dea.location, 
	   dea.date, 
	   dea.population, 
	   vacc.new_vaccinations,
	   SUM(CAST(vacc.new_vaccinations AS int)) 
			OVER (PARTITION BY dea.location 
			ORDER BY dea.location, dea.date) AS rolling_people_vaccinated
FROM PortfolioProject..[CovidDeaths.Africa] dea
JOIN PortfolioProject..[CovidVaccinations.Africa] vacc
	ON dea.location = vacc.location
	AND dea.date = vacc.date
WHERE dea.continent IS NOT null

SELECT *, 
	   (rolling_people_vaccinated/population)*100 AS "%of_rolling_people_vaccinated"
FROM #PercentPopulationVaccinated



-- CREATING VIEWS TO STORE DATA FOR VISUALIZATIONS


-- DROP VIEW IF EXISTS PercentPopulationVaccinated_roll
USE PortfolioProject
GO
CREATE VIEW PercentPopulationVaccinated_roll AS
Select dea.continent,  
	   dea.location, 
	   dea.date, 
	   dea.population, 
	   vacc.new_vaccinations,
	   SUM(CAST(vacc.new_vaccinations AS int)) 
			OVER (PARTITION BY dea.location 
			ORDER BY dea.location, dea.date) AS rolling_people_vaccinated
FROM PortfolioProject..[CovidDeaths.Africa] dea
JOIN PortfolioProject..[CovidVaccinations.Africa] vacc
	ON dea.location = vacc.location
	AND dea.date = vacc.date
WHERE dea.continent IS NOT null
GO



-- DROP VIEW IF EXISTS PercentPopulationVaccinated_roll
USE PortfolioProject
GO
CREATE VIEW PercentPopulationVaccinated AS
Select dea.position_demography, 
	   dea.location, 
	   dea.date, 
	   dea.population, 
	   vacc.new_vaccinations,
	   SUM(CAST(vacc.new_vaccinations AS int)) 
			OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS cummulative_people_vaccinated
FROM PortfolioProject..[CovidDeaths.Africa] dea
JOIN PortfolioProject..[CovidVaccinations.Africa] vacc
	ON dea.location = vacc.location
	AND dea.date = vacc.date
WHERE dea.position_demography IS NOT null
GO



-- DROP VIEW IF EXISTS CasesVsVaccination
USE PortfolioProject
GO
CREATE VIEW CasesVsVaccination AS
SELECT 
	SUM(new_cases) AS total_cases, 
	SUM(CAST(new_vaccinations AS int)) AS total_vaccinations, 
	SUM(CAST(new_vaccinations AS int))/SUM(new_cases)*100 AS vaccination_percentage
FROM PortfolioProject..[CovidDeaths.Africa] dea
JOIN PortfolioProject..[CovidVaccinations.Africa] vacc
	ON dea.location = vacc.location
	AND dea.date = vacc.date
GO




-- DROP VIEW IF EXISTS VaccinationCount
USE PortfolioProject
GO
CREATE VIEW VaccinationCount AS
SELECT position_demography, 
	   MAX(CAST(total_vaccinations AS int)) AS total_vacination_count
FROM PortfolioProject..[CovidVaccinations.Africa]
GROUP BY position_demography
GO



DROP VIEW IF EXISTS DeathPercent
USE PortfolioProject
GO
CREATE VIEW DeathPercent AS
SELECT location, 
	   date, 
	   total_cases, 
	   total_deaths, 
	   (total_deaths/total_cases)*100 AS death_percentage
FROM PortfolioProject..[CovidDeaths.Africa]
WHERE location IS NOT NULL
GO
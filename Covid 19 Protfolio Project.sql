SELECT *
FROM PortfolioProject..CovidDeaths
ORDER BY 3,4
 
 SELECT *
FROM PortfolioProject..CovidVaccinations
ORDER BY 3,4

SELECT location,date, total_cases, new_cases,total_deaths,population
FROM  PortfolioProject..CovidDeaths
ORDER BY 1,2



--Looking at Deathpercangate in United States


SELECT location,date,
CONVERT(float, total_cases) AS TotalCases,
CONVERT (float, total_deaths) AS TotalDeaths,
(CONVERT(float,total_deaths)/ CONVERT(float,total_cases)) *100 as DeathPercentage
FROM  PortfolioProject..CovidDeaths
WHERE location like'%states%'
ORDER BY 1,2

-- Looking at total cases vs populaton which shows the percentage of population got covid


SELECT location,date,
CAST(total_cases as float) AS TotalCases,
CAST (population as float) AS Population,
CAST(total_cases as float)/CAST(population as float)*100 AS InfectedPopulationPercentage
FROM  PortfolioProject..CovidDeaths
ORDER BY 1,2


-- countries with highest Infection rate compared to population

SELECT location,population,
MAX(CONVERT(float, total_cases)) AS TotalCases,
CONVERT (float,population) AS Population,
MAX(CONVERT(float,total_cases)/ CONVERT(float,population))*100 AS InfectedPopulationPercentage
FROM  PortfolioProject..CovidDeaths
GROUP BY location, population
ORDER BY InfectedPopulationPercentage DESC


-- countries with Highest Death Count per Population

SELECT location, MAX(cast(total_deaths as int))AS TotalDeathCount
FROM  PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC


-- Breaking things down by continents
--Continent with highest death count per population

SELECT continent, MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- Global Numbers

SELECT SUM(new_cases) As Total_Cases , SUM(new_deaths) AS Total_Deaths, SUM(new_deaths)/SUM(new_cases)*100 AS DeathPercentage
FROM  PortfolioProject..CovidDeaths
WHERE continent is not null

 -- Joining Tables

SELECT *
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location= vac.location
and dea.date= vac.date


 -- Total population vs Vaccinated population

 SELECT dea.continent, dea.location,dea.date, dea.population,vac.new_vaccinations
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location= vac.location
and dea.date= vac.date
WHERE dea.continent is not null
ORDER BY 2,3 



SELECT dea.continent, dea.location,dea.date, dea.population,vac.new_vaccinations , SUM(cast( vac.new_vaccinations AS numeric))
OVER(partition by dea.location ORDER BY dea.location, dea.date) AS TotalVaccinations
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location= vac.location
and dea.date= vac.date
WHERE dea.continent is not null
ORDER BY 2,3 

--Using CTE


WITH PopulationvsVaccination (contient, location,date,population, new_vaccinations, TotalVaccinations)
AS
(SELECT dea.continent, dea.location,dea.date, dea.population,vac.new_vaccinations , SUM(cast( vac.new_vaccinations AS numeric))
OVER(partition by dea.location ORDER BY dea.location, dea.date) AS TotalVaccinations
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location= vac.location
and dea.date= vac.date
WHERE dea.continent is not null
)
SELECT*, TotalVaccinations/population*100
FROM PopulationvsVaccination 

-- creating view for storing data 

CREATE VIEW VaccinatedPopulationPercentage As

SELECT dea.continent, dea.location,dea.date, dea.population,vac.new_vaccinations , SUM(cast( vac.new_vaccinations AS numeric))
OVER(partition by dea.location ORDER BY dea.location, dea.date) AS TotalVaccinations
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location= vac.location
and dea.date= vac.date
WHERE dea.continent is not null




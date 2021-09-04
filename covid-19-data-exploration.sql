-- data we are going to be using
use covid_exploration;
SELECT 
    location, date, total_cases, population
FROM
    covid_deaths
ORDER BY 1;

-- Total cases vs total deaths (Death Rate)
-- Shows likelihood of dying if you contract covid in your country
SELECT 
    location,
    date,
    total_cases,
    total_deaths,
    ROUND((total_deaths / total_cases) * 100, 2) AS death_rate
FROM
    covid_deaths
WHERE
    location LIKE '%irel%'
ORDER BY 1;

-- Total cases vs total population
-- Shows what percentage of population contracted covid
SELECT 
    location,
    date,
    total_cases,
    ROUND((total_cases / population) * 100, 10) AS infection_rate
FROM
    covid_deaths
WHERE
    location LIKE '%irel%'
ORDER BY 1;

-- Showing Countries with Highest Infection Rate per Population Currently

SELECT 
    location,
    population,
    MAX(total_cases) AS total_cases,
    ROUND(MAX(total_cases / population) * 100, 10) AS infection_rate
FROM
    covid_deaths
WHERE
    continent IS NOT NULL
GROUP BY location , population
HAVING MAX(date)
ORDER BY 3 DESC;

-- Showing Highest Death Count per Population

SELECT 
    location, MAX(total_deaths) AS total_death_count, population
FROM
    covid_deaths
WHERE
    continent IS NOT NULL
GROUP BY location , population
HAVING MAX(date)
ORDER BY 2 DESC;

-- Showing Countries with Highest Death Rate currently (total_deaths/ total_cases)
-- Likelihood of death if contracted infection

SELECT 
    location,
    population,
    MAX(total_cases) AS total_cases,
    MAX(total_deaths) AS total_deaths,
    ROUND(MAX(total_deaths) / MAX(total_cases) * 100,
            2) AS death_rate
FROM
    covid_deaths
WHERE
    continent IS NOT NULL
GROUP BY location , population
HAVING MAX(date)
ORDER BY 5 DESC;

-- Showing death Rate by Continent (total_deaths/ total_cases)
-- Likelihood of death if contracted infection

SELECT 
    location,
    population,
    MAX(total_cases) AS total_cases,
    MAX(total_deaths) AS total_deaths,
    ROUND(MAX(total_deaths) / MAX(total_cases) * 100,
            2) AS death_rate
FROM
    covid_deaths
WHERE
    continent IS NULL
        AND population IS NOT NULL
GROUP BY location , population
ORDER BY 5 DESC;

-- Global Numbers
-- Showing the total cases and deaths in the world with the death rate
SELECT 
    SUM(new_cases) AS total_cases,
    SUM(new_deaths) AS total_deaths,
    ROUND((SUM(new_deaths) / SUM(new_cases) * 100),
            2) AS death_rate
FROM
    covid_deaths;

-- Showing People Fully Vaccinated per Population

SELECT 
    d.location,
    d.population,
    MAX(v.people_fully_vaccinated) AS total_vaccinations
FROM
    covid_deaths d
        INNER JOIN
    covid_vaccinations v ON d.location = v.location
        AND d.date = v.date
WHERE
    d.continent IS NOT NULL
GROUP BY d.location , d.population
HAVING MAX(d.date)
ORDER BY total_vaccinations DESC;

-- Showing Countries Having the Highest Vaccination Rates Currently

SELECT 
    d.location,
    d.population,
    MAX(v.new_vaccinations) AS new_vaccinations,
    ROUND(MAX(v.new_vaccinations) / population * 100,
            2) AS vaccination_rate
FROM
    covid_deaths d
        INNER JOIN
    covid_vaccinations v ON d.location = v.location
        AND d.date = v.date
WHERE
    d.continent IS NOT NULL
GROUP BY d.location , d.population
HAVING MAX(d.date)
ORDER BY vaccination_rate DESC;

-- Total Covid Deaths and Death Percentage in all the Countries
CREATE TABLE viz_table_1 (SELECT SUM(new_cases) AS total_cases,
    SUM(new_deaths) AS total_deaths,
    ROUND(SUM(new_deaths) / SUM(New_Cases) * 100,
            2) AS death_percentage FROM
    covid_deaths
WHERE
    continent IS NOT NULL
ORDER BY 1 , 2);

-- total deaths by continents
CREATE TABLE viz_table_2 (SELECT location, SUM(new_deaths) AS total_death_count FROM
    covid_deaths
WHERE
    continent IS NULL
        AND location NOT IN ('World' , 'European Union', 'International')
GROUP BY location
ORDER BY total_death_count DESC);


-- Higest Infection count as per Country population
CREATE TABLE viz_table_3 (SELECT Location,
    Population,
    MAX(total_cases) AS highest_infection_count,
    ROUND(MAX((total_cases / population)) * 100, 2) AS percent_population_infected FROM
    covid_deaths
GROUP BY Location , Population
ORDER BY percent_population_infected DESC);

-- Highest Infection count as per Dates
DROP TABLE IF EXISTS viz_table_4;
CREATE TABLE viz_table_4 (SELECT Location,
    Population,
    date,
    MAX(total_cases) AS highest_infection_count,
    ROUND(MAX((total_cases / population)) * 100, 2) AS percent_population_infected FROM
    covid_deaths
GROUP BY Location , Population , date
ORDER BY percent_population_infected DESC);

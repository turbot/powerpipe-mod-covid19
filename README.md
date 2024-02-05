# COVID-19 Data Analysis Using PostgreSQL and PowerPipe

Analyze COVID-19 data using PostgreSQL and PowerPipe.

## Installation

Download and install Powerpipe (https://powerpipe.io/downloads) and PostgreSQL(https://www.postgresql.org/download). Or use Brew:

```sh
brew tap turbot/tap
brew install powerpipe
brew install postgresql
```

Clone:

```sh
git clone https://github.com/turbot/-samples.git
cd covid19_postgresql_powerpipe_analysis
```

## Setup

Download CovidDeaths.csv and CovidVaccinations.csv from https://drive.google.com/drive/u/1/folders/18ElOTPDDo6y3JBCLr-dimsfnjXz7B6Pu

```
postgres=# CREATE TABLE covid_deaths (
    iso_code VARCHAR(10),
    continent VARCHAR(50),
    location VARCHAR(100),
    date DATE,
    population BIGINT,
    total_cases BIGINT,
    new_cases BIGINT,
    total_deaths BIGINT,
    new_deaths BIGINT,
    total_deaths_per_million DECIMAL,
    new_deaths_per_million DECIMAL,
    reproduction_rate DECIMAL,
    icu_patients BIGINT,
    hosp_patients BIGINT,
    weekly_icu_admissions BIGINT,
    weekly_hosp_admissions BIGINT
);
CREATE TABLE

postgres=# \copy covid_deaths FROM '/path/to/downloads/CovidDeaths.csv' DELIMITER ',' CSV HEADER;

ERROR:  date/time field value out of range: "13-01-2020"

HINT:  Perhaps you need a different "datestyle" setting.

CONTEXT:  COPY covid_deaths, line 12, column date: "13-01-2020"

postgres=# SET DateStyle = 'DMY';
SET

postgres=# \copy covid_deaths FROM '/path/to/downloads/CovidDeaths.csv' DELIMITER ',' CSV HEADER;
COPY 308013

postgres=# reset DateStyle;
RESET

CREATE TABLE covid_vaccinations (
    iso_code VARCHAR(10),
    continent VARCHAR(50),
    location VARCHAR(100),
    date DATE,
    total_tests BIGINT,
    new_tests BIGINT,
    positive_rate DECIMAL,
    tests_per_case DECIMAL,
    tests_units VARCHAR(50),
    total_vaccinations BIGINT,
    people_vaccinated BIGINT,
    people_fully_vaccinated BIGINT,
    total_boosters BIGINT,
    new_vaccinations BIGINT,
    stringency_index DECIMAL,
    population_density DECIMAL,
    median_age DECIMAL,
    aged_65_older DECIMAL,
    aged_70_older DECIMAL,
    gdp_per_capita DECIMAL,
    extreme_poverty DECIMAL,
    cardiovasc_death_rate DECIMAL,
    diabetes_prevalence DECIMAL,
    handwashing_facilities DECIMAL,
    life_expectancy DECIMAL,
    human_development_index DECIMAL,
    excess_mortality_cumulative DECIMAL,
    excess_mortality DECIMAL
);

postgres=# SET DateStyle = 'DMY';
SET

\copy covid_vaccinations FROM '/path/to/downloads/CovidVaccinations.csv' DELIMITER ',' CSV HEADER;
COPY 308013

postgres=# reset DateStyle;
RESET
```

## Usage

Run the dashboard and specify the DB connection string:

```sh
powerpipe server --database postgresql://username:password@localhost:5432/mydatabase
```

(If running as trusted user, e.g. user `postgres`, you can omit `:password`

Then visit localhost:9194 to view the dashboard.


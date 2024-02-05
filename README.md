# COVID-19 Data Analysis Using PostgreSQL and Powerpipe

Analyze COVID-19 data using PostgreSQL and Powerpipe.

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

Download data from https://covid.ourworldindata.org/data/owid-covid-data.csv.

```
CREATE TABLE covid_data (
    iso_code VARCHAR(10),
    continent VARCHAR(50),
    location VARCHAR(50),
    date DATE,
    total_cases FLOAT,
    new_cases FLOAT,
    new_cases_smoothed FLOAT,
    total_deaths FLOAT,
    new_deaths FLOAT,
    new_deaths_smoothed FLOAT,
    total_cases_per_million FLOAT,
    new_cases_per_million FLOAT,
    new_cases_smoothed_per_million FLOAT,
    total_deaths_per_million FLOAT,
    new_deaths_per_million FLOAT,
    new_deaths_smoothed_per_million FLOAT,
    reproduction_rate FLOAT,
    icu_patients FLOAT,
    icu_patients_per_million FLOAT,
    hosp_patients FLOAT,
    hosp_patients_per_million FLOAT,
    weekly_icu_admissions FLOAT,
    weekly_icu_admissions_per_million FLOAT,
    weekly_hosp_admissions FLOAT,
    weekly_hosp_admissions_per_million FLOAT,
    total_tests FLOAT,
    new_tests FLOAT,
    total_tests_per_thousand FLOAT,
    new_tests_per_thousand FLOAT,
    new_tests_smoothed FLOAT,
    new_tests_smoothed_per_thousand FLOAT,
    positive_rate FLOAT,
    tests_per_case FLOAT,
    tests_units VARCHAR(50),
    total_vaccinations FLOAT,
    people_vaccinated FLOAT,
    people_fully_vaccinated FLOAT,
    total_boosters FLOAT,
    new_vaccinations FLOAT,
    new_vaccinations_smoothed FLOAT,
    total_vaccinations_per_hundred FLOAT,
    people_vaccinated_per_hundred FLOAT,
    people_fully_vaccinated_per_hundred FLOAT,
    total_boosters_per_hundred FLOAT,
    new_vaccinations_smoothed_per_million FLOAT,
    new_people_vaccinated_smoothed FLOAT,
    new_people_vaccinated_smoothed_per_hundred FLOAT,
    stringency_index FLOAT,
    population_density FLOAT,
    median_age FLOAT,
    aged_65_older FLOAT,
    aged_70_older FLOAT,
    gdp_per_capita FLOAT,
    extreme_poverty FLOAT,
    cardiovasc_death_rate FLOAT,
    diabetes_prevalence FLOAT,
    female_smokers FLOAT,
    male_smokers FLOAT,
    handwashing_facilities FLOAT,
    hospital_beds_per_thousand FLOAT,
    life_expectancy FLOAT,
    human_development_index FLOAT,
    population FLOAT,
    excess_mortality_cumulative_absolute FLOAT,
    excess_mortality_cumulative FLOAT,
    excess_mortality FLOAT,
    excess_mortality_cumulative_per_million FLOAT
);
```

```
postgres=# \copy covid_data FROM '/path/to/repo/owid-covid-data.csv' DELIMITER ',' CSV HEADER;
COPY 373434
```

## Usage

Run the dashboard and specify the DB connection string:

```sh
powerpipe server --database postgresql://username:password@localhost:5432/mydatabase
```

(If you're running Postgres as a trusted user, e.g. `postgres`, you can omit `:password`)

Then visit localhost:9194 in a browser.

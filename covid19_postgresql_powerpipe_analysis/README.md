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

Download the COVID-19 deaths and vaccinations data (https://medium.com/@ajet.gbenga/a-project-on-exploring-covid-19-deaths-and-vaccinations-data-with-sql-using-postgresql-project-b57ccf8d9d4c).

Create a new database specifically for COVID-19 analysis, and within it, create the covid_deaths and covid_vaccinations tables according to their respective column structures as defined in the above CSV files.

Import the CSV files into their respective tables covid_deaths and covid_vaccinations.

## Usage

Run the dashboard and specify the DB connection string:

```sh
powerpipe server --workspace-database postgresql://username:password@localhost:5432/mydatabase
```

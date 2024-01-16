dashboard "covid19_dashboard" {

  title = "COVID-19 Data Analysis Dashboard"

  # Dashboard Containers
  container {

    title = "Overview"

    # Cards for Key Metrics
    card {
      query = query.total_cases
      width = 2
    }

    card {
      query = query.total_deaths
      width = 2
    }

    card {
      query = query.total_vaccinations
      width = 4
    }

    card {
      query = query.people_fully_vaccinated
      width = 4
    }
  }

  container {

    title = "Vaccination Analysis"

    # Vaccination Charts
    chart {
      title = "Vaccination Progress by Continent"
      query = query.vaccination_by_continent
      type  = "bar"
      width = 6
    }

    chart {
      title = "Total Tests Conducted by Continent"
      query = query.total_tests_by_continent
      type  = "bar"
      width = 6
    }
  }

  container {

    title = "Mortality Analysis"

    # Mortality Charts
    chart {
      title = "Deaths by Continent"
      query = query.deaths_by_continent
      type  = "bar"
      width = 6
    }

    chart {
      title = "Case Fatality Rate by Location"
      query = query.case_fatality_rate
      type  = "column"
      width = 6
    }
  }
}

# SQL Queries for the Dashboard

query "total_cases" {
  sql = "SELECT COUNT(*) AS \"Total Cases\" FROM covid_deaths WHERE total_cases IS NOT NULL;"
}

query "total_deaths" {
  sql = "SELECT COUNT(*) AS \"Total Deaths\" FROM covid_deaths WHERE total_deaths IS NOT NULL;"
}

query "total_vaccinations" {
  sql = "SELECT SUM(total_vaccinations) AS \"Total Vaccinations\" FROM covid_vaccinations;"
}

query "people_fully_vaccinated" {
  sql = "SELECT SUM(people_fully_vaccinated) AS \"Fully Vaccinated People\" FROM covid_vaccinations;"
}

query "vaccination_by_continent" {
  sql = "SELECT continent, SUM(total_vaccinations) AS \"Total Vaccinations\" FROM covid_vaccinations GROUP BY continent ORDER BY SUM(total_vaccinations) DESC;"
}

query "deaths_by_continent" {
  sql = "SELECT continent, SUM(total_deaths) AS \"Deaths\" FROM covid_deaths GROUP BY continent ORDER BY SUM(total_deaths) DESC;"
}

query "case_fatality_rate" {
  sql = "SELECT location, (SUM(total_deaths)/SUM(total_cases))*100 AS \"Case Fatality Rate\" FROM covid_deaths GROUP BY location ORDER BY (SUM(total_deaths)/SUM(total_cases))*100 DESC;"
}

query "total_tests_by_continent" {
  sql = "SELECT continent, SUM(total_tests) AS \"Total Tests\" FROM covid_vaccinations WHERE total_tests IS NOT NULL GROUP BY continent ORDER BY SUM(total_tests) DESC;"
}

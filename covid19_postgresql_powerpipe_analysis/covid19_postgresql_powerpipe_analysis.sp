dashboard "covid19_dashboard" {

  title = "COVID-19 Data Analysis Dashboard"

  # Dashboard Containers
  container {

    title = "Overview"

    # Cards for Key Metrics
    card {
      query = query.total_cases
      width = 3
      type  = "info"
    }

    card {
      query = query.total_deaths
      width = 3
      type  = "info"
    }

    card {
      query = query.total_vaccinations
      width = 3
      type  = "info"
    }

    card {
      query = query.people_fully_vaccinated
      width = 3
      type  = "info"
    }
  }

  container {

    title = "Vaccination Proportions"
    width = 6

    chart {
      title = "Proportion of Fully Vaccinated People"
      query = query.proportion_fully_vaccinated
      type  = "donut"

      series "count" {
        point "fully vaccinated" {
          color = "ok"
        }
        point "not fully vaccinated" {
          color = "alert"
        }
      }
    }
  }

  container {

    title = "Case Severity Analysis"
    width = 6

    chart {
      title = "Case Fatality Rate"
      query = query.case_fatality_rate_proportion
      type  = "donut"

      series "count" {
        point "fatal cases" {
          color = "alert"
        }
        point "recovered cases" {
          color = "ok"
        }
      }
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
  sql = <<-EOQ
    SELECT SUM(total_cases)::bigint AS "Total Cases"
    FROM covid_deaths
    WHERE total_cases IS NOT NULL;
  EOQ
}

query "total_deaths" {
  sql = <<-EOQ
    SELECT SUM(total_deaths)::bigint AS "Total Deaths"
    FROM covid_deaths
    WHERE total_deaths IS NOT NULL;
  EOQ
}

query "total_vaccinations" {
  sql = <<-EOQ
    SELECT SUM(total_vaccinations)::bigint AS "Total Vaccinations"
    FROM covid_vaccinations
    WHERE total_vaccinations IS NOT NULL;
  EOQ
}

query "people_fully_vaccinated" {
  sql = <<-EOQ
    SELECT SUM(people_fully_vaccinated)::bigint AS "Fully Vaccinated People"
    FROM covid_vaccinations;
  EOQ
}

query "vaccination_by_continent" {
  sql = <<-EOQ
    SELECT continent, SUM(total_vaccinations) AS "Total Vaccinations"
    FROM covid_vaccinations
    GROUP BY continent
    ORDER BY SUM(total_vaccinations) DESC;
  EOQ
}

query "deaths_by_continent" {
  sql = <<-EOQ
    SELECT continent, SUM(total_deaths) AS "Deaths"
    FROM covid_deaths
    GROUP BY continent
    ORDER BY SUM(total_deaths) DESC;
  EOQ
}

query "case_fatality_rate" {
  sql = <<-EOQ
    SELECT location, (SUM(total_deaths)/SUM(total_cases))*100 AS "Case Fatality Rate"
    FROM covid_deaths
    GROUP BY location
    ORDER BY (SUM(total_deaths)/SUM(total_cases))*100 DESC;
  EOQ
}

query "total_tests_by_continent" {
  sql = <<-EOQ
    SELECT continent, SUM(total_tests) AS "Total Tests"
    FROM covid_vaccinations
    WHERE total_tests IS NOT NULL
    GROUP BY continent
    ORDER BY SUM(total_tests) DESC;
  EOQ
}

query "proportion_fully_vaccinated" {
  sql = <<-EOQ
    SELECT
      'fully vaccinated' AS status,
      SUM(people_fully_vaccinated) AS count
    FROM
      covid_vaccinations
    UNION ALL
    SELECT
      'not fully vaccinated' AS status,
      SUM(total_vaccinations - people_fully_vaccinated) AS count
    FROM
      covid_vaccinations
    WHERE
      people_fully_vaccinated IS NOT NULL AND total_vaccinations IS NOT NULL;
  EOQ
}

query "case_fatality_rate_proportion" {
  sql = <<-EOQ
    SELECT
      'fatal cases' AS category,
      SUM(total_deaths) AS count
    FROM
      covid_deaths
    UNION ALL
    SELECT
      'recovered cases' AS category,
      SUM(total_cases - total_deaths) AS count
    FROM
      covid_deaths
    WHERE
      total_cases IS NOT NULL AND total_deaths IS NOT NULL;
  EOQ
}

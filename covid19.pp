dashboard "covid19" {
  title = "COVID-19 Dashboard"

  container {
    title = "Global Overview"

    card {
      query = query.covid19_global_total_cases
      width = 3
      type  = "info"
    }

    card {
      query = query.covid19_global_new_cases
      width = 3
      type  = "info"
    }

    card {
      query = query.covid19_global_total_deaths
      width = 3
      type  = "info"
    }

    card {
      query = query.covid19_global_new_deaths
      width = 3
      type  = "info"
    }
  }

  container {
    title = "Testing and Vaccinations"

    chart {
      type  = "line"
      title = "Global New Tests vs. New Cases Over Time"
      query = query.covid19_tests_vs_cases_over_time
      width = 6
    }

    chart {
      type  = "line"
      title = "Global Vaccination Progress Over Time"
      query = query.covid19_vaccination_progress_over_time
      width = 6
    }
  }

  container {
    title = "Healthcare Capacity"

    chart {
      type  = "line"
      title = "ICU Patients vs. Hospital Patients"
      query = query.covid19_icu_vs_hospital_patients
      width = 6
    }

    chart {
      type  = "line"
      title = "Weekly ICU and Hospital Admissions"
      query = query.covid19_weekly_admissions
      width = 6
    }
  }

  container {
    title = "Case and Death Rates by Location"

    chart {
      type     = "column"
      title    = "Total Cases and Deaths Per Million by Continent"
      query    = query.covid19_cases_deaths_per_million_by_continent
      width    = 6
      grouping = "compare"
    }

    chart {
      type  = "pie"
      title = "Distribution of New Cases by Continent"
      query = query.covid19_distribution_of_new_cases_by_continent
      width = 6
    }
  }

  container {
    title = "Vaccination Coverage"

    chart {
      type  = "donut"
      title = "People Fully Vaccinated Per Hundred by Continent"
      query = query.covid19_fully_vaccinated_per_hundred_by_continent
      width = 6
    }

    chart {
      type  = "column"
      title = "Total Boosters Administered by Continent"
      query = query.covid19_boosters_by_continent
      width = 6
    }
  }
}

# Global Overview Queries

query "covid19_global_total_cases" {
  sql = <<-EOQ
    select
      sum(total_cases) as "Global Total Cases"
    from
      covid_data;
  EOQ
}

query "covid19_global_new_cases" {
  sql = <<-EOQ
    select
      sum(new_cases) as "Global New Cases"
    from
      covid_data;
  EOQ
}

query "covid19_global_total_deaths" {
  sql = <<-EOQ
    select
      sum(total_deaths) as "Global Total Deaths"
    from
      covid_data;
  EOQ
}

query "covid19_global_new_deaths" {
  sql = <<-EOQ
    select
      sum(new_deaths) as "Global New Deaths"
    from
      covid_data;
  EOQ
}

# Testing and Vaccinations Queries

query "covid19_tests_vs_cases_over_time" {
  sql = <<-EOQ
    select
      date,
      sum(new_tests) as "New Tests",
      sum(new_cases) as "New Cases"
    from
      covid_data
    group by
      date
    order by
      date;
  EOQ
}

query "covid19_vaccination_progress_over_time" {
  sql = <<-EOQ
    select
      date,
      sum(total_vaccinations) as "Total Vaccinations"
    from
      covid_data
    group by
      date
    order by
      date;
  EOQ
}

# Healthcare Capacity Queries

query "covid19_icu_vs_hospital_patients" {
  sql = <<-EOQ
    select
      date,
      sum(icu_patients) as "ICU Patients",
      sum(hosp_patients) as "Hospital Patients"
    from
      covid_data
    group by
      date
    order by
      date;
  EOQ
}

query "covid19_weekly_admissions" {
  sql = <<-EOQ
    select
      date,
      sum(weekly_icu_admissions) as "ICU Admissions",
      sum(weekly_hosp_admissions) as "Hospital Admissions"
    from
      covid_data
    group by
      date
    order by
      date;
  EOQ
}

# Case and Death Rates by Location Queries

query "covid19_cases_deaths_per_million_by_continent" {
  sql = <<-EOQ
    select
      continent,
      sum(total_cases_per_million) as "Total Cases Per Million",
      sum(total_deaths_per_million) as "Total Deaths Per Million"
    from
      covid_data
    where
      continent != ''
    group by
      continent
    order by
      sum(total_cases_per_million),
      sum(total_deaths_per_million) desc;
  EOQ
}

query "covid19_distribution_of_new_cases_by_continent" {
  sql = <<-EOQ
    select
      continent,
      sum(new_cases) as "New Cases"
    from
      covid_data
    where
      continent != ''
    group by
      continent
    order by
      sum(new_cases) desc;
  EOQ
}

# Vaccination Coverage Queries

query "covid19_fully_vaccinated_per_hundred_by_continent" {
  sql = <<-EOQ
    select
      continent,
      max(people_fully_vaccinated_per_hundred) as "People Fully Vaccinated Per Hundred"
    from
      covid_data
    where
      continent != ''
    group by
      continent
    order by
      max(people_fully_vaccinated_per_hundred) desc;
  EOQ
}

query "covid19_boosters_by_continent" {
  sql = <<-EOQ
    select
      continent,
      sum(total_boosters) as "Total Boosters"
    from
      covid_data
    where
      continent != ''
    group by
      continent
    order by
      sum(total_boosters) desc;
  EOQ
}

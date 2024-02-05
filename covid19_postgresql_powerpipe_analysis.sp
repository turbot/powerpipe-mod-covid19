dashboard "covid19_dashboard" {

  title = "COVID-19 Data Analysis Dashboard"

  container {
    title = "Overview"

    card {
      width = 6
      type  = "info"
      sql = "select to_char(max(total_deaths),'999G999G999') as \"Global Deaths\" from covid_data where iso_code = 'OWID_WRL';"
    }
  }
}


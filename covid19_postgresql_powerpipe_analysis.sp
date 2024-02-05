dashboard "covid19_dashboard" {

  title = "COVID-19 Data"

  container {
    title = "Overview"

    card {
      width = 2
      type  = "info"
      sql = "select to_char(max(total_deaths),'999G999G999') as \"Global Deaths\" from covid_data where iso_code = 'OWID_WRL';"
    }
  }

  container {

    input "locations" {
      width = 2
      title = "locations"
      sql = <<EOQ
        with data as (
          select distinct on (iso_code)
            iso_code,
            continent || ', ' || location || ' (' || iso_code || ')' as location
          from
            covid_data
        )
        select
          location as label,
          iso_code as value
        from
          data
        order by
          label, value
      EOQ
    }
  }

  container {

    table {
      width = 4
      sql = <<EOQ
        select 
          to_char(sum(new_deaths), '999,999,999,999') as deaths,
          to_char(max(population), '999,999,999,999') as population,
          to_char(max(people_vaccinated), '999,999,999,999') as people_vaccinated,
          round( (max(people_vaccinated)::numeric / max(population)::numeric), 1) * 100 as "% vaccinated",
          to_char(max(people_fully_vaccinated), '999,999,999,999') as people_fully_vaccinated,
          round( (max(people_fully_vaccinated)::numeric / max(population)::numeric), 1) * 100 as "% fully vaccinated"
        from covid_data
        where iso_code = $1
        group by iso_code, population
      EOQ
      args = [self.input.locations.value]
    }

  }

}


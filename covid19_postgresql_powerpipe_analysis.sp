dashboard "covid19_dashboard" {

  title = "COVID-19 Data"

  container {
    title = "Overview"

    card {
      width = 6
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
      width = 2
      sql = <<EOQ
        select 
          to_char(sum(new_deaths), '999,999,999,999') as deaths,
          to_char(max(population), '999,999,999,999') as population
        from covid_data
        where iso_code = $1
        group by iso_code, population
      EOQ
      args = [self.input.locations.value]
    }

  }


  container {

    table {
      title = "by location"
      sql = "select * from covid_data where iso_code = $1 order by date limit 100"
      args = [self.input.locations.value]
    }

  }


}


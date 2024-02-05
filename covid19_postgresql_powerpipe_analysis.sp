dashboard "covid-19" {

  title = "COVID-19 Data"

  container {
    title = "Overview"

    card {
      width = 2
      type  = "info"
      sql   = "select to_char(max(total_deaths),'999G999G999') as \"Global Deaths\" from covid_data where iso_code = 'OWID_WRL';"
    }
  }

  container {
    width = 4

    input "locations" {
      width = 4
      title = "locations"
      sql   = <<EOQ
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

    table {
      query = query.by_iso_code
      args = [self.input.locations.value]
    }
  }

  container {
    width = 4

    input "continents" {
      width = 4
      title = "continents"
      sql   = <<EOQ
          with data as (
            select distinct on (iso_code)
              iso_code,
              location
            from
              covid_data
          )
          select
            location || ' (' || iso_code || ')' label,
            iso_code as value
          from
            data
          where iso_code in ('OWID_AFR', 'OWID_ASI', 'OWID_EUR', 'OWID_NAM', 'OWID_OCE', 'OWID_SAM', 'OWID_WRL')
          order by
            label, value
     EOQ
    }

    table {
      query = query.by_iso_code
      args = [self.input.continents.value]
    }

  }

  container {
    width = 4

    input "income" {
      width = 4
      title = "income"
      sql   = <<EOQ
        with data as (
          select distinct on (iso_code)
            iso_code,
            location
          from
            covid_data
        )
        select
          location || ' (' || iso_code || ')' label,
          iso_code as value
        from
          data
        where iso_code in ('OWID_LIC', 'OWID_LMC', 'OWID_UMC', 'OWID_HIC')
        order by
          label, value
     EOQ
    }

    table {
      query = query.by_iso_code
      args = [self.input.income.value]
    }

  }

}

query "by_iso_code" {
  sql = <<EOQ
    select 
      to_char(sum(new_deaths), '999,999,999,999') as deaths,
      to_char(max(population), '999,999,999,999') as population,
      round(sum(new_deaths)::numeric / max(population)::numeric * 100, 2) as "%",
      to_char(max(people_vaccinated), '999,999,999,999') as vaccinated,
      round((max(people_vaccinated)::numeric / max(population)::numeric) * 100, 2) as "%",
      to_char(max(people_fully_vaccinated), '999,999,999,999') as fully_vaccinated,
      round((max(people_fully_vaccinated)::numeric / max(population)::numeric) * 100, 2) as "%"
    from covid_data
    where iso_code = 'USA'
  EOQ
}







dashboard "covid-19" {

  title = "COVID-19 Data"

  container {

    card {
      width = 2
      sql   = "select to_char(max(total_deaths),'999G999G999') as \"Deaths: global\" from covid_data where iso_code = 'OWID_WRL';"
    }

    card {
      width = 2
      sql   = "select to_char(max(total_deaths),'999G999G999') as \"Deaths: Africa\" from covid_data where iso_code = 'OWID_AFR';"
    }

    card {
      width = 2
      sql   = "select to_char(max(total_deaths),'999G999G999') as \"Deaths: Asia\" from covid_data where iso_code = 'OWID_ASI';"
    }

    card {
      width = 2
      sql   = "select to_char(max(total_deaths),'999G999G999') as \"Deaths: North America\" from covid_data where iso_code = 'OWID_NAM';"
    }

    card {
      width = 2
      sql   = "select to_char(max(total_deaths),'999G999G999') as \"Deaths: Oceania\" from covid_data where iso_code = 'OWID_OCE';"
    }

    card {
      width = 2
      sql   = "select to_char(max(total_deaths),'999G999G999') as \"Deaths: South America\" from covid_data where iso_code = 'OWID_SAM';"
    }


  }

  container {
    
    chart {
      title = "Deaths as a % of population by region"
      width = 3
      type = "donut"
      sql = <<EOQ
        select
          location,
          round(sum(new_deaths)::numeric / max(population)::numeric * 100, 2) as "pct"
        from covid_data
        where iso_code in ('OWID_AFR', 'OWID_ASI', 'OWID_EUR', 'OWID_NAM', 'OWID_OCE', 'OWID_SAM')
        group by location
        order by "pct"
      EOQ
    }

    chart {
      title = "Global deaths by month"
      width = 8
      type = "column"
      sql = <<EOQ
        with data as (
          select
            to_char(date, 'YYYY-MM') as year_month,
            sum(new_deaths) as deaths
        from covid_data
        where iso_code = 'OWID_WRL'
        group by year_month
        order by year_month
        )
        select
          year_month,
          deaths
        from data
        order by year_month
      EOQ
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
      round(sum(new_deaths)::numeric / max(population)::numeric * 100, 2) as "% d",
      to_char(max(people_vaccinated), '999,999,999,999') as vaccinated,
      round((max(people_vaccinated)::numeric / max(population)::numeric) * 100, 2) as "% v",
      to_char(max(people_fully_vaccinated), '999,999,999,999') as fully_vaccinated,
      round((max(people_fully_vaccinated)::numeric / max(population)::numeric) * 100, 2) as "% fv"
    from covid_data
    where iso_code = $1
  EOQ
}







dashboard "covid-19" {

  title = "COVID-19 data from https://covid.ourworldindata.org/data/owid-covid-data.csv"

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
    width = 12
    chart {
      title = "Global deaths by month"
      type  = "column"
      sql   = <<EOQ
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

    title = "Deaths as a % of population"

    container {
      chart {
        width = 4
        title = "Deaths as a % of population by region"
        type  = "donut"
        sql   = <<EOQ
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
        width = 4
        title = "Deaths as a % of population by continent"
        type  = "donut"
        sql   = <<EOQ
          select
            location,
            round(sum(new_deaths)::numeric / max(population)::numeric * 100, 2) as "pct"
          from covid_data
          where iso_code not in ('OWID_AFR', 'OWID_ASI', 'OWID_EUR', 'OWID_NAM', 'OWID_OCE', 'OWID_SAM', 'OWID_LIC', 'OWID_LMC', 'OWID_UMC', 'OWID_HIC')
          group by location
          order by "pct"
        EOQ
      }

      chart {
        width = 4
        title = "Deaths as a % of population by income"
        type  = "donut"
        sql   = <<EOQ
          select
            location,
            round(sum(new_deaths)::numeric / max(population)::numeric * 100, 2) as "pct"
          from covid_data
          where iso_code in ('OWID_LIC', 'OWID_LMC', 'OWID_UMC', 'OWID_HIC')
          group by location, iso_code
          order by "pct"
        EOQ
      }

      text {
        width = 4
        value = "Note: small values for Africa/Asia and Low income/Lower middle income likely reflect underreporting."
      }


    }
  }

  container {
    width = 4

    input "locations" {
      width = 6
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
      width = 8
      type  = "line"
      query = query.by_iso_code
      args  = [self.input.locations.value]
    }


  }

  container {
    width = 4

    input "continents" {
      width = 6
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
      width = 8
      type  = "line"
      query = query.by_iso_code
      args  = [self.input.continents.value]
    }

  }

  container {
    width = 4

    input "income" {
      width = 6
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
      width = 8
      type  = "line"
      query = query.by_iso_code
      args  = [self.input.income.value]
    }

    table {
      sql = <<EOQ
        select iso_code, location as category, to_char(max(population),'999,999,999,999') as population
        from covid_data where iso_code = 'OWID_HIC'
        group by iso_code, location
        union
        select iso_code, location as category, to_char(max(population),'999,999,999,999') as population
        from covid_data where iso_code = 'OWID_UMC'
        group by iso_code, location
        union
        select iso_code, location as category, to_char(max(population),'999,999,999,999') as population
        from covid_data where iso_code = 'OWID_LMC'
        group by iso_code, location
        union
        select iso_code, location as category, to_char(max(population),'999,999,999,999') as population
        from covid_data where iso_code = 'OWID_LIC'
        group by iso_code, location
      EOQ
    }

  }

  container {
    title = "About the data"
    
    table "columns" {
      width = 4
      title = "All available columns"
      sql   = <<EOQ
        select column_name
        from information_schema.columns
        where table_name  = 'covid_data'
        order by column_name
      EOQ
    }

    table {
      width = 4
      title = "Most recent data by location, oldest to newest"
      sql = <<EOQ
        select to_char(max(date), 'YYYY-MM-DD') as date, location
        from covid_data 
        group by iso_code, location
        order by date, iso_code
      EOQ

    }

  }

}

query "by_iso_code" {
  sql = <<EOQ
    select 
      to_char(sum(new_deaths), '999,999,999,999') as deaths,
      to_char(max(population), '999,999,999,999') as population,
      round(sum(new_deaths)::numeric / max(population)::numeric * 100, 2) as "deaths as % of population",
      to_char(max(people_vaccinated), '999,999,999,999') as vaccinated,
      round((max(people_vaccinated)::numeric / max(population)::numeric) * 100, 2) as "people vaccinated as % of population",
      to_char(max(people_fully_vaccinated), '999,999,999,999') as fully_vaccinated,
      round((max(people_fully_vaccinated)::numeric / max(population)::numeric) * 100, 2) as "people fully vaccinated as % of population"
    from covid_data
    where iso_code = $1
  EOQ
}









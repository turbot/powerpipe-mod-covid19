dashboard "covid-19" {

  title = "COVID-19 data from https://covid.ourworldindata.org/data/owid-covid-data.csv"

  container {
  }

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

    card {
      width = 2
      sql   = "select to_char(max(total_vaccinations),'999G999G999G999') as \"Vaccinations: global\" from covid_data where iso_code = 'OWID_WRL';"
    }

    card {
      width = 2
      sql   = "select to_char(max(total_vaccinations),'999G999G999G999') as \"Vaccinations: Africa\" from covid_data where iso_code = 'OWID_AFR';"
    }

    card {
      width = 2
      sql   = "select to_char(max(total_vaccinations),'999G999G999G999') as \"Vaccinations: Asia\" from covid_data where iso_code = 'OWID_ASI';"
    }

    card {
      width = 2
      sql   = "select to_char(max(total_vaccinations),'999G999G999G999') as \"Vaccinations: North America\" from covid_data where iso_code = 'OWID_NAM';"
    }

    card {
      width = 2
      sql   = "select to_char(max(total_vaccinations),'999G999G999G999') as \"Vaccinations: Oceania\" from covid_data where iso_code = 'OWID_OCE';"
    }

    card {
      width = 2
      sql   = "select to_char(max(total_vaccinations),'999G999G999G999') as \"Vaccinations: South America\" from covid_data where iso_code = 'OWID_SAM';"
    }

  }

  container {
    width = 12
    chart {
      title = "Deaths by month"
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

/*
  container {
      chart {
        type = "line"
        sql = <<EOQ
          SELECT * FROM (
            VALUES
              ('us-east-1', 'foo', 4),
              ('us-east-2', 'foo', 3),
              ('us-west-1', 'foo', 2),
              ('us-west-2', 'foo', 1),
              ('us-east-1', 'bar', 5),
              ('us-east-2', 'bar', 6),
              ('us-west-1', 'bar', 7),
              ('us-west-2', 'bar', 8)
          ) AS t(region, series_name, count);        
        EOQ
      }
   }
*/   


  container {
    width = 12
    chart {
      type = "line"
      title = "Deaths by country, top 15 by population"
      sql   = <<EOQ
        with iso_codes as (
          select iso_code, location as location, max(population) as max_pop from covid_data
          where iso_code not in ('OWID_WRL', 'OWID_AFR', 'OWID_ASI', 'OWID_EUR', 'OWID_NAM', 'OWID_OCE', 'OWID_SAM', 'OWID_LIC', 'OWID_LMC', 'OWID_UMC', 'OWID_HIC')
          group by iso_code, location
          order by max_pop desc
          limit 15
        ),
        monthly_deaths as (
          select
            iso_code,
            to_char(date, 'YYYY-MM') as year_month,
            sum(coalesce(new_deaths, 0)) as deaths
          from covid_data c join iso_codes i using (iso_code)
          group by iso_code, year_month
        )
        select 
          m.year_month,
          i.location,
          m.deaths
        from iso_codes i
        join monthly_deaths m using (iso_code)
        order by iso_code, year_month, deaths
      EOQ
    }
    
  }  

  container {

    title = "Deaths as a % of population"

    container {

      chart {
        width = 4
        title = "Deaths as a % of population by continent"
        type  = "donut"
        sql   = <<EOQ
          select
            location,
            round(sum(new_deaths)::numeric / max(population)::numeric * 100, 2) as "pct"
          from covid_data
          where iso_code in ('OWID_AFR', 'OWID_ASI', 'OWID_EUR', 'OWID_NAM', 'OWID_OCE', 'OWID_SAM')
          and new_deaths is not null
          group by location
          order by "pct"
        EOQ
      }

      chart {
        width = 4
        title = "Deaths as a % of population by location"
        type  = "donut"
        sql   = <<EOQ
          select
            location,
            round(sum(new_deaths)::numeric / max(population)::numeric * 100, 2) as "pct"
          from covid_data
          where iso_code not in ('OWID_WRL', 'OWID_AFR', 'OWID_ASI', 'OWID_EUR', 'OWID_NAM', 'OWID_OCE', 'OWID_SAM', 'OWID_LIC', 'OWID_LMC', 'OWID_UMC', 'OWID_HIC')
          and new_deaths is not null
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
          and new_deaths is not null
          group by location, iso_code
          order by "pct"
        EOQ
      }

      text {
        value = "Note: small values for Africa/Asia and Low income/Lower middle income likely reflect underreporting."
      }

    }
  }

  container {

    container {
      chart {
        width = 4
        title = "People fully vaccinated as a % of population by continent"
        type  = "donut"
        sql   = <<EOQ
          select
            location,
            round((max(people_fully_vaccinated)::numeric / max(population)::numeric) * 100, 2) as "pct"
          from covid_data
          where iso_code in ('OWID_AFR', 'OWID_ASI', 'OWID_EUR', 'OWID_NAM', 'OWID_OCE', 'OWID_SAM')
          and people_fully_vaccinated is not null
          group by location
          order by "pct"
        EOQ
      }

      chart {
        width = 4
        title = "People fully vaccinated as a % of population by location"
        type  = "donut"
        sql   = <<EOQ
          select
            location,
            round((max(people_fully_vaccinated)::numeric / max(population)::numeric) * 100, 2) as "pct"
          from covid_data
          where iso_code not in ('OWID_AFR', 'OWID_ASI', 'OWID_EUR', 'OWID_NAM', 'OWID_OCE', 'OWID_SAM', 'OWID_LIC', 'OWID_LMC', 'OWID_UMC', 'OWID_HIC')
          and people_fully_vaccinated is not null
          group by location
          order by "pct"
        EOQ
      }

      chart {
        width = 4
        title = "People fully vaccinated as a % of population by income"
        type  = "donut"
        sql   = <<EOQ
          select
            location,
            round((max(people_fully_vaccinated)::numeric / max(population)::numeric) * 100, 2) as "pct"
          from covid_data
          where iso_code in ('OWID_LIC', 'OWID_LMC', 'OWID_UMC', 'OWID_HIC')
          and people_fully_vaccinated is not null
          group by location, iso_code
          order by "pct"
        EOQ
      }

    }

  }  

  container {
    
    container {
      title = "Locations"
      width = 4

      input "locations" {
        base = input.locations
      }

      table {
        width = 8
        type  = "line"
        query = query.by_iso_code
        args  = [self.input.locations.value]
      }


    }

    container {
      title = "Continents"
      width = 4

      input "continents" {
        base = input.continents
      }

      table {
        width = 8
        type  = "line"
        query = query.by_iso_code
        args  = [self.input.continents.value]
      }

    }

    container {
      title = "Income"
      width = 4

      input "income" {
        base = input.income
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

  }

  container {
    title = "About the data"

    container {
      width = 4
      title = "Locations"
      table "locations" {
        query = query.locations
      }
    }

    container {
      width = 3
      title = "All available columns"

      table "columns" {
        sql   = <<EOQ
          select distinct column_name
          from information_schema.columns
          where table_name  = 'covid_data' and column_name != '_ctx'
          order by column_name
        EOQ
      }

    }
   

    container {
      title = "Most recent data by location, oldest to newest"
      width = 4

        table {
          sql = <<EOQ
            select to_char(max(date), 'YYYY-MM-DD') as date, location || '( ' || iso_code || ')' as location
            from covid_data 
            group by iso_code, location
            order by date, iso_code
          EOQ

        }
    }

  }

}



query  "locations" {
  sql = <<EOQ
    select distinct continent, location, iso_code
    from covid_data
    order by iso_code

  EOQ
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
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

input "columns" {
  sql   = <<EOQ
    select column_name as label, column_name as value
    from information_schema.columns
    where table_name  = 'covid_data'
    order by column_name
  EOQ
}

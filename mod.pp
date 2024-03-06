mod "covid19" {
  title         = "Covid19"
  description   = "Visualize COVID-19 vaccinations, healthcare capacity, regional trends, and more using Powerpipe and PostgreSQL."
  documentation = file("./docs/index.md")
  color         = "#72A945"
  icon          = "/images/mods/turbot/covid19-insights.svg"
  documentation = file("./README.md")
  categories    = ["dashboard", "postgres"]

  opengraph {
    title       = "Powerpipe Mod for Covid19"
    description = "Visualize COVID-19 vaccinations, healthcare capacity, regional trends, and more using Powerpipe and PostgreSQL."
    image       = "/images/mods/turbot/covid19-insights-social-graphic.png"
  }
}

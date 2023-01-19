library(dplyr)
library(purrr)

## TODO how to add github button on each readme website so user can follow github link based on geomarker.io URLs?

repos <- list(
  resources = c(
    "geomarkers"
  ),
  tdr_repos = c(
    "hh_acs_measures",
    "harmonized_historical_census_data",
    "tract_indices",
    "dep_index",
    "hamilton_parcels",
    "hamilton_landcover",
    "hamilton_drivetime"
  ),
  spatial_data_repos = c(
    "crime_incidents",
    "shotspotter",
    ## "housing_infractions",
    "st_pm_hex",
    "zcta_to_h3"
    ),
  ## dashboards = c(
  ##   "odh_predicting_lead_risk",
  ##   "covid_testing_locations",
  ##   "covid_resource_access",
  ##   "pm_cv_accuracy",
  ##   "riseup_dashboard",
  ##   "community_table_dashboard",
  ##   "safe_dasbhoard"
  ##   ),
  tools = c(
    "zctaDB",
    "hamilton",
    "tidydlnm", # live somewhere else?
    "s3",
    ## "dht", # ?
    "CODECtools"
  )
)

repos_md <-
  repos |>
  tibble::enframe(name = "type", value = "repo") |>
  tidyr::unnest(cols = c(repo)) |>
  rowwise() |>
  mutate(gh_info = list(gh::gh("GET /repos/geomarker-io/{repo}", repo = repo))) |>
  mutate(gh_info = list(gh_info[c("name", "html_url", "description", "homepage")])) |>
  tidyr::unnest(cols = c(gh_info)) |>
  mutate(gh_info_name = names(gh_info)) |>
  tidyr::unnest(cols = c(gh_info)) |>
  tidyr::pivot_wider(names_from = gh_info_name, values_from = gh_info)

repos_md

glue::glue("[{repo}]({html_url}): {description}", .envir = repos_md) |>
  cat(file = "geomarker-io_resources.md", sep = "\n\n")

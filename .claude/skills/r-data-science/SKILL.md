---
name: r-data-science
description: R-first data science and statistical analysis with SQL as secondary language. Use when the user asks to analyze data in R, write R scripts, create tidyverse pipelines, build statistical models, work with time series (fable/tsibble), run machine learning workflows (tidymodels), query databases from R (DuckDB, dbplyr), build reproducible pipelines (targets), or parallelize computations (crew/mirai). Triggers on R, tidyverse, dplyr, ggplot2, targets, tidymodels, DuckDB, time series forecasting, or statistical modeling requests.
---

# R Data Science Skill

R-first data science workflows emphasizing tidyverse idioms, functional programming, and reproducible research.

## Core Principles

1. **Tidyverse-first**: Prefer tidyverse solutions; use data.table or base R when performance requires
2. **Pipelines over scripts**: Use `|>` (native pipe) for clarity; `%>%` acceptable in existing codebases
3. **Functional style**: Leverage purrr for iteration; avoid explicit loops
4. **Lazy evaluation**: Use DuckDB/dbplyr to push computation to the database
5. **Reproducibility**: Structure projects with targets for pipeline orchestration

## Quick Reference

### Data Import/Export
```r
# CSV (readr - tidyverse)
df <- read_csv("data.csv", col_types = cols())

# Parquet (arrow)
df <- arrow::read_parquet("data.parquet")

# Excel
df <- readxl::read_excel("data.xlsx", sheet = 1)
```

### Data Manipulation (dplyr + tidyr)
```r
result <- df |>
  filter(status == "active") |>
  mutate(rate = value / total) |>
  group_by(category) |>
  summarise(
    n = n(),
    mean_rate = mean(rate, na.rm = TRUE),
    .groups = "drop"
  ) |>
  arrange(desc(mean_rate))

# Pivoting
wide <- df |> pivot_wider(names_from = year, values_from = value)
long <- df |> pivot_longer(cols = -id, names_to = "year", values_to = "value")
```

### Iteration (purrr)
```r
# Map over list
results <- map(file_list, read_csv)

# Map with type safety
means <- map_dbl(df_list, \(x) mean(x$value, na.rm = TRUE))

# Row-wise operations
df |> mutate(result = pmap_dbl(list(a, b, c), \(a, b, c) a + b * c))
```

## Database Workflows

### DuckDB (Preferred for Local Analytics)
```r
library(duckdb)
library(dplyr)

con <- dbConnect(duckdb())

# Register data frame as virtual table
duckdb_register(con, "my_table", df)

# Query with SQL
result <- dbGetQuery(con, "SELECT * FROM my_table WHERE value > 100")

# Or use dplyr
tbl(con, "my_table") |>

  filter(value > 100) |>
  collect()

dbDisconnect(con, shutdown = TRUE)
```

### duckdplyr (Zero-Copy DuckDB Backend)
```r
library(duckdblyr)

# Automatically uses DuckDB for supported operations
df |>
  filter(value > 100) |>
  summarise(total = sum(value))
```

### dbplyr (Remote Databases)
```r
library(dbplyr)

con <- DBI::dbConnect(RPostgres::Postgres(), ...)
remote_tbl <- tbl(con, "schema.table_name")

# Build query lazily
query <- remote_tbl |>
  filter(date >= "2024-01-01") |>
  group_by(region) |>
  summarise(revenue = sum(amount))

# View generated SQL
show_query(query)

# Execute and retrieve
local_df <- collect(query)
```

## Detailed References

Load these as needed based on the task:

- **Time series analysis** (fable, tsibble, feasts): See [references/time-series.md](references/time-series.md)
- **Machine learning** (tidymodels): See [references/tidymodels.md](references/tidymodels.md)
- **Pipeline orchestration** (targets): See [references/targets.md](references/targets.md)
- **Parallel computing** (crew, mirai): See [references/parallel.md](references/parallel.md)
- **Visualization** (ggplot2, coefplot): See [references/visualization.md](references/visualization.md)
- **Performance patterns** (data.table, vectorization): See [references/performance.md](references/performance.md)

## Project Structure

Standard layout for targets-based projects:

```
project/
├── _targets.R          # Pipeline definition
├── R/
│   ├── functions.R     # Reusable functions
│   └── plots.R         # Visualization functions
├── data-raw/           # Original data (gitignored if large)
├── data/               # Processed data
├── output/             # Reports, figures
└── renv.lock           # Dependency lockfile
```

## Code Style

- Use tidyverse style guide conventions
- Explicit `library()` calls at script top; avoid `require()`
- Prefer named arguments for clarity: `mean(x, na.rm = TRUE)` not `mean(x, T)`
- Document functions with roxygen2 comments when writing packages
- Use `stopifnot()` or `cli::cli_abort()` for assertions

# Performance Patterns

## Contents
1. [When to Optimize](#when-to-optimize)
2. [data.table Fundamentals](#datatable-fundamentals)
3. [Vectorization](#vectorization)
4. [Memory Management](#memory-management)
5. [Profiling](#profiling)

---

## When to Optimize

Use tidyverse by default. Consider data.table when:
- Data exceeds ~1M rows
- Operations are in hot loops
- Memory is constrained
- Speed is critical (production pipelines)

Consider DuckDB when:
- Data exceeds memory
- SQL operations suffice
- Reading from Parquet/CSV directly

---

## data.table Fundamentals

### Basic Syntax
```r
library(data.table)

# Convert
dt <- as.data.table(df)
dt <- setDT(df)  # In-place, no copy

# Basic form: DT[i, j, by]
# i = row filter
# j = select/compute columns
# by = grouping
```

### Filtering and Selection
```r
# Filter rows
dt[status == "active"]
dt[value > 100 & category == "A"]

# Select columns
dt[, .(col1, col2)]
dt[, c("col1", "col2"), with = FALSE]

# Combined
dt[status == "active", .(id, value)]
```

### Aggregation
```r
# Group by
dt[, .(
  n = .N,
  mean_val = mean(value),
  sum_val = sum(value)
), by = category]

# Multiple grouping columns
dt[, .(total = sum(value)), by = .(region, year)]

# With filtering
dt[status == "active", .(mean = mean(value)), by = category]
```

### Modification by Reference
```r
# Add/modify columns (no copy!)
dt[, new_col := value * 2]
dt[, c("a", "b") := .(x + 1, y + 2)]

# Conditional update
dt[value > 100, flag := TRUE]

# Remove columns
dt[, old_col := NULL]
```

### Keys and Joins
```r
# Set key for fast lookups
setkey(dt, id)
dt[.(123)]  # Fast lookup by key

# Joins
setkey(dt1, id)
setkey(dt2, id)

# Inner join
dt1[dt2, nomatch = 0]

# Left join
dt2[dt1]

# Non-equi join
dt1[dt2, on = .(date >= start_date, date <= end_date)]
```

### Chaining
```r
dt[status == "active"
  ][, .(total = sum(value)), by = category
  ][order(-total)
  ][1:10]
```

### Special Symbols
```r
.N          # Number of rows in group
.SD         # Subset of data (all columns except by)
.SDcols     # Specify which columns in .SD
.I          # Row indices
.GRP        # Group number
.BY         # List of by values

# Example: apply function to multiple columns
dt[, lapply(.SD, mean), by = group, .SDcols = c("a", "b", "c")]
```

---

## Vectorization

### Avoid Loops
```r
# BAD: Row-wise loop
for (i in 1:nrow(df)) {
  df$result[i] <- df$a[i] + df$b[i]
}

# GOOD: Vectorized
df$result <- df$a + df$b

# GOOD: dplyr
df |> mutate(result = a + b)

# GOOD: data.table
dt[, result := a + b]
```

### Conditional Logic
```r
# BAD: Loop with if
for (i in 1:nrow(df)) {
  if (df$value[i] > 100) {
    df$category[i] <- "high"
  } else {
    df$category[i] <- "low"
  }
}

# GOOD: Vectorized
df$category <- ifelse(df$value > 100, "high", "low")

# GOOD: dplyr
df |> mutate(category = if_else(value > 100, "high", "low"))

# GOOD: Multiple conditions
df |> mutate(category = case_when(
  value > 100 ~ "high",
  value > 50 ~ "medium",
  TRUE ~ "low"
))

# GOOD: data.table
dt[, category := fifelse(value > 100, "high", "low")]
dt[, category := fcase(
  value > 100, "high",
  value > 50, "medium",
  default = "low"
)]
```

### Apply Family vs purrr
```r
# Base R apply (matrices)
apply(mat, 1, sum)  # Row sums
apply(mat, 2, sum)  # Column sums

# vapply (type-safe)
vapply(list_of_vecs, mean, numeric(1))

# purrr (tidyverse, readable)
map_dbl(list_of_vecs, mean)

# For data frames, prefer dplyr
df |> summarise(across(everything(), mean))
```

---

## Memory Management

### Avoid Copies
```r
# BAD: Creates copies
df <- df |> mutate(x = x + 1)

# GOOD: data.table modifies in place
dt[, x := x + 1]

# Check copies
tracemem(df)
df <- transform(df, y = x + 1)  # Shows copy
```

### Read Efficiently
```r
# Specify column types upfront
df <- read_csv("data.csv", col_types = cols(
  id = col_integer(),
  value = col_double(),
  date = col_date()
))

# Read only needed columns
df <- read_csv("data.csv", col_select = c(id, value))

# data.table fread (often faster)
dt <- fread("data.csv", select = c("id", "value"))
```

### Use Appropriate Types
```r
# Integers instead of doubles where possible
df$count <- as.integer(df$count)

# Factors for low-cardinality strings
df$category <- as.factor(df$category)

# Check sizes
object.size(df)
lobstr::obj_size(df)
```

### Chunked Processing
```r
# Process large files in chunks
library(readr)

callback <- function(chunk, pos) {
  # Process chunk
  result <- chunk |> filter(value > 100) |> summarise(n = n())
  return(result)
}

results <- read_csv_chunked(
  "huge_file.csv",
  callback = DataFrameCallback$new(callback),
  chunk_size = 100000
)
```

### DuckDB for Out-of-Memory
```r
library(duckdb)

con <- dbConnect(duckdb())

# Query Parquet directly without loading
result <- dbGetQuery(con, "
  SELECT category, SUM(value) as total
  FROM read_parquet('huge_data/*.parquet')
  GROUP BY category
")
```

---

## Profiling

### Timing
```r
# Simple timing
system.time({
  result <- expensive_operation(data)
})

# Microbenchmark for comparisons
library(microbenchmark)
microbenchmark(
  dplyr = df |> group_by(cat) |> summarise(m = mean(x)),
  dt = dt[, .(m = mean(x)), by = cat],
  times = 100
)

# bench package (includes memory)
library(bench)
bench::mark(
  dplyr = df |> group_by(cat) |> summarise(m = mean(x)),
  dt = dt[, .(m = mean(x)), by = cat],
  check = FALSE
)
```

### Profiling
```r
# Base R profiler
Rprof("profile.out")
result <- my_function(data)
Rprof(NULL)
summaryRprof("profile.out")

# profvis (visual)
library(profvis)
profvis({
  result <- my_function(data)
})
```

### Memory Profiling
```r
# Track allocations
library(profmem)
p <- profmem({
  result <- my_function(data)
})
print(p)
total(p)  # Total bytes allocated
```

---

## Quick Reference: Choosing the Right Tool

| Scenario | Recommendation |
|----------|----------------|
| Interactive analysis, <1M rows | dplyr/tidyverse |
| Production pipeline, >1M rows | data.table |
| Data larger than RAM | DuckDB |
| Complex SQL-like queries | DuckDB or dbplyr |
| Need both R and SQL teams | DuckDB (SQL interface) |
| Parquet/Arrow files | arrow + dplyr or DuckDB |
| Real-time/streaming | data.table |

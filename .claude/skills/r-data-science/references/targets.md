# Pipeline Orchestration with targets

## Contents
1. [Core Concepts](#core-concepts)
2. [Basic Setup](#basic-setup)
3. [Target Types](#target-types)
4. [Dynamic Branching](#dynamic-branching)
5. [Parallel Execution](#parallel-execution)
6. [Best Practices](#best-practices)

---

## Core Concepts

targets is a Make-like pipeline tool for R that:
- Skips targets that are already up-to-date
- Tracks dependencies automatically via static code analysis
- Enables reproducible, auditable workflows

Key ideas:
- **Target**: A single cached output (R object, file, etc.)
- **Pipeline**: The directed acyclic graph (DAG) of targets
- **Branching**: Creating multiple targets from a pattern

---

## Basic Setup

### _targets.R Structure
```r
# _targets.R
library(targets)

# Source functions
tar_source("R/")  # Loads all .R files in R/

# Set options
tar_option_set(
  packages = c("dplyr", "readr", "ggplot2"),
  format = "qs"  # Fast serialization
)

# Define pipeline
list(
  # Data ingestion
  tar_target(raw_data_file, "data-raw/input.csv", format = "file"),
  tar_target(raw_data, read_csv(raw_data_file)),
  
  # Processing
  tar_target(clean_data, clean_data_fn(raw_data)),
  tar_target(model_data, prepare_features(clean_data)),
  
  # Modeling
  tar_target(model, fit_model(model_data)),
  
  # Output
  tar_target(report, render_report(model, clean_data), format = "file")
)
```

### Common Commands
```r
# Visualize pipeline
tar_visnetwork()
tar_manifest()

# Run pipeline
tar_make()
tar_make_future()  # Parallel

# Read targets
tar_read(clean_data)
tar_load(c(model, clean_data))

# Check status
tar_progress()
tar_outdated()

# Debugging
tar_invalidate(clean_data)  # Force re-run
tar_destroy()               # Clear all targets
```

---

## Target Types

### Standard Targets
```r
tar_target(result, my_function(input))
```

### File Targets
```r
# Track external files (re-run if file changes)
tar_target(data_file, "data/input.csv", format = "file")

# Output files
tar_target(
  plot_file,
  {
    ggsave("output/plot.png", my_plot)
    "output/plot.png"
  },
  format = "file"
)
```

### Grouped Targets
```r
# Return grouped data frame for downstream branching
tar_target(
  grouped_data,
  clean_data |> group_by(region) |> tar_group(),
  iteration = "group"
)
```

---

## Dynamic Branching

### Pattern Types
```r
# Map: one branch per element
tar_target(
  model_by_region,
  fit_model(grouped_data),
  pattern = map(grouped_data)
)

# Cross: all combinations
tar_target(
  results,
  run_simulation(param_a, param_b),
  pattern = cross(param_a, param_b)
)

# Combine branches back to single target
tar_target(
  combined_results,
  bind_rows(model_by_region)
)
```

### Branching Over Values
```r
list(
  tar_target(regions, unique(data$region)),
  tar_target(
    region_model,
    fit_model(data |> filter(region == regions)),
    pattern = map(regions)
  )
)
```

### Branching Over Files
```r
list(
  tar_target(
    input_files,
    list.files("data-raw", pattern = "\\.csv$", full.names = TRUE),
    format = "file"
  ),
  tar_target(
    processed,
    process_file(input_files),
    pattern = map(input_files),
    format = "qs"
  )
)
```

---

## Parallel Execution

### With crew (Recommended)
```r
# _targets.R
library(targets)
library(crew)

tar_option_set(
  controller = crew_controller_local(workers = 4)
)

list(
  # targets...
)
```

Run with:
```r
tar_make()  # Automatically uses crew
```

### With crew.cluster (HPC)
```r
library(crew.cluster)

tar_option_set(
  controller = crew_controller_slurm(
    workers = 10,
    seconds_idle = 60,
    slurm_memory_gigabytes_per_cpu = 4
  )
)
```

### With future (Legacy)
```r
# _targets.R
library(future)
library(future.callr)
plan(callr, workers = 4)

# Run
tar_make_future(workers = 4)
```

---

## Best Practices

### Function Organization
```r
# R/functions.R - Define functions, NOT targets
clean_data_fn <- function(raw) {
  raw |>
    filter(!is.na(value)) |>
    mutate(date = as.Date(date))
}

# _targets.R - Use functions in targets
tar_target(clean_data, clean_data_fn(raw_data))
```

### Avoid Side Effects in Functions
```r
# BAD: Reads file inside function (targets can't track)
process <- function() {
  read_csv("data.csv") |> mutate(x = x + 1)
}

# GOOD: Pass file as target
tar_target(file, "data.csv", format = "file")
tar_target(data, read_csv(file))
tar_target(processed, mutate(data, x = x + 1))
```

### Granularity Guidelines
- One target per major transformation step
- Avoid mega-targets that do too much
- Avoid micro-targets for trivial operations
- Group related small operations

### Storage Formats
```r
tar_option_set(
  format = "qs"          # Default: fast, compressed
)

# Per-target overrides
tar_target(big_data, ..., format = "feather")  # Arrow format
tar_target(model, ..., format = "rds")         # Standard R
tar_target(output, ..., format = "file")       # External files
```

### Reproducibility
```r
# Use renv for package management
# Include renv.lock in version control

# Set seeds for stochastic targets
tar_target(
  bootstrap_results,
  {
    set.seed(123)
    run_bootstrap(data)
  }
)
```

---

## Example: Full ML Pipeline

```r
# _targets.R
library(targets)
library(crew)

tar_source("R/")

tar_option_set(
  packages = c("tidyverse", "tidymodels"),
  controller = crew_controller_local(workers = 4),
  format = "qs"
)

list(
  # Data
  tar_target(raw_file, "data-raw/train.csv", format = "file"),
  tar_target(raw_data, read_csv(raw_file)),
  tar_target(clean_data, clean_data_fn(raw_data)),
  
  # Split
  tar_target(splits, initial_split(clean_data, prop = 0.8, strata = outcome)),
  tar_target(train, training(splits)),
  tar_target(test, testing(splits)),
  tar_target(folds, vfold_cv(train, v = 5, strata = outcome)),
  
  # Preprocessing
  tar_target(recipe, create_recipe(train)),
  
  # Models to compare
  tar_target(
    model_specs,
    list(
      glm = logistic_reg() |> set_engine("glm"),
      rf = rand_forest(trees = 500) |> set_engine("ranger") |> set_mode("classification")
    )
  ),
  
  # Fit each model
  tar_target(
    cv_results,
    fit_and_evaluate(recipe, model_specs, folds),
    pattern = map(model_specs)
  ),
  
  # Select best
  tar_target(best_model, select_best_model(cv_results)),
  tar_target(final_fit, fit_final(best_model, recipe, splits)),
  
  # Output
  tar_target(
    metrics_file,
    {
      write_csv(collect_metrics(final_fit), "output/metrics.csv")
      "output/metrics.csv"
    },
    format = "file"
  )
)
```

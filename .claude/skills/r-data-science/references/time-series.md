# Time Series Analysis

## Contents
1. [tsibble: Tidy Temporal Data](#tsibble-tidy-temporal-data)
2. [feasts: Feature Extraction and Statistics](#feasts-feature-extraction-and-statistics)
3. [fable: Forecasting](#fable-forecasting)
4. [Common Patterns](#common-patterns)

---

## tsibble: Tidy Temporal Data

tsibble provides the foundational data structure for tidy time series.

### Creating tsibbles
```r
library(tsibble)

# From data frame (must specify index and optional key)
ts_data <- df |>
  as_tsibble(index = date, key = c(region, product))

# Regular time index
ts_data <- df |>
  as_tsibble(index = yearmonth(date), key = store_id)

# Check regularity
has_gaps(ts_data)
scan_gaps(ts_data)
fill_gaps(ts_data, value = 0)
```

### Index Types
```r
# Daily
as_tsibble(df, index = date)

# Weekly (week starting Monday)
as_tsibble(df, index = yearweek(date))

# Monthly
as_tsibble(df, index = yearmonth(date))

# Quarterly
as_tsibble(df, index = yearquarter(date))

# Yearly
as_tsibble(df, index = year(date))
```

### Temporal Operations
```r
# Lag/lead within groups
ts_data |>
  group_by_key() |>
  mutate(
    value_lag1 = lag(value, 1),
    value_diff = difference(value, 1)
  )

# Rolling windows
ts_data |>
  group_by_key() |>
  mutate(
    ma_7 = slider::slide_dbl(value, mean, .before = 6, .complete = TRUE)
  )
```

---

## feasts: Feature Extraction and Statistics

feasts provides tools for exploring and understanding time series.

### Visual Diagnostics
```r
library(feasts)

# Seasonal plots
ts_data |> gg_season(value)
ts_data |> gg_subseries(value)

# Autocorrelation
ts_data |> ACF(value) |> autoplot()
ts_data |> PACF(value) |> autoplot()

# Lag plots
ts_data |> gg_lag(value, lags = 1:12)

# STL decomposition plot
ts_data |>
  model(STL(value)) |>
  components() |>
  autoplot()
```

### Feature Extraction
```r
# Extract statistical features
features <- ts_data |>
  features(value, feature_set(pkgs = "feasts"))

# Specific feature sets
ts_data |> features(value, feat_stl)        # STL features
ts_data |> features(value, feat_acf)        # ACF features
ts_data |> features(value, feat_spectral)   # Spectral entropy
ts_data |> features(value, guerrero)        # Box-Cox lambda

# Custom features
ts_data |>
  features(value, list(
    mean = mean,
    sd = sd,
    cv = \(x) sd(x) / mean(x)
  ))
```

### Decomposition
```r
# STL decomposition
decomp <- ts_data |>
  model(STL(value ~ season(window = "periodic"))) |>
  components()

# Classical decomposition
decomp <- ts_data |>
  model(classical_decomposition(value, type = "multiplicative")) |>
  components()
```

---

## fable: Forecasting

fable provides a tidy interface to forecasting models.

### Model Specification
```r
library(fable)

# Fit multiple models
fit <- ts_data |>
  model(
    ets = ETS(value),
    arima = ARIMA(value),
    snaive = SNAIVE(value),
    prophet = fable.prophet::prophet(value)
  )

# Model with regressors
fit <- ts_data |>
  model(
    arima_xreg = ARIMA(value ~ trend() + season() + temperature)
  )
```

### Common Models
```r
# ETS (Exponential Smoothing)
ETS(value)                              # Automatic selection
ETS(value ~ error("A") + trend("A"))    # Holt's linear
ETS(value ~ error("M") + trend("A") + season("M"))  # Multiplicative seasonal

# ARIMA
ARIMA(value)                            # Automatic selection
ARIMA(value ~ pdq(1,1,1) + PDQ(1,1,1))  # Specified orders
ARIMA(value ~ xreg + pdq(d = 1))        # With regressor, fixed differencing

# Baseline models
MEAN(value)           # Mean forecast
NAIVE(value)          # Random walk
SNAIVE(value)         # Seasonal naive
RW(value ~ drift())   # Random walk with drift

# Regression
TSLM(value ~ trend() + season())  # Time series linear model
```

### Forecasting
```r
# Generate forecasts
fc <- fit |> forecast(h = "12 months")
fc <- fit |> forecast(h = 12)
fc <- fit |> forecast(new_data = future_data)

# Plot forecasts
fc |> autoplot(ts_data, level = c(80, 95))

# Extract point forecasts and intervals
fc |>
  hilo(level = 95) |>
  unpack_hilo(`95%`)
```

### Model Evaluation
```r
# In-sample accuracy
accuracy(fit)

# Cross-validation
cv_results <- ts_data |>
  stretch_tsibble(.init = 36, .step = 1) |>
  model(
    ets = ETS(value),
    arima = ARIMA(value)
  ) |>
  forecast(h = 3) |>
  accuracy(ts_data)

# Residual diagnostics
fit |>
  select(arima) |>
  gg_tsresiduals()

# Ljung-Box test
augment(fit) |>
  features(.innov, ljung_box, lag = 24)
```

### Model Selection
```r
# Compare models by AICc
glance(fit) |>
  arrange(AICc)

# Best model per series
fit |>
  select_best(metric = "AICc")
```

---

## Common Patterns

### Full Workflow Example
```r
library(tsibble)
library(feasts)
library(fable)

# 1. Prepare data
ts_data <- raw_df |>
  mutate(month = yearmonth(date)) |>
  as_tsibble(index = month, key = product_id)

# 2. Explore
ts_data |> autoplot(sales)
ts_data |> gg_season(sales)
ts_data |> features(sales, feat_stl)

# 3. Model
fit <- ts_data |>
  model(
    ets = ETS(sales),
    arima = ARIMA(sales),
    snaive = SNAIVE(sales)
  )

# 4. Evaluate
accuracy(fit) |>
  group_by(.model) |>
  summarise(across(c(RMSE, MAE, MAPE), mean))

# 5. Forecast with best model
fc <- fit |>
  select(arima) |>
  forecast(h = "6 months")

# 6. Visualize
fc |> autoplot(ts_data |> filter_index("2023" ~ .))
```

### Hierarchical Forecasting
```r
library(fable)

# Aggregate structure
agg_data <- ts_data |>
  aggregate_key(region / store, sales = sum(sales))

# Reconciled forecasts
fit <- agg_data |>
  model(ets = ETS(sales)) |>
  reconcile(
    ets_bu = bottom_up(ets),
    ets_mint = min_trace(ets, method = "mint_shrink")
  )

fc <- fit |> forecast(h = 12)
```

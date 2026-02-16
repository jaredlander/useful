# Machine Learning with tidymodels

## Contents
1. [Core Workflow](#core-workflow)
2. [Preprocessing (recipes)](#preprocessing-recipes)
3. [Model Specifications (parsnip)](#model-specifications-parsnip)
4. [Resampling (rsample)](#resampling-rsample)
5. [Tuning (tune)](#tuning-tune)
6. [Workflows](#workflows)
7. [Model Evaluation (yardstick)](#model-evaluation-yardstick)

---

## Core Workflow

```r
library(tidymodels)

# 1. Split data
set.seed(123)
splits <- initial_split(df, prop = 0.8, strata = outcome)
train <- training(splits)
test <- testing(splits)

# 2. Create recipe
rec <- recipe(outcome ~ ., data = train) |>
  step_normalize(all_numeric_predictors()) |>
  step_dummy(all_nominal_predictors())

# 3. Specify model
spec <- rand_forest(trees = 500) |>
  set_engine("ranger") |>
  set_mode("classification")

# 4. Create workflow
wf <- workflow() |>
  add_recipe(rec) |>
  add_model(spec)

# 5. Fit
fit <- wf |> fit(train)

# 6. Predict
preds <- predict(fit, test) |>
  bind_cols(test |> select(outcome))

# 7. Evaluate
metrics(preds, truth = outcome, estimate = .pred_class)
```

---

## Preprocessing (recipes)

### Common Steps
```r
rec <- recipe(outcome ~ ., data = train) |>
  # Missing values
  step_impute_median(all_numeric_predictors()) |>
  step_impute_mode(all_nominal_predictors()) |>
  

  # Numeric transformations
  step_log(skewed_var, offset = 1) |>
  step_normalize(all_numeric_predictors()) |>
  step_YeoJohnson(all_numeric_predictors()) |>
  
  # Categorical encoding
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |>
  step_other(category, threshold = 0.05) |>
  step_novel(all_nominal_predictors()) |>
  
  # Feature engineering
  step_interact(~ var1:var2) |>
  step_poly(continuous_var, degree = 2) |>
  step_date(date_col, features = c("dow", "month", "year")) |>
  
  # Dimensionality reduction
  step_pca(all_numeric_predictors(), num_comp = 5) |>
  
  # Feature selection
  step_zv(all_predictors()) |>
  step_corr(all_numeric_predictors(), threshold = 0.9) |>
  step_nzv(all_predictors())
```

### Role Assignment
```r
rec <- recipe(outcome ~ ., data = train) |>
  update_role(id_column, new_role = "id") |>
  step_rm(has_role("id"))
```

### Checking Recipe
```r
# Preview transformations
rec |> prep() |> bake(new_data = NULL) |> glimpse()

# Check specific step
rec |> prep() |> tidy(number = 1)
```

---

## Model Specifications (parsnip)

### Classification
```r
# Logistic regression
logistic_reg() |> set_engine("glm")
logistic_reg(penalty = 0.1, mixture = 1) |> set_engine("glmnet")  # Lasso

# Random forest
rand_forest(trees = 500, mtry = tune(), min_n = tune()) |>
  set_engine("ranger", importance = "impurity") |>
  set_mode("classification")

# XGBoost
boost_tree(trees = 500, tree_depth = tune(), learn_rate = tune()) |>
  set_engine("xgboost") |>
  set_mode("classification")

# SVM
svm_rbf(cost = tune(), rbf_sigma = tune()) |>
  set_engine("kernlab") |>
  set_mode("classification")
```

### Regression
```r
# Linear regression
linear_reg() |> set_engine("lm")
linear_reg(penalty = tune(), mixture = tune()) |> set_engine("glmnet")

# Random forest
rand_forest(trees = 500) |>
  set_engine("ranger") |>
  set_mode("regression")

# XGBoost
boost_tree(trees = 500) |>
  set_engine("xgboost") |>
  set_mode("regression")
```

---

## Resampling (rsample)

```r
# Cross-validation
folds <- vfold_cv(train, v = 10, strata = outcome)
folds <- vfold_cv(train, v = 5, repeats = 3)

# Bootstrap
boots <- bootstraps(train, times = 100)

# Time series
time_folds <- sliding_period(
  train,
  index = date,
  period = "month",
  lookback = 12,
  assess_stop = 3
)

# Grouped CV (keeps groups together)
group_folds <- group_vfold_cv(train, group = patient_id, v = 5)

# Validation set
val_split <- validation_split(train, prop = 0.8, strata = outcome)
```

---

## Tuning (tune)

### Grid Search
```r
# Define tunable model
spec <- rand_forest(mtry = tune(), min_n = tune(), trees = 500) |>
  set_engine("ranger") |>
  set_mode("classification")

wf <- workflow() |>
  add_recipe(rec) |>
  add_model(spec)

# Regular grid
grid <- grid_regular(
  mtry(range = c(2, 10)),
  min_n(range = c(2, 20)),
  levels = 5
)

# Random grid
grid <- grid_random(
  mtry(range = c(2, 10)),
  min_n(range = c(2, 20)),
  size = 20
)

# Tune
tune_results <- wf |>
  tune_grid(
    resamples = folds,
    grid = grid,
    metrics = metric_set(roc_auc, accuracy),
    control = control_grid(save_pred = TRUE)
  )

# View results
autoplot(tune_results)
show_best(tune_results, metric = "roc_auc")
```

### Bayesian Optimization
```r
tune_results <- wf |>
  tune_bayes(
    resamples = folds,
    initial = 10,
    iter = 25,
    metrics = metric_set(roc_auc),
    control = control_bayes(no_improve = 10)
  )
```

### Finalize Model
```r
best_params <- select_best(tune_results, metric = "roc_auc")

final_wf <- wf |>
  finalize_workflow(best_params)

# Final fit on full training set, evaluate on test
final_fit <- final_wf |> last_fit(splits)

# Collect metrics and predictions
collect_metrics(final_fit)
collect_predictions(final_fit)
```

---

## Workflows

### Workflow Sets (Compare Many Models)
```r
library(workflowsets)

# Define preprocessing variants
preproc <- list(
  basic = rec,
  pca = rec |> step_pca(all_numeric_predictors(), num_comp = 5)
)

# Define model variants
models <- list(
  glm = logistic_reg() |> set_engine("glm"),
  rf = rand_forest(trees = 500) |> set_engine("ranger") |> set_mode("classification"),
  xgb = boost_tree(trees = 500) |> set_engine("xgboost") |> set_mode("classification")
)

# Create all combinations
all_workflows <- workflow_set(preproc, models)

# Fit all
results <- all_workflows |>
  workflow_map(
    "fit_resamples",
    resamples = folds,
    metrics = metric_set(roc_auc, accuracy)
  )

# Compare
autoplot(results)
rank_results(results, rank_metric = "roc_auc")
```

---

## Model Evaluation (yardstick)

### Classification Metrics
```r
# Confusion matrix
conf_mat(preds, truth = outcome, estimate = .pred_class)

# Multiple metrics
metrics <- metric_set(accuracy, sens, spec, ppv, npv, f_meas, roc_auc)
metrics(preds, truth = outcome, estimate = .pred_class, .pred_positive)

# ROC curve
roc_curve(preds, truth = outcome, .pred_positive) |> autoplot()

# Precision-recall
pr_curve(preds, truth = outcome, .pred_positive) |> autoplot()

# Calibration
cal_plot_breaks(preds, truth = outcome, .pred_positive)
```

### Regression Metrics
```r
metrics <- metric_set(rmse, mae, rsq, mape)
metrics(preds, truth = outcome, estimate = .pred)
```

### Custom Metrics
```r
# Weighted metrics
preds |>
  metrics(truth = outcome, estimate = .pred_class, case_weights = wt)
```

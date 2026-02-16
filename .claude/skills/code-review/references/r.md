# R Code Review Reference

## Priority Focus
- Tidyverse style and idioms
- Vectorization over loops
- Performance optimization

## Tidyverse Style

### Prefer
```r
# Pipe chains for readability
result <- data %>%
  filter(x > 0) %>%
  mutate(y = x * 2) %>%
  summarize(mean_y = mean(y))

# Explicit column selection
select(data, col1, col2)

# Use across() for multiple columns
mutate(data, across(where(is.numeric), scale))
```

### Avoid
```r
# Nested function calls
summarize(mutate(filter(data, x > 0), y = x * 2), mean_y = mean(y))

# Positional column indices
data[, c(1, 3)]

# Repetitive column operations
mutate(data, col1 = scale(col1), col2 = scale(col2))
```

## Vectorization

### Critical Patterns

**Flag**: Any `for` loop operating on data frame rows
```r
# BAD - row-wise loop
for (i in 1:nrow(df)) {
  df$result[i] <- df$a[i] + df$b[i]
}

# GOOD - vectorized
df$result <- df$a + df$b
```

**Flag**: `apply()` family when vectorized alternative exists
```r
# BAD
sapply(x, function(i) i^2)

# GOOD
x^2
```

**Flag**: Growing vectors in loops
```r
# BAD - grows vector each iteration
result <- c()
for (i in 1:n) {
  result <- c(result, compute(i))
}

# GOOD - pre-allocate
result <- vector("numeric", n)
for (i in 1:n) {
  result[i] <- compute(i)
}

# BETTER - vectorize or use map
result <- map_dbl(1:n, compute)
```

## Performance Checks

### Data Table for Large Data
Flag when processing >100k rows without data.table:
```r
# For large data, suggest data.table
library(data.table)
dt <- as.data.table(df)
dt[x > 0, .(mean_y = mean(y)), by = group]
```

### Avoid Repeated Subsetting
```r
# BAD
mean(df[df$group == "A", ]$value)
sd(df[df$group == "A", ]$value)

# GOOD
group_a <- df[df$group == "A", ]$value
mean(group_a)
sd(group_a)
```

### Use Appropriate Join Functions
```r
# Prefer dplyr joins over merge()
left_join(df1, df2, by = "key")
```

## Common Pitfalls

- `=` vs `<-` for assignment (prefer `<-`)
- Forgetting `stringsAsFactors = FALSE` in older R
- Not handling NA values explicitly
- Using `T`/`F` instead of `TRUE`/`FALSE`
- Relying on partial matching
- Not setting seed for reproducibility

## Documentation Standards

```r
#' Brief description of function
#'
#' @param x Description of x
#' @param y Description of y
#' @return Description of return value
#' @examples
#' my_function(1, 2)
#' @export
my_function <- function(x, y) {
  # Implementation
}
```

## Testing with testthat

```r
test_that("function handles edge cases", {
  expect_equal(my_func(0), expected_value)
  expect_error(my_func(NULL))
  expect_warning(my_func(NA))
})
```

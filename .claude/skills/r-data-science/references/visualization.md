# Visualization

## Contents
1. [ggplot2 Essentials](#ggplot2-essentials)
2. [Common Plot Types](#common-plot-types)
3. [Theming and Customization](#theming-and-customization)
4. [coefplot: Model Coefficients](#coefplot-model-coefficients)
5. [Publication-Ready Figures](#publication-ready-figures)

---

## ggplot2 Essentials

### Grammar of Graphics Pattern
```r
library(ggplot2)

ggplot(data, aes(x = var1, y = var2)) +
  geom_point() +
  labs(title = "Title", x = "X Label", y = "Y Label") +
  theme_minimal()
```

### Aesthetic Mappings
```r
aes(
  x = continuous_var,
  y = response,
  color = group,           # Outline/line color
  fill = group,            # Fill color
  size = weight,           # Point/line size
  shape = category,        # Point shape (max 6 levels)
  linetype = type,         # Line type
  alpha = transparency,    # Transparency (0-1)
  group = id               # Grouping for lines/paths
)
```

### Faceting
```r
# Wrap by single variable
ggplot(data, aes(x, y)) +
  geom_point() +
  facet_wrap(~ category, ncol = 3, scales = "free_y")

# Grid by two variables
ggplot(data, aes(x, y)) +
  geom_point() +
  facet_grid(rows = vars(row_var), cols = vars(col_var))
```

---

## Common Plot Types

### Distributions
```r
# Histogram
ggplot(df, aes(x = value)) +
  geom_histogram(bins = 30, fill = "steelblue", color = "white")

# Density
ggplot(df, aes(x = value, fill = group)) +
  geom_density(alpha = 0.5)

# Box plot
ggplot(df, aes(x = group, y = value)) +
  geom_boxplot()

# Violin + jitter
ggplot(df, aes(x = group, y = value)) +
  geom_violin(fill = "lightgray") +
  geom_jitter(width = 0.1, alpha = 0.3)
```

### Relationships
```r
# Scatter
ggplot(df, aes(x = var1, y = var2)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = TRUE)

# Scatter with marginal distributions
library(ggExtra)
p <- ggplot(df, aes(x = var1, y = var2)) + geom_point()
ggMarginal(p, type = "density")

# Correlation heatmap
library(ggcorrplot)
cor_matrix <- cor(df |> select(where(is.numeric)), use = "complete.obs")
ggcorrplot(cor_matrix, type = "lower", lab = TRUE)
```

### Time Series
```r
# Line plot
ggplot(df, aes(x = date, y = value, color = series)) +
  geom_line() +
  scale_x_date(date_breaks = "1 month", date_labels = "%b %Y")

# Area plot
ggplot(df, aes(x = date, y = value, fill = category)) +
  geom_area(position = "stack")

# Ribbon (confidence intervals)
ggplot(df, aes(x = date, y = mean)) +
  geom_ribbon(aes(ymin = lower, ymax = upper), alpha = 0.3) +
  geom_line()
```

### Categorical
```r
# Bar plot (counts)
ggplot(df, aes(x = category)) +
  geom_bar()

# Bar plot (values)
ggplot(summary_df, aes(x = category, y = value)) +
  geom_col()

# Grouped bars
ggplot(df, aes(x = category, y = value, fill = group)) +
  geom_col(position = "dodge")

# Stacked percentage
ggplot(df, aes(x = category, y = value, fill = group)) +
  geom_col(position = "fill") +
  scale_y_continuous(labels = scales::percent)

# Lollipop
ggplot(df, aes(x = reorder(category, value), y = value)) +
  geom_segment(aes(xend = category, yend = 0)) +
  geom_point(size = 3) +
  coord_flip()
```

---

## Theming and Customization

### Built-in Themes
```r
+ theme_minimal()      # Clean, minimal
+ theme_bw()           # Black and white
+ theme_classic()      # Classic look
+ theme_void()         # Nothing (for maps)
```

### Custom Theme Elements
```r
+ theme(
    # Text
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    axis.title = element_text(size = 11),
    axis.text = element_text(size = 9),
    legend.title = element_text(size = 10),
    
    # Legend
    legend.position = "bottom",  # "none", "left", "right", "top"
    legend.direction = "horizontal",
    
    # Panel
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank(),
    
    # Margins
    plot.margin = margin(10, 10, 10, 10)
  )
```

### Color Scales
```r
# Discrete
+ scale_color_brewer(palette = "Set1")
+ scale_fill_viridis_d()
+ scale_color_manual(values = c("A" = "#E41A1C", "B" = "#377EB8"))

# Continuous
+ scale_fill_viridis_c()
+ scale_color_gradient(low = "white", high = "darkblue")
+ scale_fill_gradient2(low = "blue", mid = "white", high = "red", midpoint = 0)
```

### Axis Scales
```r
# Log scale
+ scale_y_log10()

# Percent
+ scale_y_continuous(labels = scales::percent)

# Currency
+ scale_y_continuous(labels = scales::dollar)

# Comma formatting
+ scale_y_continuous(labels = scales::comma)

# Custom breaks
+ scale_x_continuous(breaks = seq(0, 100, 20), limits = c(0, 100))

# Reverse
+ scale_y_reverse()
```

---

## coefplot: Model Coefficients

### Basic Usage
```r
library(coefplot)

# Fit model
model <- lm(mpg ~ wt + hp + cyl, data = mtcars)

# Plot coefficients
coefplot(model)

# Exclude intercept
coefplot(model, intercept = FALSE)
```

### Customization
```r
coefplot(
  model,
  intercept = FALSE,
  title = "Model Coefficients",
  xlab = "Estimate",
  ylab = "Variable",
  color = "steelblue",
  shape = 16,
  innerCI = 1,      # 1 SE
  outerCI = 2,      # 2 SE
  lwdInner = 1,
  lwdOuter = 0.5
)
```

### Multiple Models
```r
model1 <- lm(mpg ~ wt + hp, data = mtcars)
model2 <- lm(mpg ~ wt + hp + cyl, data = mtcars)

multiplot(model1, model2, intercept = FALSE)

# With custom names
multiplot(
  model1, model2,
  names = c("Base Model", "Full Model"),
  intercept = FALSE
)
```

### GLM Support
```r
logit_model <- glm(am ~ wt + hp, data = mtcars, family = binomial)

# Coefficients on log-odds scale
coefplot(logit_model, intercept = FALSE)

# Transform to odds ratios
coefplot(logit_model, intercept = FALSE, trans = exp)
```

### Extract Data for Custom Plots
```r
library(broom)

# Get tidy coefficient data
coef_data <- tidy(model, conf.int = TRUE) |>
  filter(term != "(Intercept)")

# Custom ggplot
ggplot(coef_data, aes(x = estimate, y = reorder(term, estimate))) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "gray50") +
  geom_errorbarh(aes(xmin = conf.low, xmax = conf.high), height = 0.2) +
  geom_point(size = 3) +
  labs(x = "Estimate", y = NULL, title = "Model Coefficients") +
  theme_minimal()
```

---

## Publication-Ready Figures

### Standard Template
```r
publication_theme <- theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(color = "gray40"),
    axis.title = element_text(size = 11),
    axis.text = element_text(size = 10),
    legend.position = "bottom",
    legend.title = element_text(size = 10),
    panel.grid.minor = element_blank(),
    strip.text = element_text(face = "bold", size = 11)
  )

p <- ggplot(df, aes(x, y)) +
  geom_point() +
  labs(
    title = "Main Title",
    subtitle = "Explanatory subtitle",
    x = "X Axis Label",
    y = "Y Axis Label",
    caption = "Source: Data source"
  ) +
  publication_theme
```

### Saving
```r
# Vector formats (preferred for publication)
ggsave("figure.pdf", p, width = 8, height = 6, units = "in")
ggsave("figure.svg", p, width = 8, height = 6, units = "in")

# Raster (for presentations)
ggsave("figure.png", p, width = 8, height = 6, units = "in", dpi = 300)
```

### Multi-Panel Figures
```r
library(patchwork)

p1 <- ggplot(df, aes(x, y)) + geom_point()
p2 <- ggplot(df, aes(x)) + geom_histogram()
p3 <- ggplot(df, aes(group, y)) + geom_boxplot()

# Combine
(p1 | p2) / p3 +
  plot_annotation(
    title = "Combined Figure",
    tag_levels = "A"  # Adds A, B, C labels
  )
```

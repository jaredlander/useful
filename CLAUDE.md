# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

The `useful` package is a collection of handy R utility functions covering data manipulation, visualization, formatting, and statistical operations. It's designed as a general-purpose toolkit without a single focused domain - functions are added as needed across various use cases.

## Required Workflows

### CRITICAL: Consult Context7 Before Writing/Editing Code

**ALWAYS consult Context7 documentation before writing or editing any R code.** This ensures you're using current best practices and correct syntax for all dependencies.

Before modifying any code that uses:
- **ggplot2**: Query Context7 for ggplot2 documentation and current API
- **dplyr/plyr**: Query Context7 for tidyverse best practices
- **testthat**: Query Context7 for testing patterns and expectations
- **Any other package**: Query Context7 to verify correct usage

Example workflow:
1. Identify which packages/functions you need to work with
2. Use Context7 MCP tools to get current documentation
3. Write code following the retrieved best practices
4. Verify your approach matches current package conventions

### Required Skills

This codebase requires using specific skills for different workflows:

- **r-data-science**: Use this skill when working with R code, especially for:
  - Data manipulation with dplyr/tidyverse
  - ggplot2 visualizations
  - R package development patterns
  - Statistical functions and data analysis

- **code-review**: Use this skill when:
  - A major feature or fix is complete
  - Before creating commits or PRs
  - To ensure code quality and adherence to R package standards
  - To verify roxygen2 documentation is complete and correct

## Development Commands

**Remember: Always consult Context7 before writing or editing code!**

### Building and Checking
```r
# Build package
devtools::build()

# Run R CMD check (standard package validation)
devtools::check()

# Load package for testing during development
devtools::load_all()
```

### Testing
```r
# Run all tests
devtools::test()

# Run tests with coverage
covr::package_coverage()

# Run specific test file
testthat::test_file("tests/testthat/test-formatters.r")
```

### Documentation
```r
# Regenerate documentation from roxygen2 comments
devtools::document()

# Preview documentation for a function
?useful::corner
```

### README
The README.md is generated from README.Rmd - always edit the .Rmd file:
```r
# Regenerate README.md from README.Rmd
rmarkdown::render("README.Rmd")
```

## Package Architecture

### Function Categories

The package is organized by functionality, with each R file typically containing related functions:

- **Data Subsetting** (`corner.r`): View corners of data.frames/matrices (topleft, bottomright, etc.)
- **Formula Building** (`buildFormula.r`, `buildMatrix.r`): Programmatically construct formulas and design matrices
- **Formatting** (`formatters.r`): Number formatters for ggplot2 scales (multiple, multiple.comma, multiple.dollar)
- **K-means Utilities** (`kmeansPlotting.r`, `hartigan.r`): Plotting and diagnostic tools for clustering
- **Time Series** (`tsPlot.r`, `time.single.R`): Time series visualization helpers
- **String Manipulation** (`checkCase.r`, `subspecials.r`, `regex.r`): Case conversion, special character substitution
- **Coordinate Systems** (`coordinates.r`): Cartesian/polar coordinate conversions
- **Column Operations** (`ColumnReorder.r`, `shiftColumn.r`): Move columns, reorder data.frame columns
- **Imputation** (`impute.r`): Simple imputation methods
- **Utilities** (`reclass.r`, `comparisons.r`, `indices.r`, etc.): Various helper functions

### Key Dependencies

- **ggplot2**: Core dependency - many functions integrate with ggplot2 (autoplot methods, scale formatters)
- **dplyr/plyr**: Data manipulation
- **testthat**: Testing framework

### S3 Methods

The package implements several S3 methods:
- `plot.kmeans`, `fortify.kmeans`, `autoplot.acf` - visualization methods
- `corner.*` - multiple dispatch for different data types
- `simple.impute.*` - imputation for data.frames and tibbles

## Testing Conventions

- Test files in `tests/testthat/` follow naming pattern `test-{feature}.r`
- Use standard testthat expectations (`expect_equal`, `expect_error`, etc.)
- Each test file corresponds to a source file in `R/`

## CI/CD

GitHub Actions workflow `.github/workflows/R-CMD-check.yaml` runs R CMD check on:
- Multiple OS: Ubuntu, macOS, Windows
- Multiple R versions: devel, release, oldrel-1

## CRAN Submission

This package is published on CRAN. When preparing updates:
- Update version in `DESCRIPTION`
- Update `NEWS.md` with changes
- Run `devtools::check()` and ensure zero errors, warnings, or notes
- Check `cran-comments.md` for submission notes

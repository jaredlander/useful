context("load-packages")

test_that("Packages load as expected", {
    expect_message(load_packages('ggplot2'), 'ggplot2')
    expect_message(load_packages(c('ggplot2', 'coefplot')), 'ggplot2, coefplot')
})

test_that('Errors are captured', {
    expect_error(load_packages(5), 'packages is not a character vector')
    expect_error(load_packages(c('ggplot2', 'fake1')), 'fake1')
})

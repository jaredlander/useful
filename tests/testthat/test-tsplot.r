context('Test that the functions of TSPlot work properly')

test_that('Plotting functions return a variable of the correct type', {
  expect_is(ts.plotter(airmiles), 'ggplot')
  expect_error(ts.plotter(iris), "'from' must be of length 1")
  
  expect_is(autoplot(acf(airmiles, plot=FALSE)), 'ggplot')
  expect_is(autoplot(acf(iris, plot=FALSE)), 'ggplot')
  expect_is(autoplot(pacf(airmiles, plot=FALSE)), 'ggplot')
  expect_is(autoplot(pacf(iris, plot=FALSE)), 'ggplot')
  expect_is(plotTimesSeries(airmiles), 'ggplot')
  
  expect_error(plotTimesSeries(iris), "'from' must be of length 1")
  expect_error(plotTimesSeries(acf(airmiles, plot=FALSE)), "'from' must be of length 1")
  expect_error(plotTimesSeries(acf(iris, plot=FALSE)), "'from' must be of length 1")
  expect_error(plotTimesSeries(pacf(airmiles, plot=FALSE)), "'from' must be of length 1")
  expect_error(plotTimesSeries(pacf(iris, plot=FALSE)), "'from' must be of length 1")
})

test_that('plot.acf is deprecated and retuns the right type of object', {
    expect_warning(plot.acf(acf(airmiles, plot=FALSE)))
    expect_warning(plot.acf(acf(iris, plot=FALSE)))
    expect_warning(plot.acf(pacf(airmiles, plot=FALSE)))
    expect_warning(plot.acf(pacf(iris, plot=FALSE)))
    
    expect_is(suppressWarnings(plot.acf(acf(airmiles, plot=FALSE))), 'ggplot')
    expect_is(suppressWarnings(plot.acf(acf(iris, plot=FALSE))), 'ggplot')
    expect_is(suppressWarnings(plot.acf(pacf(airmiles, plot=FALSE))), 'ggplot')
    expect_is(suppressWarnings(plot.acf(pacf(iris, plot=FALSE))), 'ggplot')
})

test_that('fortify returns the correct object', {
    expect_is(fortify(airmiles), 'data.frame')
    expect_is(fortify(iris), 'data.frame')
    
    expect_is(fortify.acf(acf(airmiles, plot=FALSE)), 'data.frame')
    expect_is(fortify.acf(acf(iris, plot=FALSE)), 'data.frame')
    expect_is(fortify.acf(pacf(airmiles, plot=FALSE)), 'data.frame')
    expect_is(fortify.acf(pacf(iris, plot=FALSE)), 'data.frame')
    
    expect_is(fortify(acf(airmiles, plot=FALSE)), 'data.frame')
    expect_is(fortify(acf(iris, plot=FALSE)), 'data.frame')
    expect_is(fortify(pacf(airmiles, plot=FALSE)), 'data.frame')
    expect_is(fortify(pacf(iris, plot=FALSE)), 'data.frame')
})

test_that('Each variable is of correct length', {
  expect_equal(nrow(fortify(airmiles)), length(airmiles))
  expect_equal(nrow(fortify(iris)), nrow(iris))
  expect_equal(nrow(fortify.acf(acf(airmiles, plot=FALSE))), nrow(acf(airmiles, plot=FALSE)$acf))
  expect_equal(nrow(fortify.acf(acf(iris, plot=FALSE))), nrow(acf(iris, plot=FALSE)$acf))
  expect_equal(nrow(fortify.acf(pacf(airmiles, plot=FALSE))), nrow(pacf(airmiles, plot=FALSE)$acf))
  expect_equal(nrow(fortify.acf(pacf(iris, plot=FALSE))), nrow(pacf(iris, plot=FALSE)$acf))
  expect_equal(nrow(fortify(acf(airmiles, plot=FALSE))), nrow(acf(airmiles, plot=FALSE)$acf))
  expect_equal(nrow(fortify(acf(iris, plot=FALSE))), nrow(acf(iris, plot=FALSE)$acf))
  expect_equal(nrow(fortify(pacf(airmiles, plot=FALSE))), nrow(pacf(airmiles, plot=FALSE)$acf))
  expect_equal(nrow(fortify(pacf(iris, plot=FALSE))), nrow(pacf(iris, plot=FALSE)$acf))
})

test_that('Each function returns the correct numbers', {
  expect_equal(fortify.acf(acf(airmiles, plot=FALSE)), fortify(acf(airmiles, plot=FALSE)))
  expect_equal(fortify.acf(acf(iris, plot=FALSE)), fortify(acf(iris, plot=FALSE)))
  expect_equal(fortify.acf(pacf(airmiles, plot=FALSE)), fortify(pacf(airmiles, plot=FALSE)))
  expect_equal(fortify.acf(pacf(iris, plot=FALSE)), fortify(pacf(iris, plot=FALSE)))
})

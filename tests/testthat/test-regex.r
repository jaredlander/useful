context('Test that the functions of regex return the correct output in all cases')

test_that('Each function returns the correct type (or error)', {
  expect_is(regex('a+', 'abc'), 'character')
  expect_is(regex('a+', c('abc', 'def', 'cba a', 'aa')), 'character')
  expect_is(regex('a+', 'def'), 'character')
  expect_is(OneRegex('abc', 'a+'), 'character')
  expect_error(OneRegex(c('abc', 'def', 'cba a', 'aa'), 'a+'),
               'arguments imply differing number of rows: 1, 4')
  expect_is(OneRegex('def', 'a+'), 'character')
  expect_is(gregex('a+', 'abc'), 'list')
  expect_is(gregex('a+', c('abc', 'def', 'cba a', 'aa')), 'list')
  expect_is(gregex('a+', 'def'), 'list')
})

test_that('Each function returns something with the correct length', {
  expect_equal(length(regex('a+', 'abc')), 1)
  expect_equal(length(regex('a+', c('abc', 'def', 'cba a', 'aa'))), 3)
  expect_equal(length(regex('a+', 'def')), 0)
  expect_equal(length(OneRegex('abc', 'a+')), 1)
  expect_equal(length(OneRegex('def', 'a+')), 0)
  expect_equal(length(gregex('a+', 'abc')), 1)
  expect_equal(length(gregex('a+', c('abc', 'def', 'cba a', 'aa'))), 3)
  expect_equal(length(gregex('a+', 'def')), 0)
})

test_that('Each function returns the correct numbers', {
  expect_equal(regex('a+', 'abc'), 'a')
  expect_equal(regex('a+', c('abc', 'def', 'cba a', 'aa')), c('a', 'a', 'aa'))
  expect_equal(regex('a+', 'def'), character(0))
  expect_equal(OneRegex('abc', 'a+'), 'a')
  expect_equal(OneRegex('def', 'a+'), character(0))
  testlist <- list(abc='a')
  expect_identical(gregex('a+', 'abc'), testlist)
  testlist <- list(abc='a', 'cba a'=c('a', 'a'), aa='aa')
  expect_identical(gregex('a+', c('abc', 'def', 'cba a', 'aa')), testlist)
  #testlist <- list()
  #expect_identical(gregex('a+', 'def'), testlist)
})

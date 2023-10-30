context('Check that all the functions in formatters work correctly')

library(useful)
library(scales)
vect <- c(1000, 1500, 23450, 21784, 875003780)

test_that('All functions return correct types', {
  expect_is(multiple(vect), 'character')
  expect_is(multiple(vect, extra=dollar), 'character')
  expect_is(multiple(vect, digits=5), 'character')
  expect_is(multiple(vect, extra=identity, digits=5), 'character')
  expect_is(multiple(vect, multiple='M'), 'character')
  expect_is(multiple(vect, multiple='M', extra=dollar), 'character')
  expect_is(multiple(vect, multiple='m', digits=5), 'character')
  expect_is(multiple(vect, multiple='m', extra=identity, digits=5), 'character')
  
  expect_is(multiple_format()(vect), 'character')
  expect_is(multiple_format(extra=dollar)(vect), 'character')
  expect_is(multiple_format(digits=5)(vect), 'character')
  expect_is(multiple_format(extra=identity, digits=5)(vect), 'character')
  expect_is(multiple_format(multiple='M')(vect), 'character')
  expect_is(multiple_format(multiple='M', extra=dollar)(vect), 'character')
  expect_is(multiple_format(multiple='m', digits=5)(vect), 'character')
  expect_is(multiple_format(multiple='m', extra=identity, digits=5)(vect), 'character')
  
  expect_is(multiple.dollar(vect), 'character')
  expect_is(multiple.dollar(vect, digits=5), 'character')
  expect_is(multiple.dollar(vect, multiple="h"), 'character')
  expect_is(multiple.dollar(vect, multiple="h", digits=5), 'character')
  
  expect_is(multiple.comma(vect), 'character')
  expect_is(multiple.comma(vect, digits=5), 'character')
  expect_is(multiple.comma(vect, multiple="h"), 'character')
  expect_is(multiple.comma(vect, multiple="h", digits=5), 'character')
  
  expect_is(multiple.identity(vect), 'character')
  expect_is(multiple.identity(vect, digits=5), 'character')
  expect_is(multiple.identity(vect, multiple="h"), 'character')
  expect_is(multiple.identity(vect, multiple="h", digits=5), 'character')
})

test_that('All functions return lists of proper length', {
  expect_equal(length(multiple(vect)), length(vect))
  expect_equal(length(multiple(vect, extra=dollar)), length(vect))
  expect_equal(length(multiple(vect, digits=5)), length(vect))
  expect_equal(length(multiple(vect, extra=identity, digits=5)), length(vect))
  expect_equal(length(multiple(vect, multiple='M')), length(vect))
  expect_equal(length(multiple(vect, multiple='M', extra=dollar)), length(vect))
  expect_equal(length(multiple(vect, multiple='m', digits=5)), length(vect))
  expect_equal(length(multiple(vect, multiple='m', extra=identity, digits=5)), length(vect))
  
  expect_equal(length(multiple_format()(vect)), length(vect))
  expect_equal(length(multiple_format(extra=dollar)(vect)), length(vect))
  expect_equal(length(multiple_format(digits=5)(vect)), length(vect))
  expect_equal(length(multiple_format(extra=identity, digits=5)(vect)), length(vect))
  expect_equal(length(multiple_format(multiple='M')(vect)), length(vect))
  expect_equal(length(multiple_format(multiple='M', extra=dollar)(vect)), length(vect))
  expect_equal(length(multiple_format(multiple='m', digits=5)(vect)), length(vect))
  expect_equal(length(multiple_format(multiple='m', extra=identity, digits=5)(vect)), length(vect))
  
  expect_equal(length(multiple.dollar(vect)), length(vect))
  expect_equal(length(multiple.dollar(vect, digits=5)), length(vect))
  expect_equal(length(multiple.dollar(vect, multiple="h")), length(vect))
  expect_equal(length(multiple.dollar(vect, multiple="h", digits=5)), length(vect))
  
  expect_equal(length(multiple.comma(vect)), length(vect))
  expect_equal(length(multiple.comma(vect, digits=5)), length(vect))
  expect_equal(length(multiple.comma(vect, multiple="h")), length(vect))
  expect_equal(length(multiple.comma(vect, multiple="h", digits=5)), length(vect))
  
  expect_equal(length(multiple.identity(vect)), length(vect))
  expect_equal(length(multiple.identity(vect, digits=5)), length(vect))
  expect_equal(length(multiple.identity(vect, multiple="h")), length(vect))
  expect_equal(length(multiple.identity(vect, multiple="h", digits=5)), length(vect))
})

test_that('All functions return correct output', {
  expect_equal(multiple(vect), c('1K', '2K', '23K', '22K', '875,004K'))
  expect_equal(multiple(vect, extra=dollar), c('$1K', '$2K', '$23K', '$22K', '$875,004K'))
  expect_equal(multiple(vect, digits=5), c('1.000K', '1.500K', '23.450K', '21.784K', '875,003.780K'))
  expect_equal(multiple(vect, extra=identity, digits=5), c('1K', '1.5K', '23.45K', '21.784K', '875003.78K'))
  expect_equal(multiple(vect, multiple='M'), c('0M', '0M', '0M', '0M', '875M'))
  expect_equal(multiple(vect, multiple='M', extra=dollar), c('$0M', '$0M', '$0M', '$0M', '$875M'))
  expect_equal(multiple(vect, multiple='m', digits=5), c('0.00100m', '0.00150m', '0.02345m', '0.02178m', '875.00378m'))
  expect_equal(multiple(vect, multiple='m', extra=identity, digits=5), c('0.001m', '0.0015m', '0.02345m', '0.02178m', '875.00378m'))
  
  expect_equal(multiple_format()(vect), c('1K', '2K', '23K', '22K', '875,004K'))
  expect_equal(multiple_format(extra=dollar)(vect), c('$1K', '$2K', '$23K', '$22K', '$875,004K'))
  expect_equal(multiple_format(digits=5)(vect), c('1.000K', '1.500K', '23.450K', '21.784K', '875,003.780K'))
  expect_equal(multiple_format(extra=identity, digits=5)(vect), c('1K', '1.5K', '23.45K', '21.784K', '875003.78K'))
  expect_equal(multiple_format(multiple='M')(vect), c('0M', '0M', '0M', '0M', '875M'))
  expect_equal(multiple_format(multiple='M', extra=dollar)(vect), c('$0M', '$0M', '$0M', '$0M', '$875M'))
  expect_equal(multiple_format(multiple='m', digits=5)(vect), c('0.00100m', '0.00150m', '0.02345m', '0.02178m', '875.00378m'))
  expect_equal(multiple_format(multiple='m', extra=identity, digits=5)(vect), c('0.001m', '0.0015m', '0.02345m', '0.02178m', '875.00378m'))
  
  expect_equal(multiple.dollar(vect), c('$1K', '$2K', '$23K', '$22K', '$875,004K'))
  expect_equal(multiple.dollar(vect, digits=5), c('$1K', '$2K', '$23K', '$22K', '$875,004K'))
  expect_equal(multiple.dollar(vect, multiple="h"), c('$10h', '$15h', '$234h', '$218h', '$8,750,038h'))
  expect_equal(multiple.dollar(vect, multiple="h", digits=5), c('$10h', '$15h', '$234h', '$218h', '$8,750,038h'))
  
  expect_equal(multiple.comma(vect), c('1K', '2K', '23K', '22K', '875,004K'))
  expect_equal(multiple.comma(vect, digits=5), c('1.00000K', '1.50000K', '23.45000K', '21.78400K', '875,003.78000K'))
  expect_equal(multiple.comma(vect, multiple="h"), c('10h', '15h', '234h', '218h', '8,750,038h'))
  expect_equal(multiple.comma(vect, multiple="h", digits=5), c('10.00000h', '15.00000h', '234.50000h', '217.84000h', '8,750,037.80000h'))
  
  expect_equal(multiple.identity(vect), c('1K', '2K', '23K', '22K', '875004K'))
  expect_equal(multiple.identity(vect, digits=5), c('1K', '1.5K', '23.45K', '21.784K', '875003.78K'))
  expect_equal(multiple.identity(vect, multiple="h"), c('10h', '15h', '234h', '218h', '8750038h'))
  expect_equal(multiple.identity(vect, multiple="h", digits=5), c('10h', '15h', '234.5h', '217.84h', '8750037.8h'))
})

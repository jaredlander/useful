context('Checking that MapToInterval maps correctly according to the formula')

# create numerical vector
nums <- c(7, 10, 2, 9, 8, 4, 3, 6, 5, 1)
nums2 <- c(1, 3.5, 7, 7.5, 8, 8.2, 8.3, 12, 14, 20)

test_that('The functions return numericals', {
  expect_is(mapping(nums), 'numeric')
  expect_is(mapping(nums2), 'numeric')
})

test_that('The correct number of elements are returned', {
  expect_equal(length(mapping(nums)), length(nums))
  expect_equal(length(mapping(nums2)), length(nums2))
})

test_that('mapping returns correct numerical output', {
  expect_equal(mapping(nums), nums)
  expect_equal(mapping(nums, 11, 20), c(17, 20, 12, 19, 18, 14, 13, 16, 15, 11))
  expect_equal(mapping(nums, 1, 20), c(13.6666667, 20, 3.1111111, 17.8888889,
                                           15.7777778, 7.3333333, 5.2222222,
                                           11.5555556, 9.4444444, 1))
  expect_equal(mapping(nums2), c(1, 2.1842105, 3.8421053, 4.0789474,
                                     4.3157895, 4.4105263, 4.4578947,
                                     6.2105263, 7.1578947, 10))
})

# All these tests pass, will likely add more
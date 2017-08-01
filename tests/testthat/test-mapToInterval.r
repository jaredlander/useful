context('Checking that MapToInterval and mapping maps correctly
        according to the formula')

# create numerical vector
nums <- c(7, 10, 2, 9, 8, 4, 3, 6, 5, 1)
nums2 <- c(1, 3.5, 7, 7.5, 8, 8.2, 8.3, 12, 14, 20)

# tests for mapping
test_that('mapping return numericals', {
  expect_is(mapping(nums), 'numeric')
  expect_is(mapping(nums2), 'numeric')
  expect_is(mapping(nums, 3, 55), 'numeric')
  expect_is(mapping(nums2, 10, 2), 'numeric')
})

test_that('mapping returns the correct number of elements', {
  expect_equal(length(mapping(nums)), length(nums))
  expect_equal(length(mapping(nums2)), length(nums2))
  expect_equal(length(mapping(nums, 3, 55)), length(nums))
  expect_equal(length(mapping(nums2, 10, 2)), length(nums2))
})

test_that('mapping returns correct numerical output', {
  expect_equal(mapping(nums), nums)
  expect_equal(mapping(nums, 20, 11), c(14, 11, 19, 12, 13, 17, 18, 15, 16, 20))
  expect_equal(mapping(nums, 1, 20), c(13.6666667, 20, 3.1111111, 17.8888889,
                                           15.7777778, 7.3333333, 5.2222222,
                                           11.5555556, 9.4444444, 1))
  expect_equal(mapping(nums2), c(1, 2.1842105, 3.8421053, 4.0789474,
                                     4.3157895, 4.4105263, 4.4578947,
                                     6.2105263, 7.1578947, 10))
})

# tests for MapToInterval
test_that('MapToInterval return numericals', {
  expect_is(MapToInterval(nums), 'numeric')
  expect_is(MapToInterval(nums2), 'numeric')
  expect_is(MapToInterval(nums, 3, 55), 'numeric')
  expect_is(MapToInterval(nums2, 10, 2), 'numeric')
})

test_that('MapToInterval returns the correct number of elements', {
  expect_equal(length(MapToInterval(nums)), length(nums))
  expect_equal(length(MapToInterval(nums2)), length(nums2))
  expect_equal(length(MapToInterval(nums, 3, 55)), length(nums))
  expect_equal(length(MapToInterval(nums2, 10, 2)), length(nums2))
})

test_that('MapToInterval returns correct numerical output', {
  expect_equal(MapToInterval(nums), nums)
  expect_equal(MapToInterval(nums, 20, 11), c(14, 11, 19, 12, 13, 17, 18, 15, 16, 20))
  expect_equal(MapToInterval(nums, 1, 20), c(13.6666667, 20, 3.1111111, 17.8888889,
                                       15.7777778, 7.3333333, 5.2222222,
                                       11.5555556, 9.4444444, 1))
  expect_equal(MapToInterval(nums2), c(1, 2.1842105, 3.8421053, 4.0789474,
                                 4.3157895, 4.4105263, 4.4578947,
                                 6.2105263, 7.1578947, 10))
})

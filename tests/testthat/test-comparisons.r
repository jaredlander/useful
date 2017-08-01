context('Checking that comparisons is properly comparing lists')

list1 <- c(1, 2, 3)
list2 <- c(1, 2)
list3 <- c(3, 2, 1)

test_that('compare.list returns logicals (or errors when appropriate)', {
  expect_is(compare.list(list1, list1), "logical")
  expect_is(compare.list(list1, list3), "logical")
  expect_error(compare.list(list1, list2), "a and b must be the same length")
})

test_that('compare.list returns a list of proper length', {
  expect_equal(length(compare.list(list1, list3)), length(list1))
})

test_that('compare.list returns correct output', {
  expect_equal(compare.list(list1, list1), c(TRUE, TRUE, TRUE))
  expect_equal(compare.list(list1, list3), c(FALSE, TRUE, FALSE))
})

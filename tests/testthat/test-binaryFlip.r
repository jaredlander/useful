context("Check that binary.flip correctly changes 1's to 0's and vice versa")

# create numerical vector
bin <- c(1, 1, 0, 0, 0, 0, 1, 0, 0, 0)

test_that('binary.flip returns numericals', {
  expect_is(binary.flip(bin), 'numeric')
})

test_that('binary.flip returns the correct number of elements', {
  expect_equal(length(binary.flip(bin)), length(bin))
})

test_that('binary.flip returns the correct numerical output', {
  expect_equal(binary.flip(bin), c(0, 0, 1, 1, 1, 1, 0, 1, 1, 1))
})
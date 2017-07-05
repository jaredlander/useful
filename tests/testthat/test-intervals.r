context('Test that interval returns the correct output in all cases')

test_that('interval.check returns the correct type', {
  expect_is(interval.check(cars, input="speed", times=seq(min(cars$speed), max(cars$speed), length=10)), 'numeric')
  expect_is(interval.check(cars, input="speed", times=seq(min(cars$speed), max(cars$speed), length=10), fun='>='), 'numeric')
  expect_is(interval.check(cars, input="speed", times=seq(min(cars$speed), max(cars$speed), length=10), fun='>'), 'numeric')
  expect_is(interval.check(cars, input="speed", times=seq(min(cars$speed), max(cars$speed), length=10), fun='<'), 'numeric')
  expect_is(interval.check(pressure, input='pressure', times=seq(min(pressure$pressure), max(pressure$pressure), length=10)), 'numeric')
})

test_that('interval.check returns the correct length', {
  expect_equal(length(interval.check(cars, input="speed", times=seq(min(cars$speed), max(cars$speed), length=10))), length(cars$speed))
  expect_equal(length(interval.check(cars, input="speed", times=seq(min(cars$speed), max(cars$speed), length=10), fun='>=')), length(cars$speed))
  expect_equal(length(interval.check(cars, input="speed", times=seq(min(cars$speed), max(cars$speed), length=10), fun='>')), length(cars$speed))
  expect_equal(length(interval.check(cars, input="speed", times=seq(min(cars$speed), max(cars$speed), length=10), fun='<')), length(cars$speed))
  expect_equal(length(interval.check(pressure, input='pressure', times=seq(min(pressure$pressure), max(pressure$pressure), length=10))), length(pressure$pressure))
})

test_that('interval returns the output we expect', {
  expect_equal(interval.check(cars, input="speed", times=seq(min(cars$speed), max(cars$speed), length=10)), 
               c(4, 4, 8.6666667, 8.6666667, 8.6666667, 11, 11, 11, 11, 11, 11,
                 13.3333333, 13.3333333, 13.3333333, 13.3333333, 13.3333333, 
                 13.3333333, 13.3333333, 13.3333333, 15.6666667, 15.6666667, 
                 15.6666667, 15.6666667, 15.6666667, 15.6666667, 15.6666667, 
                 18, 18, 18, 18, 18, 18, 18, 18, 18, 20.3333333, 20.3333333, 
                 20.3333333, 20.3333333, 20.3333333, 20.3333333, 20.3333333, 
                 20.3333333, 22.6666667, 25, 25, 25, 25, 25, 25))
  expect_equal(interval.check(pressure, input='pressure', times=seq(min(pressure$pressure), max(pressure$pressure), length=10)),
               c(0.0002, 89.555733, 89.555733, 89.555733, 89.555733, 89.555733, 89.555733, 
                 89.555733, 89.555733, 89.555733, 89.555733, 89.555733, 89.555733, 179.111267,
                 179.111267, 268.666800, 447.777867, 626.888933, 806))
})

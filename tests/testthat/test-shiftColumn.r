context('Test that shiftColumn returns the correct output in all cases')

myData <- data.frame(Upper=LETTERS, lower=letters)

test_that('shift.column returns data.frames (or appropriate errors)', {
    skip_if(getRversion() <= '3.4')
    expect_is(shift.column(data=myData, columns="lower"), "data.frame")
    expect_is(shift.column(data=myData, columns="lower", len=3), "data.frame")
    expect_is(shift.column(data=myData, columns="lower", up=FALSE), "data.frame")
    expect_is(shift.column(data=myData, columns="lower", len=3, up=FALSE), "data.frame")
    expect_error(shift.column(data=myData, columns="lower", len=30), "'length.out' must be a non-negative number")
    expect_error(shift.column(data=myData, columns="lower", newNames=c("a", "b")), "columns and newNames must be the same length")
})

test_that('shift.column returns the correct number of rows and columns', {
  expect_equal(length(shift.column(data=myData, columns="lower")), 3)
  expect_equal(nrow(shift.column(data=myData, columns="lower")), 25)
  expect_equal(length(shift.column(data=myData, columns="lower", len=3)), 3)
  expect_equal(nrow(shift.column(data=myData, columns="lower", len=3)), 23)
  expect_equal(length(shift.column(data=myData, columns="lower", up=FALSE)), 3)
  expect_equal(nrow(shift.column(data=myData, columns="lower", up=FALSE)), 25)
  expect_equal(length(shift.column(data=myData, columns="lower", len=3, up=FALSE)), 3)
  expect_equal(nrow(shift.column(data=myData, columns="lower", len=3, up=FALSE)), 23)
})

test_that('shift.column returns the correct output', {
  comp <- data.frame(Upper=LETTERS,
                     lower=letters,
                     lower.Shifted=c(letters[2:26], letters[1]))
  expect_equal(shift.column(data=myData, columns="lower"), comp[-c(26),])
  comp <- data.frame(Upper=LETTERS,
                     lower=letters,
                     lower.Shifted=c(letters[4:26], letters[1:3]))
  expect_equal(shift.column(data=myData, columns="lower", len=3), comp[-c(24,25,26),])
  comp <- data.frame(Upper=LETTERS,
                     lower=letters,
                     lower.Shifted=c(letters[26], letters[1:25]))
  expect_equal(shift.column(data=myData, columns="lower", up=FALSE), comp[-c(1),])
  comp <- data.frame(Upper=LETTERS,
                     lower=letters,
                     lower.Shifted=c(letters[24:26], letters[1:23]))
  expect_equal(shift.column(data=myData, columns="lower", len=3, up=FALSE), comp[-c(1,2,3),])
})

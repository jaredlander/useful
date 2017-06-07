context('Check that buildFormula returns the correct formula')

test_that('build.formula returns a formula', {
  expect_is(build.formula("x", "y"), "formula")
  expect_is(build.formula(c("y", "z"), "x"), "formula")
  expect_is(build.formula("z", c("w", "x")), "formula")
  expect_is(build.formula(c("y", "z"), c("w", "x")), "formula")
})

test_that('build.formula returns the correct output', {
  expect_equal(build.formula("x", "y"), as.formula("x ~ y"))
  expect_equal(build.formula(c("y", "z"), "x"), as.formula("y + z ~ x"))
  expect_equal(build.formula("z", c("w", "x")), as.formula("z ~ w + x"))
  expect_equal(build.formula(c("y", "z"), c("w", "x")), as.formula("y + z ~ w + x"))
})

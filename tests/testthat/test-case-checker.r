context('Checking that upper and lower case are detected properly.')

# create text to check
toCheck <- c('BIG', 'little', 'Mixed', 'BIG WITH SPACE', 'little with space', 'MIXED with SPACE')

test_that('The functions return logicals', {
    expect_is(find.case(toCheck, 'upper'), 'logical')
    expect_is(find.case(toCheck, 'lower'), 'logical')
    expect_is(all.upper(toCheck), 'logical')
    expect_is(all.lower(toCheck), 'logical')
})

test_that('The correct number of elements are returned', {
    expect_equal(length(find.case(toCheck, 'upper')), length(toCheck))
    expect_equal(length(find.case(toCheck, 'lower')), length(toCheck))
    expect_equal(length(all.upper(toCheck)), length(toCheck))
    expect_equal(length(all.lower(toCheck)), length(toCheck))
    
    expect_equal(length(find.case(toCheck, 'upper')), length(all.upper(toCheck)))
    expect_equal(length(find.case(toCheck, 'lower')), length(all.lower(toCheck)))
})

test_that('find.case returns the same results as all.upper and all.lower', {
    expect_identical(find.case(toCheck, 'upper'), all.upper(toCheck))
    expect_identical(find.case(toCheck, 'lower'), all.lower(toCheck))
})

test_that('find.case, all.upper and all.lower work on simple data', {
    expect_identical(find.case(toCheck, 'upper'), c(TRUE, FALSE, FALSE, TRUE, FALSE, FALSE))
    expect_identical(all.upper(toCheck), c(TRUE, FALSE, FALSE, TRUE, FALSE, FALSE))
    
    expect_identical(find.case(toCheck, 'lower'), c(FALSE, TRUE, FALSE, FALSE, TRUE, FALSE))
    expect_identical(all.lower(toCheck), c(FALSE, TRUE, FALSE, FALSE, TRUE, FALSE))
})
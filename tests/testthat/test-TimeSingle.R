context("Timing calcualtion and display")

now <- Sys.time()
Sys.sleep(time=2)
then <- Sys.time()

nowBlank <- time.single(startTime=Sys.time())

nowThen <- time.single(startTime=now, endTime=then)
thenNow <- time.single(startTime=then, endTime=now)

nowMessage <- time.single('Time goes by', startTime=Sys.time())
nowThenMessage <- time.single('Time goes by', startTime=now, endTime=then)

nowSep <- time.single(startTime=Sys.time(), sep='|')
nowSepMessage <- time.single('Time slips away', startTime=Sys.time(), sep='|')
nowSepMessageThen <- time.single('Time slips away', startTime=now, endTime=then, sep='|')

test_that('A character is returned', {
    expect_is(nowBlank, 'character')
    expect_is(nowThen, 'character')
    expect_is(thenNow, 'character')
    expect_is(nowMessage, 'character')
    expect_is(nowThenMessage, 'character')
    expect_is(nowSep, 'character')
    expect_is(nowSepMessage, 'character')
    expect_is(nowSepMessageThen, 'character')
})

test_that("There are errors for non-time entries", {
    expect_error(time.single(startTime=4))
    expect_error(time.single(startTime=Sys.time(), endTime=4))
    expect_error(time.single(startTime=5, endTime=Sys.time()))
})

test_that('Check for the correct text', {
    expect_match(object=nowBlank, regexp='^Time difference')
    expect_match(nowThen, '^Time difference')
    expect_match(thenNow, '^Time difference')
    expect_match(nowMessage, '^Time goes by')
    expect_match(nowThenMessage, '^Time goes by')
    expect_match(nowSep, '^Time difference')
    expect_match(nowSepMessage, 'Time slips away')
    expect_match(nowSepMessageThen, '^Time slips away')
})

test_that('Check for the correct separator', {
    expect_match(object=nowBlank, regexp='^Time difference :')
    expect_match(nowThen, '^Time difference :')
    expect_match(thenNow, '^Time difference :')
    expect_match(nowMessage, '^Time goes by :')
    expect_match(nowThenMessage, '^Time goes by :')
    expect_match(nowSep, '^Time difference |')
    expect_match(nowSepMessage, 'Time slips away |')
    expect_match(nowSepMessageThen, '^Time slips away |')
})

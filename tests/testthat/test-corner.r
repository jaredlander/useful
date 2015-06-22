context('Ensure corner returns the correct part of the data.')

topL0 <- WhichCorner('topleft')
bottomL0 <- WhichCorner('bottomleft')
topR0 <- WhichCorner('topright')
bottomR0 <- WhichCorner('bottomright')

topLR6 <- WhichCorner('topleft', r=6)
bottomLR6 <- WhichCorner('bottomleft', r=6)
topRR6 <- WhichCorner('topright', r=6)
bottomRR6 <- WhichCorner('bottomright', r=6)

topLC7 <- WhichCorner('topleft', c=7)
bottomLC7 <- WhichCorner('bottomleft', c=7)
topRC7 <- WhichCorner('topright', c=7)
bottomRC7 <- WhichCorner('bottomright', c=7)

topLR8C3 <- WhichCorner('topleft', r=8, c=3)
bottomLR8C3 <- WhichCorner('bottomleft', r=8, c=3)
topRR8C3 <- WhichCorner('topright', r=8, c=3)
bottomRR8C3 <- WhichCorner('bottomright', r=8, c=3)

test_that('WhichCorner returns expression class', {
    expect_is(topL0, 'expression')
    expect_is(bottomL0, 'expression')
    expect_is(topR0, 'expression')
    expect_is(bottomR0, 'expression')
    
    expect_is(topLR6, 'expression')
    expect_is(bottomLR6, 'expression')
    expect_is(topRR6, 'expression')
    expect_is(bottomRR6, 'expression')
    
    expect_is(topLC7, 'expression')
    expect_is(bottomLC7, 'expression')
    expect_is(topRC7, 'expression')
    expect_is(bottomRC7, 'expression')
    
    expect_is(topLR8C3, 'expression')
    expect_is(bottomLR8C3, 'expression')
    expect_is(topRR8C3, 'expression')
    expect_is(bottomRR8C3, 'expression')
})

test_that('WhichCorner gets the right number of rows and columns', {
    expect_equal(as.character(topL0), 'list(rows = 1:5, cols = 1:5)')
    expect_equal(as.character(bottomL0), 'list(rows = (nrow(x) - 5 + 1):nrow(x), cols = 1:5)')
    expect_equal(as.character(topR0), 'list(rows = 1:5, cols = (ncol(x) - 5 + 1):ncol(x))')
    expect_equal(as.character(bottomR0), 'list(rows = (nrow(x) - 5 + 1):nrow(x), cols = (ncol(x) - 5 + 1):ncol(x))')
    
    expect_equal(as.character(topLR6), 'list(rows = 1:6, cols = 1:5)')
    expect_equal(as.character(bottomLR6), 'list(rows = (nrow(x) - 6 + 1):nrow(x), cols = 1:5)')
    expect_equal(as.character(topRR6), 'list(rows = 1:6, cols = (ncol(x) - 5 + 1):ncol(x))')
    expect_equal(as.character(bottomRR6), 'list(rows = (nrow(x) - 6 + 1):nrow(x), cols = (ncol(x) - 5 + 1):ncol(x))')
    
    expect_equal(as.character(topLC7), 'list(rows = 1:5, cols = 1:7)')
    expect_equal(as.character(bottomLC7), 'list(rows = (nrow(x) - 5 + 1):nrow(x), cols = 1:7)')
    expect_equal(as.character(topRC7), 'list(rows = 1:5, cols = (ncol(x) - 7 + 1):ncol(x))')
    expect_equal(as.character(bottomRC7), 'list(rows = (nrow(x) - 5 + 1):nrow(x), cols = (ncol(x) - 7 + 1):ncol(x))')
    
    expect_equal(as.character(topLR8C3), 'list(rows = 1:8, cols = 1:3)')
    expect_equal(as.character(bottomLR8C3), 'list(rows = (nrow(x) - 8 + 1):nrow(x), cols = 1:3)')
    expect_equal(as.character(topRR8C3), 'list(rows = 1:8, cols = (ncol(x) - 3 + 1):ncol(x))')
    expect_equal(as.character(bottomRR8C3), 'list(rows = (nrow(x) - 8 + 1):nrow(x), cols = (ncol(x) - 3 + 1):ncol(x))')
})

# test_that('', {
#     expect_is(eval(WhichCorner(corner="topleft", 5, 5, "testFrame")), 'list')
#     expect_is(eval(WhichCorner(corner="topright", 5, 5, "testFrame")), 'list')
#     expect_is(eval(WhichCorner(corner="bottomleft", 5, 5, "testFrame")), 'list')
#     expect_is(eval(WhichCorner(corner="bottomright", 5, 5, "testFrame")), 'list')
#     
#     eval(WhichCorner(corner="topleft", 5, 5, "testFrame"))
#     eval(WhichCorner(corner="topright", 5, 5, "testFrame"))
#     eval(WhichCorner(corner="bottomleft", 5, 5, "testFrame"))
#     eval(WhichCorner(corner="bottomright", 5, 5, "testFrame"))
# })
context("Coordinates conversion from polar to cartesian and back")

library(dplyr)

polarRadPosTop <- data.frame(r=c(3, 5, 3, 5, 4, 6, 4, 6, 2), theta=c(0, pi/6, pi/4, pi/3, pi/2, 2*pi/3, 3*pi/4, 5*pi/6, pi))
polarRadPosBottom <- data.frame(r=c(3, 5, 3, 5, 4, 6, 4, 6, 2), theta=c(pi, 7*pi/6, 5*pi/4, 4*pi/3, 3*pi/2, 5*pi/3, 7*pi/4, 9*pi/6, 2*pi))
polarRadNegTop <- data.frame(r=c(3, 5, 3, 5, 4, 6, 4, 6, 2), theta=-1*c(0, pi/6, pi/4, pi/3, pi/2, 2*pi/3, 3*pi/4, 5*pi/6, pi))
polarRadNegBottom <- data.frame(r=c(3, 5, 3, 5, 4, 6, 4, 6, 2), theta=-1*c(pi, 7*pi/6, 5*pi/4, 4*pi/3, 3*pi/2, 5*pi/3, 7*pi/4, 9*pi/6, 2*pi))

test_that('pol2cart returns a data.frame', {
    expect_is(pol2cart(polarRadPosTop$r, polarRadPosTop$theta), 'data.frame')
    expect_is(pol2cart(polarRadPosBottom$r, polarRadPosBottom$theta), 'data.frame')
    expect_is(pol2cart(polarRadNegTop$r, polarRadNegTop$theta), 'data.frame')
    expect_is(pol2cart(polarRadNegBottom$r, polarRadNegBottom$theta), 'data.frame')
})

test_that('pol2cart returns the right dimensions', {
    expect_equal(dim(pol2cart(polarRadPosTop$r, polarRadPosTop$theta)), c(9, 4))
    expect_equal(dim(pol2cart(polarRadPosBottom$r, polarRadPosBottom$theta)), c(9, 4))
    expect_equal(dim(pol2cart(polarRadNegTop$r, polarRadNegTop$theta)), c(9, 4))
    expect_equal(dim(pol2cart(polarRadNegBottom$r, polarRadNegBottom$theta)), c(9, 4))
})

test_that('pol2cart maps polar to cartesian correctly', {
    expect_identical(pol2cart(polarRadPosTop$r, polarRadPosTop$theta), 
                     data_frame(
                         x=polarRadPosTop$r*cos(polarRadPosTop$theta), 
                         y=polarRadPosTop$r*sin(polarRadPosTop$theta), 
                         r=polarRadPosTop$r, theta=polarRadPosTop$theta
                         )
                     )
    
    expect_identical(pol2cart(polarRadPosBottom$r, polarRadPosBottom$theta), 
                     data_frame(
                         x=polarRadPosBottom$r*cos(polarRadPosBottom$theta), 
                         y=polarRadPosBottom$r*sin(polarRadPosBottom$theta), 
                         r=polarRadPosBottom$r, theta=polarRadPosBottom$theta
                     )
    )
    
    expect_identical(pol2cart(polarRadNegTop$r, polarRadNegTop$theta), 
                     data_frame(
                         x=polarRadNegTop$r*cos(polarRadNegTop$theta), 
                         y=polarRadNegTop$r*sin(polarRadNegTop$theta), 
                         r=polarRadNegTop$r, theta=polarRadNegTop$theta
                     )
    )
    
    expect_identical(pol2cart(polarRadNegBottom$r, polarRadNegBottom$theta), 
                     data_frame(
                         x=polarRadNegBottom$r*cos(polarRadNegBottom$theta), 
                         y=polarRadNegBottom$r*sin(polarRadNegBottom$theta), 
                         r=polarRadNegBottom$r, theta=polarRadNegBottom$theta
                     )
    )
})


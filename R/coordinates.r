#' @title pol2cart
#' @description Converts polar coordinates to caretsian coordinates
#' @details Converts polar coordinates to caretsian coordinates using a simple conversion.  The angle, \code{theta} must be in radians.
#' 
#' Somewhat inspired by http://www.r-bloggers.com/convert-polar-coordinates-to-cartesian/ and https://www.mathsisfun.com/polar-cartesian-coordinates.html
#' @export pol2cart
#' @aliases pol2cart
#' @author Jared P. Lander
#' @param r The radius of the point
#' @param theta The angle of the point, in radians
#' @param degrees Logical indicating if theta is specified in degrees
#' @return A data.frame holding the (x,y) coordinates and original polar coordinates
#' @examples 
#' 
#' polarRadPosTop <- data.frame(r=c(3, 5, 3, 5, 4, 6, 4, 6, 2), theta=c(0, pi/6, pi/4, pi/3, pi/2, 2*pi/3, 3*pi/4, 5*pi/6, pi))
#' polarRadPosBottom <- data.frame(r=c(3, 5, 3, 5, 4, 6, 4, 6, 2), theta=c(pi, 7*pi/6, 5*pi/4, 4*pi/3, 3*pi/2, 5*pi/3, 7*pi/4, 9*pi/6, 2*pi))
#' polarRadNegTop <- data.frame(r=c(3, 5, 3, 5, 4, 6, 4, 6, 2), theta=-1*c(0, pi/6, pi/4, pi/3, pi/2, 2*pi/3, 3*pi/4, 5*pi/6, pi))
#' polarRadNegBottom <- data.frame(r=c(3, 5, 3, 5, 4, 6, 4, 6, 2), theta=-1*c(pi, 7*pi/6, 5*pi/4, 4*pi/3, 3*pi/2, 5*pi/3, 7*pi/4, 9*pi/6, 2*pi))
#' 
#' pol2cart(polarRadPosTop$r, polarRadPosTop$theta)
#' pol2cart(polarRadPosBottom$r, polarRadPosBottom$theta)
#' pol2cart(polarRadNegTop$r, polarRadNegTop$theta)
#' pol2cart(polarRadNegBottom$r, polarRadNegBottom$theta)
#' 
pol2cart <- function(r, theta, degrees=FALSE)
{
    # convert degrees to raidans if so requested
    if(degrees)
    {
        degrees*pi/180
    }
    
    # compute x
    x <- r*cos(theta)
    # compute y
    y <- r*sin(theta)
    
    data_frame(x=x, y=y, r=r, theta=theta)
}


#' @title cart2pol
#' @description Converts polar coordinates to caretsian coordinates
#' @details Converts polar coordinates to caretsian coordinates using a simple conversion.  The angle, \code{theta} must be in radians.
#' 
#' Somewhat inspired by http://www.r-bloggers.com/convert-polar-coordinates-to-cartesian/ and https://www.mathsisfun.com/polar-cartesian-coordinates.html
#' @export cart2pol
#' @aliases cart2pol
#' @author Jared P. Lander
#' @param r The radius of the point
#' @param theta The angle of the point, in radians
#' @param degrees Logical indicating if theta is specified in degrees
#' @return A data.frame holding the (x,y) coordinates and original polar coordinates
#' @examples 
#' 
#' polarRadPosTop <- data.frame(r=c(3, 5, 3, 5, 4, 6, 4, 6, 2), theta=c(0, pi/6, pi/4, pi/3, pi/2, 2*pi/3, 3*pi/4, 5*pi/6, pi))
#' polarRadPosBottom <- data.frame(r=c(3, 5, 3, 5, 4, 6, 4, 6, 2), theta=c(pi, 7*pi/6, 5*pi/4, 4*pi/3, 3*pi/2, 5*pi/3, 7*pi/4, 9*pi/6, 2*pi))
#' polarRadNegTop <- data.frame(r=c(3, 5, 3, 5, 4, 6, 4, 6, 2), theta=-1*c(0, pi/6, pi/4, pi/3, pi/2, 2*pi/3, 3*pi/4, 5*pi/6, pi))
#' polarRadNegBottom <- data.frame(r=c(3, 5, 3, 5, 4, 6, 4, 6, 2), theta=-1*c(pi, 7*pi/6, 5*pi/4, 4*pi/3, 3*pi/2, 5*pi/3, 7*pi/4, 9*pi/6, 2*pi))
#' 
#' cart2pol(polarRadPosTop$r, polarRadPosTop$theta)
#' cart2pol(polarRadPosBottom$r, polarRadPosBottom$theta)
#' cart2pol(polarRadNegTop$r, polarRadNegTop$theta)
#' cart2pol(polarRadNegBottom$r, polarRadNegBottom$theta)
#' 
cart2pol <- function(x, y, degrees=FALSE)
{
    
}
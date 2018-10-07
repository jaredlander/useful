## formatting functions

#' multiple
#' 
#' Order of Magnitude Formatter
#' 
#' This divides the number by the appropriate amount and adds on the corresponding symbol at the end of the number.
#' 
#' @author Jared P. Lander
#' @aliases multiple
#' @export multiple
#' @param x Vector of numbers to be formatted.
#' @param multiple The multiple to display numbers in.  This symbol will be added to the end of the numbers.
#' @param big.mark Character specifying the thousands separator
#' @param extra DEPRECATED, use `big.mark` and `prefix` instead: Function for perform any further formatting.
#' @param digits Number of decimal places for rounding.
#' @param prefix Symbol to put in front of the numbers such as a dollar sign.
#' @param scientific Logical (default: `FALSE`) indicating if the numbers should be returned in scientific notation.
#' @return Character vector of formatted numbers.
#' @md
#' @examples
#' 
#' require(scales)
#' vect <- c(1000, 1500, 23450, 21784, 875003780)
#' multiple(vect)
#' multiple(vect, extra=dollar)
#' multiple(vect, extra=identity)
#' 
#' require(ggplot2)
#' data(diamonds)
#' ggplot(diamonds, aes(x=x, y=y, color=price*100)) + geom_point() + 
#' scale_color_gradient2(labels=multiple)
#' 
multiple <- function(x, 
                     multiple=c("K", "M", "B", "T", "H", "k", "m", "b", "t", "h"), 
                     big.mark=',',
                     extra, digits=0,
                     prefix='',
                     scientific=FALSE)
{
    assertthat::assert_that(is.numeric(x))
    
    if(!missing(extra) && is.function(extra))
    {
        big.mark <- dplyr::case_when(
            identical(extra, scales::comma) ~ ',',
            identical(extra, identity) ~ '',
            TRUE ~ big.mark
        )
        
        prefix <- dplyr::case_when(
            identical(extra, scales::dollar) ~ '$',
            TRUE ~ prefix
        )
    }
    
    # get the multiple
    multiple=match.arg(multiple)
    
    # set up a vector for dividing
    dividers <- c("K"=1000, "M"=1000000, "B"=1000000000, "T"=1000000000000, "H"=100)
    
    # get what we're dividing by
    divider <- dividers[toupper(multiple)]
    
    x <- purrr::map_dbl(x, ~ round(.x / divider, digits=digits))
    # x <- format(x, digits=digits, big.mark=big.mark, scientific=scientific, trim=TRUE)
    x <- purrr::map_chr(x, ~ format(.x, big.mark=big.mark, scientific=scientific, trim=TRUE))
    
    sprintf("%s%s%s", prefix, x, multiple)
}


#' multiple_format
#' 
#' Multiple Style Formatting
#' 
#' Since ggplot requires a function for formatting this allows the user to specify the function's arguments, which will return a function that can be used by ggplot.
#' 
#' @param \dots Arguments to be passed onto \code{\link{multiple}}
#' @return The function \code{\link{multiple}}.
#' @author Jared P. Lander
#' @export multiple_format
#' @aliases multiple_format
#' @examples
#' 
#' library(scales)
#' vect <- c(1000, 1500, 23450, 21784, 875003780)
#' multiple_format()(vect)
#' multiple_format(extra=dollar)(vect)
#' multiple_format(extra=identity)(vect)
#' 
#' require(ggplot2)
#' data(diamonds)
#' ggplot(diamonds, aes(x=x, y=y, color=price*100)) + geom_point() + 
#' scale_color_gradient2(labels=multiple_format(extra=dollar))
#' 
multiple_format <- function(...)
{
    function(x) multiple(x, ...)
}



#' multiple.dollar
#' 
#' Order of Magnitude Formatter
#' 
#' Simply a wrapper for multiple that prespecifies the extra dollar.
#' 
#' @author Jared P. Lander
#' @aliases multiple.dollar
#' @export multiple.dollar
#' @param x Vector of numbers to be formatted.
#' @param \dots Further arguments to be passed on to \code{\link{multiple}}
#' @return Character vector of dollar formatted numbers.
#' @examples
#' 
#' require(scales)
#' vect <- c(1000, 1500, 23450, 21784, 875003780)
#' multiple.dollar(vect)
#' multiple.dollar(vect, multiple="k")
#' multiple.dollar(vect, multiple="h")
#' 
#' require(ggplot2)
#' data(diamonds)
#' ggplot(diamonds, aes(x=x, y=y, color=price*100)) + geom_point() + 
#' scale_color_gradient2(labels=multiple.dollar)
#'
multiple.dollar <- function(x, ...)
{
    multiple(x=x, extra=scales::dollar, ...)
}


#' multiple.comma
#' 
#' Order of Magnitude Formatter
#' 
#' Simply a wrapper for multiple that prespecifies the extra comma.
#' 
#' @author Jared P. Lander
#' @aliases multiple.comma
#' @export multiple.comma
#' @param x Vector of numbers to be formatted.
#' @param \dots Further arguments to be passed on to \code{link{multiple}}
#' @return Character vector of comma formatted numbers.
#' @examples
#' 
#' require(scales)
#' vect <- c(1000, 1500, 23450, 21784, 875003780)
#' multiple.comma(vect)
#' multiple.comma(vect, multiple="k")
#' multiple.comma(vect, multiple="h")
#' 
#' require(ggplot2)
#' data(diamonds)
#' ggplot(diamonds, aes(x=x, y=y, color=price*100)) + geom_point() + 
#' scale_color_gradient2(labels=multiple.comma)
#' 
multiple.comma <- function(x, ...)
{
    multiple(x=x, extra=scales::comma, ...)
}



#' multiple.identity
#' 
#' Order of Magnitude Formatter
#' 
#' Simply a wrapper for multiple that prespecifies the extra identity.
#' 
#' @author Jared P. Lander
#' @aliases multiple.identity
#' @export multiple.identity
#' @param x Vector of numbers to be formatted.
#' @param \dots Further arguments to be passed on to \code{link{multiple}}
#' @return Character vector of formatted numbers.
#' @examples
#' 
#' vect <- c(1000, 1500, 23450, 21784, 875003780)
#' multiple.identity(vect)
#' multiple.identity(vect, multiple="k")
#' multiple.identity(vect, multiple="h")
#' 
#' require(ggplot2)
#' data(diamonds)
#' ggplot(diamonds, aes(x=x, y=y, color=price*100)) + geom_point() + 
#' scale_color_gradient2(labels=multiple.identity)
#'
multiple.identity <- function(x, ...)
{    
    multiple(x=x, extra=identity, ...)
}

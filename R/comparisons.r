#' List Comparison
#'
#' List Comparison
#'
#' Compare elements of two equal length lists.
#'
#' @export compare.list
#' @aliases compare.list
#' @param a A List
#' @param b A List
#' @return A vector with a logical indicator for equality of each element
#' author Jared P. Lander www.jaredlander.com
#' @keywords list
#' @examples
#'
#' vect <- c(mean, mode, mean)
#' vect2 <- c(mean, mode, max)
#' vect3 <- c(mean, mean)
#' compare.list(vect, vect)
#' compare.list(vect, vect2)
#' tryCatch(compare.list(vect, vect3), error=function(e) print("Caught error"))
#'
compare.list <- function(a, b)
{
    a.length <- length(a)
    b.length <- length(b)
    
    if(a.length != b.length)
    {
        stop("a and b must be the same length", call.=FALSE)
    }
    
    result <- rep(FALSE, a.length)
    
    for(i in 1:a.length)
    {
        result[i] <- identical(a[[i]], b[[i]])
    }
    
    rm(a, b, a.length, b.length)
    
    return(result)
}
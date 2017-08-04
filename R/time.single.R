# time single

#' time.single
#'
#' Convenience function that takes in a time object and calculates a difference
#' with a user specified prompt
#'
#' @export time.single
#' @author Daniel Y. Chen
#' @aliases time.single
#' @param string string of what was timed
#' @param startTime "POSIXct" "POSIXt" object, usually from \code{\link{Sys.time}}
#' @param endTime "POSIXct" "POSIXt" object, usually from \code{\link{Sys.time}}
#' @param sep string, usually character that is used as the separator between user prompt and time difference
#' @return prompt_string string user prompt with time difference
#' @examples
#'
#' x <- 3.14
#' strt <- Sys.time()
#' sq <- x ** 2
#' time.single('Squaring value', strt)
#'
time.single <- function(string='Time difference', startTime,
                        endTime=Sys.time(), sep=':')
{
    assertthat::assert_that(assertthat::is.time(startTime))
    assertthat::assert_that(assertthat::is.time(endTime))
    
    diffTime <- endTime - startTime
    parse_time <- unclass(diffTime)[1]
    parse_units <- attr(unclass(diffTime), 'units')
    
    prompt_string <- sprintf('%s %s %s %s', string, sep, parse_time, parse_units)
    
    return(prompt_string)
}

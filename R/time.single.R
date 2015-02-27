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
#' @param start_time "POSIXct" "POSIXt" object, usually from `Sys.time()`
#' @param end_time "POSIXct" "POSIXt" object, usually from `Sys.time()`
#' @param sep string, usually character that is used as the separator between
#' user prompt and time difference
#' @return prompt_string string user prompt with time difference
#' @examples
#'
#' x <- 3.14
#' strt <- Sys.time()
#' sq <- x ** 2
#' time.single('Squaring value', strt)
#'
time.single <- function(string='Time difference', start_time,
                                  end_time = Sys.time(), sep=':'){
  diff_time <- end_time - start_time
  parse_time <- unclass(diff_time)[1]
  parse_units <- attr(unclass(diff_time), 'units')

  prompt_string <- sprintf('%s %s %s %s', string, sep, parse_time, parse_units)

  return(prompt_string)
}

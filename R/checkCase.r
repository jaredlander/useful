#' @title all.upper
#' @description Checks if strings are all upper case
#' @details Checks if strings are all upper case.  This is a wrapper for \code{find.case('text', 'upper')}.
#' @export all.upper
#' @aliases all.upper
#' @author Jared P. Lander
#' @param string Character vector of strings to check cases
#' @return A vector of TRUE AND FALSE
#' @seealso find.case all.lower
#' @examples 
#'  
#' all.upper(toCheck)
all.upper <- function(string)
{
    find.case(string, 'upper')
}


#' @title all.lower
#' @description Checks if strings are all lower case
#' @details Checks if strings are all lower case. This is a wrapper for \code{find.case('text', 'lower')}.
#' @export all.lower
#' @aliases all.lower
#' @author Jared P. Lander
#' @param string Character vector of strings to check cases
#' @return A vector of TRUE AND FALSE
#' @seealso find.case all.upper
#' @examples 
#' toCheck <- c('BIG', 'little', 'Mixed', 'BIG WITH SPACE', 'little with space', 'MIXED with SPACE')
#' all.lower(toCheck)
all.lower <- function(string)
{
    find.case(string, 'lower')
}

#' @title find.case
#' @description Checks if strings are all upper or all lower case
#' @details Checks if strings are all upper or all lower case
#' @export find.case
#' @aliases find.case
#' @author Jared P. Lander
#' @param string Character vector of strings to check cases
#' @param case Whether checking for upper or lower case
#' @return A vector of TRUE AND FALSE
#' @seealso all.upper all.lower
#' @examples
#' toCheck <- c('BIG', 'little', 'Mixed', 'BIG WITH SPACE', 'little with space', 'MIXED with SPACE')
#' find.case(toCheck, 'upper')
#' find.case(toCheck, 'lower')
find.case <- function(string, case=c('upper', 'lower'))
{
    # find which case
    case <- match.arg(case)
    
    # ensure that string is a character
    string <- as.character(string)
    
    # build patterns
    # the entire item must be lower or upper
    patterns <- c(upper='^([A-Z]+| )+$', lower='^([a-z]+| )+$')
    
    grepl(pattern=patterns[case], x=string)
}
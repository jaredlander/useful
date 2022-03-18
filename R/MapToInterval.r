## maps a given set of numbers to the specified interval
## @nums: (vector) the numbers to be mapped
## @start (numeric) the beginging of the mapping
## @stop (numeric) the end of the mapping


#' Map numbers to interval
#' 
#' Maps a range of numbers to a given interval
#' 
#' formula: a + (x - min(x)) * (b - a) / (max(x) - min(x))
#' 
#' @aliases MapToInterval mapping
#' @param nums The vector of numbers to be mapped
#' @param start The start of the interval
#' @param stop The end of the interval
#' @param na.rm Whether to remove \code{NA} values before calculating interval
#' @return The original numbers mapped to the given interval
#' @author Jared P. Lander
#' www.jaredlander.com
#' @export MapToInterval mapping
#' @seealso \code{\link{mapping}}
#' @keywords numbers mapping interval
#' @examples
#' 
#' MapToInterval(1:10, start=0, stop=1)
#' mapping(1:10, start=0, stop=1)
#' 
MapToInterval <- function(nums, start=1, stop=10, na.rm=TRUE)
{
    #do the mapping: a + (x - min(x)) * (b - a) / (max(x) - min(x))
    mapped <- start + (nums - min(nums, na.rm=na.rm)) * (stop - start) / diff(range(nums, na.rm=na.rm))
    return(mapped)
}


# just a better name for the function
mapping <- function(nums, start=1, stop=10, na.rm=FALSE)
{
    return(MapToInterval(nums=nums, start=start, stop=stop, na.rm=na.rm))
}

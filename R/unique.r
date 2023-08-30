#' @title uniqueBidirection
#' @description Find unique rows of a data.frame regardless of the order they appear
#' @details Sorts individual rows to get uniques regardless of order of appearance.
#' @author Jared P. Lander
#' @rdname uniqueBidirection
#' @export uniqueBidirection
#' @param x a data.frame
#' @return A data.frame that is unique regardless of direction
#' @examples 
#' 
#' ex <- data.frame(One=c('a', 'c', 'a', 'd', 'd', 'c', 'b'), 
#' Two=c('b', 'd', 'b', 'e', 'c', 'd', 'a'),
#' stringsAsFactors=FALSE)
#' 
#' # make a bigger version
#' exBig <- ex
#' for(i in 1:1000)
#' {
#'     exBig <- rbind(exBig, ex)
#' }
#' 
#' dim(exBig)
#' 
#' uniqueBidirection(ex)
#' uniqueBidirection(exBig)
#' 
#' ex3 <- dplyr::bind_cols(ex, tibble::tibble(Three=rep('a', nrow(ex))))
#' uniqueBidirection(ex3)
#' 
uniqueBidirection <- function(x)
{
    # make sure x is a two-column data.frame
    if(!is.data.frame(x))
    {
        stop('x must be a data.frame')
    }
    
    # if(ncol(x) != 2)
    # {
    #     stop('x must have exactly two columns')
    # }
    
    # get original names and class to use later
    theNames <- names(x)
    theClass <- class(x)
    
    res <- unique(t(apply(unique(x), 1, sort)))
    
    res <- as.data.frame(res, stringsAsFactors=FALSE)
    
    if('tbl' %in% theClass)
    {
        res <- tibble::as_tibble(res)
    }
    
    # set names and return
    stats::setNames(res, theNames)
}

# dplyr way but slower
# sortCols <- function(x)
# {
#     # get original names to use later
#     theNames <- names(x)
#     
#     # sort them col-wise
#     x <- sort(as.data.frame(x, stringsAsFactors=FALSE))
#     
#     # set original names and return object
#     setNames(x, nm=theNames)
# }
# 
# uniqueBidirection <- function(x)
# {
#     x %>% unique %>% rowwise %>% do(sortCols(.)) %>% ungroup %>% unique
# }
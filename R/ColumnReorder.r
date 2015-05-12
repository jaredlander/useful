#' @title colsToFront
#' @description Moves column names to the fron or back of the names
#' @details Moves column names to the fron or back of the names
#' @author Jared P. Lander
#' @export colsToFront
#' @param data data.frame or tbl
#' @param cols Columns that should be moved
#' @return Character vector of column names
#' @examples 
#' theDF <- data.frame(A=1:10, B=11:20, C=1:10, D=11:20)
#' colsToFront(theDF, c('B', 'C'))
#' colsToFront(theDF, c('C', 'B'))
#' colsToFront(theDF, c('C', 'C'))
#' 
colsToFront <- function(data, cols=names(data))
{
    allCols <- names(data)
    # get the columns that are not in cols
    back <- allCols[!allCols %in% cols]
    
    # return the new order
    c(cols, back)
}

#' @title colsToBack
#' @rdname colsToFront
#' @inheritParams colsToFront
#' 
colsToBack <- function(data, cols=names(data))
{
    allCols <- names(data)
    # get the columns that are not in cols
    back <- allCols[!allCols %in% cols]
    
    # return the new order
    c(back, cols)
}

moveToFront <- function(data, cols)
{
    colOrder <- colsToFront(data, cols)
    
    data %>% select_(.dots=colOrder)
}

#textExtract %>% moveToFront(c('One', 'Two'))

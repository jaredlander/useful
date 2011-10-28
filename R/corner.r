## Functions to grab the corner of data similar to head or tail

## Helper function for getting the indexing for data.frame's, matrices
## @corner (character) which corner to display c("topleft", "bottomleft", "topright", "bottomright")
## @r (numeric) the number of rows to show
## @c (numeric) the number of columns to show
## @var (character) the name of the data variable that is being shown
WhichCorner <- function(corner="topleft", r=5L, c=5L, object="x")
{
    theCorners <- list(
                    topleft=sprintf("list(rows=1:%s, cols=1:%s)", r, c),
                    bottomleft=sprintf("list(rows=nrow(%s):(nrow(%s)-%s+1), cols=1:%s)", object, object, r, c),
                    topright=sprintf("list(rows=1:%s, cols=(ncol(%s)-%s+1):ncol(%s))", r, object, c, object),
                    bottomright=sprintf("list(rows=nrow(%s):(nrow(%s)-%s+1), cols=(ncol(%s)-%s+1):ncol(%s))", object, object, r, object, c, object)
                )
    
    return(parse(text=theCorners[[corner]]))
}
# eval(WhichCorner(corner="topleft", 5, 5, "testFrame"))
# eval(WhichCorner(corner="topright", 5, 5, "testFrame"))
# eval(WhichCorner(corner="bottomleft", 5, 5, "testFrame"))
# eval(WhichCorner(corner="bottomright", 5, 5, "testFrame"))


## S3 generic function for getting the corner of data



#' Grabs a corner of a data set
#' 
#' Display a corner section of a rectangular data set
#' 
#' Displays a
#' corner of a retangular data set such as a data.frame or martrix.  If showing
#' the right side or bottom, the order of the data is preserved.
#' 
#' The default method reverts to simply calling \code{\link{head}}
#' 
## @aliases corner corner.default corner.data.frame corner.matrix
#' @rdname corner
#' @usage corner(x, ...)
#' @usage corner.default(x, r=5L, ...)
#' @usage corner.data.frame(x, r=5L, c=5L, corner="topleft", ...)
#' @usage corner.matrix(x, r=5L, c=5L, corner="topleft", ...)
#' @param x The data
#' @param r Number of rows to display
#' @param c Number of columns to show
#' @param corner Which corner to grab.  Posibble
#' values are c("topleft", "bottomleft", "topright", "bottomright")
#' @param \dots Arguments passed on to other
#' functions
#' @return ... The part of the data set that was requested.  The size
#' depends on r and c and the position depends on corner.
#' @author Jared P. Lander www.jaredlander.com
#' @seealso \code{\link{head}} \code{\link{tail}}
#' @export corner corner.default corner.data.frame corner.matrix
#' @keywords corner head tail display subsection view
#' @examples
#' 
#' data(diamonds)
#' head(diamonds)      # displays all columns
#' corner(diamonds)    # displays first 5 rows and only the first 5 columns
#' corner(diamonds, corner="bottomleft")       # displays the last 5 rows and the first 5 columns
#' corner(diamonds, corner="topright")       # displays the first 5 rows and the last 5 columns
#'
corner <- function(x, ...)
{
    UseMethod("corner")
}


## gets the corner for a data.frame
## @x (data.frame) the data
## @r (numeric) the number of rows to show
## @c (numeric) the number of columns to show
## @corner (character) which corner to return, c("topleft", "bottomleft", "topright", "bottomright")
#' @rdname corner
#' @method corner data.frame
#' @S3method corner data.frame
corner.data.frame <- function(x, r=5L, c=5L, corner="topleft", ...)
{
    r <- if(nrow(x) < r) nrow(x) else r
    c <- if(ncol(x) < c) ncol(x) else c
    
    seqs <- eval(WhichCorner(corner=corner, r=r, c=c, object="x"))

    return(x[seqs$rows, seqs$cols, drop=FALSE])
}


## gets the corner for a matrix
## @x (matrix) the data
## @r (numeric) the number of rows to show
## @c (numeric) the number of columns to show
## @corner (character) which corner to return, c("topleft", "bottomleft", "topright", "bottomright")
#' @rdname corner
#' @method corner matrix
#' @S3method corner matrix
corner.matrix <- function(x, r=5L, c=5L, corner="topleft", ...)
{
    r <- if(nrow(x) < r) nrow(x) else r
    c <- if(ncol(x) < c) ncol(x) else c
    
    seqs <- eval(WhichCorner(corner=corner, r=r, c=c, object="x"))
                 
    return(x[seqs$rows, seqs$cols, drop=FALSE])
}

#' @rdname corner
#' @method corner table
#' @S3method corner table
corner.table <- function(x, r=5L, c=5L, corner="topleft", ...)
{
    r <- if(nrow(x) < r) nrow(x) else r
    c <- if(ncol(x) < c) ncol(x) else c
    
    seqs <- eval(WhichCorner(corner=corner, r=r, c=c, object="x"))
                 
    return(x[seqs$rows, seqs$cols, drop=FALSE])
}

## gets the corner for default
## @x (data) the data
## @r (numeric) the number of rows to show
#' @rdname corner
#' @method corner default
#' @S3method corner default
corner.default <- function(x, r=5L, ...)
{
    head(x, n=r, ...)
}

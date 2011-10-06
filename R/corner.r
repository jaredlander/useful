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
corner <- function(x, ...)
{
    UseMethod("corner")
}


## gets the corner for a data.frame
## @x (data.frame) the data
## @r (numeric) the number of rows to show
## @c (numeric) the number of columns to show
## @corner (character) which corner to return, c("topleft", "bottomleft", "topright", "bottomright")
corner.data.frame <- function(x, r=5L, c=5L, corner="topleft", ...)
{
    r <- if(nrow(x) < r) nrow(x) else r
    c <- if(nrow(x) < c) nrow(x) else c
    
    seqs <- eval(WhichCorner(corner=corner, r=r, c=c, object="x"))
                 
    return(x[seqs$rows, seqs$cols, drop=FALSE])
}


## gets the corner for a matrix
## @x (matrix) the data
## @r (numeric) the number of rows to show
## @c (numeric) the number of columns to show
## @corner (character) which corner to return, c("topleft", "bottomleft", "topright", "bottomright")
corner.matrix <- function(x, r=5L, c=5L, corner="topleft", ...)
{
    r <- if(nrow(x) < r) nrow(x) else r
    c <- if(nrow(x) < c) nrow(x) else c
    
    seqs <- eval(WhichCorner(corner=corner, r=r, c=c, object="x"))
                 
    return(x[seqs$rows, seqs$cols, drop=FALSE])
}


## gets the corner for default
## @x (data) the data
## @r (numeric) the number of rows to show
## @c (numeric) the number of columns to show
## @corner (character) which corner to return, c("topleft", "bottomleft", "topright", "bottomright")
corner.default <- function(x, r=5L, c=5L, corner="topleft", ...)
{
    r <- if(nrow(x) < r) nrow(x) else r
    c <- if(nrow(x) < c) nrow(x) else c
    
    seqs <- eval(WhichCorner(corner=corner, r=r, c=c, object="x"))
                 
    return(x[seqs$rows, seqs$cols, drop=FALSE])
}


## method for vector
## @x (vector) the data
## @... other arguments pased on to other functions
## just calls head
corner.vector <- function(x, ...)
{
    head(x, ...)
}


## method for character
## @x (character) the data
## @... other arguments pased on to other functions
## just calls head
corner.character <- function(x, ...)
{
    head(x, ...)
}
# Correlation

#' Pairwise correlation
#'
#' Compute the correlation between individual columns, one pair at a time
#'
#' Computes pairwise correlations between individual columns of a matrix or data.frame.
#'
#' This should be faster than using cor(x, use="pairwise.complete.obs" because it takes advantage of correlation symmetry and only uses one loop nstead of a nested double loop.
#'
#' Removes any rows in a pair-wise comparison that have even one NA element.
#'
#' @param x An NxP matrix
#' @return A PxP correlation matrix
#' @export cor2
#' @aliases cor2
#' @author Jared P. Lander www.jaredlander.com
#' @seealso \code{\link{cor}}
#' @examples
#'
#' x <- rnorm(10)
#' y <- rnorm(10)
#' z <- rnorm(10)
#' hold1 <- cor2(cbind(x, y, z))
#' hold2 <- cor(cbind(x, y, z))
#' all.equal(hold1, hold2)
#' x[c(3, 6)] <- NA
#' y[c(2)] <- NA
#' hold3 <- cor2(cbind(x, y, z))
#' hold4 <- cor(cbind(x, y, z), use="pairwise.complete.obs")
#' all.equal(hold3, hold4)
#'
cor2 <- function(x)
{
    # get number of columns
    cols <- ncol(x)
    
    # build a grid comparing every column to every other
    nums <- expand.grid(1:cols, 1:cols)
    
    # get the unique combinations
    nums <- unique(t(apply(nums, 1, function(x) {x[order(x)]})))
    
    # don't bother with rows that compare a column against itself
    nums <- nums[nums[, 1] != nums[, 2], ]
    
    # build matrix to hold correlations
    corMat <- matrix(1, ncol=cols, nrow=cols)
    
    # for each combination of columns compute the correlation
    # omit rows that have an NA in either position
    for(i in 1:nrow(nums))
    {
        corMat[nums[i, 1], nums[i, 2]] <- cor(na.omit(x[, nums[i, ]]))[1, 2]
    }
    
    # since it is symmetric multiply itself by it's transpose to fill in the ones we did not compute
    corMat <- corMat*t(corMat)
    
    # give proper labels
    rownames(corMat) <- colnames(corMat) <- colnames(x)
    
    rm(cols, nums, x); gc()         # housekeeping
    
    return(corMat)
}
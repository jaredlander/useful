# testX <- matrix(rnorm(50000), ncol=5)
# system.time(replicate(n=1000, expr=cor(testX)))
# system.time(replicate(n=1000, expr=cor2(testX)))
# testX[sample(x=c(TRUE, FALSE), size=10000*5, replace=TRUE, prob=c(.05, .95))] <- NA
# hold5 <- cor(testX, use="pairwise.complete.obs")
# hold6 <- cor2(testX)
# all.equal(hold5, hold6)
# system.time(replicate(100, cor(testX, use="pairwise.complete.obs")))
# system.time(replicate(100, cor2(testX)))
# testX2 <- matrix(rnorm(100000), ncol=10)
# hold7 <- cor(testX2, use="pairwise.complete.obs")
# hold8 <- cor2(testX2)
# all.equal(hold5, hold6)
# system.time(replicate(100, cor(testX2, use="pairwise.complete.obs")))
# system.time(replicate(100, cor2(testX2)))
# testX3 <- matrix(rnorm(10000*1000), ncol=1000)
# testX3[sample(x=c(TRUE, FALSE), size=10000*1000, replace=TRUE, prob=c(.05, .95))] <- NA
# system.time(hold9 <- cor(testX3, use="pairwise.complete.obs"))
# system.time(hold10 <- cor2(testX3))
# all.equal(hold5, hold6)
#system.time(replicate(100, cor(testX2, use="pairwise.complete.obs")))
#system.time(replicate(100, cor2(testX2)))
# Correlation

doCor <- function(mat)
{
    x <- mat[, 1]
    y <- mat[, 2]
    (sum(x*y) - NROW(x)*mean(x)*mean(y)) / ((NROW(x) - 1) * sqrt(var(x)) * sqrt(var(y)))
}


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
#' a <- rnorm(10000)
#' b <- rnorm(10000)
#' c <- rnorm(10000)
#' d <- rnorm(10000)
#' e <- rnorm(10000)
#'
cor2 <- function(x)
{
    # get number of columns
    cols <- ncol(x)
    
    # build a grid comparing every column to every other
    nums <- combn(1:cols, 2)
    
    # build matrix to hold correlations
    corMat <- matrix(1, ncol=cols, nrow=cols)
# print(nums)
    # for each combination of columns compute the correlation
    # omit rows that have an NA in either position
    for(i in 1:ncol(nums))
    {
#         print(i)
#         print(nums[1, i])
#         print(nums[2, i])
        #corMat[nums[1, i], nums[2, i]] <- cor(na.omit(x[, nums[, i]]))[1, 2]
        #corMat[nums[1, i], nums[2, i]] <- corMat[nums[2, i], nums[1, i]] <- doCor(na.omit(x[, nums[, i]]))
        theData <- na.omit(x[, nums[, i]])
        corMat[nums[1, i], nums[2, i]] <- corMat[nums[2, i], nums[1, i]] <- .Internal(cor(theData[, 1], theData[, 2], 1L, FALSE))
    }
    
    # since it is symmetric multiply itself by it's transpose to fill in the ones we did not compute
    #corMat <- corMat*t(corMat)
    
    # give proper labels
    rownames(corMat) <- colnames(corMat) <- colnames(x)
    
    rm(cols, nums, x); gc()         # housekeeping
    
    return(corMat)
}
cor3 <- compiler::cmpfun(cor2)
system.time(replicate(100, hold10 <- cor3(testX3)))
testX3 <- matrix(rnorm(100*10, 0, 10), ncol=10)
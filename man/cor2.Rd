\name{cor2}
\alias{cor2}
\title{Pairwise correlation}
\usage{
  cor2(x)
}
\arguments{
  \item{x}{An NxP matrix}
}
\value{
  A PxP correlation matrix
}
\description{
  Compute the correlation between individual columns, one
  pair at a time
}
\details{
  Computes pairwise correlations between individual columns
  of a matrix or data.frame.

  This should be faster than using cor(x,
  use="pairwise.complete.obs" because it takes advantage of
  correlation symmetry and only uses one loop nstead of a
  nested double loop.

  Removes any rows in a pair-wise comparison that have even
  one NA element.
}
\examples{
x <- rnorm(10)
y <- rnorm(10)
z <- rnorm(10)
hold1 <- cor2(cbind(x, y, z))
hold2 <- cor(cbind(x, y, z))
all.equal(hold1, hold2)
x[c(3, 6)] <- NA
y[c(2)] <- NA
hold3 <- cor2(cbind(x, y, z))
hold4 <- cor(cbind(x, y, z), use="pairwise.complete.obs")
all.equal(hold3, hold4)
}
\author{
  Jared P. Lander www.jaredlander.com
}
\seealso{
  \code{\link{cor}}
}


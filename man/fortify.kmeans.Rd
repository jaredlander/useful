\name{fortify.kmeans}
\alias{fortify.kmeans}
\title{fortify.kmeans}
\usage{
  \method{fortify}{kmeans} (model, data, ...)
}
\arguments{
  \item{model}{\code{\link{kmeans}} model}

  \item{data}{Data used to fit the model}

  \item{\dots}{Not Used}
}
\value{
  The original data with extra columns: \item{.x}{The
  projected x position.} \item{.y}{The projected y
  position.} \item{.Cluster}{The cluster that point belongs
  to.}
}
\description{
  Fortify a kmeans model with its data
}
\details{
  Prepares a kmeans object to be plotted using
  \code{\link{cmdscale}} to compute the projected x/y
  coordinates.
}
\examples{
k1 <- kmeans(x=iris[, 1:4], centers=3)
hold <- fortify(k1)
head(k1)
}
\author{
  Jared P. Lander
}
\seealso{
  kmeans fortify ggplot plot.kmeans
}


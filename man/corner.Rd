\name{corner}
\alias{corner}
\alias{corner.data.frame}
\alias{corner.default}
\alias{corner.matrix}
\alias{corner.table}
\title{Grabs a corner of a data set}
\usage{
  corner(x, ...)

  \method{corner}{data.frame} (x, r = 5L, c = 5L,
    corner = "topleft", ...)

  \method{corner}{matrix} (x, r = 5L, c = 5L,
    corner = "topleft", ...)

  \method{corner}{table} (x, r = 5L, c = 5L,
    corner = "topleft", ...)

  \method{corner}{default} (x, r = 5L, ...)
}
\arguments{
  \item{x}{The data}

  \item{r}{Number of rows to display}

  \item{c}{Number of columns to show}

  \item{corner}{Which corner to grab.  Posibble values are
  c("topleft", "bottomleft", "topright", "bottomright")}

  \item{\dots}{Arguments passed on to other functions}
}
\value{
  ... The part of the data set that was requested.  The
  size depends on r and c and the position depends on
  corner.
}
\description{
  Display a corner section of a rectangular data set
}
\details{
  Displays a corner of a retangular data set such as a
  data.frame, martrix or table.  If showing the right side
  or bottom, the order of the data is preserved.

  The default method reverts to simply calling
  \code{\link{head}}
}
\examples{
data(diamonds)
head(diamonds)      # displays all columns
corner(diamonds)    # displays first 5 rows and only the first 5 columns
corner(diamonds, corner="bottomleft")       # displays the last 5 rows and the first 5 columns
corner(diamonds, corner="topright")       # displays the first 5 rows and the last 5 columns
}
\author{
  Jared P. Lander www.jaredlander.com
}
\seealso{
  \code{\link{head}} \code{\link{tail}}
  \code{\link{topleft}} \code{\link{topright}}
  \code{\link{bottomleft}} \code{\link{bottomright}}
  \code{\link{left}} \code{\link{right}}
}
\keyword{corner}
\keyword{display}
\keyword{head}
\keyword{subsection}
\keyword{tail}
\keyword{view}


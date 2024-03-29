% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/corner.r
\name{WhichCorner}
\alias{WhichCorner}
\title{WhichCorner}
\usage{
WhichCorner(
  corner = c("topleft", "bottomleft", "topright", "bottomright"),
  r = 5L,
  c = 5L,
  object = "x"
)
}
\arguments{
\item{corner}{(character) which corner to display c("topleft", "bottomleft", "topright", "bottomright")}

\item{r}{(numeric) the number of rows to show}

\item{c}{(numeric) the number of columns to show}

\item{object}{The name of the object that is being subsetted}
}
\value{
An expression that is evaluated to return the proper portion of the data
}
\description{
Function to build the right row selection depending on the desired corner.
}
\details{
Function to build the right row selection depending on the desired corner.  Helper function for getting the indexing for data.frame's, matrices
}
\examples{
\dontrun{
WhichCorner('topleft')
WhichCorner('bottomleft')
WhichCorner('topright')
WhichCorner('bottomright')

WhichCorner('topleft', r=6)
WhichCorner('bottomleft', r=6)
WhichCorner('topright', r=6)
WhichCorner('bottomright', r=6)

WhichCorner('topleft', c=7)
WhichCorner('bottomleft', c=7)
WhichCorner('topright', c=7)
WhichCorner('bottomright', c=7)

WhichCorner('topleft', r=8, c=3)
WhichCorner('bottomleft', r=8, c=3)
WhichCorner('topright', r=8, c=3)
WhichCorner('bottomright', r=8, c=3)
}

}
\author{
Jared P. Lander
}

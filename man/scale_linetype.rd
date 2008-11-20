\name{scale_linetype}
\alias{scale_linetype}
\alias{ScaleLinetype}
\title{scale\_linetype}
\description{Scale for line patterns}
\details{
This page describes scale\_linetype, see \code{\link{layer}} and \code{\link{qplot}} for how to create a complete plot from individual components.
}
\usage{scale_linetype(name=NULL, expand=c(0.05, 0), limits=NULL, breaks=NULL, labels=NULL, formatter=identity, ...)}
\arguments{
 \item{name}{name of scale to appear in legend or on axis.  Maybe be an expression: see ?plotmath}
 \item{expand}{numeric vector of length 2, giving multiplicative and additive expansion factors}
 \item{limits}{numeric vector of length 2, giving the extent of the scale}
 \item{breaks}{numeric vector indicating where breaks should lie}
 \item{labels}{character vector giving labels associated with breaks}
 \item{formatter}{NULL}
 \item{...}{ignored }
}
\seealso{\itemize{
  \item \url{http://had.co.nz/ggplot2/scale_linetype.html}
}}
\value{A \code{\link{layer}}}
\examples{\dontrun{
ec_scaled <- data.frame(
  date = economics$date, 
  rescaler(economics[, -(1:2)], "range")
)
ecm <- melt(ec_scaled, id = "date")

qplot(date, value, data=ecm, geom="line", group=variable)
qplot(date, value, data=ecm, geom="line", linetype=variable)
qplot(date, value, data=ecm, geom="line", colour=variable)

# The linetype scale currently has no options, so there's
# no point in adding it manually
}}
\author{Hadley Wickham, \url{http://had.co.nz/}}
\keyword{hplot}
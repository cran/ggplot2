\name{scale_prob}
\alias{scale_prob}
\alias{scale_x_prob}
\alias{scale_y_prob}
\alias{scale_z_prob}
\alias{scale_xend_prob}
\alias{scale_yend_prob}
\alias{ScaleProb}
\title{scale\_prob}
\description{Probability scale}
\details{
This page describes scale\_prob, see \code{\link{layer}} and \code{\link{qplot}} for how to create a complete plot from individual components.
}
\usage{scale_x_prob(name=NULL, limits=c(NA, NA), breaks=NULL, family="norm", ...)
scale_y_prob(name=NULL, limits=c(NA, NA), breaks=NULL, family="norm", ...)
scale_z_prob(name=NULL, limits=c(NA, NA), breaks=NULL, family="norm", ...)
scale_xend_prob(name=NULL, limits=c(NA, NA), breaks=NULL, family="norm", ...)
scale_yend_prob(name=NULL, limits=c(NA, NA), breaks=NULL, family="norm", ...)}
\arguments{
 \item{name}{name of scale to appear in legend or on axis}
 \item{limits}{numeric vector of length 2, giving the extent of the scale}
 \item{breaks}{numeric vector indicating where breaks should lie}
 \item{family}{NULL}
 \item{...}{ignored }
}
\seealso{\itemize{
  \item \code{\link{scale_discrete}}: Discrete position scales
  \item \url{http://had.co.nz/ggplot/scale_prob.html}
}}
\value{A \code{\link{layer}}}
\examples{\dontrun{
    # Coming soon
}}
\author{Hadley Wickham, \url{http://had.co.nz/}}
\keyword{hplot}

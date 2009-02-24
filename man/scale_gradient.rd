\name{scale_gradient}
\alias{scale_gradient}
\alias{scale_colour_gradient}
\alias{scale_fill_gradient}
\alias{ScaleGradient}
\alias{scale_colour_continuous}
\alias{scale_fill_continuous}
\title{scale\_gradient}
\description{Smooth gradient between two colours}
\details{
This page describes scale\_gradient, see \code{\link{layer}} and \code{\link{qplot}} for how to create a complete plot from individual components.
}
\usage{scale_colour_gradient(name=NULL, low="#3B4FB8", high="#B71B1A", space="rgb", breaks=NULL, labels=NULL, limits=NULL, trans="identity", alpha=1, ...)
scale_fill_gradient(name=NULL, low="#3B4FB8", high="#B71B1A", space="rgb", breaks=NULL, labels=NULL, limits=NULL, trans="identity", alpha=1, ...)}
\arguments{
 \item{name}{name of scale to appear in legend or on axis.  Maybe be an expression: see ?plotmath}
 \item{low}{colour at low end of scale}
 \item{high}{colour at high end of scale}
 \item{space}{colour space to interpolate through, rgb or Lab, see ?colorRamp for details}
 \item{breaks}{numeric vector indicating where breaks should lie}
 \item{labels}{character vector giving labels associated with breaks}
 \item{limits}{numeric vector of length 2, giving the extent of the scale}
 \item{trans}{a transformer to use}
 \item{alpha}{alpha value to use for colours}
 \item{...}{other arguments}
}
\seealso{\itemize{
  \item \code{\link{scale_gradient2}}: continuous colour scale with midpoint
  \item \code{\link{colorRamp}}: for details of interpolation algorithm
  \item \url{http://had.co.nz/ggplot2/scale_gradient.html}
}}
\value{A \code{\link{layer}}}
\examples{\dontrun{
# It's hard to see, but look for the bright yellow dot 
# in the bottom right hand corner
dsub <- subset(diamonds, x > 5 & x < 6 & y > 5 & y < 6)
(d <- qplot(x, y, data=dsub, colour=z))
# That one point throws our entire scale off.  We could
# remove it, or manually tweak the limits of the scale

# Tweak scale limits.  Any points outside these
# limits will not be plotted, but will continue to affect the 
# calculate of statistics, etc
d + scale_colour_gradient(limits=c(3, 10))
d + scale_colour_gradient(limits=c(3, 4))
# Setting the limits manually is also useful when producing
# multiple plots that need to be comparable

# Alternatively we could try transforming the scale:
d + scale_colour_gradient(trans = "log")
d + scale_colour_gradient(trans = "sqrt")

# Other more trivial manipulations, including changing the name
# of the scale and the colours.

d + scale_colour_gradient("Depth")
d + scale_colour_gradient(expression(Depth[mm]))

d + scale_colour_gradient(limits=c(3, 4), low="red")
d + scale_colour_gradient(limits=c(3, 4), low="red", high="white")
# Much slower
d + scale_colour_gradient(limits=c(3, 4), low="red", high="white", space="Lab")
d + scale_colour_gradient(limits=c(3, 4), space="Lab")

# Can also make partially transparent
d + scale_colour_gradient(limits=c(3, 4), alpha=0.5)

# scale_fill_continuous works similarly, but for fill colours
(h <- qplot(x - y, data=dsub, geom="histogram", binwidth=0.01, fill=..count..))
h + scale_fill_continuous(low="black", high="pink", limits=c(0,3100))
}}
\author{Hadley Wickham, \url{http://had.co.nz/}}
\keyword{hplot}

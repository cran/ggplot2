\name{geom_density2d}
\alias{geom_density2d}
\alias{GeomDensity2d}
\title{geom\_density2d}
\description{Contours from a 2d density estimate}
\details{
Perform a 2D kernel density estimatation using kde2d and  display the results with contours.

This page describes geom\_density2d, see \code{\link{layer}} and \code{\link{qplot}} for how to create a complete plot from individual components.
}
\section{Aesthetics}{
The following aesthetics can be used with geom\_density2d.  Aesthetics are mapped to variables in the data with the aes function: \code{geom\_density2d(aes(x = var))}
\itemize{
  \item \code{x}: x position (\strong{required}) 
  \item \code{y}: y position (\strong{required}) 
  \item \code{weight}: observation weight used in statistical transformation 
  \item \code{colour}: border colour 
  \item \code{size}: size 
  \item \code{linetype}: line type 
  \item \code{alpha}: transparency 
}
}
\section{Advice}{
This can be useful for dealing with overplotting.

}
\usage{geom_density2d(mapping=NULL, data=NULL, stat="density2d", position="identity", lineend="butt", linejoin="round", linemitre=1, na.rm=FALSE, ...)}
\arguments{
 \item{mapping}{mapping between variables and aesthetics generated by aes}
 \item{data}{dataset used in this layer, if not specified uses plot dataset}
 \item{stat}{statistic used by this layer}
 \item{position}{position adjustment used by this layer}
 \item{lineend}{Line end style (round, butt, square)}
 \item{linejoin}{Line join style (round, mitre, bevel)}
 \item{linemitre}{Line mitre limit (number greater than 1)}
 \item{na.rm}{NULL}
 \item{...}{other arguments}
}
\seealso{\itemize{
  \item \code{\link{geom_contour}}: contour drawing geom
  \item \code{\link{stat_sum}}: another way of dealing with overplotting
  \item \url{http://had.co.nz/ggplot2/geom_density2d.html}
}}
\value{A \code{\link{layer}}}
\examples{\dontrun{
# See stat_density2d for examples
}}
\author{Hadley Wickham, \url{http://had.co.nz/}}
\keyword{hplot}

\name{geom_rug}
\alias{geom_rug}
\alias{GeomRug}
\title{geom\_rug}
\description{Marginal rug plots}
\details{
This page describes geom\_rug, see \code{\link{layer}} and \code{\link{qplot}} for how to create a complete plot from individual components.
}
\section{Aesthetics}{
The following aesthetics can be used with geom\_rug.  Aesthetics are mapped to variables in the data with the \code{\link{aes}} function: \code{geom\_rug(\code{\link{aes}}(x = var))}
\itemize{
  \item \code{colour}: border colour 
  \item \code{size}: size 
  \item \code{linetype}: line type 
}
}
\usage{geom_rug(mapping=NULL, data=NULL, stat="identity", position="identity", ...)}
\arguments{
 \item{mapping}{mapping between variables and aesthetics generated by aes}
 \item{data}{dataset used in this layer, if not specified uses plot dataset}
 \item{stat}{statistic used by this layer}
 \item{position}{position adjustment used by this layer}
 \item{...}{ignored }
}
\seealso{\itemize{
  \item \url{http://had.co.nz/ggplot/geom_rug.html}
}}
\value{A \code{\link{layer}}}
\examples{\dontrun{
    p <- ggplot(mtcars, aes(x=wt, y=mpg))
    p + geom_point()
    p + geom_point() + geom_rug()
    p + geom_point() + geom_rug(position='jitter')
}}
\author{Hadley Wickham, \url{http://had.co.nz/}}
\keyword{hplot}

\name{stat_density2d}
\alias{stat_density2d}
\alias{StatDensity2d}
\title{stat\_density2d}
\description{Density estimation, 2D}
\details{
This page describes stat\_density2d, see \code{\link{layer}} and \code{\link{qplot}} for how to create a complete plot from individual components.
}
\section{Aesthetics}{
The following aesthetics can be used with stat\_density2d.  Aesthetics are mapped to variables in the data with the aes function: \code{stat\_density2d(aes(x = var))}
\itemize{
  \item \code{x}: x position (\strong{required}) 
  \item \code{y}: y position (\strong{required}) 
  \item \code{colour}: border colour 
  \item \code{size}: size 
}
}
\usage{stat_density2d(mapping=NULL, data=NULL, geom="density2d", position="identity", na.rm=FALSE, contour=TRUE, n=100, ...)}
\arguments{
 \item{mapping}{mapping between variables and aesthetics generated by aes}
 \item{data}{dataset used in this layer, if not specified uses plot dataset}
 \item{geom}{geometric used by this layer}
 \item{position}{position adjustment used by this layer}
 \item{na.rm}{NULL}
 \item{contour}{If TRUE, contour the results of the 2d density estimation.}
 \item{n}{number of grid points in each direction}
 \item{...}{other arguments passed on to ?kde2d}
}
\seealso{\itemize{
  \item \url{http://had.co.nz/ggplot2/stat_density2d.html}
}}
\value{A \code{\link{layer}}}
\examples{\dontrun{
m <- ggplot(movies, aes(x=rating, y=length)) + 
  geom_point() + 
  scale_y_continuous(limits=c(1, 500))
m + geom_density2d()

dens <- MASS::kde2d(movies$rating, movies$length, n=100)
densdf <- data.frame(expand.grid(rating = dens$x, length = dens$y),
 z = as.vector(dens$z))
m + geom_contour(aes(z=z), data=densdf)

m + geom_density2d() + scale_y_log10()
m + geom_density2d() + coord_trans(y="log10")

m + stat_density2d(aes(fill = ..level..), geom="polygon")

qplot(rating, length, data=movies, geom=c("point","density2d")) +     
  ylim(1, 500)

# If you map an aesthetic to a categorical variable, you will get a
# set of contours for each value of that variable
qplot(rating, length, data = movies, geom = "density2d", 
  colour = factor(Comedy), ylim = c(0, 150))
qplot(rating, length, data = movies, geom = "density2d", 
  colour = factor(Action), ylim = c(0, 150))
qplot(carat, price, data = diamonds, geom = "density2d", colour = cut)

# Another example ------
d <- ggplot(diamonds, aes(carat, price)) + xlim(1,3)
d + geom_point() + geom_density2d()

# If we turn contouring off, we can use use geoms like tiles:
d + stat_density2d(geom="tile", aes(fill = ..density..), contour = FALSE)
last_plot() + scale_fill_gradient(limits=c(1e-5,8e-4))

# Or points:
d + stat_density2d(geom="point", aes(size = ..density..), contour = FALSE)
}}
\author{Hadley Wickham, \url{http://had.co.nz/}}
\keyword{hplot}

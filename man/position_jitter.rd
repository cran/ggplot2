\name{position_jitter}
\alias{position_jitter}
\alias{PositionJitter}
\title{position\_jitter}
\description{Jitter points to avoid overplotting}
\details{
This page describes position\_jitter, see \code{\link{layer}} and \code{\link{qplot}} for how to create a complete plot from individual components.
}
\usage{position_jitter(xjitter=NULL, yjitter=NULL, ...)}
\arguments{
 \item{xjitter}{degree of jitter in x direction, see ?jitter for details, defaults to 1 if the x variable is a factor, 0 otherwise}
 \item{yjitter}{degree of jitter in y direction, see ?jitter for details, defaults to 1 if the y variable is a factor, 0 otherwise}
 \item{...}{other arguments}
}
\seealso{\itemize{
  \item \url{http://had.co.nz/ggplot/position_jitter.html}
}}
\value{A \code{\link{layer}}}
\examples{\dontrun{
    qplot(am, vs, data=mtcars)
    qplot(am, vs, data=mtcars, position="jitter")
    # Control amount of jittering by calling position_jitter
    qplot(am, vs, data=mtcars, position=position_jitter(x=10, y=0))
    qplot(am, vs, data=mtcars, position=position_jitter(x=0.5, y=0.5))
    
    # See lots of actually useful examples at geom_jitter
    # You can, however, jitter any geom, however little sense it might make
    qplot(cut, clarity, data=diamonds, geom="blank", group=1) + geom_path()
    qplot(cut, clarity, data=diamonds, geom="blank", group=1) + geom_path(position="jitter")
}}
\author{Hadley Wickham, \url{http://had.co.nz/}}
\keyword{hplot}

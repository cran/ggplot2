\name{position_jitter}
\alias{position_jitter}
\title{Jitter points to avoid overplotting.}
\usage{
  position_jitter(width = NULL, height = NULL)
}
\arguments{
  \item{width}{degree of jitter in x direction. Defaults to
  40\% of the resolution of the data.}

  \item{height}{degree of jitter in y direction. Defaults
  to 40\% of the resolution of the data}
}
\description{
  Jitter points to avoid overplotting.
}
\examples{
qplot(am, vs, data = mtcars)

# Default amount of jittering will generally be too much for
# small datasets:
qplot(am, vs, data = mtcars, position = "jitter")
# Control the amount as follows
qplot(am, vs, data = mtcars, position = position_jitter(w = 0.1, h = 0.1))

# With ggplot
ggplot(mtcars, aes(x = am, y = vs)) + geom_point(position = "jitter")
ggplot(mtcars, aes(x = am, y = vs)) + geom_point(position = position_jitter(w = 0.1, h = 0.1))

# The default works better for large datasets, where it will
# take up as much space as a boxplot or a bar
qplot(class, hwy, data = mpg, geom = c("boxplot", "jitter"))
}
\seealso{
  Other position adjustments: \code{\link{position_dodge}},
  \code{\link{position_fill}},
  \code{\link{position_identity}},
  \code{\link{position_stack}}
}

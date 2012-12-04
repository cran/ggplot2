\name{stat_quantile}
\alias{stat_quantile}
\title{Continuous quantiles.}
\usage{
  stat_quantile(mapping = NULL, data = NULL,
    geom = "quantile", position = "identity",
    quantiles = c(0.25, 0.5, 0.75), formula = NULL,
    method = "rq", na.rm = FALSE, ...)
}
\arguments{
  \item{quantiles}{conditional quantiles of y to calculate
  and display}

  \item{formula}{formula relating y variables to x
  variables}

  \item{method}{Quantile regression method to use.
  Currently only supports \code{\link[quantreg]{rq}}.}

  \item{na.rm}{If \code{FALSE} (the default), removes
  missing values with a warning.  If \code{TRUE} silently
  removes missing values.}

  \item{mapping}{The aesthetic mapping, usually constructed
  with \code{\link{aes}} or \code{\link{aes_string}}. Only
  needs to be set at the layer level if you are overriding
  the plot defaults.}

  \item{data}{A layer specific dataset - only needed if you
  want to override the plot defaults.}

  \item{geom}{The geometric object to use display the data}

  \item{position}{The position adjustment to use for
  overlappling points on this layer}

  \item{...}{other arguments passed on to
  \code{\link{layer}}. This can include aesthetics whose
  values you want to set, not map. See \code{\link{layer}}
  for more details.}
}
\value{
  a data.frame with additional columns:
  \item{quantile}{quantile of distribution}
}
\description{
  Continuous quantiles.
}
\section{Aesthetics}{
  \Sexpr[results=rd,stage=build]{ggplot2:::rd_aesthetics("stat",
  "quantile")}
}
\examples{
\donttest{
msamp <- movies[sample(nrow(movies), 1000), ]
m <- ggplot(msamp, aes(year, rating)) + geom_point()
m + stat_quantile()
m + stat_quantile(quantiles = 0.5)
q10 <- seq(0.05, 0.95, by=0.05)
m + stat_quantile(quantiles = q10)

# You can also use rqss to fit smooth quantiles
m + stat_quantile(method = "rqss")
# Note that rqss doesn't pick a smoothing constant automatically, so
# you'll need to tweak lambda yourself
m + stat_quantile(method = "rqss", lambda = 10)
m + stat_quantile(method = "rqss", lambda = 100)

# Use 'votes' as weights for the quantile calculation
m + stat_quantile(aes(weight=votes))

# Change scale
m + stat_quantile(aes(colour = ..quantile..), quantiles = q10)
m + stat_quantile(aes(colour = ..quantile..), quantiles = q10) +
  scale_colour_gradient2(midpoint = 0.5)

# Set aesthetics to fixed value
m + stat_quantile(colour = "red", size = 2, linetype = 2)

# Use qplot instead
qplot(year, rating, data=movies, geom="quantile")
}
}


\name{qplot}
\alias{qplot}
\title{Quick plot.}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Quick plot is a convenient wrapper function for creating simple ggplot plot objects.
}
\usage{qplot(x, y = NULL, z=NULL, ..., data, facets = . ~ ., margins=FALSE, geom = "point", stat=list(NULL), position=list(NULL), xlim = c(NA, NA), ylim = c(NA, NA), log = "", main = NULL, xlab = deparse(substitute(x)), ylab = deparse(substitute(y)), add=NULL)}
\arguments{
\item{x}{x values}
\item{y}{y values}
\item{z}{data frame to use (optional)}
\item{...}{facetting formula to use}
\item{data}{grob type(s) to draw (can be a vector of multiple names)}
\item{facets}{limits for x axis (aesthetics to range of data)}
\item{margins}{limits for y axis (aesthetics to range of data)}
\item{geom}{which variables to log transform ("x", "y", or "xy")}
\item{stat}{character vector or expression for plot title}
\item{position}{character vector or expression for x axis label}
\item{xlim}{character vector or expression for y axis label}
\item{ylim}{if specified, build on top of this ggplot, rather than creating a new one}
\item{log}{other arguments passed on to the geom functions}
\item{main}{}
\item{xlab}{}
\item{ylab}{}
\item{add}{}
}

\details{FIXME: describe how to get more information
FIXME: add more examples

\code{qplot} provides a quick way to create simple plots.}

\examples{# Use data from data.frame
qplot(mpg, wt, data=mtcars)
qplot(mpg, wt, data=mtcars, colour=cyl)
qplot(mpg, wt, data=mtcars, size=cyl)
qplot(mpg, wt, data=mtcars, facets=vs ~ am)

# Use data from workspace environment
attach(mtcars)
qplot(mpg, wt)
qplot(mpg, wt, colour=cyl)
qplot(mpg, wt, size=cyl)
qplot(mpg, wt, facets=vs ~ am)

# Use different geoms
qplot(mpg, wt, geom="path")
qplot(factor(cyl), wt, geom=c("boxplot", "jitter"))

# Add to an existing plot
p <- qplot(mpg, wt, geom="path")
qplot(mpg, wt, geom="point", add=p)}
\keyword{hplot}

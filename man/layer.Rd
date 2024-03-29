% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/layer.R
\name{layer}
\alias{layer}
\title{Create a new layer}
\usage{
layer(
  geom = NULL,
  stat = NULL,
  data = NULL,
  mapping = NULL,
  position = NULL,
  params = list(),
  inherit.aes = TRUE,
  check.aes = TRUE,
  check.param = TRUE,
  show.legend = NA,
  key_glyph = NULL,
  layer_class = Layer
)
}
\arguments{
\item{geom}{The geometric object to use to display the data, either as a
\code{ggproto} \code{Geom} subclass or as a string naming the geom stripped of the
\code{geom_} prefix (e.g. \code{"point"} rather than \code{"geom_point"})}

\item{stat}{The statistical transformation to use on the data for this
layer, either as a \code{ggproto} \code{Geom} subclass or as a string naming the
stat stripped of the \code{stat_} prefix (e.g. \code{"count"} rather than
\code{"stat_count"})}

\item{data}{The data to be displayed in this layer. There are three
options:

If \code{NULL}, the default, the data is inherited from the plot
data as specified in the call to \code{\link[=ggplot]{ggplot()}}.

A \code{data.frame}, or other object, will override the plot
data. All objects will be fortified to produce a data frame. See
\code{\link[=fortify]{fortify()}} for which variables will be created.

A \code{function} will be called with a single argument,
the plot data. The return value must be a \code{data.frame}, and
will be used as the layer data. A \code{function} can be created
from a \code{formula} (e.g. \code{~ head(.x, 10)}).}

\item{mapping}{Set of aesthetic mappings created by \code{\link[=aes]{aes()}}. If specified and
\code{inherit.aes = TRUE} (the default), it is combined with the default mapping
at the top level of the plot. You must supply \code{mapping} if there is no plot
mapping.}

\item{position}{Position adjustment, either as a string naming the adjustment
(e.g. \code{"jitter"} to use \code{position_jitter}), or the result of a call to a
position adjustment function. Use the latter if you need to change the
settings of the adjustment.}

\item{params}{Additional parameters to the \code{geom} and \code{stat}.}

\item{inherit.aes}{If \code{FALSE}, overrides the default aesthetics,
rather than combining with them. This is most useful for helper functions
that define both data and aesthetics and shouldn't inherit behaviour from
the default plot specification, e.g. \code{\link[=borders]{borders()}}.}

\item{check.aes, check.param}{If \code{TRUE}, the default, will check that
supplied parameters and aesthetics are understood by the \code{geom} or
\code{stat}. Use \code{FALSE} to suppress the checks.}

\item{show.legend}{logical. Should this layer be included in the legends?
\code{NA}, the default, includes if any aesthetics are mapped.
\code{FALSE} never includes, and \code{TRUE} always includes.
It can also be a named logical vector to finely select the aesthetics to
display.}

\item{key_glyph}{A legend key drawing function or a string providing the
function name minus the \code{draw_key_} prefix. See \link{draw_key} for details.}

\item{layer_class}{The type of layer object to be constructed. This is
intended for ggplot2 internal use only.}
}
\description{
A layer is a combination of data, stat and geom with a potential position
adjustment. Usually layers are created using \verb{geom_*} or \verb{stat_*}
calls but it can also be created directly using this function.
}
\examples{
# geom calls are just a short cut for layer
ggplot(mpg, aes(displ, hwy)) + geom_point()
# shortcut for
ggplot(mpg, aes(displ, hwy)) +
  layer(
    geom = "point", stat = "identity", position = "identity",
    params = list(na.rm = FALSE)
  )

# use a function as data to plot a subset of global data
ggplot(mpg, aes(displ, hwy)) +
  layer(
    geom = "point", stat = "identity", position = "identity",
    data = head, params = list(na.rm = FALSE)
  )

}
\keyword{internal}

ggplot <- function(data, ...) UseMethod("ggplot")

# Create a new plot
# Create a new ggplot plot
# 
# This function creates the basic ggplot object which you can then
# furnish with graphical objects.  Here you will set 
# up the default data frame, default aesthetics and the formula that
# will determine how the panels are broken apart.  See \code{\link[reshape]{reshape}} 
# for more details on specifying the facetting formula and margin arguments.
# Note that ggplot creates a plot object without a "plot": you need to
# grobs (points, lines, bars, etc.) to create something that you can see.
#
# To get started, read the introductory vignette: \code{vignette("introduction", "ggplot")}
#
# ggplot is different from base and lattice graphics in how you build up the plot.
# With ggplot you build up the plot object (rather than the plot on the screen as
# in base graphics, or all at once as in lattice graphics.) 
# 
# Each of the geom and scale functions adds the geom to the plot and returns
# the modified plot object.  This lets you quickly experiment with different
# versions of the plot, using different geoms or scales.  You can see how this 
# works in the examples
# 
# You can also use \code{summary} to give a quick description of a plot.
# 
# If you want to change the background colour, how the panel strips are displayed,
# or any other default graphical option, see \code{\link{ggopt}}.
# 
# @alias package-ggplot
# @alias ggplot
# @arguments default data frame
# @arguments default list of aesthetic mappings (these can be colour, size, shape, line type -- see individual geom functions for more details)
# @seealso \url{http://had.co.nz/ggplot}, \\code{\\link[reshape]{stamp}}, \\code{\\link[reshape]{reshape}}, \\code{\\link{ggopt}}, \\code{vignette("introduction", "ggplot")}
# @keyword hplot
ggplot.default <- function(data = NULL, mapping=aes(), ...) {
	p <- structure(list(
		data = data, 
		layers = list(),
		scales = Scales$new(),
		defaults = mapping,
		title = NULL,
		fixedaspect = FALSE
	), class="ggplot")
	p$coordinates <- CoordCartesian$new()
	p$facet <- FacetGrid$new()
	p$scales$add_defaults(p$data, p$defaults)

	(.last_plot <<- p)
}


# Print ggplot
# Print generic for ggplot.  Plot on current graphics device.
#
# @arguments plot to display
# @arguments draw new (empty) page first?
# @arguments viewport to draw plot in
# @arguments other arguments passed on to \\code{\\link{ggplot_plot}}
# @keyword hplot
# @keyword internal 
print.ggplot <- function(x, newpage = is.null(vp), vp = NULL, save=ggopt()$save, ...) {
	if (save) {
		try_require("decumar")
		img(grid.draw(ggplot_plot(x, ...)), hash=digest(x))
		return()
	}
	
	if (newpage) grid.newpage()
	if (is.null(vp)) {
		grid.draw(ggplot_plot(x, ...)) 
	} else {
		if (is.character(vp)) seekViewport(vp) else pushViewport(vp)
		grid.draw(ggplot_plot(x, ...)) 
		upViewport()
	}
}

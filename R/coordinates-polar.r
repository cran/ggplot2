CoordPolar <- proto(Coord, {

	new <- function(., theta="x") {
		theta <- if (theta == "x") "x" else "y"
		r <- if (theta == "x") "y" else "x"

		proto(., theta = theta, r = r)
	}

	theta_scale <- function(.) .$.scales$get_scales(.$theta)
	theta_range <- function(.) expand_range(.$theta_scale()$frange(), 0, .$theta_scale()$.expand[2])
	theta_rescale <- function(., x) rescale(x, c(0, 2 * pi), .$theta_range())
	
	xlabel <- function(., gp) textGrob(NULL)
	ylabel <- function(., gp) textGrob(NULL)
	
	r_scale <- function(.) .$.scales$get_scales(.$r)
	r_range <- function(.) expand_range(.$r_scale()$frange(), 0,0)#.$r_scale()$.expand[1], .$r_scale()$.expand[2])
	r_rescale <- function(., x) rescale(x, c(0, 1), .$r_range())

	muncher <- function(.) TRUE
	transform <- function(., data) {
		r <- .$r_rescale(data[[.$r]])
		theta <- .$theta_rescale(data[[.$theta]])
		
		data$x <- r * sin(theta)
		data$y <- r * cos(theta)
	
		data
	}
	
	guide_inside <- function(., plot) {
		theta <- .$theta_rescale(.$theta_scale()$breaks())
		thetafine <- seq(0, 2*pi, length=100)
		
		r <- 1
		rfine <- .$r_rescale(.$r_scale()$breaks())
		
		gp <- gpar(fill=plot$grid.fill, col=plot$grid.colour)
		
		ggname("grill", gTree(children = gList(
			ggname("background", rectGrob(gp=gpar(fill=plot$grid.fill, col=NA))),
			ggname("major-angle", segmentsGrob(0, 0, r * sin(theta), r*cos(theta), gp=gp, default.units="native")),
			ggname("labels-angle", textGrob(.$theta_scale()$labels(), r * 1.05 * sin(theta), r * 1.05 * cos(theta), gp=gpar(col=plot$axis.colour), default.units="native")),
			ggname("major-radius", polylineGrob(rep(rfine, each=length(thetafine)) * sin(thetafine), rep(rfine, each=length(thetafine)) * cos(thetafine), default.units="native", gp=gp)),
			ggname("labels-radius", textGrob(.$r_scale()$labels(), 0.02, rfine + 0.04, default.units="native", gp=gpar(col=plot$axis.colour), hjust=0))
		)))
	}

	
	frange <- function(.) {
		list(
			x = expand_range(c(-1, 1), 0.1, 0),
			y = expand_range(c(-1, 1), 0.1, 0)
		)
	}
		
	guide_axes <- function(.) {
		list(
			x = ggaxis(c(-1, 1), "", "bottom", c(-1,1)),
			y = ggaxis(c(-1, 1), "", "left", c(-1,1))
		)
	}

	# Documetation -----------------------------------------------

	objname <- "polar"
	desc <- "Polar coordinates"
	icon <- function(.) circleGrob(r = c(0.1, 0.25, 0.45), gp=gpar(fill=NA))
	
	details <- "<p>The polar coordinate system is most commonly used for pie charts, which are a stacked bar chart in polar coordinates.</p>\n\n<p>This coordinate system has one argument, <code>theta</code>, which determines which variable is mapped to angle and which to radius.  Valid values are \"x\" and \"y\".</p>\n"
	
	examples <- function(.) {
		# See stat_bin and geom_bar for pie charts
		# Still very experimental, so a bit on the buggy side, but I'm
		# working on it.  Also need to deal properly with cyclical
		# variables
		
		qplot(length, rating, data=movies, geom=c("point", "smooth"), method="lm") + coord_polar()
	}

})
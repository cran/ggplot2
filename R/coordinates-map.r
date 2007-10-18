CoordMap <- proto(CoordCartesian, {
	new <- function(., projection="mercator", ...) {
		try_require("mapproj")
		.$proto(projection=projection, params=list(...))
	}
	
	muncher <- function(.) TRUE
	munch <- function(., data) .$transform(data)
	
	transform <- function(., data) {
		trans <- .$mproject(data[, c("x","y")])
		.$drange <- lapply(trans[c("x","y")], range, na.rm=TRUE)
		data.frame(trans[c("x","y")], data[, setdiff(names(data), c("x","y"))])
	}
	
	mproject <- function(., data) {
		suppressWarnings(do.call("mapproject", c(data, projection=.$projection, .$params)))
	}
	
	frange <- function(.) {
		expand <- .$expand()
		list(
			x = expand_range(.$drange$x, expand$x[1], expand$x[2]),
			y = expand_range(.$drange$y, expand$y[1], expand$y[2])
		)
	}
	
	guide_axes <- function(.) {
		list(
			x = ggaxis(c(-1, 1), "", "bottom", c(-1,1)),
			y = ggaxis(c(-1, 1), "", "left", c(-1,1))
		)
	}
	
	guide_inside <- function(., plot) {
		range <- list(
			x = expand_range(.$x()$frange(), 0.1),
			y = expand_range(.$y()$frange(), 0.1)
		)
		x <- grid.pretty(range$x)
		y <- grid.pretty(range$y)

		xgrid <- expand.grid(x = c(seq(range$x[1], range$x[2], len = 100), NA), y = y)
		ygrid <- expand.grid(y = c(seq(range$y[1], range$y[2], len = 100), NA), x = x)
		
		xlines <- .$mproject(xgrid)
		ylines <- .$mproject(ygrid)

		gp <- gpar(fill=plot$grid.fill, col=plot$grid.colour)
		ggname("grill", gTree(children = gList(
			ggname("background", rectGrob(gp=gpar(fill=plot$grid.fill, col=NA))),
			ggname("major-verticall", linesGrob(xlines$x, xlines$y, default.units="native", gp = gp)),
			ggname("major-horizontal", linesGrob(ylines$x, ylines$y, default.units="native", gp = gp))
		)))
	}	

	# Documetation -----------------------------------------------

	objname <- "map"
	desc <- "Map projections"
	icon <- function(.) {
		nz <- data.frame(map("nz", plot=FALSE)[c("x","y")])
		nz$x <- nz$x - min(nz$x, na.rm=TRUE)
		nz$y <- nz$y - min(nz$y, na.rm=TRUE)
		nz <- nz / max(nz, na.rm=TRUE)
		linesGrob(nz$x, nz$y, default.units="npc")
	}
	
	details <- "<p>This coordinate system provides the full range of map projections available in the mapproject package.</p>\n\n<p>This is still experimental, and if you have any advice to offer regarding a better (or more correct) way to do this, please let me know</p>\n"
	
	examples <- function(.) {
		try_require("maps")
		# Create a lat-long dataframe from the maps package
		nz <- data.frame(map("nz", plot=FALSE)[c("x","y")])
		(nzmap <- qplot(x, y, data=nz, geom="path"))
		
		nzmap + coord_map()
		nzmap + coord_map(project="cylindrical")
		nzmap + coord_map(project='azequalarea',orient=c(-36.92,174.6,0))
		
		states <- data.frame(map("state", plot=FALSE)[c("x","y")])
		(usamap <- qplot(x, y, data=states, geom="path"))
		usamap + coord_map()
		# See ?mapproject for coordinate systems and their parameters
		usamap + coord_map(project="gilbert")
		usamap + coord_map(project="orthographic")
		usamap + coord_map(project="stereographic")
		usamap + coord_map(project="conic", 30)
		usamap + coord_map(project="bonne", 50)
		usamap + coord_map(project="lagrange")
	}
})

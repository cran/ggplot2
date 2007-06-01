ScaleShape <- proto(ScaleDiscrete, expr={
	objname <- "shape"
	common <- NULL
	.input <- .output <- "shape"
	solid <- TRUE

	new <- function(., name=NULL, solid=TRUE) {
		proto(., name=name, solid=solid)
	}
	
	breaks <- function(.) {
		(if (.$solid) {
			c(16, 17, 15, 3, 7, 8)
		} else {
			c(1, 2, 0, 3, 7, 8)
		})[1:length(.$domain())]
	}

	max_levels <- function(.) 6
	guide_legend_geom <- function(.) GeomPoint
	
	examples <- function(.) {
		dsmall <- diamonds[sample(nrow(diamonds), 100), ]
		
		(d <- qplot(carat, price, data=diamonds, shape=cut))
		d + scale_shape(solid = TRUE) # the default
		d + scale_shape(solid = FALSE)
		d + scale_shape(name="Cut of diamond")
		d + scale_shape(name="Cut of\ndiamond")
		
		# To change order of levels, change order of 
		# underlying factor
		levels(dsmall$cut) <- c("Fair", "Good", "Very Good", "Premium", "Ideal")

		# Need to recreate plot to pick up new data
		qplot(price, carat, data=dsmall, shape=cut)

		# Or for short:
		d %+% dsmall
		
	}
}) 

ScaleSize <- proto(ScaleContinuous, expr={
	common <- NULL
	.input <- .output  <- "size"
	
	new <- function(., name=NULL, to=c(1, 5), guide="point") {
		proto(., name=name, .range=to, .grob=guide)
	}
	
	guide_legend_geom <- function(.) Geom$find(.$.grob)
	
	objname <- "size"
	desc <- "Size scale for continuous variable"
	examples <- function(.) {
		(p <- qplot(mpg, cyl, data=mtcars, size=cyl))
		p + scale_size("cylinders")
		p + scale_size("number\nof\ncylinders")
		
		p + scale_size(to = c(0, 10))
		p + scale_size(to = c(1, 2))

		# Map area, instead of width/radius
		# Perceptually, this is a little better
		p + scale_area()
		p + scale_area(to = c(1, 25))
		
		# Also works with factors, but not a terribly good
		# idea, unless your factor is ordered, as in this example
		qplot(mpg, cyl, data=mtcars, size=factor(cyl))
		
		# For lines, you need to tell that you want lines on the legend
		(p <- qplot(mpg, cyl, data=mtcars, size=cyl, geom="line"))
		p + scale_size(guide="line")
	}
	
})

ScaleSizeDiscrete <- proto(ScaleDiscrete, expr={
	common <- NULL
	objname <- "size_discrete"
	.input <- .output <- "size"
	desc <- "Size scale for discrete variables"

	frange <- function(.) {
		1:length(.$domain())
	}

	max_levels <- function(.) Inf
	guide_legend_geom <- function(.) GeomPoint
}) 
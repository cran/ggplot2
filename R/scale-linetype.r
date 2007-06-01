ScaleLinetype <- proto(ScaleDiscrete, expr={
	common <- NULL
	.input <- .output <- "linetype"

	frange <- function(.) (1:4)[1:length(.$domain())]
	max_levels <- function(.) 4
	guide_legend_geom <- function(.) GeomPath
	
	objname <- "linetype"
	desc <- "Create a scale for categorical line types"
	examples <- function() {
		# Fairly nonsensical example, but looking for better
		# sample data set
		qplot(wt, mpg, data=mtcars, geom="line", linetype=factor(cyl))
		
		# Force all points to be connected together
		qplot(wt, mpg, data=mtcars, geom="line", linetype=factor(cyl), group=1)
		
		# The linetype scale currently has no options, so there's
		# no point in adding it manually
	}
	
})

StatIdentity <- proto(Stat, {
	objname <- "identity" 
	desc <- "Identity statistic"
	
	default_geom <- function(.) GeomPoint
	calculate_groups <- function(., data, scales, ...) data
	icon <- function(.) textGrob("f(x) = x", gp=gpar(cex=1.2))
})

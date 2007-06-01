StatUnique <- proto(Stat, {
	objname <- "unique" 
	desc <- "Remove duplicates"
	
	default_geom <- function(.) GeomPoint
	
	calculate_groups <- function(., data, scales, ...) unique(data)
})

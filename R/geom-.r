Geom <- proto(TopLevel, expr={
	class <- function(.) "geom"

	parameters <- function(.) {
		params <- formals(get("draw", .))
		params <- params[setdiff(names(params), c(".","data","scales", "coordinates", "..."))]
		
		c(params, .$default_aes()[setdiff(names(.$default_aes()), names(params))])
	}
	
	default_aes <- function(.) {}
	default_pos <- function(.) PositionIdentity

	draw <- function(...) {}
	draw_groups <- function(., data, scales, coordinates, ...) {
		if (nrow(data) == 0) return(NULL)
		groups <- split(data, factor(data$group))
		grobs <- lapply(groups, function(group) .$draw(group, scales, coordinates, ...))
		
		gTree(
			children = do.call("gList", grobs), 
			cl=paste("geom", .$objname, sep="-")
		)
	}
	
	adjust_scales_data <- function(., scales, data) data
	
	new <- function(., aesthetics=aes(), data=NULL, stat=NULL, position=NULL, ...){
		layer(aesthetics=aesthetics, data=data, stat=stat, geom=., position=position, ...)
	}
	
	pprint <- function(., newline=TRUE) {
		cat("geom_", .$objname, ": ", clist(.$parameters()), sep="")
		if (newline) cat("\n")
	}
	
	# Html documentation ----------------------------------
	
	
		
	
})
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
		if (is.null(data) || nrow(data) == 0) return()
		groups <- split(data, factor(data$group))
		grobs <- lapply(groups, function(group) .$draw(group, scales, coordinates, ...))
		
		ggname(paste(.$objname, "s", sep=""), gTree(
			children = do.call("gList", grobs)
		))
	}
	
	adjust_scales_data <- function(., scales, data) data
	
	new <- function(., mapping=aes(), data=NULL, stat=NULL, position=NULL, ...){
		do.call("layer", list(mapping=mapping, data=data, stat=stat, geom=., position=position, ...))
	}
	
	pprint <- function(., newline=TRUE) {
		cat("geom_", .$objname, ": ", clist(.$parameters()), sep="")
		if (newline) cat("\n")
	}
	
	# Html documentation ----------------------------------
	
	
		
	
})
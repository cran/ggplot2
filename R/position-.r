# Position adjustment occurs over all groups within a geom
# They work only with discrete x scales and may affect x and y position.
# Should occur after statistics and scales have been applied.

Position <- proto(TopLevel, expr = {
	adjust <- function(., data, scales, ...) data
	class <- function(.) "position"
	
	new <- function(.) proto(.)
	
	pprint <- function(., newline=TRUE) {
		cat("position_", .$objname, ": ()", sep="")
		if (newline) cat("\n")
	}
})
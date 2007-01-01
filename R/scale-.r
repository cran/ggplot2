Scale <- proto(TopLevel, expr={
	.input <- ""
	.output <- ""
	common <- NULL	
	
	class <- function(.) "scale"
	
	new <- function(., name="Unknown") {
		proto(., name=name)
	}
	discrete <- function(.) FALSE
	
	clone <- function(.) {
		as.proto(.$as.list(), parent=.) 
	}

	find <- function(., output, only.documented = FALSE) {
		scales <- Scales$find_all()
		select <- sapply(scales, function(x) any(output %in% c(x$output(), get("common", x))))
		if (only.documented) select <- select & sapply(scales, function(x) get("doc", x))
		
		unique(scales[select])
	}


	accessors <- function(.) {
		objects <- Scale$find_all()
		name <- "scale"
		
		scale_with_var <- function(x, oldname, var) {
			objname <- get("objname", envir=x)
			
			output <- deparse(substitute(
				short <- function(...) obj$new(..., variable=var),
				list(
					short = as.name(paste(name, var, objname, sep="_")),
					obj = as.name(oldname),
					var = var
				) 
			), width.cutoff = 500)
		}
		
		scale <- function(x, oldname) {
			objname <- get("objname", envir=x)
			
			output <- deparse(substitute(
				short <- obj$new,
				list(
					short = as.name(paste(name, objname, sep="_")),
					obj = as.name(oldname)
				) 
			), width.cutoff = 500)
			output <- paste(output, "\n", sep="")
		}
		
		
		mapply(function(object, name) {
			if(!is.null(object$common)) {
				paste(paste(sapply(object$common, function(x) scale_with_var(object, name, x)), sep="", collapse="\n"), "\n", sep="")
			} else {
				scale(object, name)
			}
		}, objects, names(objects))
	}
		# For all continuous scales ScaleZzz
		# create scale_x_zzz and and scale_y_zzz
		# scale_(x|y)_transform(...) = ScaleContinuous$new(variable="x|y", ...) 

	input <- function(.) .$.input
	output <- function(.) .$.output
	domain <- function(.) .$.domain
	
	# Train scale from a data frame
	train_df <- function(., df) {
		.$train(df[[.$input()]])
	}

	transform_df <- function(., df) {
		df <- data.frame(.$stransform(df[[.$input()]]))
		if (ncol(df) == 0) return(NULL)
		names(df) <- .$output()
		df
	}

	# Map values from a data.frame.	 Returns data.frame
	map_df <- function(., df) {
		df <- data.frame(.$map(df[[.$input()]]))
		names(df) <- .$output()
		df
	}
	
	pprint <- function(., newline=TRUE) {
		clist <- function(x) paste(x, collapse=",")
		
		cat("scale_", .$objname, ": ", clist(.$input()),	 " -> ", clist(.$output()), sep="")
		if (!is.null(.$domain())) {
			cat(" (", clist(.$domain()), " -> ", clist(.$frange()), ")", sep="")
		}
		if (newline) cat("\n") 
	}
	
	guide_legend_geom <- function(.) GeomPoint
	
	# Guides
	# ---------------------------------------------
	
	guide_legend <- function(.) {
		if (identical(., Scale)) return(NULL)
		
		labels <- rev(.$labels())
		breaks <- rev(.$rbreaks())

		if (is.null(breaks)) return(NULL)
		grob <- function(data) .$guide_legend_geom()$draw_legend(data)

		title <- textGrob(.$name, x = 0, y = 0.5, just = c("left", "centre"), 
			gp=gpar(fontface="bold"), name="legend-title"
		)

		nkeys <- length(labels)
		hgap <- vgap <- unit(0.3, "lines")

		values <- data.frame(breaks)
		names(values) <- .$output()
		
		label.heights <- do.call("unit.c", lapply(labels, function(x) stringHeight(as.expression(x))))
		label.widths <- do.call("unit.c", lapply(labels, function(x) stringWidth(as.expression(x))))
		
		widths <- unit.c(
			unit(1.4, "lines"), 
			hgap, 
			max(unit.c(unit(1, "grobwidth", title) - unit(1.4, "lines") - 2 * hgap), label.widths),
			hgap
		)

		heights <- unit.c(
			unit(1, "grobheight", title) + 2 * vgap, 
			unit.pmax(unit(1.4, "lines"), vgap + label.heights)
		)	

		# Make a table
	  legend.layout <- grid.layout(nkeys + 1, 4, widths = widths, heights = heights, just=c("left","top"))
	  fg <- frameGrob(layout = legend.layout, name="legend")
		#fg <- placeGrob(fg, rectGrob(gp=gpar(fill="NA", col="NA", name="legend-background")))

		fg <- placeGrob(fg, title, col=1:2, row=1)
		for (i in 1:nkeys) {
			df <- as.list(values[i,, drop=FALSE])
			fg <- placeGrob(fg, editGrob(grob(df), name="legend-key"), col = 1, row = i+1)
			fg <- placeGrob(fg, textGrob(labels[[i]], x = 0, y = 0.5, just = c("left", "centre"), name="legend-label"), col = 3, row = i+1)
		}

		fg
	}
})





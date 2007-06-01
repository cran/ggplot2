# ggsave
# Save a ggplot with sensible defaults
# 
# @arguments plot to save
# @arguments file name/path of plot
# @arguments device to use, automatically extract from file name extension
# @arguments scaling factor
# @arguments width (in inches)
# @arguments height (in inches)
# @arguments grid to use, normal for white on pale grey, print for pale grey on white
# @arguments dpi to use for raster graphics
# @arguments other arguments passed to device function
# @keyword file 
ggsave <- function(plot = .last_plot, filename=default_name(plot), device=default_device(filename), scale=1, width=par("din")[1], height=par("din")[2], grid="normal", dpi=96, ...) {

	ps <- function(..., width, height) grDevices:::ps(..., width=width, height=height)
	tex <- function(..., width, height) grDevices:::pictex(..., width=width, height=height)
	pdf <- function(..., version="1.4") grDevices:::pdf(..., version=version)

	# if (require("cairoDevice", quiet=TRUE)) Cairo(..., width=width*dpi, height=height*dpi, surface="png") else
	png <- function(..., width, height)  grDevices:::png(..., width=width*dpi, height=height*dpi)
	# if (require("cairoDevice", quiet=TRUE)) Cairo(..., width=width*dpi, height=height*dpi, surface="jpeg") else
	jpeg <- function(..., width, height)  grDevices:::jpeg(..., width=width*dpi, height=height*dpi)
	jpeg <- function(..., width, height) grDevices:::bmp(..., width=width*dpi, height=height*dpi)
	wmf <- function(..., width, height) grDevices:::win.metafile(..., width=width, height=height)
	
	default_name <- function(plot) { 
		title <- if (is.null(plot$title) || nchar(plot$title) == 0) "ggplot" else plot$title
		clean <- tolower(gsub("[^a-zA-Z]+", "_", title))
		paste(clean, ".pdf", sep="")
	}
	
	default_device <- function(filename) {
		pieces <- strsplit(filename, "\\.")[[1]]
		ext <- tolower(pieces[length(pieces)])
		match.fun(ext)
	}

	width <- width * scale
	height <- height * scale
	
	if (grid != "normal") {
		plot$grid.colour = "grey80"
		plot$grid.fill = "white"
	}
	
	device(file=filename, width=width, height=height, ...)
	print(plot)
	a <- capture.output(dev.off())
	
}
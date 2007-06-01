GeomSegment <- proto(Geom, {
	draw <- function(., data, scales, coordinates, ...) {
		munched <- coordinates$munch(data)

		with(munched, 
			segmentsGrob(x, y, xend, yend, default.units="native",
			gp=gpar(col=colour, lwd=size, lty=linetype)) #, name="path"
		)
	}
	
	objname <- "segment"
	desc <- "Single line segments"
	icon <- function(.) segmentsGrob(c(0.1, 0.3, 0.5, 0.7), c(0.3, 0.5, 0.1, 0.9), c(0.2, 0.5, 0.7, 0.9), c(0.8, 0.7, 0.4, 0.3))

	seealso <- list(
		geom_path = GeomPath$desc,
		geom_line = GeomLine$desc
	)

	default_stat <- function(.) StatIdentity
	default_aes <- function(.) aes(colour="black", size=0, linetype=1)
})


GeomDensity <- proto(GeomArea, {
	objname <- "density"
	desc <- "Display a smooth density estimate"
	icon <- function(.) {
		x <- seq(0, 1, length=80)
		y <- dnorm(x, mean=0.5, sd=0.15)
		linesGrob(x, 0.05 + y / max(y) * 0.9, default="npc")
	}
	default_stat <- function(.) StatDensity
	seealso <- list(
		geom_histogram = "for the histogram"
	)	

	default_aes <- function(.) defaults(aes(fill=NA, weight=1, colour="black"), GeomRibbon$default_aes())

	examples <- function(.) {}
})

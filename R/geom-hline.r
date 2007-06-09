GeomHline <- proto(Geom, {
	new <- function(., mapping=aes(), data=NULL, intercept=1, ...) {
		if (missing(data)) {
			data <- data.frame(intercept = intercept)
		}
		mapping <- defaults(mapping, aes(intercept=intercept))
		layer(mapping=mapping, data=data, geom = ., geom_params = list(...))
	}

	draw <- function(., data, scales, coordinates, ...) {
		xrange <- coordinates$frange()$x

		ggname(.$my_name(), gTree(children=do.call(gList, lapply(1:nrow(data), function(i) {
			row <- data[c(i, i), ]
			row$x <- xrange
			row$y <- row$intercept

			GeomPath$draw(row, scales, coordinates)
		}))))
	}

	objname <- "hline"
	desc <- "Line, horizontal"
	icon <- function(.) linesGrob(c(0, 1), c(0.5, 0.5))
	
	default_stat <- function(.) StatIdentity
	default_aes <- function(.) c(GeomPath$default_aes(), aes(intercept=0))
	
	seealso <- list(
		geom_vline = "for vertical lines",
		geom_abline = "for lines defined by a slope and intercept"
	)
	
	examples <- function(.) {
		p <- ggplot(mtcars, aes(x = wt, y=mpg)) + geom_point()

		p + geom_hline(intercept=20)
		p + geom_hline(intercept=seq(10, 30, by=5))
		p + geom_hline(intercept=mean(mtcars$mpg), size=2)
	}	
})

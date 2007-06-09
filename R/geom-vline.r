GeomVline <- proto(Geom, {
	new <- function(., mapping=aes(), data=NULL, intercept=1, ...) {
		if (missing(data)) {
			data <- data.frame(intercept = intercept)
		}
		mapping <- defaults(mapping, aes(intercept=intercept))
		layer(mapping=mapping, data=data, geom = ., geom_params = list(...))
	}

	draw <- function(., data, scales, coordinates, ...) {
		yrange <- coordinates$frange()$y

		ggname(.$my_name(), gTree(children = do.call(gList, lapply(1:nrow(data), function(i) {
			row <- data[c(i, i), ]
			row$y <- yrange
			row$x <- row$intercept

			GeomPath$draw(row, scales, coordinates)
		}))))
	}

	objname <- "vline"
	desc <- "Line, vertical"
	icon <- function(.) linesGrob(c(0.5, 0.5), c(0, 1))
	
	default_stat <- function(.) StatIdentity
	default_aes <- function(.) c(GeomPath$default_aes(), aes(intercept=0))

	seealso <- list(
		geom_hline = "for horizontal lines",
		geom_abline = "for lines defined by a slope and intercept"
	)
	
	examples <- function(.) {
		# Fixed lines
		p <- ggplot(mtcars, aes(x = wt, y=mpg)) + geom_point()
		p + geom_vline(intercept=5)
		p + geom_vline(intercept=2:5)
		p + geom_vline(intercept=2:5, colour="green")
		p + geom_vline(intercept=mean(mtcars$wt), size=2)
		
		# Lines from data
		p <- ggplot(mtcars, aes(x = wt, y=mpg)) + facet_grid(. ~ cyl) + geom_point()
		df <- data.frame(cyl=c(4,6,8), intercept=tapply(mtcars$wt, mtcars$cyl, mean))
		p + geom_vline(data=df)
		p + geom_vline(data=df, colour="red")
		
	}	
})

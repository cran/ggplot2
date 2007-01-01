GeomPath <- proto(Geom, {
	draw_groups <- function(., ...) .$draw(...)

	draw <- function(., data, scales, coordinates, ...) {
		if (is.null(data$group)) data$group <- 1
		munched <- coordinates$munch(data)
		
		n <- nrow(munched)
		start <- unlist(tapply(1:n, munched$group, function(x) x[-length(x)]))
		end <- unlist(tapply(1:n, munched$group, function(x) x[-1]))
		
		if (n == 1) return()
		with(munched, 
			segmentsGrob(x[start], y[start], x[end], y[end], default.units="native",
			gp=gpar(col=colour[start], lwd=size[start], lty=linetype[start])) #, name="path"
		)
	}

	draw_legend <- function(., data, ...) {
		data <- aesdefaults(data, .$default_aes(), list(...))

		with(data, 
		  segmentsGrob(0, 0.5, 1, 0.5, default.units="npc",
		  gp=gpar(col=colour, lwd=size, lty=linetype))
		)
	}
	
	objname <- "path"
	desc <- "Connect observations, in original order"

	default_stat <- function(.) StatIdentity
	default_aes <- function(.) aes(colour="black", size=1, linetype=1)
	icon <- function(.) linesGrob(c(0.2, 0.4, 0.8, 0.6, 0.5), c(0.2, 0.7, 0.4, 0.1, 0.5))
	
	seealso <- list(
		geom_line = "Functional (ordered) lines", 
		geom_polygon = "Filled paths (polygons)",
		geom_segments = "Line segments"
	)

	examples <- function(.) {
		# Generate data
		myear <- do.call(rbind, by(movies, movies$year, function(df) data.frame(year=df$year[1], mean.length = mean(df$length), mean.rating=mean(df$rating))))
		p <- ggplot(myear, aes(x=mean.length, y=mean.rating))
		p + geom_path()

		# Add aesthetic mappings
		p + geom_path(aes(size=year))
		p + geom_path(aes(colour=year))
		
		# Change scale
		p + geom_path(aes(size=year)) + scale_size(to=c(1, 3))

		# Set aesthetics to fixed value
		p + geom_path(colour = "green")
		
		# Use qplot instead
		qplot(mean.length, mean.rating, data=myear, geom="path")
	}	
})


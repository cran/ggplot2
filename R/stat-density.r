StatDensity <- proto(Stat, {
	calculate <- function(., data, scales, adjust=1, kernel="gaussian", trim=FALSE, ...) {
		n <- nrow(data)
		if (is.null(data$weight)) data$weight <- rep(1, n) / n

		dens <- density(data$x, adjust=adjust, kernel=kernel, weight=data$weight)
		densdf <- as.data.frame(dens[c("x","y")])

	  densdf$scaled <- densdf$y / max(densdf$y) #* max(data$x)
	  if (trim) densdf <- subset(densdf, x > min(data$x) & x < max(data$x))

		rename(densdf, c(y = "density"))
	}

	objname <- "density" 
	desc <- "Density estimation, 1D"
	icon <- function(.) GeomDensity$icon()

	desc_params <- list(
		adjust = "see \\code{\\link{density}} for details",
		kernel = "kernel used for density estimation, see \\code{\\link{density}} for details"
	)
	desc_output <- list(
		y = "density estimate",
		scaled = "density estimate, scaled to maximum of 1"
	)

	seealso <- list(
		stat_bin = "for the histogram",
		density = "for details of the algorithm used"
	)
	
	default_geom <- function(.) GeomArea
	default_aes <- function(.) aes(y = ..density.., fill=NA)

	examples <- function(.) {
		m <- ggplot(movies, aes(x=rating))
		m + stat_density()
		
		# Adjust parameters
		m + stat_density(kernel = "rectangular")
		m + stat_density(kernel = "biweight") 
		m + stat_density(kernel = "epanechnikov")
		m + stat_density(adjust=1/5) # Very rough
		m + stat_density(adjust=5) # Very smooth
		
		# Adjust aesthetics
		m + stat_density(aes(colour=factor(Drama)), size=2, fill=NA)
		# Scale so peaks have same height:
		m + stat_density(aes(colour=factor(Drama), y = ..scaled..), size=2, fill=NA)

		m + stat_density(colour="darkgreen", size=2)
		m + stat_density(colour="darkgreen", size=2, fill=NA)
		m + stat_density(colour="darkgreen", size=2, fill="green")
		
		# Change scales
		(m <- ggplot(movies, aes(x=votes)) + stat_density(trim = TRUE))
		m + scale_x_log10()
		m + coord_trans(x="log10")
		m + scale_x_log10() + coord_trans(x="log10")
		
		# Also useful with
		m + stat_bin()

		# Need to be careful with weighted data
		m <- ggplot(movies, aes(x=rating, weight=votes))
		m + geom_histogram(aes(y = ..count..)) + stat_density(fill=NA)

		m <- ggplot(movies, aes(x=rating, weight=votes/sum(votes)))
		m + geom_histogram(aes(y=..density..)) + stat_density(fill=NA, colour="black")

		movies$decade <- round_any(movies$year, 10)
		m <- ggplot(movies, aes(x=rating, colour=decade, group=decade)) 
		m + stat_density(fill=NA)
		
		# Use qplot instead
		qplot(length, data=movies, geom="density", weight=rating)
		qplot(length, data=movies, geom="density", weight=rating/sum(rating))
	}	
})

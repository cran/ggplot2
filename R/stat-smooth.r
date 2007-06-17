StatSmooth <- proto(Stat, {
	calculate <- function(., data, scales, method=loess, formula=y~x, se = TRUE, n=80, fullrange=FALSE, xseq = NULL, level=0.95, ...) {
		if (nrow(data) < 2) return(NULL)
		if (is.null(data$weight)) data$weight <- 1
		
		if (is.null(xseq)) {
			range <- if (fullrange) scales$get_scales("x")$frange() else range(data$x, na.rm=TRUE)	
			xseq <- seq(range[1], range[2], length=n)
		}
		if (is.character(method)) method <- match.fun(method)
		
		params <- list(...)
		model.params <- params[intersect(names(formals(method)), names(params))]
		
		method.special <- function(...) method(formula, data=data, weights=weight, ...)
		model <- do.call(method.special, model.params)
		pred <- predict(model, data.frame(x=xseq), se=se, type="response")

		if (se) {
			std <- qnorm(level/2 + 0.5)
			data.frame(
				x = xseq, y = as.vector(pred$fit),
				min = as.vector(pred$fit - std * pred$se), 
				max = as.vector(pred$fit + std * pred$se),
				se = as.vector(pred$se)
			)
		} else {
			data.frame(x = xseq, y = as.vector(pred))
		}
	}
	
	objname <- "smooth" 
	desc <- "Add a smoother"
	details <- "Aids the eye in seeing patterns in the presence of overplotting."
	icon <- function(.) GeomSmooth$icon()
	
	default_geom <- function(.) GeomSmooth
	desc_params <- list(
		method = "smoothing method (function) to use, eg. lm, glm, gam, loess, rlm",
		formula =  "formula to use in smoothing function, eg. y ~ x, y ~ poly(x, 2), y ~ log(x)",
		se = "display one standard error on either side of fit? (true by default)",
		fullrange = "should the fit span the full range of the plot, or just the data",
		level = "level of confidence interval to use",
		n = "number of points to evaluate smoother at",
		xseq = "exact points to evaluate smooth at, overrides n",
		"..." = "other arguments are passed to smoothing function"
	)
	desc_output <- list(
		"y" = "predicted value",
		"min" = "lower pointwise confidence interval around the mean",
		"max" = "upper pointwise confidence interval around the mean",
		"se" = "standard error"
	)
	
	examples <- function(.) {
		c <- ggplot(mtcars, aes(y=wt, x=qsec))
		c + stat_smooth() 
		c + stat_smooth() + geom_point()

		# Adjust parameters
		c + stat_smooth(se = FALSE) + geom_point()

		c + stat_smooth(span = 0.9) + geom_point()	
		c + stat_smooth(method = "lm") + geom_point()	
		c + stat_smooth(method = lm, formula= y ~ ns(x,3)) + geom_point()	
		c + stat_smooth(method = rlm, formula= y ~ ns(x,3)) + geom_point()	
		
		# Add aesthetic mappings
		c + stat_smooth(fill="blue", colour="darkblue", size=2)
		c + stat_smooth(fill=alpha("blue", 0.2), colour="darkblue", size=2)
		c + geom_point() + stat_smooth(fill=alpha("blue", 0.2), colour="darkblue", size=2)
		
		# Smoothers for subsets
		c <- ggplot(mtcars, aes(y=wt, x=mpg), . ~ cyl)
		c + stat_smooth(method=lm) + geom_point() 
		c + stat_smooth(method=lm, fullrange=T) + geom_point() 
		
		# Geoms and stats are automatically split by aesthetics that are factors
		c <- ggplot(mtcars, aes(y=wt, x=mpg, colour=factor(cyl)))
		c + stat_smooth(method=lm) + geom_point() 
		c + stat_smooth(method=lm, fullrange=TRUE, fill=alpha("black", 0.1)) + geom_point() 

		# Use qplot instead
		qplot(qsec, wt, data=mtcars, geom=c("smooth", "point"))
		
		# Example with logistic regression
		data("kyphosis", package="rpart")
		qplot(Age, Kyphosis, data=kyphosis)
		qplot(Age, Kyphosis, data=kyphosis, position="jitter")
		qplot(Age, Kyphosis, data=kyphosis, position=position_jitter(y=5))

		qplot(Age, as.numeric(Kyphosis) - 1, data=kyphosis) + stat_smooth(method="glm", family="binomial")
		qplot(Age, as.numeric(Kyphosis) - 1, data=kyphosis) + stat_smooth(method="glm", family="binomial", fill="grey70")
	}
})

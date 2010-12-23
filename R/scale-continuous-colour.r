ScaleGradient <- proto(ScaleContinuous, expr={
  aliases <- c("scale_colour_continuous", "scale_fill_continuous", "scale_color_continuous", "scale_color_gradient")

  new <- function(., name = NULL, low = "#3B4FB8", high = "#B71B1A", space = "rgb", ...) {

    .super$new(., name = name, low = low, high = high, space = space, ...)
  }
  
  map <- function(., x) {
    ramp  <- colorRamp(c(.$low, .$high),  space=.$space, interpolate="linear")

    x <- rescale(x, from = .$input_set(), to = c(0, 1))
    nice_ramp(ramp, x)
  }
    
  output_breaks <- function(.) {
    .$map(.$input_breaks()) 
  }
  
  common <- c("colour", "fill")

  # Documentation -----------------------------------------------
  
  objname <- "gradient"
  desc <- "Smooth gradient between two colours"
  icon <- function(.) {
    g <- scale_fill_gradient()
    g$train(1:5)
    rectGrob(c(0.1, 0.3, 0.5, 0.7, 0.9), width=0.21, 
      gp=gpar(fill=g$map(1:5), col=NA)
    )    
  }


  desc_params <- list(
    low = "colour at low end of scale", 
    high = "colour at high end of scale",
    space = "colour space to interpolate through, rgb or Lab, see ?colorRamp for details",
    interpolate = "type of interpolation to use, linear or spline, see ?colorRamp for more details"
  )
  seealso <- list(
    "scale_gradient2" = "continuous colour scale with midpoint",
    "colorRamp" = "for details of interpolation algorithm"
  )
  
  examples <- function(.) {
    # It's hard to see, but look for the bright yellow dot 
    # in the bottom right hand corner
    dsub <- subset(diamonds, x > 5 & x < 6 & y > 5 & y < 6)
    (d <- qplot(x, y, data=dsub, colour=z))
    # That one point throws our entire scale off.  We could
    # remove it, or manually tweak the limits of the scale
    
    # Tweak scale limits.  Any points outside these
    # limits will not be plotted, but will continue to affect the 
    # calculate of statistics, etc
    d + scale_colour_gradient(limits=c(3, 10))
    d + scale_colour_gradient(limits=c(3, 4))
    # Setting the limits manually is also useful when producing
    # multiple plots that need to be comparable
    
    # Alternatively we could try transforming the scale:
    d + scale_colour_gradient(trans = "log")
    d + scale_colour_gradient(trans = "sqrt")
    
    # Other more trivial manipulations, including changing the name
    # of the scale and the colours.

    d + scale_colour_gradient("Depth")
    d + scale_colour_gradient(expression(Depth[mm]))
    
    d + scale_colour_gradient(limits=c(3, 4), low="red")
    d + scale_colour_gradient(limits=c(3, 4), low="red", high="white")
    # Much slower
    d + scale_colour_gradient(limits=c(3, 4), low="red", high="white", space="Lab")
    d + scale_colour_gradient(limits=c(3, 4), space="Lab")
    
    # scale_fill_continuous works similarly, but for fill colours
    (h <- qplot(x - y, data=dsub, geom="histogram", binwidth=0.01, fill=..count..))
    h + scale_fill_continuous(low="black", high="pink", limits=c(0,3100))
  }
  
  
})

ScaleGradient2 <- proto(ScaleContinuous, expr={  
  new <- function(., name = NULL, low = muted("red"), mid = "white", high = muted("blue"), midpoint = 0, space = "rgb", ...) {
    .super$new(., name = name, low = low, mid = mid, high = high,
      midpoint = midpoint, space = space, ...)
  }
  
  aliases <- c("scale_color_gradient2")
  map <- function(., x) {
    ramp  <- colorRamp(c(.$low, .$mid, .$high), space=.$space,
      interpolate="linear")
    
    rng <- .$output_set()  - .$midpoint
    extent <- max(abs(rng))
    
    domain <- .$input_set()
    x[x < domain[1] | x > domain[2]] <- NA

    x <- x - .$midpoint
    x <- x / extent / 2 + 0.5
    
    nice_ramp(ramp, x)
  }
  
  objname <-"gradient2"
  common <- c("colour", "fill")
  desc <- "Smooth gradient between three colours (high, low and midpoints)"

  output_breaks <- function(.) .$map(.$input_breaks())

  icon <- function(.) {
    g <- scale_fill_gradient2()
    g$train(1:5 - 3)
    rectGrob(c(0.1, 0.3, 0.5, 0.7, 0.9), width=0.21, 
      gp=gpar(fill=g$map(1:5 - 3), col=NA)
    )
  }

  desc_params <- list(
    low = "colour at low end of scale", 
    mid = "colour at mid point of scale",
    high = "colour at high end of scale",
    midpoint = "position of mid point of scale, defaults to 0",
    space = "colour space to interpolate through, rgb or Lab, see ?colorRamp for details",
    interpolate = "type of interpolation to use, linear or spline, see ?colorRamp for more details"
  )
  seealso <- list(
    "scale_gradient" = "continuous colour scale",
    "colorRamp" = "for details of interpolation algorithm"
  )
  
  examples <- function(.) {
    dsub <- subset(diamonds, x > 5 & x < 6 & y > 5 & y < 6)
    dsub$diff <- with(dsub, sqrt(abs(x-y))* sign(x-y))
    (d <- qplot(x, y, data=dsub, colour=diff))
    
    d + scale_colour_gradient2()
    # Change scale name
    d + scale_colour_gradient2(expression(sqrt(abs(x - y))))
    d + scale_colour_gradient2("Difference\nbetween\nwidth and\nheight")

    # Change limits and colours
    d + scale_colour_gradient2(limits=c(-0.2, 0.2))

    # Using "muted" colours makes for pleasant graphics 
    # (and they have better perceptual properties too)
    d + scale_colour_gradient2(low="red", high="blue")
    d + scale_colour_gradient2(low=muted("red"), high=muted("blue"))

    # Using the Lab colour space also improves perceptual properties
    # at the price of slightly slower operation
    d + scale_colour_gradient2(space="Lab")
    
    # About 5% of males are red-green colour blind, so it's a good
    # idea to avoid that combination
    d + scale_colour_gradient2(high=muted("green"))

    # We can also make the middle stand out
    d + scale_colour_gradient2(mid=muted("green"), high="white", low="white")
    
    # or use a non zero mid point
    (d <- qplot(carat, price, data=diamonds, colour=price/carat))
    d + scale_colour_gradient2(midpoint=mean(diamonds$price / diamonds$carat))
    
    # Fill gradients work much the same way
    p <- qplot(letters[1:5], 1:5, fill= c(-3, 3, 5, 2, -2), geom="bar")
    p + scale_fill_gradient2("fill")
    # Note how positive and negative values of the same magnitude
    # have similar intensity
  }
  
})


ScaleGradientn <- proto(ScaleContinuous, expr={  
  new <- function(., name=NULL, colours, values = NULL, rescale = TRUE, space="rgb", ...) {
    
    .super$new(., 
      name = name, 
      colours = colours, values = values, rescale = rescale, 
      space = space,  ..., 
    )
  }

  aliases <- c("scale_color_gradientn")
  
  map <- function(., x) {
    if (.$rescale) x <- rescale(x, c(0, 1), .$input_set())
    if (!is.null(.$values)) {
      xs <- seq(0, 1, length = length(.$values))      
      f <- approxfun(.$values, xs)
      x <- f(x)
    }
    ramp <- colorRamp(.$colours, space=.$space, interpolate="linear")
    nice_ramp(ramp, x)
  }
  
  objname <- "gradientn"
  common <- c("colour", "fill")
  desc <- "Smooth gradient between n colours"

  output_breaks <- function(.) .$map(.$input_breaks())

  icon <- function(.) {
    g <- scale_fill_gradientn(colours = rainbow(7))
    g$train(1:5)
    rectGrob(c(0.1, 0.3, 0.5, 0.7, 0.9), width=0.21, 
      gp=gpar(fill = g$map(1:5), col=NA)
    )
  }

  desc_params <- list(
    space = "colour space to interpolate through, rgb or Lab, see ?colorRamp for details",
    interpolate = "type of interpolation to use, linear or spline, see ?colorRamp for more details"
  )
  seealso <- list(
    "scale_gradient" = "continuous colour scale with midpoint",
    "colorRamp" = "for details of interpolation algorithm"
  )
  
  examples <- function(.) {    
    # scale_colour_gradient make it easy to use existing colour palettes

    dsub <- subset(diamonds, x > 5 & x < 6 & y > 5 & y < 6)
    dsub$diff <- with(dsub, sqrt(abs(x-y))* sign(x-y))
    (d <- qplot(x, y, data=dsub, colour=diff))

    d + scale_colour_gradientn(colour = rainbow(7))
    breaks <- c(-0.5, 0, 0.5)
    d + scale_colour_gradientn(colour = rainbow(7), 
      breaks = breaks, labels = format(breaks))
    
    d + scale_colour_gradientn(colour = topo.colors(10))
    d + scale_colour_gradientn(colour = terrain.colors(10))

    # You can force them to be symmetric by supplying a vector of 
    # values, and turning rescaling off
    max_val <- max(abs(dsub$diff))
    values <- seq(-max_val, max_val, length = 11)

    d + scale_colour_gradientn(colours = topo.colors(10), 
      values = values, rescale = FALSE)
    d + scale_colour_gradientn(colours = terrain.colors(10), 
      values = values, rescale = FALSE)
    

  }
  
})
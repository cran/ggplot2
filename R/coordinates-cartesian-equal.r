CoordEqual <- proto(CoordCartesian, {

  new <- function(., ratio=1) {
    list(.$proto(ratio=ratio), opts(aspect.ratio = ratio))
  }

  frange <- function(.) {
    xlim <- .$x()$frange()
    ylim <- .$y()$frange()
    
    xr <- diff(xlim)
    yr <- diff(ylim)
    
    desired <- .$ratio
    actual  <- yr / xr
    
    ad <- actual/desired
    
    if (desired < actual) {
      # desired is shorter/fatter than actual - expand x
      xratio <- xr * ad
      yratio <- yr   
    } else {
      # desired is taller/skinnier than actual - expand y
      xratio <- xr
      yratio <- yr / ad
    }
    stopifnot(xratio >= xr)
    stopifnot(yratio >= yr)
    stopifnot(all.equal(yratio / xratio, desired))

    xlim <- mean(xlim) + xratio * c(-0.5, 0.5)
    ylim <- mean(ylim) + yratio * c(-0.5, 0.5)
    
    expand <- .$expand()
    list(
      x = expand_range(xlim, expand$x[1], expand$x[2]),
      y = expand_range(ylim, expand$y[1], expand$y[2])
    )
  }
  
  guide_axes <- function(.) {
    range <- .$frange()
    list(
      x = ggaxis(grid.pretty(range$x), grid.pretty(range$x), "bottom", range$x),
      y = ggaxis(grid.pretty(range$y), grid.pretty(range$y), "left", range$y)
    )
  }

  guide_inside <- function(., plot) {
    range <- .$frange()
    breaks <- list(
      x = list(major = grid.pretty(range$x), minor = .$x()$minor_breaks(b = grid.pretty(range$x))),
      y = list(major = grid.pretty(range$y), minor = .$y()$minor_breaks(b = grid.pretty(range$y)))
    )
    
    draw_grid(plot, breaks)
  }

  # Documetation -----------------------------------------------

  objname <- "equal"
  desc <- "Equal scale cartesian coordinates"
  icon <- function(.) textGrob("=", gp=gpar(cex=3))  
  
  details <- "<p>An equal scale coordinate system plays a similar role to ?eqscplot in MASS, but it works for all types of graphics, not just scatterplots.</p>\n<p>This coordinate system has one parameter, <code>ratio</code>, which specifies the ratio between the x and y scales. An aspect ratio of two means that the plot will be twice as high as wide.  An aspection ratio of 1/2 means that the plot will be twice as wide as high.   By default, the aspect.ratio of the plot will also be set to this value.</p>\n"
  
  examples <- function(.) {
    # coord_equal ensures that the ranges of axes are equal to the
    # specified ratio (1 by default, indicating equal ranges).
    
    qplot(mpg, wt, data=mtcars) + coord_equal(ratio=1)
    qplot(mpg, wt, data=mtcars) + coord_equal(ratio=5)
    qplot(mpg, wt, data=mtcars) + coord_equal(ratio=1/5)
    
    # Resize the plot, and you'll see that the specified aspect ratio is 
    # mantained
  }  

  
})



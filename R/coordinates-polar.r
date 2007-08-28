CoordPolar <- proto(Coord, {

  new <- function(., theta="x") {
    theta <- if (theta == "x") "x" else "y"
    r <- if (theta == "x") "y" else "x"

    c(.$proto(theta = theta, r = r), list(opts(aspect.ratio = 1)))
  }

  theta_scale <- function(.) .$.scales$get_scales(.$theta)
  theta_range <- function(.) {
    if (.$theta_discrete()) {
      expand_range(.$theta_scale()$frange(), 0,0.5)
    } else {
      expand_range(.$theta_scale()$frange(), 0,0)
    }
  }
  theta_rescale <- function(., x) rescale(x, c(0, 2 * pi), .$theta_range())
  theta_discrete <- function(., x) .$.scales$get_scales(.$theta)$objname == "discrete"
  
  xlabel <- function(., gp) textGrob(NULL)
  ylabel <- function(., gp) textGrob(NULL)
  
  r_scale <- function(.) .$.scales$get_scales(.$r)
  r_range <- function(.) {
    if (.$r_discrete()) {
      expand_range(.$r_scale()$frange(), 0,0.5)
    } else {
      expand_range(.$r_scale()$frange(), 0,0)
    }
  }
  
  r_rescale <- function(., x) rescale(x, c(0, 0.9), .$r_range())
  r_discrete <- function(., x) .$.scales$get_scales(.$r)$objname == "discrete"

  muncher <- function(.) TRUE
  transform <- function(., data) {
    r <- .$r_rescale(data[[.$r]])
    theta <- .$theta_rescale(data[[.$theta]])
    
    data$x <- r * sin(theta)
    data$y <- r * cos(theta)
  
    data
  }
  
  guide_inside <- function(., plot) {
    theta <- .$theta_rescale(.$theta_scale()$breaks()) %% (2 * pi)
    thetamin <- .$theta_rescale(.$theta_scale()$minor_breaks())
    thetafine <- seq(0, 2*pi, length=100)
    
    r <- 1
    rfine <- .$r_rescale(.$r_scale()$breaks())
    
    gp <- gpar(fill=plot$grid.fill, col=plot$grid.colour)
    
    ggname("grill", gTree(children = gList(
      ggname("background", rectGrob(gp=gpar(fill=plot$grid.fill, col=NA))),
      ggname("major-angle", segmentsGrob(0, 0, 5 * sin(theta), 5*cos(theta), gp=gp, default.units="native")),
      ggname("minor-angle", segmentsGrob(0, 0, 5 * sin(thetamin), 5*cos(thetamin), gp=gp, default.units="native")),
      ggname("labels-angle", textGrob(.$theta_scale()$labels(), r * 1.1 * sin(theta), r * 1.1 * cos(theta), gp=gpar(col=plot$axis.colour), default.units="native")),
      ggname("major-radius", polylineGrob(rep(rfine, each=length(thetafine)) * sin(thetafine), rep(rfine, each=length(thetafine)) * cos(thetafine), default.units="native", gp=gp))# ,
      #       ggname("labels-radius", textGrob(.$r_scale()$labels(), 0.02, rfine + 0.04, default.units="native", gp=gpar(col=plot$axis.colour), hjust=0))
    )))
  }

  
  frange <- function(.) {
    list(
      x = expand_range(c(-1, 1), 0.1, 0),
      y = expand_range(c(-1, 1), 0.1, 0)
    )
  }
    
  guide_axes <- function(.) {
    list(
      x = ggaxis(c(-1, 1), "", "bottom", c(-1,1)),
      y = ggaxis(.$r_rescale(.$r_scale()$breaks()) / 2 + 0.6, .$r_scale()$labels(), "left", c(0, 1.2))
    )
  }

  # Documetation -----------------------------------------------

  objname <- "polar"
  desc <- "Polar coordinates"
  icon <- function(.) circleGrob(r = c(0.1, 0.25, 0.45), gp=gpar(fill=NA))
  
  details <- "<p>The polar coordinate system is most commonly used for pie charts, which are a stacked bar chart in polar coordinates.</p>\n\n<p>This coordinate system has one argument, <code>theta</code>, which determines which variable is mapped to angle and which to radius.  Valid values are \"x\" and \"y\".</p>\n"
  
  examples <- function(.) {
    # Still very experimental, so a bit on the buggy side, but I'm
    # working on it.  Also need to deal properly with cyclical
    # variables
    ggopt(aspect.ratio = 1)    
    
    # NOTE: Use these plots with caution - polar coordinates has
    # major perceptual problems.  The main point of these examples is 
    # to demonstrate how these common plots can be described in the
    # grammar.  Use with EXTREME caution.

    # A coxcomb plot = bar chart + polar coordinates
    cxc <- ggplot(mtcars, aes(x=factor(cyl))) + geom_bar(width=1, colour="black")
    cxc + coord_polar()
    # A new type of plot?
    cxc + coord_polar(theta = "y")
    
    # A pie chart = stacked bar chart + polar coordinates
    pie <- ggplot(mtcars, aes(x=factor(1), fill=factor(cyl))) + geom_bar(width=1)
    pie + coord_polar(theta="y")
    # A new type of plot?
    pie + coord_polar()
    
    # Windrose + doughnut plot
    movies$rrating <- factor(round_any(movies$rating, 1))
    movies$budgetq <- factor(chop(movies$budget, 4), labels=1:4)
    
    doh <- ggplot(movies, aes(x=rrating, fill=budgetq))
    
    # Wind rose
    doh + geom_bar(width=1) + coord_polar()
    #Doughnut plot
    doh + geom_bar(width=0.9, position="fill") + coord_polar(theta="y")
    ggopt(aspect.ratio = NULL)
  }

})
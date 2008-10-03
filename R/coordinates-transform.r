CoordTrans <- proto(CoordCartesian, expr={
  
  muncher <- function(.) TRUE

  transform_x <- function(., data) {
    rescale(.$xtr$transform(data), 0:1, .$output_set()$x)
  }
  transform_y <- function(., data) {
    rescale(.$ytr$transform(data), 0:1, .$output_set()$y)
  }
  
  new <- function(., xtrans="identity", ytrans="identity") {
    if (is.character(xtrans)) xtrans <- Trans$find(xtrans)
    if (is.character(ytrans)) ytrans <- Trans$find(ytrans)
    .$proto(xtr=xtrans, ytr=ytrans)
  }

  pprint <- function(., newline=TRUE) {
    cat("coord_", .$objname, ": ", 
      "x = ", .$xtr$objname, ", ", 
      "y = ", .$ytr$objname, sep = ""
    )
    
    if (newline) cat("\n") 
  }

  output_set <- function(.) {
    # range is necessary in case transform has flipped min and max
    list(
      x = expand_range(range(.$xtr$transform(.$x()$output_set())), 0.05),
      y = expand_range(range(.$ytr$transform(.$y()$output_set())), 0.05)
    )
  }

  guide_axes <- function(., theme) {
    breaks <- .$breaks()
    list(
      x = guide_axis(breaks$x$major, .$x()$labels(), "bottom", theme),
      y = guide_axis(breaks$y$major, .$y()$labels(), "left", theme)
    )
  }

  # guide_background <- function(., theme) {
  #   x.major <- unit(.$xtr$transform(.$x()$input_breaks_n()), "native")
  #   x.minor <- unit(.$xtr$transform(.$x()$output_breaks()), "native")
  #   y.major <- unit(.$ytr$transform(.$y()$input_breaks_n()), "native")
  #   y.minor <- unit(.$ytr$transform(.$y()$output_breaks()), "native")
  #   
  #   draw_grid(theme, x.minor, x.major, y.minor, y.major)
  # }

  # Documentation -----------------------------------------------

  objname <- "trans"
  desc <- "Transformed cartesian coordinate system"
  details <- ""
  icon <- function(.) {
    breaks <- cumsum(1 / 2^(1:5))
    gTree(children=gList(
      segmentsGrob(breaks, 0, breaks, 1),
      segmentsGrob(0, breaks, 1, breaks)
    ))
  }
  
  examples <- function(.) {
    # See ?geom_boxplot for other examples
    
    # Three ways of doing transformating in ggplot:
    #  * by transforming the data
    qplot(log10(carat), log10(price), data=diamonds)
    #  * by transforming the scales
    qplot(carat, price, data=diamonds, log="xy")
    qplot(carat, price, data=diamonds) + scale_x_log10() + scale_y_log10()
    #  * by transforming the coordinate system:
    qplot(carat, price, data=diamonds) + coord_trans(x="log10", y="log10")

    # The difference between transforming the scales and
    # transforming the coordinate system is that scale
    # transformation occurs BEFORE statistics, and coordinate
    # transformation afterwards.  Coordinate transformation also 
    # changes the shape of geoms:
    library(mgcv)
    qplot(carat, price, data=diamonds, log="xy", geom=c("point","smooth"), method="gam", formula=y ~ s(x, bs="cr"))
    qplot(carat, price, data=diamonds, geom=c("point","smooth"), method="gam", formula=y ~ s(x, bs="cr"))  + coord_trans(x="log10", y="log10")
    
    # With a combination of scale and coordinate transformation, it's
    # possible to do back-transformations:
    qplot(carat, price, data=diamonds, log="xy", geom=c("point", "smooth"), method="lm") + coord_trans(x="pow10", y="pow10")
    # cf.
    qplot(carat, price, data=diamonds, geom=c("point", "smooth"), method="lm")
    
  }

  
})



CoordCartesian <- proto(Coord, expr={  
  
  new <- function(.) {
    .$proto()
  }
  
  x <- function(.) .$.scales$get_scales("x")
  y <- function(.) .$.scales$get_scales("y")
  
  transform <- function(., data) data
  
  # Assumes contiguous series of points
  munch <- function(., data, npieces=1) data
  
  expand <- function(.) {
    list(
      x = .$x()$.expand, 
      y = .$y()$.expand
    )
  }
  
  frange <- function(.) {
    expand <- .$expand()
    list(
      x = expand_range(range(.$x()$frange()), expand$x[1], expand$x[2]),
      y = expand_range(range(.$y()$frange()), expand$y[1], expand$y[2])
    )
  }

  guide_axes <- function(.) {
    range <- .$frange()
    list(
      x = ggaxis(.$x()$breaks(), .$x()$labels(), "bottom", range$x),
      y = ggaxis(.$y()$breaks(), .$y()$labels(), "left", range$y)
    )
  }
  
  xlabel <- function(., gp) ggname("xlabel", textGrob(.$x()$name, just=c("centre", "centre"), gp=gp))
  ylabel <- function(., gp) ggname("ylabel", textGrob(.$y()$name, rot=90, just=c("centre","centre"), gp=gp))

  # Axis labels should go in here somewhere too
  guide_inside <- function(., plot) {
    breaks <- list(
      x = list(major = .$x()$breaks(), minor = .$x()$minor_breaks()),
      y = list(major = .$y()$breaks(), minor = .$y()$minor_breaks())
    )
    
    draw_grid(plot, breaks)
  }
  
  draw_grid <- function(plot, breaks) {
    gp <- gpar(col=plot$grid.colour)
    ggname("grill", gTree(children = gList(
      ggname("background", rectGrob(gp=gpar(fill=plot$grid.fill, col=NA))),

      ggname("minor-horizontal", segmentsGrob(unit(0, "npc"), breaks$y$minor, unit(1, "npc"), breaks$y$minor, gp = gpar(col=plot$grid.minor.colour, lwd=0.8), default.units="native")),
      ggname("minor-vertical", segmentsGrob(breaks$x$minor, unit(0, "npc"), breaks$x$minor, unit(1, "npc"), gp = gpar(col=plot$grid.minor.colour, lwd=0.8), default.units="native")),

      ggname("major-horizontal", segmentsGrob(unit(0, "npc"), breaks$y$major, unit(1, "npc"), breaks$y$major, gp = gp, default.units="native")),
      ggname("major-vertical", segmentsGrob(breaks$x$major, unit(0, "npc"), breaks$x$major, unit(1, "npc"), gp = gp, default.units="native"))
    )))
  }
  
  # Documetation -----------------------------------------------

  objname <- "cartesian"
  desc <- "Cartesian coordinates"
  
  details <- "<p>The Cartesian coordinate system is the most familiar, and common, type of coordinate system.  There are no options to modify, and it is used by default, so you shouldn't need to call it explicitly</p>\n"
  
  icon <- function(.) {
    gTree(children = gList(
      segmentsGrob(c(0, 0.25), c(0.25, 0), c(1, 0.25), c(0.25, 1), gp=gpar(col="grey50", lwd=0.5)),
      segmentsGrob(c(0, 0.75), c(0.75, 0), c(1, 0.75), c(0.75, 1), gp=gpar(col="grey50", lwd=0.5)),
      segmentsGrob(c(0, 0.5), c(0.5, 0), c(1, 0.5), c(0.5, 1))
    ))
  }
  
  examples <- function(.) {
    # There aren't any parameters that you can control with 
    # the Cartesian coordinate system, and they're the default, so
    # you should never need to use it explicitly.  Most of the configuration
    # of the axes and gridlines occurs in the scales, so look at 
    # scale_continuous and scale_discrete for ideas.
    
    qplot(rating, length, data=movies) + coord_cartesian()
  }

})



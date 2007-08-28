GeomSmooth <- proto(GeomInterval, {
  draw <- function(., data, scales, coordinates, ...) {
    gList(
      tryNULL(GeomRibbon$draw(transform(data, colour=NA), scales, coordinates)),
      GeomPath$draw(rename(data, c(middle = "y")), scales, coordinates)
    )
  }

  objname <- "smooth"
  desc <- "Add a smoothed condition mean."
  icon <- function(.) {
    gTree(children=gList(
      polygonGrob(c(0, 0.3, 0.5, 0.8, 1, 1, 0.8, 0.5, 0.3, 0), c(0.5, 0.3, 0.4, 0.2, 0.3, 0.7, 0.5, 0.6, 0.5, 0.7), gp=gpar(fill="grey60", col=NA)),
      linesGrob(c(0, 0.3, 0.5, 0.8, 1), c(0.6, 0.4, 0.5, 0.4, 0.6))
    ))
  }
  
  
  default_stat <- function(.) StatSmooth
  required_aes <- c("x", "y")
  default_aes <- function(.) aes(colour="grey50", fill=alpha("black", 0.2), size=2, linetype=1, weight=1)

  examples <- function(.) {
    # See stat_smooth for examples
  }

})

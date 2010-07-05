GeomHline <- proto(Geom, {
  new <- function(., data = NULL, mapping = NULL, yintercept = NULL, legend = NA, ...) {
    if (is.numeric(yintercept)) {
      data <- data.frame(yintercept = yintercept)
      yintercept <- NULL
      mapping <- aes_all(names(data))
      if(is.na(legend)) legend <- FALSE
    }
    .super$new(., data = data, mapping = mapping, inherit.aes = FALSE, 
      yintercept = yintercept, legend = legend, ...)
  }

  draw <- function(., data, scales, coordinates, ...) {
    data$x    <- -Inf
    data$xend <- Inf
    
    GeomSegment$draw(unique(data), scales, coordinates)
  }

  objname <- "hline"
  desc <- "Line, horizontal"
  icon <- function(.) linesGrob(c(0, 1), c(0.5, 0.5))
  details <- "<p>This geom allows you to annotate the plot with horizontal lines (see geom_vline and geom_abline for other types of lines)</p>\n\n<p>There are two ways to use it.  You can either specify the intercept of the line in the call to the geom, in which case the line will be in the same position in every panel.  Alternatively, you can supply a different intercept for each panel using a data.frame.  See the examples for the differences</p>"
    
  default_stat <- function(.) StatHline
  default_aes <- function(.) aes(colour="black", size=0.5, linetype=1, alpha = 1)
  guide_geom <- function(.) "path"
  
  seealso <- list(
    geom_vline = "for vertical lines",
    geom_abline = "for lines defined by a slope and intercept",
    geom_segment = "for a more general approach"
  )
  
  examples <- function(.) {
    p <- ggplot(mtcars, aes(x = wt, y=mpg)) + geom_point()

    p + geom_hline(aes(yintercept=mpg))
    p + geom_hline(yintercept=20)
    p + geom_hline(yintercept=seq(10, 30, by=5))
    
    # To display different lines in different facets, you need to 
    # create a data frame.
    p <- qplot(mpg, wt, data=mtcars, facets = vs ~ am)

    hline.data <- data.frame(z = 1:4, vs = c(0,0,1,1), am = c(0,1,0,1))
    p + geom_hline(aes(yintercept = z), hline.data)
  } 
})

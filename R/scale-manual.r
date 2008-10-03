ScaleManual <- proto(ScaleDiscrete, {  
  doc <- TRUE
  common <- c("colour","fill","size","shape","linetype")
  values <- c()
  
  new <- function(., name=NULL, values=NULL, variable="x", limits = NULL, breaks = NULL, labels = NULL) {
    .$proto(name=name, values=values, .input=variable, .output=variable, limits = limits, breaks = breaks, .labels = labels)
  }

  map <- function(., values) {
    .$check_domain()
    if (.$has_names()) {
      .$output_breaks()[as.character(values)]
    } else {
      .$output_breaks()[match(as.character(values), .$input_set())]
    }
  }

  has_names <- function(.) !is.null(names(.$output_breaks()))

  output_breaks <- function(.) .$values
  output_set <- function(.) .$values
  labels <- function(.) if (.$has_names()) names(.$output_breaks()) else .$.domain
  

  # Documentation -----------------------------------------------

  objname <- "manual"
  desc <- "Create your own discrete scale"
  icon <- function(.) textGrob("man", gp=gpar(cex=1.2))
  
  examples <- function(.) {
    p <- qplot(mpg, wt, data=mtcars, colour=factor(cyl))

    p + scale_colour_manual(values = c("red","blue", "green"))
    p + scale_colour_manual(values = c("8" = "red","4" = "blue","6" = "green"))
  }
  
})

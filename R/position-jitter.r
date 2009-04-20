PositionJitter <- proto(Position, {
  
  adjust <- function(., data, scales) {
    if (empty(data)) return(data.frame())
    check_required_aesthetics(c("x", "y"), names(data), "position_jitter")
    
    if (is.null(.$width)) .$width <- resolution(data$x) * 0.4
    if (is.null(.$height)) .$height <- resolution(data$y) * 0.4
    
    trans_x <- NULL
    trans_y <- NULL
    if(.$width > 0) {
      trans_x <- function(x) jitter(x, amount = .$width)
    }
    if(.$height > 0) {
      trans_y <- function(x) jitter(x, amount = .$height)
    }
    
    transform_position(data, trans_x, trans_y)
  }
  
  objname <- "jitter" 
  desc <- "Jitter points to avoid overplotting"
  
  icon <- function(.) GeomJitter$icon()
  desc_params <- list(
    width = "degree of jitter in x direction. Defaults to 40\\% of the resolution of the data.", 
    height = "degree of jitter in y direction. Defaults to 40\\% of the resolution of the data."
    )

  examples <- function(.) {
    qplot(am, vs, data=mtcars)
    
    # Default amount of jittering will generally be too much for 
    # small datasets:
    qplot(am, vs, data=mtcars, position="jitter")
    # Control the amount as follows
    qplot(am, vs, data=mtcars, position=position_jitter(w=0.1, h=0.1))
    
    # The default works better for large datasets, where it will 
    # will up as much space as a boxplot or a bar
    qplot(cut, price, data=diamonds, geom=c("boxplot", "jitter"))
  }
  
})

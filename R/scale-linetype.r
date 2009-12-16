ScaleLinetypeDiscrete <- proto(ScaleDiscrete, expr={
  doc <- TRUE
  common <- NULL
  .input <- .output <- "linetype"
  aliases <- "scale_linetype"

  output_set <- function(.) c("solid", "22", "42", "44", "13", "1343", "73", "2262", "12223242", "F282", "F4448444", "224282F2", "F1")[seq_along(.$input_set())]
  max_levels <- function(.) 12
  
  detail <- "<p>Default line types based on a set supplied by Richard Pearson, University of Manchester.</p>"
  
  # Documentation -----------------------------------------------

  objname <- "linetype_discrete"
  desc <- "Scale for line patterns"
  
  icon <- function(.) {
    gTree(children=gList(
      segmentsGrob(0, 0.25, 1, 0.25, gp=gpar(lty=1)),
      segmentsGrob(0, 0.50, 1, 0.50, gp=gpar(lty=2)),
      segmentsGrob(0, 0.75, 1, 0.75, gp=gpar(lty=3))
    ))
  }
  
  examples <- function() {
    ec_scaled <- data.frame(
      date = economics$date, 
      rescaler(economics[, -(1:2)], "range")
    )
    ecm <- melt(ec_scaled, id = "date")
    
    qplot(date, value, data=ecm, geom="line", group=variable)
    qplot(date, value, data=ecm, geom="line", linetype=variable)
    qplot(date, value, data=ecm, geom="line", colour=variable)
    
    # See scale_manual for more flexibility
  }
  
})

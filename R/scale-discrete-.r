ScaleDiscrete <- proto(Scale, expr={
  .domain <- c()
  max_levels <- function(.) Inf
  .expand <- c(0, 0.05)
  .labels <- NULL
  doc <- FALSE

  discrete <- function(.) TRUE

  new <- function(., name=NULL, variable=.$.input, expand = c(0.05, 0.55), limits = NULL, breaks = NULL, labels = NULL, formatter = identity, drop = FALSE, legend = TRUE) {
    
    b_and_l <- check_breaks_and_labels(breaks, labels)
    
    .$proto(name=name, .input=variable, .output=variable, .expand = expand, .labels = b_and_l$labels, limits = limits, breaks = b_and_l$breaks, formatter = formatter, drop = drop, legend = legend)
  }

  # Range -------------------
  map <- function(., values) {
    .$check_domain()
    .$output_set()[match(as.character(values), .$input_set())]
  }

  input_breaks <- function(.) nulldefault(.$breaks, .$input_set())
  input_breaks_n <- function(.) match(.$input_breaks(), .$input_set())
  
  labels <- function(.) {
    if (!is.null(.$.labels)) return(as.list(.$.labels))
    
    f <- match.fun(get("formatter", .))
    as.list(f(.$input_breaks()))
  }
  
  output_set <- function(.) seq_along(.$input_set())
  output_breaks <- function(.) .$map(.$input_breaks())


  # Domain ------------------------------------------------
  
  transform_df <- function(., df) {
    NULL
  }

  # Override default behaviour: we do need to train, even if limits
  # have been set
  train_df <- function(., df, drop = FALSE) {
    if (empty(df)) return() 
    if (!is.null(.$limits)) return()
    
    input <- .$input_aesthetics(df)
    l_ply(input, function(var) .$train(df[[var]], drop))
  }

  train <- function(., x, drop = .$drop) {
    if (is.null(x)) return()
    if (!is.discrete(x)) {
      stop("Continuous variable (", .$name , ") supplied to discrete ",
       .$my_name(), ".", call. = FALSE) 
    }
    
    .$.domain <- discrete_range(.$.domain, x, drop = drop)
  }

  check_domain <- function(.) {
    d <- .$input_set()
    if (length(d) > .$max_levels()) {
      stop(.$my_name(), " can deal with a maximum of ", .$max_levels(), " discrete values, but you have ", length(d), ".  See ?scale_manual for a possible alternative", call. = FALSE)
    }  
  }
  
  # Guides
  # -------------------

  minor_breaks <- function(.) NA
  
  # Documentation
  objname <- "discrete"
  

})

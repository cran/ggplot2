  # Create a new layer
  # Layer objects store the layer of an object.
  # 
  # They have the following attributes:
  # 
  #  * data
  #  * geom + parameters
  #  * statistic + parameters
  #  * position + parameters
  #  * aesthetic mapping
  # 
  # Can think about grob creation as a series of data frame transformations.
Layer <- proto(expr = {  
  geom <- NULL
  geom_params <- NULL
  stat <- NULL
  stat_params <- NULL
  data <- NULL
  mapping <- NULL
  position <- NULL
  params <- NULL
  
  new <- function (., geom=NULL, geom_params=NULL, stat=NULL, stat_params=NULL, data=NULL, mapping=NULL, position=NULL, params=NULL, ...) {
    
    if (is.null(geom) && is.null(stat)) stop("Need at least one of stat and geom")
    
    if (!is.null(data) && !is.data.frame(data)) stop("Data needs to be a data.frame")
    if (!is.null(mapping) && !inherits(mapping, "uneval")) stop("Mapping should be a list of unevaluated mappings created by aes or aes_string")
    
    if (is.character(geom)) geom <- Geom$find(geom)
    if (is.character(stat)) stat <- Stat$find(stat)
    if (is.character(position)) position <- Position$find(position)
    
    if (is.null(geom)) geom <- stat$default_geom()
    if (is.null(stat)) stat <- geom$default_stat()
    if (is.null(position)) position <- geom$default_pos()

    match.params <- function(possible, params) {
      if ("..." %in% names(possible)) {
        params
      } else {
        params[match(names(possible), names(params), nomatch=0)]
      }
      
    }
    
    if (is.null(geom_params) && is.null(stat_params)) {
      params <- c(params, list(...))
      geom_params <- match.params(geom$parameters(), params)
      stat_params <- match.params(stat$parameters(), params)
    }
    
    proto(., geom=geom, geom_params=geom_params, stat=stat, stat_params=stat_params, data=data, aesthetics=mapping, position=position)
  }
  
  clone <- function(.) as.proto(.$as.list())
  
  use_defaults <- function(., data) {
    df <- aesdefaults(data, .$geom$default_aes(), compact(.$aesthetics))
    gp <- intersect(names(.$geom$parameters()), names(.$geom_params))
    if (length(.$geom_params[gp])) 
      gp <- gp[sapply(.$geom_params[gp], is.atomic)]
    df[gp] <- .$geom_params[gp]
    df
  }
  
  pprint <- function(.) {
    if (is.null(.$geom)) {
      cat("Empty layer\n")
      return(invisible());
    }
    .$geom$print(newline=FALSE)
    cat(" +", clist(.$geom_params), "\n")
    .$stat$print(newline=FALSE)
    cat(" +", clist(.$stat_params), "\n")
    .$position$print()
    cat("mapping:", clist(.$aesthetics), "\n")
  }
  
  
  # Produce data.frame of evaluated aesthetics
  # Depending on the construction of the layer, we may need
  # to stitch together a data frame using the defaults from plot\$defaults 
  # and overrides for a given geom.
  #
  make_aesthetics <- function(., plot) {
    data <- nulldefault(.$data, plot$data)
    if (is.null(data)) stop("No data for layer", call.=FALSE)

    aesthetics <- compact(defaults(.$aesthetics, plot$defaults))
    # Override grouping if specified in layer
    if (!is.null(.$geom_params$group)) {
      aesthetics["group"] <- .$geom_params$group
    } 
    
    # Drop aesthetics that are set manually
    aesthetics <- aesthetics[setdiff(names(aesthetics), names(.$geom_params))]
    plot$scales$add_defaults(plot$data, aesthetics)
    
    calc_aesthetics(plot, data, aesthetics)
  }

  calc_statistics <- function(., data, scales) {
    gg_apply(data, function(x) .$calc_statistic(x, scales))  
  }
  
  calc_statistic <- function(., data, scales) {
    if (is.null(data) || nrow(data) == 0) return()

# tryNULL(
    do.call(.$stat$calculate_groups, c(
      list(data=as.name("data"), scales=as.name("scales")), 
      .$stat_params)
    )#)
    
  }

  # Map new aesthetic names
  # After the statistic transformation has been applied, a second round
  # of aesthetic mappings occur.  This allows the mapping of variables 
  # created by the statistic, for example, height in a histogram, levels
  # on a contour plot.
  map_statistics <- function(., data, plot) {
    gg_apply(data, function(x) .$map_statistic(x, plot=plot))
  }
  
  map_statistic <- function(., data, plot) {
    if (is.null(data) || nrow(data) == 0) return()
    aesthetics <- defaults(.$aesthetics, defaults(plot$defaults, .$stat$default_aes()))
    
    match <- "\\.\\.([a-zA-z._]+)\\.\\."
    new <- aesthetics[grep(match, aesthetics)]
    new <- lapply(new, function(x) parse(text = sub(match, "\\1", x))[[1]])
    
    for(i in seq_along(new)) {
      data[[names(new)[i]]] <- eval(new[[i]], data, parent.frame())
    }
    
    plot$scales$add_defaults(data, new)
    
    data
  }

  adjust_position <- function(., data, scales, position) {
    gg_apply(data, function(x) {
      if (.$position$position == position) {
        .$position$adjust(x, scales)
      } else {
        x
      }
    })
  }

  make_grobs <- function(., data, scales, cs) {
    force(data)
    gg_apply(data, function(x) .$make_grob(x, scales, cs))
  }

  make_grob <- function(., data, scales, cs) {
    if (is.null(data) || nrow(data) == 0) return()
    data <- .$use_defaults(data)
    
    check_required_aesthetics(.$geom$required_aes, c(names(data), names(.$geom_params)), paste("geom_", .$geom$objname, sep=""))
    
    do.call(.$geom$draw_groups, c(
      data = list(as.name("data")), 
      scales = list(as.name("scales")), 
      coordinates = list(as.name("cs")), 
      .$geom_params
    ))
  }

  class <- function(.) "layer"

  # Methods that probably belong elsewhere ------------------------------------
  
  # Stamp data.frame into list of matrices
  
  scales_transform <- function(., data, scale) {
    gg_apply(data, function(df) scale$transform_df(df))
  }
  
  # Train scale for this layer
  scales_train <- function(., data, scale, adjust=FALSE) {
    gg_apply(data, function(df) {
      if (adjust) df <- .$geom$adjust_scales_data(scale, df)
      scale$train_df(df)
    })
  }
  
  # Map data using scales.
  scales_map <- function(., data, scale) {
    gg_apply(data, function(x) scale$map_df(x))
  }  
})

gg_apply <- function(gg, f, ...) {
  # lapply(gg, function(dm) {
    apply(gg, c(1,2), function(data) {
      f(data[[1]], ...)
    })
  # })
}
layer <- Layer$new

# Build data frame
# Build data frome for a plot with given data and ... (dots) arguments
#
# Depending on the layer, we need
# to stitch together a data frame using the defaults from plot\$defaults 
# and overrides for a given geom.
#
# Arguments in dots are evaluated in the context of \\code{data} so that
# column names can easily be references. 
#
# Also makes sure that it contains all the columns required to correctly
# place the output into the row+column structure defined by the formula,
# by using \\code{\\link[reshape]{expand.grid.df}} to add in extra columns if needed.
#
# @arguments plot object
# @arguments data frame to use
# @arguments extra arguments supplied by user that should be used first
# @keyword hplot
# @keyword internal
calc_aesthetics <- function(plot, data = plot$data, aesthetics) {
  if (is.null(data)) data <- plot$data
  if (!is.data.frame(data)) stop("data is not a data.frame")
  
  eval.each <- function(dots) lapply(dots, function(x) eval(x, data, parent.frame()))
  # Conditioning variables needed for facets
  cond <- plot$facet$conditionals()
  
  # Remove aesthetics mapped to variables created by statistics
  match <- "\\.\\.([a-zA-z._]+)\\.\\."
  stats <- rep(F, length(aesthetics))
  stats[grep(match, sapply(aesthetics, as.character))] <- TRUE
  aesthetics <- aesthetics[!stats]
  
  
  df <- data.frame(eval.each(aesthetics))
  df <- cbind(df, data[,intersect(names(data), cond), drop=FALSE])
  
  if (is.null(plot$data)) return(df)
  expand.grid.df(df, unique(plot$data[, setdiff(cond, names(df)), drop=FALSE]), unique=FALSE)
}


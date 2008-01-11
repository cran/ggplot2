# Chop
# Chop a continuous variable into a categorical variable.
#
# Chop provides a convenient interface to the main methods of
# converting a continuous variable into a categorical variable.
#
# @argument continuous variable to chop into pieces
# @argument number of bins to chop into
# @argument method to use: quantiles (approximately equal numbers), cut (equal lengths) or pretty
# @argument mid point for diverging factors
# @seealso \code{\link{chop.breaks}} to get breaks used
# @keyword manip
chop <- function(x, n=5, method="quantiles", midpoint=0, digits=2) {
  methods <- c("quantiles","cut", "pretty")
  method <- methods[charmatch(method, methods)]
  if (is.na(method)) stop(paste("Method must be one of:", paste(methods, collapse=", ")))
  
  breaks <- chop.breaks(x, n, method, midpoint)
  labels <- formatC(breaks, digits=2, width=0)
  
  fac <- ordered(cut(x, breaks, labels=FALSE, include.lowest=TRUE) - attr(breaks,"midpoint.level"),labels=paste(labels[-length(breaks)], labels[-1], sep="-"))
  attr(fac, "breaks") <- breaks
  
  if (attr(breaks,"midpoint.level") != 0) {
    attr(fac, "midpoint.level") <- - attr(breaks,"midpoint.level")
    class(fac) <- c("diverging", "ordered", "factor")    
  }

  fac
}

# Chop breaks
# Calculate breakpoints for chop function
#
# @argument continuous variable
# @argument number of bins to chop into
# @argument method to use: quantiles (approximately equal numbers), cut (equal lengths) or pretty
# @argument mid point for diverging factors
# @keyword manip
# @keyword internal
chop.breaks <- function(x, n, method, midpoint=NA) {
  if (!missing(midpoint) && midpoint > min(x, na.rm=TRUE) && midpoint < max(x, na.rm=TRUE)) {
    range <- diff(range(x, na.rm=TRUE))
    range.neg <- midpoint - min(x, na.rm=TRUE)
    range.pos <- max(x, na.rm=TRUE) - midpoint
    
    n.pos <- floor(n * range.pos / range)
    n.neg <- ceiling(n * range.neg / range)
    
    breaks <- unique(c(
      chop.breaks(x[x <= midpoint], n.neg, method, midpoint)[-(n.neg + 1)],
      midpoint, 
      chop.breaks(x[x >= midpoint], n.pos, method, midpoint)[-1]
    ))
    attr(breaks, "midpoint.level") <- n.neg+1
    
  } else {
    breaks <- unique(as.vector(switch(method, 
      pretty = pretty(x, n),
      cut = seq(min(x, na.rm=TRUE),max(x, na.rm=TRUE), length=n+1), 
      quantiles = quantile(x, seq(0,1, length=n+1), na.rm=TRUE)
    )))
    attr(breaks, "midpoint.level") <- 0
  }
  
  breaks
}


# Automatic chop
# Keep categorical variables as is, chop up continuous variable
#
# @argument data
# @keyword manip
# @keyword internal
chop_auto <- function(x) {
  if(is.factor(x)) return(x)
  if (length(unique(x)) < 5) return(factor(x))
  
  warning("Continuous variable automatically converted to categorical", call.=FALSE)
  chop(x)#, method="pretty")
}


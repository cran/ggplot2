# Get grid names
# 
# @keyword internal 
listChildren <- function(grob) {
  cat(get.names(), "\n")
}

get.names <- function(x=grid.get(getNames()[[1]]), indent=0) {
  hasChildren <- function(x) length(x$children) > 0
  hasGrandchildren <- function(x) hasChildren(x) && any(lapply(x$children, hasChildren))
  
  spaces <- ps(rep(" ", indent)) 
  name <- grid:::getName(x)

  if(hasGrandchildren(x)) {
    children <- sapply(x$children, get.names, indent=indent + 1)
    paste(spaces, name, ":\n", paste(children, collapse="\n"), sep="")    
  } else if (hasChildren(x)) {
    children <- sapply(x$children, get.names, indent=0)
    paste(spaces, name, ": (", paste(children, collapse=", "), ")", sep="")    
  } else {
    paste(spaces, name, sep="")
  }
}




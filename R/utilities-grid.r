# Get grid names
# 
# @keyword internal 
listChildren <- function(grob) {
  cat(get.names(), "\n")
}

get.names <- function(x=grid.get(getNames()[[1]]), indent=0, only.name=FALSE) {
  hasChildren <- function(x) length(x$children) > 0
  hasGrandchildren <- function(x) hasChildren(x) && any(lapply(x$children, hasChildren))
  
  spaces <- ps(rep(" ", indent)) 
  name <- grid:::getName(x)
	if (only.name) name <- gsub("\\..*", "", name)
	
	if (inherits(x, "cellGrob")) {
		if (!hasChildren(x)) return()
		return(get.names(x$children[[1]], indent, only.name=only.name))
	}

  if(hasGrandchildren(x)) {
    children <- sapply(x$children, get.names, indent=indent + 1, only.name=only.name)
    paste(spaces, name, "::\n", paste(children, collapse="\n"), sep="")    
  } else if (hasChildren(x)) {
    children <- sapply(x$children, get.names, indent=0, only.name=only.name)
    paste(spaces, name, ":: (", paste(children, collapse=", "), ")", sep="")    
  } else {
    paste(spaces, name, sep="")
  }
}

current.grobTree <- function(all=TRUE, only.name=FALSE) {
	cat(get.names(only.name=only.name), "\n")
}


ggname <- function(prefix, grob) {
	grob$name <- grobName(grob, prefix)
	grob
}

grid.gedit <- function(..., global=TRUE, grep=TRUE) grid.edit(..., global=global, 
grep=grep)

grid.gremove <- function(..., global=TRUE, grep=TRUE) grid.remove(..., global=global, grep=grep)


dev.save <- function(file, width=6, height= 4) {
  dev.copy(device=pdf, file=file, width=width, height=height)
  dev.off()
  cat("\\includegraphics[scale=1]{", file, "}", "\n", sep="")
}

# Code to create a scattplot matrix (experimental)
# 
# @keyword internal
scatterplotmatrix <- function(data) {
  data <- rescaler(data, "range")
  grid <- expand.grid(x=1:ncol(data), y=1:ncol(data))
  grid <- subset(grid, x != y)

  all <- do.call("rbind", lapply(1:nrow(grid), function(i) {
    xcol <- grid[i, "x"]
    ycol <- grid[i, "y"]

    data.frame(
      xvar = names(data)[xcol], yvar=names(data)[ycol],
      x = data[, xcol], y = data[, ycol]
    )
  }))
  all$xvar <- factor(all$xvar, levels=unique(all$xvar))
  all$yvar <- factor(all$yvar, levels=unique(all$xvar))

  densities <- do.call("rbind", lapply(1:ncol(data), function(i) {
    data.frame(
      xvar = names(data)[i], yvar=names(data)[i],
      x = data[, i], y = NA
    )

  }))

  p <- qplot(x, y, xvar ~ yvar, data=all)
  p <- ggdensity(p, data=densities, matrix=TRUE)
  p$ylabel <- NULL
  p$xlabel <- NULL
  p  
}


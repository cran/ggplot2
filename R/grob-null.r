# Zero grob
# The zero grob draws nothing and has zero size.
# 
# @alias widthDetails.zeroGrob
# @alias heightDetails.zeroGrob
# @alias grobWidth.zeroGrob
# @alias grobHeight.zeroGrob
# @alias drawDetails.zeroGrob
# @alias is.zero
# @keyword internal
zeroGrob <- function() .zeroGrob

.zeroGrob <- grob(cl = "zeroGrob", name = "NULL")
widthDetails.zeroGrob <-
heightDetails.zeroGrob <- 
grobWidth.zeroGrob <- 
grobHeight.zeroGrob <- function(x) unit(0, "cm")

drawDetails.zeroGrob <- function(x, recording) {}

is.zero <- function(x) inherits(x, "zeroGrob")

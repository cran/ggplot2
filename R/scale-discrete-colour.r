ScaleColour <- proto(ScaleDiscrete, expr={
  objname <- "colour"
  doc <- FALSE
  common <- c()
})

ScaleHue <- proto(ScaleColour, expr={
  aliases <- c("scale_colour_discrete", "scale_fill_discrete")
  
  new <- function(., name=NULL, h=c(0,360), l=65, c=100, alpha=1, labels=NULL, h.start = 0, direction = 1,  variable) {
    .$proto(name=name, h=h, l=l, c=c, alpha=alpha, .input=variable, .output=variable, .labels = labels, direction = direction, start  = h.start)
  }
  
  breaks <- function(.) {
    rotate <- function(x) (x + .$start) %% 360 * .$direction
    
    n <- length(.$domain())
    grDevices::hcl(
      h = rotate(seq(.$h[1], .$h[2], length = n+1)), 
      c =.$c, 
      l =.$l, 
      alpha=.$alpha
    )[-(n+1)]
  }
  max_levels <- function(.) Inf

  doc <- TRUE
  common <- c("colour", "fill")

  # Documetation -----------------------------------------------
  objname <- "hue"
  desc <- "Colours that vary continuously in hue"
  icon <- function(.) {
    rectGrob(c(0.1, 0.3, 0.5, 0.7, 0.9), width=0.21, 
      gp=gpar(fill=hcl(seq(0, 360, length=6)[-6], c=100, l=65), col=NA)
    )
  }
  
  desc_params <- list(
    h = "range of hues to use, in degrees", 
    l = "luminance",
    c = "chroma",
    alpha = "alpha"
  )
  
  examples <- function(.) {
    dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
    (d <- qplot(carat, price, data=dsamp, colour=clarity))
  
    # Change scale label
    d + scale_colour_hue()
    d + scale_colour_hue("clarity")
    d + scale_colour_hue(expression(clarity[beta]))
    
    # Adjust luminosity and chroma
    d + scale_colour_hue(l=40, c=30)
    d + scale_colour_hue(l=70, c=30)
    d + scale_colour_hue(l=70, c=150)
    d + scale_colour_hue(l=80, c=150)
    
    # Change range of hues used
    d + scale_colour_hue(h=c(0, 90))
    d + scale_colour_hue(h=c(90, 180))
    d + scale_colour_hue(h=c(180, 270))
    d + scale_colour_hue(h=c(270, 360))
    
    # Vary opacity
    # (only works with pdf, quartz and cairo devices)
    d + scale_colour_hue(alpha = 0.9)
    d + scale_colour_hue(alpha = 0.5)
    d + scale_colour_hue(alpha = 0.2)
  }
})



ScaleBrewer <- proto(ScaleColour, expr={
  doc <- TRUE

  new <- function(., name=NULL, palette=1, type="qual", alpha=1, reverse = FALSE, labels=NULL, variable) {
    .$proto(name=name, palette=palette, type=type, .input=variable, .output=variable, .alpha=alpha, .reverse = reverse, .labels = labels)
  }

  breaks <- function(.) {
    n <- length(.$domain())
    pal <- brewer.pal(n, .$pal_name())
    if (.$.reverse) pal <- rev(pal)
    alpha(pal, .$.alpha)
  }

  pal_name <- function(.) {
    if (is.character(.$palette)) {
      if (!.$palette %in% RColorBrewer:::namelist) {
        warning("Unknown palette ", .$palette)
        .$palette <- "Greens"
      }
      return(.$palette)
    }
    
    switch(.$type, 
      div = RColorBrewer:::divlist, 
      qual = RColorBrewer:::quallist, 
      seq = RColorBrewer:::seqlist
    )[.$palette]
  }
  
  max_levels <- function(.) RColorBrewer:::maxcolors[RColorBrewer:::namelist == .$pal_name()]

  # Documetation -----------------------------------------------

  objname <- "brewer"
  desc <- "Colour brewer colour scales"
  details <- "<p>See <a href='http://colorbrewer.org'>colorbrewer.org</a> for more info</p>"
  common <- c("colour", "fill")

  icon <- function(.) {
    rectGrob(c(0.1, 0.3, 0.5, 0.7, 0.9), width=0.21, 
      gp=gpar(fill=brewer.pal(5, "PuOr"), col=NA)
    )
  }
  
  examples <- function(.) {
    (d <- qplot(carat, price, data=diamonds, colour=clarity))
    
    # Change scale label
    d + scale_colour_brewer()
    d + scale_colour_brewer("clarity")
    d + scale_colour_brewer(expression(clarity[beta]))

    # Select brewer palette to use, see ?brewer.pal for more details
    d + scale_colour_brewer(type="seq")
    d + scale_colour_brewer(type="seq", palette=3)

    display.brewer.all(n=8, exact.n=FALSE)

    d + scale_colour_brewer(palette="Blues")
    d + scale_colour_brewer(palette="Set1")
    
    # One way to deal with overplotting - use transparency
    # (only works with pdf, quartz and cairo devices)
    d + scale_colour_brewer(alpha = 0.2)
    d + scale_colour_brewer(alpha = 0.01)
  
    # scale_fill_brewer works just the same as 
    # scale_colour_brewer but for fill colours
    ggplot(diamonds, aes(x=price, fill=cut)) + 
      geom_bar(position="dodge") + 
      scale_fill_brewer()
    
  }
})
GeomBlank <- proto(Geom, {
  default_stat <- function(.) StatIdentity
  default_aes <- function(.) aes()

  # Documetation -----------------------------------------------

  objname <- "blank"
  desc <- "Blank, draws nothing"
  detail <- "<p>The blank geom draws nothing, but can be a useful way of ensuring common scales between different plots</p>\n"
  
  examples <- function(.) {
    qplot(length, rating, data=movies, geom="blank")
    # Nothing to see here!
  }
  
})

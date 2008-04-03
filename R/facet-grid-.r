FacetGrid <- proto(Facet, {
  objname <- "grid"
  desc <- "Lay out panels in a rectangular/tabular manner."
  icon <- function(.) {
    gTree(children = gList(
      rectGrob(0, 1, width=0.95, height=0.05, hjust=0, vjust=1, gp=gpar(fill="grey60", col=NA)),
      rectGrob(0.95, 0.95, width=0.05, height=0.95, hjust=0, vjust=1, gp=gpar(fill="grey60", col=NA)),
      segmentsGrob(c(0, 0.475), c(0.475, 0), c(1, 0.475), c(0.475, 1))
    ))
  }
  
  new <- function(., facets = . ~ ., margins = FALSE) {
    if (inherits(facets, "formula")) facets <- deparse(facets) 
    .$proto(facets=facets, margins=margins)
  }
  
  conditionals <- function(.) {
    vars <- all.vars(as.formula(.$facets))
    setdiff(vars, c(".", "..."))
  }
  
  stamp_data <- function(., data) {
    data.matrix <- stamp(add_group(data), .$facets, force, margins=.$margins, fill=list(NULL))
    
    force_matrix(data.matrix)
  }
  
  grid <- function(., data) {
    stamp(data, .$facets, function(x) 0, margins=.$margins)
  }
  
  examples <- function(.) {
    # Facetting displays subsets of the data in different panels
    p <- ggplot(diamonds, aes(x=carat, y=..density..)) + geom_histogram(binwidth=0.2)
    
    # With one variable
    p + facet_grid(. ~ cut)
    p + facet_grid(cut ~ .)

    # With two variables
    p + facet_grid(clarity ~ cut)
    p + facet_grid(cut ~ clarity)
    p + facet_grid(cut ~ clarity, margins=TRUE)
    
    # You can also use strings, which makes it a little easier
    # when writing functions that generate facetting specifications
    # p + facet_grid("cut ~ .")
    
    # see also ?plotmatrix for the scatterplot matrix
    
  }
  
})

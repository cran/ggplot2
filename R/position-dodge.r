PositionDodge <- proto(Position, {
	
	adjust <- function(., data, scales) {
		if (is.null(data$width)) data$width <- resolution(data$x) * 0.9
		
		maxn <- max(tapply(data$x, data$x, length))
		dodge <- function(data) {
			transform(data, 
				x = x + (1:nrow(data) - (maxn + 1) / 2) * (width/maxn) ,
				width = width / maxn
			)
		}
		
		xs <- split(data, data$x)
		do.call("rbind.fill", lapply(xs, dodge))
	}	

	objname <- "dodge"
	position <- "after"
	desc <- "Adjust position by 'dodging' overlaps to the side"
	icon <- function(.) {
		y <- c(0.5, 0.3)
		rectGrob(c(0.25, 0.75), y, width=0.4, height=y, gp=gpar(col="grey60", fill=c("#804070", "#668040")), vjust=1)
	}
	
	examples <- function(.) {
		ggplot(mtcars, aes(x=factor(cyl), fill=factor(vs))) + geom_bar(position="dodge")
		ggplot(diamonds, aes(x=price, fill=cut)) + geom_bar(position="dodge")
		# see ?geom_boxplot and ?geom_bar for more examples
	}
})

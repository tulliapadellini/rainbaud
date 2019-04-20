#' Extracts colors from Picular.co
#'
#' @param word a string to be converted into a color.
#' @return the 20 first colors found on picular.co for \code{word}. See \url{http://picular.co} for more details
#' @examples
#' get.color("spring")
#' get.color("fire")
#' @seealso \code{\link{create.palette}}
get.color <- function(word){
  url.json  = paste0("https://server.picular.co/", word)
  data.json = rjson::fromJSON(file=url.json)
  col.json  = sapply(data.json$colors, '[', 'color')

  return(unlist(col.json))
}


#' Create a palette given a collection of words
#'
#' @param words a vector containing
#' @param n.colors number of colors of the palette
#' @param aggregate method of aggregation
#' @return a color palette of \code{n.colors} elements.
#' @examples
#' library(rainbaud)
#' foo = c("forest", "water", "fire")
#' pal1 = create.palette(foo)
#' pal2 = create.palette(foo, n.colors = 11, aggregate = "median")
#' @seealso \code{\link{get.color}}
create.palette <- function(words, n.colors=length(words), aggregate = "most-prominent"){

  col.list  = switch(aggregate,
                    "most-prominent" = matrix(sapply(words, function(x) hex2RGB(get.color(x))@coords[1,]), nrow = 3),
                    "mean" = sapply(words, function(x) apply(hex2RGB(get.color(x))@coords,2, mean)),
                    "median" = sapply(words, function(x) apply(hex2RGB(get.color(x))@coords,2, median))
  )

  pal = apply(col.list, 2, function(x) rgb(x[1], x[2], x[3]))

  if(n.colors!=length(words)){
    grad.pal = colorRampPalette(pal)
    pal = grad.pal(n.colors)
  }

  return(pal)

}


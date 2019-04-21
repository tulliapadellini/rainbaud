#' Parse colors from Picular.co
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


#' Create a palette given a collection of words (or only one word?)
#'
#' @param words a vector containing
#' @param n.colors number of colors of the palette
#' @param aggregate method of aggregation
#' @return a color palette of \code{n.colors} elements.
#' @examples
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

#' Extracts the most relevant words from a sentence
#'
#' @param sentence a string
#' @return a vector of strings
#' @examples
#' myfairlady = "the rain in Spain stays mainly in the plain"
#' extract_words(myfairlady)
extract_words <- function(sentence) {
  corpus <- Corpus(VectorSource(sentence))
  dtm <- DocumentTermMatrix(corpus, control = list( stemming = TRUE, remove_stopwords="en",
                                                    minWordLength = 2, removeNumbers = TRUE,
                                                    removePunctuation = TRUE, bounds=list(local = c(1,Inf)),
                                                    weighting = function(x) weightTfIdf(x, normalize = FALSE)))
  out <- dtm$dimnames$Terms
  m <- match(out,stopwords("en"))
  if (any(!is.na(m))) {
    out <- out[-which(!is.na(m))]
  }
  return(out)
}


#' Parse colors from Picular.co
#'
#' @param word a string to be converted into a color.
#' @return the 20 first colors found on picular.co for \code{word}. See \url{http://picular.co} for more details
#' @examples
#' get.color("spring")
#' get.color("fire")
#' @seealso \code{\link{create.palette}}
aggregate.colors <- function(colors, aggregate = "median"){

  col.conv = sapply(colors, function(x) rgb2hsv(col2rgb(x)))

  col.summ  = switch(aggregate,
                     "mean"   = apply(col.conv, 1, mean),
                     "median" = col.conv[ ,ceiling(ncol(col.conv)/2) ],
                     "most-prominent" = col.conv[,1])

  out.col = hsv(col.summ[1], col.summ[2], col.summ[3])

  return(out.col)
}

#' Parse colors from Picular.co
#'
#' @param word a string to be converted into a color.
#' @return the 20 first colors found on picular.co for \code{word}. See \url{http://picular.co} for more details
#' @examples
#' get.color("spring")
#' get.color("fire")
#' @seealso \code{\link{create.palette}}
get.color <- function(word, sorted= TRUE){

  # parse picular to get color vector
  url.json  = paste0("https://server.picular.co/", word)
  data.json = rjson::fromJSON(file=url.json)
  col.json  = sapply(data.json$colors, '[', 'color')
  col.vect  = unlist(col.json)

  # sort based on hue values
  if(sorted){
    col.conv = sapply(col.vect, function(x) rgb2hsv(col2rgb(x)))
    sort.idx = order(col.conv[1,])
    col.conv = col.conv[,sort.idx]
    col.vect = apply(col.conv, 2, function(x) hsv(x[1], x[2], x[3]))
  }

  return(col.vect)
}


#' Create a palette given a collection of words (or only one word?)
#'
#' @param sentence a string of words
#' @param n.colors number of colors of the palette
#' @param aggregate method of aggregation
#' @return a color palette of \code{n.colors} elements.
#' @examples
#' mfl = "the rain in spain stays mainly in the plain"
#' mfl1 = create.palette(mfl, n.colors = 11)
#' mfl2 = create.palette(mfl, n.colors = 11, aggregate = "median")
#' plot(1:11, rep(0, 11), pch = 15, col = mfl1, cex = 4, axes = FALSE, xlab = "", ylab = "")
#' points(1:11, rep(-0.2, 11), pch = 15, col = mfl1, cex = 4)
#' @seealso \code{\link{get.color}}
create.palette <- function(sentence, n.colors=length(words), sorted = TRUE, aggregate = "most-prominent"){

  if(aggregate == "most-prominent") sorted = FALSE


  words = extract_words(sentence)
  n.words = length(words)


  # case a - palette from one word
  if(n.words == 1){
    col.list  = get.color(words, sorted = sorted)

    if(n.colors == 1){
      return(col.list)
    } else{
      pal = colorRampPalette(col.list)
      return(pal(n.colors))
    }
  }

  col.list = sapply(words, get.color, sorted = sorted)

  pal = apply(col.list, 2, aggregate.colors, aggregate = aggregate)

  if(n.colors!=length(words)){
    grad.pal = colorRampPalette(pal)
    pal = grad.pal(n.colors)
  }

  return(pal)
}


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


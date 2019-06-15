#' Sort a collection of colors
#'
#' @param colors a vector containing the colors to be sorted in rgb format.
#' @param aggreg.method method of aggregation of the colors corresponding to each word in the \code{sentence} argument. Possible choices are:
#'        \itemize{
#'           \item \code{most-prominent}: take the first value returned by the function \code{\link{get.color}};
#'           \item \code{median}: sort all the colors returned by the function \code{\link{get.color}} according to their hue and then take the median color;
#'           \item \code{mean}: take the mean of all the colors returned by the function \code{\link{get.color}} in the hsv space.
#'         }
#' @return the 20 first colors found on picular.co for \code{word}. See \url{http://picular.co} for more details
#' @examples
#' get.color("spring")
#' get.color("fire")
#' @seealso \code{\link{create.palette}}
#' @export
aggreg.colors <- function(colors, aggreg.method = "median"){

  col.conv = sapply(colors, function(x) rgb2hsv(col2rgb(x)))

  col.summ  = switch(aggreg.method,
                     "mean"   = apply(col.conv, 1, mean),
                     "median" = col.conv[ ,ceiling(ncol(col.conv)/2) ],
                     "most-prominent" = col.conv[,1])

  out.col = hsv(col.summ[1], col.summ[2], col.summ[3])

  return(out.col)
}



extract_words <- function(sentence, language = "en", n.topics = 10) {


  corpus <- Corpus(VectorSource(sentence),readerControl = list(language = language) )
  dtm <- DocumentTermMatrix(corpus, control = list( stemming = TRUE, stopwords = TRUE, remove_stopwords=language,
                                                    minWordLength = 2, removeNumbers = TRUE,
                                                    removePunctuation = TRUE, bounds=list(local = c(1,Inf)),
                                                    weighting = tm::weightTf))

  out <- dtm$dimnames$Terms

  if(length(out) > 20){
    if(is.null(n.topics)) stop("If your text require LDA you need to specify argument n.colors")
  lda <- LDA(dtm, k = n.topics, control = list(seed = 1234))
  topics.tibb <- tidy(lda, matrix = "beta")

  top.terms <- top_n(group_by(topics.tibb, topic),1,beta)
  out = unique(top.terms$term)

  }
  return(out)
}


#' Parse colors from Picular.co
#'
#' @param word a string to be converted into a color.
#' @param sorted logical, if \code{TRUE} then colors are sorted according to their hue.
#' @return the 20 first colors found on picular.co for \code{word}. See \url{http://picular.co} for more details
#' @examples
#' get.color("spring")
#' get.color("fire")
#' @seealso \code{\link{create.palette}}
#' @export
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


#' Create a palette given multiple words
#'
#' @param sentence a string of words
#' @param n.colors number of colors of the palette. If \code{NULL} (default) then n.colors is set to the number of words in the \code{sentence}argument
#' @param sorted logical, if \code{TRUE} then colors are sorted according to their hue.
#' @param aggreg.method method of aggregation of the colors corresponding to each word in the \code{sentence} argument. Possible choices are:
#'        \itemize{
#'           \item \code{most-prominent}: take the first value returned by the function \code{\link{get.color}};
#'           \item \code{median}: sort all the colors returned by the function \code{\link{get.color}} according to their hue and then take the median color;
#'           \item \code{mean}: take the mean of all the colors returned by the function \code{\link{get.color}} in the hsv space.
#'         }
#' @param language string defining the language of \code{sentence} (defaults to english).
#' @description If \code{sentence} contains more than 20 words, the text is summarized by means of Latent Dirichelet Allocation.
#'  When this is the case, the argument \code{n.colors} determines the number of topic to be
#'  identified in the text and cannot be set to \code{NULL}.
#' @return a color palette of \code{n.colors} elements.
#' @examples
#' mfl = "the rain in spain stays mainly in the plain"
#' mfl1 = create.palette(mfl, n.colors = 11)
#' mfl2 = create.palette(mfl, n.colors = 11, aggreg.method = "median")
#' plot(1:11, rep(0, 11), pch = 15, col = mfl1, cex = 4, axes = FALSE, xlab = "", ylab = "")
#' points(1:11, rep(-0.2, 11), pch = 15, col = mfl1, cex = 4)
#' @seealso \code{\link{get.color}}
#' @export
create.palette <- function(sentence, n.colors = NULL, sorted = TRUE, aggreg.method = "most-prominent", language = "en"){


  if(aggreg.method == "most-prominent") sorted = FALSE


  words = extract_words(sentence, language = language, n.topics = n.colors)
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

  pal = apply(col.list, 2, aggreg.colors, aggreg.method = aggreg.method)

  if(!is.null(n.colors)){
    grad.pal = colorRampPalette(pal)
    pal = grad.pal(n.colors)
  }

  return(pal)
}



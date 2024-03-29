% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/functions.R
\name{create.palette}
\alias{create.palette}
\title{Create a palette given multiple words}
\usage{
create.palette(sentence, n.colors = NULL, sorted = TRUE,
  aggreg.method = "most-prominent", language = "en")
}
\arguments{
\item{sentence}{a string of words}

\item{n.colors}{number of colors of the palette. If \code{NULL} (default) then n.colors is set to the number of words in the \code{sentence}argument}

\item{sorted}{logical, if \code{TRUE} then colors are sorted according to their hue.}

\item{aggreg.method}{method of aggregation of the colors corresponding to each word in the \code{sentence} argument. Possible choices are:
\itemize{
   \item \code{most-prominent}: take the first value returned by the function \code{\link{get.color}};
   \item \code{median}: sort all the colors returned by the function \code{\link{get.color}} according to their hue and then take the median color;
   \item \code{mean}: take the mean of all the colors returned by the function \code{\link{get.color}} in the hsv space.
 }}

\item{language}{string defining the language of \code{sentence} (defaults to english).}
}
\value{
a color palette of \code{n.colors} elements.
}
\description{
Create a palette given multiple words
}
\examples{
mfl = "the rain in spain stays mainly in the plain"
mfl1 = create.palette(mfl, n.colors = 11)
mfl2 = create.palette(mfl, n.colors = 11, aggreg.method = "median")
plot(1:11, rep(0, 11), pch = 15, col = mfl1, cex = 4, axes = FALSE, xlab = "", ylab = "")
points(1:11, rep(-0.2, 11), pch = 15, col = mfl1, cex = 4)
}
\seealso{
\code{\link{get.color}}
}

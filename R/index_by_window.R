# index_by_window.R
# v.0.0 Koshlan Mayer-Blackwell 2016-3-14

# Description: sliding window analysis can be useful for the detection of trends that may exist within 
# discrete time intervals but not the whole period of analysis.

# index_by_window() is a utility funciton that generates a list of different indices specifying a sliding window

#' index_by_window
#'
#' @param v is an index vector such as c(1,2,3,4,5)
#' @param n is an integer describing the size of the window 
#' @param by is an integer specifying the window step
#'
#' @return a list of indices
#' @export
#'
#' @examples
#' ind <- index_by_window(by =1, n = 4)
#' alphabet <- letters[1:26]
#' lapply(ind, function(x) alphabet[x])
#' 
index_by_window <- function(v=seq(1,10), n=5, by =1 ){
  vector_length <- length(v)
  end <- vector_length - n
  starts <- seq(1,end, by = by)
  return(lapply(starts, function(x) seq(x, x + n -1 )))
}















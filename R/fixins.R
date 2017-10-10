#' Translate from an R array to a python embedded list format.
#'
#' @param ary an at most 2d array
#' @param major should the array be column or row major?
#'
#' @return a string of the array in python list notation
array_to_pylist <- function(ary, major = c("row", "column")) {
    major <- match.arg(major)

    if (length(dim(ary)) > 2) {
        stop("array_to_pylist() can only handle up to two dimensions")
    }

    if (major == "row") {
        major <- 1
    } else if (major == "column") {
        major <- 2
    }

    strings <- apply(ary, major, function(ind) {
        paste0("[", paste(ind, collapse =', '), "]")
    })

    return(paste0("[", paste(strings, collapse =', '), "]"))
}



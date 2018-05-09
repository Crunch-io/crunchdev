# Functions from crunch-test.R copied and exported here to be more easily
# available without having to source crunch-test

#' Load a CrunchCube fixture from file
#'
#' @param filename a character filename to load teh fixture from
#'
#' @return a CrunchCube
#' @export
loadCube <- function (filename) {
    crunch:::CrunchCube(jsonlite::fromJSON(filename, simplifyVector=FALSE)$value)
}

#' Turn readable test expectations into an array
#'
#' @param ... any number of numerics to turn into an array
#' @param dims the dimensions of array to return
#'
#' @return an array with the contents of `...`` with the shape of `dims`
#' @export
cubify <- function (..., dims) {
    ## Make readable test expectations for comparing cube output
    ## Borrowed from Cube arrays, fixtures and cubes come in row-col-etc. order,
    ## not column-major. Make array, then aperm the array back to order
    data <- c(...)
    d <- rev(vapply(dims, length, integer(1), USE.NAMES=FALSE))

    out <- array(data, dim=d)
    if (length(dims) > 1) {
        ap <- seq_len(length(dims))
        ap <- rev(ap)
        out <- aperm(out, ap)
    }
    dimnames(out) <- dims
    return(out)
}
# Functions from crunch-test.R exported here to be more easily available without
# having to source crunch-test

#' @importFrom crunch temp.option temp.options datasets projects urls crDELETE
#' @importFrom testthat with_mock skip
NULL

# datasets.start projects.start users.start will be undefined global functions
# on source
source(system.file("crunch-test.R", package="crunch"), local = TRUE)

#' Load a CrunchCube fixture from file
#'
#' @param filename a character filename to load the fixture from
#'
#' @return a CrunchCube
#' @export
loadCube <- loadCube


#' Turn readable test expectations into an array
#'
#' @param ... any number of numerics to turn into an array
#' @param dims the dimensions of array to return
#'
#' @return an array with the contents of `...`` with the shape of `dims`
#' @export
cubify <- cubify
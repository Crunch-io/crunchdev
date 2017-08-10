# crunchdev

[![Build Status](https://travis-ci.org/Crunch-io/crunchdev.png?branch=master)](https://travis-ci.org/Crunch-io/crunchdev)  [![codecov](https://codecov.io/gh/Crunch-io/crunchdev/branch/master/graph/badge.svg)](https://codecov.io/gh/Crunch-io/crunchdev)
[![cran](https://www.r-pkg.org/badges/version-last-release/crunchdev)](https://cran.r-project.org/package=crunchdev)

The crunchdev package offers a number of convenience functions and RStudio addins to make developing crunch packages quicker and faster.

## Installing

The pre-release version of the package can be pulled from GitHub using the [devtools](https://github.com/hadley/devtools) package:

    # install.packages("devtools")
    devtools::install_github("Crunch-io/crunchdev", build_vignettes=TRUE)

## For developers

The repository includes a Makefile to facilitate some common tasks.

### Running tests

`$ make test`. Requires the [testthat](https://github.com/hadley/testthat) package. You can also specify a specific test file or files to run by adding a "file=" argument, like `$ make test file=logging`. `test_package` will do a regular-expression pattern match within the file names. See its documentation in the `testthat` package.

### Updating documentation

`$ make doc`. Requires the [roxygen2](https://github.com/klutometis/roxygen) package.

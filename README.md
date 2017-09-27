# crunchdev

[![Build Status](https://travis-ci.org/Crunch-io/crunchdev.png?branch=master)](https://travis-ci.org/Crunch-io/crunchdev)  [![codecov](https://codecov.io/gh/Crunch-io/crunchdev/branch/master/graph/badge.svg)](https://codecov.io/gh/Crunch-io/crunchdev)
[![cran](https://www.r-pkg.org/badges/version-last-release/crunchdev)](https://cran.r-project.org/package=crunchdev)

The crunchdev package offers a number of convenience functions and [RStudio addins](https://rstudio.github.io/rstudioaddins/) to make developing crunch packages quicker and faster.

## Installing
The pre-release version of the package can be pulled from GitHub using the [devtools](https://github.com/hadley/devtools) package:

    # install.packages("devtools")
    devtools::install_github("Crunch-io/crunchdev")

## Configuration
Before using `crunchdev` there are a few options that should be added to your `~/.Rprofile`:

1. host name url maps --- there are two groups: `user.hosts` and `test.hosts` the first uses user authentication, and the second uses test user authentication. Each list can have any number of hostnames and urls.

    crunchdev.user.hosts=c("app" = "https://app.crunch.io/api/"),
    crunchdev.test.hosts=c(
	       "local" = "http://local.crunch.io/api/",
	       "testing server" = "https://testing.crunch.io/api/")
	       
1. authentication maps --- again, there are two groups: `user.auth` and `test.auth` the first is used for all hosts in `crunchdev.user.hosts`, and the second is used for all hosts in `crunchdev.test.hosts`. Each one should only contain one email and password.

    crunchdev.user.auth=c("email" = "magic.user@crunch.io",
                          "pw" = "t0pSecretP@ssw0rD"),
    crunchdev.test.auth=c("email" = "magic.testuser@crunch.io",
                          "pw" = "t0pSecretP@ssw0rD")
	       

## Addins
RStudio allows keyboard shortcuts to be bound to addins. The addins provided by crunchdev are designed to make iteration and test running quick and easy. *Note:* currently launching a terminal from RStudio requires installing [rstudioapi from feature/terminal](https://github.com/rstudio/rstudioapi/pull/52) and requires RStudio [version >= 1.1.331](https://dailies.rstudio.com/).

* Test running — For all of the test addins a configuration dialog will appear with optional settings. When done (or return) is pressed, a new terminal will launch and the tests will be run in a new, clean session.
  * Test all (Crunch) — test configuration preset to run all unit tests Suggest key binding: `shift+alt+u`
  * Test active doc (Crunch) — test configuration preset to run unit tests with the filter set for the active file (eg having `test-dataset-reference.R` active will prefill `dataset-reference` in the filter box) Suggest key binding: `shift+cmd+u`
  * Test active doc integration (Crunch) — test configuration preset to run unit and integration tests with the filter set for the active file Suggest key binding: `shift+cmd+i`
* Load all (Crunch) — tries to `logout()` before running `devtools::load_all()` this cleans up interactive iteration and reloading of Crunch packages, Since the `logout()` is run within `try()` this addin should be safe to remap `shift+cmd+l` globally.

## For developers

The repository includes a Makefile to facilitate some common tasks.

### Running tests

`$ make test`. Requires the [testthat](https://github.com/hadley/testthat) package. You can also specify a specific test file or files to run by adding a "file=" argument, like `$ make test file=logging`. `test_package` will do a regular-expression pattern match within the file names. See its documentation in the `testthat` package.

### Updating documentation

`$ make doc`. Requires the [roxygen2](https://github.com/klutometis/roxygen) package.

# crunchdev

[![Build Status](https://travis-ci.org/Crunch-io/crunchdev.png?branch=master)](https://travis-ci.org/Crunch-io/crunchdev)  [![codecov](https://codecov.io/gh/Crunch-io/crunchdev/branch/master/graph/badge.svg)](https://codecov.io/gh/Crunch-io/crunchdev)
[![cran](https://www.r-pkg.org/badges/version-last-release/crunchdev)](https://cran.r-project.org/package=crunchdev)

The crunchdev package offers a number of convenience functions and [RStudio addins](https://rstudio.github.io/rstudioaddins/) to make developing crunch packages quicker and faster. 

Highlights of CrunchDev include:
* *addins for quickly and easily specifying host, test type (unit vs integration), and file filters* These make it quick and easy to run tests on specific files which speeds up how quickly you can see if those test pass or fail, and can get back into the code. It handles all of the logic for setting up hosts and authentication for integration tests so you don't have to change any configurations or options to run them. Test are run in a terminal within RStudio so they won't block any other processes or coding you might want to do.
* *easily change backends interactively with `setupCrunch()`* There are a number of backends that are useful to use in the process of developing Crunch packages. This function lets you change which backend you are configured to connect to (eg changes the `crunch.email`, `crunch.pw`, and `crunch.api` options). No more fumbling with changing options or reloading R.

## Installing
The pre-release version of the package can be pulled from GitHub using the [devtools](https://github.com/hadley/devtools) package:

    # install.packages("devtools")
    devtools::install_github("Crunch-io/crunchdev")

## Configuration
Before using `crunchdev` there are a few options that should be added to your `~/.Rprofile`:

1. host name url maps --- there are two groups: `user.hosts` and `test.hosts` the first uses user authentication, and the second uses test user authentication. Each list can have any number of hostnames and urls.

```
crunchdev.user.hosts=c("stableapp" = "https://stableapp.crunch.io/api/"),
crunchdev.test.hosts=c(
       "local" = "http://local.crunch.io/api/",
       "testing server" = "https://testing.crunch.io/api/")
```
	       
1. authentication maps --- again, there are two groups: `user.auth` and `test.auth` the first is used for all hosts in `crunchdev.user.hosts`, and the second is used for all hosts in `crunchdev.test.hosts`. Each one should only contain one email and password.

```
crunchdev.user.auth=c("email" = "magic.user@crunch.io",
                      "pw" = "t0pSecretP@ssw0rD"),
crunchdev.test.auth=c("email" = "magic.testuser@crunch.io",
                      "pw" = "t0pSecretP@ssw0rD")
```
			  
### Example additions to an `.Rprofile`
```
options(
    crunchdev.user.auth=c("email" = "developer@crunch.io",
    "pw" = "super_secre7_passw0rd"),
    crunchdev.test.auth=c("email" = "tester@crunch.io",
    "pw" = "passw0rd_wh1ch_1s_super_secre7"),
    crunchdev.user.hosts=c("aleph" = "https://aleph.crunch.io/api/"),
    crunchdev.test.hosts=c(
	       "bet" = "https://bet.crunch.io/api/",
	       "gimmel" = "https://gimmel.crunch.io/api/")
)
```


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

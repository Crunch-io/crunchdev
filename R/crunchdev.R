# Here's a good place to put your top-level package documentation

.onAttach <- function (lib, pkgname="crunchdev") {
    ## Put stuff here you want to run when your package is loaded
    invisible()
}

#' logout of Crunch before load_alling
#'
#' A replacement for [`devtools::load_all`] will try to logout before runing
#' `devtools::load_all` so that multiple logins are not in the same session
#'
#' @param ... options passed to `load_all`
#'
#' @return nothing
#'
#' @export
load_all <- function(...) {
    try(crunch::logout())
    devtools::load_all(...)
}


captain_hosts <- c("local" = "http://local.crunch.io:8080/api/",
                   "stable" = "https://stable.crunch.io/api/",
                   "test01" = "https://test01.crunch.io/api/")
user_hosts <- c("alpha" = "https://alpha.crunch.io/api/")


#' Function to configure and kick off tests of Crunch packages
#'
#' Gets document context, and then presents the test_gadget which has
#' configuration options for testing Crunch packages
#'
#' @param filter a character of the regex of the filter to pre-populate
#' the test gadget input with
#' @param ... options to pass to the test_gadget
#'
#' @return nothing
#'
#' @export
test_crunch <- function(filter = NULL, ...) {
    if (is.null(filter)) {
        # TODO: do some matching here to check if the active R/(.*).R doc has a
        # matching test-\\1.R, if not do all
        doc <- rstudioapi::getActiveDocumentContext()
        file <- basename(doc$path)
        filter <- gsub("^test-|\\.R$", "", file)
    } else {
        filter <- filter
    }

    test_opts <- test_gadget(filter = filter, ...)

    if (test_opts$host %in% captain_hosts) {
        user <- sprintf("R_TEST_USER=%s", envOrOption("test.user"))
        pw <- sprintf("R_TEST_PW=%s", envOrOption("test.pw"))
    } else {
        user <- sprintf("R_TEST_USER=%s", envOrOption("crunch.email"))
        pw <- sprintf("R_TEST_PW=%s", envOrOption("crunch.pw"))
    }

    test_cmd <- sprintf("R --slave -e 'options(crunch.check.updates=FALSE); devtools::test(filter=\"%s\")'", test_opts$filter)
    integration <- sprintf("INTEGRATION=%s",as.character(test_opts$type == "integration"))
    api <- sprintf("R_TEST_API=%s",test_opts$host)
    rstudioapi::terminalExecute(
        test_cmd,
        env=c(api, integration, user, pw))
}

# copied directly from crunch, should be moved to crunchdev eventually
envOrOption <- function (opt) {
    ## .Rprofile options are like "test.api", while env vars are "R_TEST_API"
    envvar.name <- paste0("R_", toupper(gsub(".", "_", opt, fixed=TRUE)))
    envvar <- Sys.getenv(envvar.name)
    if (nchar(envvar)) {
        ## Let environment variable override .Rprofile, if defined
        return(envvar)
    } else {
        return(getOption(opt))
    }
}

test_crunch_int <- function() test_crunch(filter=NULL, test_type="integration")
test_crunch_all <- function() test_crunch(filter=".*")
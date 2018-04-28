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
    opts <- setup_host_auth(test_opts)

    test_cmd <- sprintf("R --vanilla --quiet --no-save --no-restore -e 'library(httptest); options(crunch.check.updates=FALSE); devtools::test(filter=\"%s\")' \n", test_opts$filter)
    integration <- as.character(test_opts$type == "integration")
    crunch_terminal(
        test_cmd,
        env=c(R_TEST_API=opts$host, INTEGRATION=integration,
              R_TEST_USER=opts$user, R_TEST_PW=opts$pw))
}

test_crunch_int <- function() test_crunch(filter=NULL, test_type="integration")
test_crunch_all <- function() test_crunch(filter=".*")

setup_host_auth <- function (opts) {
    if (!grepl("https?://.*", opts$host)) {
        all_hosts <- c(crunch::envOrOption("crunchdev.test.hosts"),
                       crunch::envOrOption("crunchdev.user.hosts"))
        opts$host <- all_hosts[opts$host]
    }

    if (opts$host %in% crunch::envOrOption("crunchdev.test.hosts")) {
        opts$user <- crunch::envOrOption("crunchdev.test.auth")[["email"]]
        opts$pw <- crunch::envOrOption("crunchdev.test.auth")[["pw"]]
    } else {
        opts$user <- crunch::envOrOption("crunchdev.user.auth")[["email"]]
        opts$pw <- crunch::envOrOption("crunchdev.user.auth")[["pw"]]
    }
    return(opts)
}

#' Check package coverage and shine the result
#'
#' A convenience method for `covr::shine(covr::package_coverage())`
#'
#' @param ... options passed to `package_coverage`
#'
#' @return nothing
#'
#' @export
shine_covr <- function(...) {
    pkg_coverage <- covr::package_coverage(...)
    covr::report(pkg_coverage)
}

#' Setup Crunch to use a particular backend
#'
#' If the host provided is in the `crunchdev.test.hosts` group, test authentication will be set (`crunchdev.test.auth`). Otherwise, user authentication will be set. If `host` is not recognized, it will be passed to [crunch::setCrunchAPI()]
#'
#' @param host host to connect to (e.g. "app", "local")
#' @param ... passed to [crunch::setCrunchAPI()]
#'
#' @return nothing
#'
#' @export
setupCrunch <- function (host, ...) {
    opts <- setup_host_auth(list("host" = host))

    if (is.na(opts$host)) {
        crunch::setCrunchAPI(host, ...)
    } else {
        options(
            "crunch.api" = opts$host
        )
    }

    options(
        "crunch.email" = opts$user,
        "crunch.pw" = opts$pw
    )

    message("Crunch will connect to ", getOption("crunch.api"),
            " with ", getOption("crunch.email"))

    return(invisible(opts))
}


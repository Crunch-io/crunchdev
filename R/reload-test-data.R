#' Reload test data
#'
#' Reloads all types, mrdf, mrdf with a multiple resonse and apidocs test data
#' to whichever backend is set in options.
#'
#' @export
reload_test_data <- function () {
    login()

    message("Loading all types")
    ## Data frames to make datasets with
    df <- data.frame(v1=c(rep(NA_real_, 5), rnorm(15)),
                     v2=c(letters[1:15], rep(NA_character_, 5)),
                     v3=8:27,
                     v4=as.factor(LETTERS[2:3]),
                     v5=as.Date(0:19, origin="1955-11-05"),
                     v6=TRUE,
                     stringsAsFactors=FALSE)
    newDataset(df, name = "test ds")

    mrdf <- data.frame(mr_1=c(1,0,1,NA_real_),
                       mr_2=c(0,0,1,NA_real_),
                       mr_3=c(0,0,1,NA_real_),
                       v4=as.factor(LETTERS[2:3]),
                       stringsAsFactors=FALSE)
    message("Loading cat array data")
    mrdf.setup(newDataset(mrdf, name = "test-mrdf"))
    message("Loading multiple response data")
    mrdf.setup(newDataset(mrdf, name = "test-mrdfmr"), selections = "1.0")
    message("Loading apidocs data")
    newDatasetFromFixture("./tests/testthat", "apidocs")

    return()
}

# copied directly from crunch, should be moved to crunchdev eventually
# setup a multiple response variable
mrdf.setup <- function (dataset, pattern="mr_", name=ifelse(is.null(selections),
                                                            "CA", "MR"), selections=NULL) {
    cast.these <- grep(pattern, names(dataset))
    dataset[cast.these] <- lapply(dataset[cast.these],
                                  castVariable, "categorical")
    if (is.null(selections)) {
        dataset[[name]] <- makeArray(dataset[cast.these], name=name)
    } else {
        dataset[[name]] <- makeMR(dataset[cast.these], name=name,
                                  selections=selections)
    }
    return(dataset)
}


# copied directly from crunch, should be moved to crunchdev eventually
newDatasetFromFixture <- function (path_prefix, filename) {
    ## Grab csv and json from "dataset-fixtures" and make a dataset
    m <- fromJSON(file.path(path_prefix, "dataset-fixtures", paste0(filename, ".json")),
                  simplifyVector=FALSE)
    return(suppressMessages(createWithMetadataAndFile(m,
                                                      file.path(path_prefix, "dataset-fixtures", paste0(filename, ".csv")))))
}
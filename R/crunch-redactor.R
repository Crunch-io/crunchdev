#' A default redactor for Crunch payloads
#'
#' @param response the response to redact
#'
#' @importFrom magrittr "%>%"
redact_crunch <- function (response) {
    response %>%
        httptest::redact_auth() %>%
        # Prune UUIDs
        httptest::gsub_response("([0-9a-f]{6})[0-9a-f]{26}", "\\1") %>%
        # Progress is meaningless in mocks
        httptest::gsub_response("https.//app.crunch.io/api/progress/.*?/",

                      "https://app.crunch.io/api/progress/") %>%
        # Shorten URLs (including encoded ones)
        httptest::gsub_response("https?.//(app|alpha|local).crunch.io", "") %>%
        httptest::gsub_response("https?%3A%2F%2F(app|alpha|local).crunch.io", "")
}

#' A quick shortcut to enable httptest redaction for Crunch payloads
#'
#' @export
enable_crunch_redactor <- function() httptest::set_redactor(redact_crunch)

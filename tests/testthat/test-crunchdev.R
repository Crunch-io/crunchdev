context("crunch dev")

# setup options to use
options(
    crunchdev.user.auth=c("email" = "user@crunch.io",
                          "pw" = "supersupersecret"),
    crunchdev.test.auth=c("email" = "tester@crunch.io",
                          "pw" = "iknowhowtomakepws"),
    crunchdev.user.hosts=c("beta" = "https://beta.crunch.io/api/"),
    crunchdev.test.hosts=c("testing" = "http://testing.crunch.io:8080/api/")
)

test_that("setup_host_auth", {
    expect_equivalent(setup_host_auth(list(host = "beta")),
                      list(host = c("beta" = "https://beta.crunch.io/api/"),
                           user = "user@crunch.io",
                           pw = "supersupersecret"))
    expect_equivalent(setup_host_auth(list(host = "app")),
                      list(host = NA_character_,
                           user = "user@crunch.io",
                           pw = "supersupersecret"))
    expect_equivalent(setup_host_auth(list(host = "testing")),
                      list(host = c("testing" = "http://testing.crunch.io:8080/api/"),
                           user = "tester@crunch.io",
                           pw = "iknowhowtomakepws"))
})

test_that("setupCrunch", {
    setupCrunch("beta")
    expect_equivalent(getOption("crunch.api"), "https://beta.crunch.io/api/")
    expect_equivalent(getOption("crunch.email"), "user@crunch.io")
    expect_equivalent(getOption("crunch.pw"), "supersupersecret")

    setupCrunch("testing")
    expect_equivalent(getOption("crunch.api"), "http://testing.crunch.io:8080/api/")
    expect_equivalent(getOption("crunch.email"), "tester@crunch.io")
    expect_equivalent(getOption("crunch.pw"), "iknowhowtomakepws")

    setupCrunch("app")
    expect_equivalent(getOption("crunch.api"), "https://app.crunch.io/api/")
    expect_equivalent(getOption("crunch.email"), "user@crunch.io")
    expect_equivalent(getOption("crunch.pw"), "supersupersecret")

    setupCrunch("app", 8888)
    expect_equivalent(getOption("crunch.api"), "http://app.crunch.io:8888/api/")
    expect_equivalent(getOption("crunch.email"), "user@crunch.io")
    expect_equivalent(getOption("crunch.pw"), "supersupersecret")
})

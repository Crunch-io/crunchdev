context("crunch terminal")

test_that("make_env_strings works", {
    expect_equal(make_env_strings(c(foo="bar", baz="qux")),
                 "export foo=bar\nexport baz=qux")
})

context("fixins")

test_that("array_to_pylist", {
    ary <- array(c(1, 2, 3, 4, 5, 6), dim = c(2,3))
    expect_equal(array_to_pylist(ary, major = "row"),
                 "[[1, 3, 5], [2, 4, 6]]")
    expect_equal(array_to_pylist(ary, major = "col"),
                 "[[1, 2], [3, 4], [5, 6]]")
})


test_that("array_to_pylist is limited to 2d", {
    ary <- array(c(1, 2, 3, 4, 5, 6), dim = c(2,3))
    expect_error(array_to_pylist(ary, major = "afsdasdfsd"),
                 "'arg' should be one of ")
})

test_that("array_to_pylist is limited to 2d", {
    ary <- array(c(1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6), dim = c(2,3, 2))
    expect_error(array_to_pylist(ary, major = "row"),
                 "array_to_pylist\\(\\) can only handle up to two dimensions")
})

test_that('duplicate variable names are not allowed', {
  x = matrix(11:20, ncol = 2, dimnames = list(NULL, c("a", "a")))

  err = "Duplicate variable names are not allowed"
  expect_error(as_draws_matrix(x), err)
  expect_error(as_draws_df(x), err)
  expect_error(as_draws_list(x), err)
  expect_error(as_draws_array(x), err)
})

test_that("variables() work with NULL", {
  expect_equal(variables(NULL), NULL)
})

test_that("variables() and variables<-() work on draws_matrix", {
  x <- as_draws_matrix(matrix(11:20, ncol = 2, dimnames = list(NULL, c("a", "b"))))

  ref <- as_draws_matrix(matrix(11:20, ncol = 2, dimnames = list(NULL, c("x", "y[1]"))))

  expect_equal(variables(x), c("a", "b"))
  expect_equal(variables(ref), c("x", "y[1]"))

  variables(x) <- c("x", "y[1]")
  expect_equal(x, ref)
})

test_that("variables() and variables<-() work on draws_array", {
  x <- as_draws_array(matrix(11:20, ncol = 2, dimnames = list(NULL, c("a", "b"))))

  ref <- as_draws_array(matrix(11:20, ncol = 2, dimnames = list(NULL, c("x", "y[1]"))))

  expect_equal(variables(x), c("a", "b"))
  expect_equal(variables(ref), c("x", "y[1]"))

  variables(x) <- c("x", "y[1]")
  expect_equal(x, ref)
})

test_that("variables() and variables<-() work on draws_list", {
  x <- as_draws_list(matrix(11:20, ncol = 2, dimnames = list(NULL, c("a", "b"))))

  ref <- as_draws_list(matrix(11:20, ncol = 2, dimnames = list(NULL, c("x", "y[1]"))))

  expect_equal(variables(x), c("a", "b"))
  expect_equal(variables(ref), c("x", "y[1]"))

  variables(x) <- c("x", "y[1]")
  expect_equal(x, ref)
})

test_that("variables() and variables<-() work on draws_df", {
  x <- as_draws_df(matrix(11:20, ncol = 2, dimnames = list(NULL, c("a", "b"))))

  ref <- as_draws_df(matrix(11:20, ncol = 2, dimnames = list(NULL, c("x", "y[1]"))))

  expect_equal(variables(x), c("a", "b"))
  expect_equal(variables(ref), c("x", "y[1]"))

  variables(x) <- c("x", "y[1]")
  expect_equal(x, ref)
})

test_that("variables() and variables<-() work on draws_rvars", {
  x <- as_draws_rvars(matrix(11:20, ncol = 2, dimnames = list(NULL, c("a", "b"))))

  ref <- as_draws_rvars(matrix(11:20, ncol = 2, dimnames = list(NULL, c("x", "y[1]"))))

  # variables works a bit differently for draws_rvars
  expect_equal(variables(x), c("a", "b"))
  expect_equal(variables(ref), c("x", "y"))

  variables(x) <- c("x", "y")
  expect_equal(x, ref)
})

test_that("variables() works on draws_df with duplicate columns", {
  # in the annoying case where someone manually changes a draws_df to have duplicate columns,
  # make sure that variables() returns the correct result...
  x <- as_draws_df(matrix(11:20, ncol = 2, dimnames = list(NULL, c("a", "b"))))
  names(x)[names(x) == "b"] = "a"

  expect_equal(variables(x), c("a", "a"))
})

test_that("variables() works on NULL", {
  expect_equal(variables(NULL), NULL)
})

# since set_variables is just a wrapper around variables() this only
# tests it on draws_matrix for now. See the tests for variables() for
# format-specific tests.
test_that("set_variables works on draws_matrix", {
  x <- as_draws_matrix(matrix(11:20, ncol = 2, dimnames = list(NULL, c("a", "b[1]"))))

  ref <- as_draws_matrix(matrix(11:20, ncol = 2, dimnames = list(NULL, c("c", "d"))))
  expect_equal(set_variables(x, c("c", "d")), ref)
})

test_that("cannot set a variable to a reserved word", {
  x <- as_draws_matrix(matrix(11:20, ncol = 2, dimnames = list(NULL, c("a", "b[1]"))))
  err <- "Variable names.*are reserved"
  expect_error(set_variables(x, c(".chain", "b[1]")), err)
  expect_error(set_variables(x, c(".iteration", "b[1]")), err)
  expect_error(set_variables(x, c(".draw", "b[1]")), err)
})

test_that("cannot set duplicate variable names", {
  x <- as_draws_matrix(matrix(11:20, ncol = 2, dimnames = list(NULL, c("a", "b[1]"))))
  expect_error(set_variables(x, c("a", "a")), "Duplicate variable names are not allowed")
})


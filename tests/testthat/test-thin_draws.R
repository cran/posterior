test_that("thin_draws works correctly", {
  x <- as_draws_array(example_draws())
  expect_equal(niterations(thin_draws(x, 5L)), niterations(x) / 5)
  expect_equal(x, thin_draws(x, thin = 1L))
  expect_error(thin_draws(x, -1), "'thin' must be a positive integer")
  expect_error(thin_draws(x, 1000), "'thin' must be smaller than")
})

test_that("thin_draws works on rvars", {
  x <- example_draws()

  expect_equal(thin_draws(as_draws_rvars(x)$theta, 10L), as_draws_rvars(thin_draws(x, 10L))$theta)
})

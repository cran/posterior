# base apply functions ---------------------------------------------------------

test_that("base apply family functions work", {
  x_array = array(1:24, dim = c(2,3,4))
  x = rvar(x_array)

  expect_equal(lapply(x, function(x) sum(draws_of(x))), as.list(apply(draws_of(x), 2, sum)))
  expect_equal(sapply(x, function(x) sum(draws_of(x))), apply(draws_of(x), 2, sum))
  expect_equal(vapply(x, function(x) sum(draws_of(x)), numeric(1)), apply(draws_of(x), 2, sum))
  expect_equal(apply(x, 1, function(x) sum(draws_of(x))), apply(draws_of(x), 2, sum))
  expect_equal(apply(x, 1:2, function(x) sum(draws_of(x))), apply(draws_of(x), 2:3, sum))
})

# base apply functions (factors) ---------------------------------------------------------

test_that("base apply family functions work with rvar_factor", {
  x_array = array(c("a","a","a","a", letters[1:20]), dim = c(2,3,4), dimnames = list(NULL, letters[1:3], NULL))
  x = rvar(x_array)

  expect_equal(lapply(x, function(x) sum(draws_of(x) == "a")), list(a = 2, b = 2, c = 1))
  expect_equal(sapply(x, function(x) sum(draws_of(x) == "a")), c(a = 2, b = 2, c = 1))
  expect_equal(vapply(x, function(x) sum(draws_of(x) == "a"), numeric(1)), c(a = 2, b = 2, c = 1))
  expect_equal(apply(x, 1, function(x) sum(draws_of(x) == "a")), c(a = 2, b = 2, c = 1))
  expect_equal(
    apply(x, 1:2, function(x) sum(draws_of(x) == "a")),
    array(c(2, 2, 1, rep(0, 9)), dim = c(3, 4), dimnames = list(c("a","b","c"), NULL))
  )
})


# rvar_apply --------------------------------------------------------------

test_that("rvar_apply works", {
  x_array = array(1:36, dim = c(2,2,3,3),
    dimnames = list(NULL, A = paste0("a", 1:2), B = paste0("b", 1:3), C = paste0("c", 1:3))
  )
  x = rvar(x_array)

  expect_equal(rvar_apply(x, 1, rvar_mean), rvar(apply(draws_of(x), 1:2, mean)))
  expect_equal(rvar_apply(x, 2, rvar_mean), rvar(apply(draws_of(x), c(1,3), mean)))
  expect_equal(rvar_apply(x, 3, rvar_mean), rvar(apply(draws_of(x), c(1,4), mean)))
  expect_equal(rvar_apply(x, c(1,2), rvar_mean), rvar(apply(draws_of(x), c(1,2,3), mean)))
  expect_equal(rvar_apply(x, c(1,3), rvar_mean), rvar(apply(draws_of(x), c(1,2,4), mean)))

  expect_error(rvar_apply(x, c(1,3), function(x) 0))

  expect_equal(length(rvar_apply(x, c(1,3), function(x) rvar())), 0)

  # test that if the cell values are multidimensional everything is bound back
  # together properly (though with dimnames dropped)
  x1 <- x + 1
  dimnames(x1)[3] <- list(NULL)
  names(dimnames(x1))[[3]] <- ""
  expect_equal(rvar_apply(x, c(1,2), function(x) x + 1), x1)

  # test that binding results together does broadcasting: x["a1",] has a mean
  # < 18 and ref["a2",] has mean > 18 and will be replaced with 0 with this
  ref <- x
  ref["a1",,] <- ref["a1",,] + 1
  ref["a2",,] <- 0
  expect_equal(rvar_apply(x, 1, function(x) if(mean(draws_of(x)) > 18) rvar(0) else x + 1), ref)
})


# rvar_apply with factors -------------------------------------------------

test_that("rvar_apply works with rvar_factor", {
  x_array = array(rep_len(letters[1:10], 36), dim = c(2,2,3,3),
    dimnames = list(NULL, A = paste0("a", 1:2), B = paste0("b", 1:3), C = paste0("c", 1:3))
  )
  x = rvar(x_array)

  expect_equal(rvar_apply(x, 1, identity), x)
  expect_equal(rvar_apply(x, 1, `[[`, 2), x[,2,1, drop = TRUE])
  expect_equal(rvar_apply(x, 2, `[[`, 1), x[1,,1, drop = TRUE])
  expect_equal(rvar_apply(x, c(1,2), `[[`, 3), x[,,3, drop = TRUE])
  expect_equal(rvar_apply(x, c(1,3), `[[`, 1), x[,1,, drop = TRUE])

  # if the rvar is ordered is preserved
  expect_equal(rvar_apply(rvar_ordered(x), 1, identity), rvar_ordered(x))

  # test that binding results together does broadcasting: cells with "d"
  # will be replaced with all "XXX" draws with this
  ref <- x
  levels(ref) <- c(levels(ref), "XXX")
  ref["a2","b1","c1"] <- "XXX"
  ref["a1","b1","c2"] <- "XXX"
  ref["a2","b3","c2"] <- "XXX"
  ref["a1","b3","c3"] <- "XXX"
  expect_equal(rvar_apply(x, 1:3, function(x) if ("d" %in% draws_of(x)) rvar("XXX") else drop(x)), ref)
})

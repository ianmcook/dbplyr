test_that("symbols weights are dropped in output", {
  # workaround so that sql snapshot is always the same
  withr::local_options(list(dbplyr_table_name = 2000))
  df <- memdb_frame(x = 1, w = 1)
  expect_equal(dbplyr_uncount(df, w) %>% collect(), tibble(x = 1))

  expect_snapshot(dbplyr_uncount(df, w) %>% show_query())
})

test_that("can request to preserve symbols", {
  df <- memdb_frame(x = 1, w = 1)

  expect_equal(
    dbplyr_uncount(df, w, .remove = FALSE) %>% colnames(),
    c("x", "w")
  )
})

test_that("unique identifiers created on request", {
  df <- memdb_frame(w = 1:3)
  expect_equal(
    dbplyr_uncount(df, w, .id = "id") %>% collect(),
    tibble(id = c(1L, 1:2, 1:3))
  )
})

test_that("expands constants and expressions", {
  df <- memdb_frame(x = 1, w = 2)

  expect_equal(dbplyr_uncount(df, 2) %>% collect(), collect(df)[c(1, 1), ])
  expect_equal(dbplyr_uncount(df, 1 + 1) %>% collect(), collect(df)[c(1, 1), ])
})


test_that("works with groups", {
  df <- memdb_frame(g = 1, x = 1, w = 1) %>% dplyr::group_by(g)
  expect_equal(group_vars(dbplyr_uncount(df, w)), "g")
})

test_that("grouping variable are removed", {
  df <- memdb_frame(g = 1, x = 1, w = 1) %>% dplyr::group_by(g)

  expect_equal(dbplyr_uncount(df, g) %>% colnames(), c("x", "w"))
})

test_that("must evaluate to integer", {
  df <- memdb_frame(x = 1, w = 1/2)
  expect_error(dbplyr_uncount(df, w), class = "vctrs_error_cast_lossy")

  expect_error(dbplyr_uncount(df, "W"), class = "vctrs_error_incompatible_type")
})

test_that("works with 0 weights", {
  df <- memdb_frame(x = 1:2, w = c(0, 1))
  expect_equal(dbplyr_uncount(df, w) %>% collect(), tibble(x = 2))
})

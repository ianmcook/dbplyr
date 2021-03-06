% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/test-frame.R
\name{testing}
\alias{testing}
\alias{test_register_src}
\alias{test_register_con}
\alias{src_test}
\alias{test_load}
\alias{test_frame}
\title{Infrastructure for testing dplyr}
\usage{
test_register_src(name, src)

test_register_con(name, ...)

src_test(name)

test_load(
  df,
  name = unique_table_name(),
  srcs = test_srcs$get(),
  ignore = character()
)

test_frame(..., srcs = test_srcs$get(), ignore = character())
}
\description{
Register testing sources, then use \code{test_load()} to load an existing
data frame into each source. To create a new table in each source,
use \code{test_frame()}.
}
\examples{
\dontrun{
test_register_src("sqlite", {
  DBI::dbConnect(RSQLite::SQLite(), ":memory:", create = TRUE)
})

test_frame(x = 1:3, y = 3:1)
test_load(mtcars)
}
}
\keyword{internal}

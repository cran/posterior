% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rvar-summaries-over-draws.R
\name{rvar-summaries-over-draws}
\alias{rvar-summaries-over-draws}
\alias{E}
\alias{mean.rvar}
\alias{Pr}
\alias{Pr.default}
\alias{Pr.logical}
\alias{Pr.rvar}
\alias{median.rvar}
\alias{min.rvar}
\alias{max.rvar}
\alias{sum.rvar}
\alias{prod.rvar}
\alias{all.rvar}
\alias{any.rvar}
\alias{Summary.rvar}
\alias{variance.rvar}
\alias{var}
\alias{var.default}
\alias{var.rvar}
\alias{sd}
\alias{sd.default}
\alias{sd.rvar}
\alias{mad}
\alias{mad.default}
\alias{mad.rvar}
\alias{mad.rvar_ordered}
\alias{range.rvar}
\alias{is.finite.rvar}
\alias{is.infinite.rvar}
\alias{is.nan.rvar}
\alias{is.na.rvar}
\title{Summaries of random variables within array elements, over draws}
\usage{
E(x, ...)

\method{mean}{rvar}(x, ...)

Pr(x, ...)

\method{Pr}{default}(x, ...)

\method{Pr}{logical}(x, ...)

\method{Pr}{rvar}(x, ...)

\method{median}{rvar}(x, ...)

\method{min}{rvar}(x, ...)

\method{max}{rvar}(x, ...)

\method{sum}{rvar}(x, ...)

\method{prod}{rvar}(x, ...)

\method{all}{rvar}(x, ...)

\method{any}{rvar}(x, ...)

\method{Summary}{rvar}(...)

\method{variance}{rvar}(x, ...)

var(x, ...)

\method{var}{default}(x, ...)

\method{var}{rvar}(x, ...)

sd(x, ...)

\method{sd}{default}(x, ...)

\method{sd}{rvar}(x, ...)

mad(x, ...)

\method{mad}{default}(x, ...)

\method{mad}{rvar}(x, ...)

\method{mad}{rvar_ordered}(x, ...)

\method{range}{rvar}(x, ...)

\method{is.finite}{rvar}(x)

\method{is.infinite}{rvar}(x)

\method{is.nan}{rvar}(x)

\method{is.na}{rvar}(x)
}
\arguments{
\item{x}{(rvar) An \code{\link{rvar}}.}

\item{...}{Further arguments passed to underlying functions (e.g.,
\code{base::mean()} or \code{base::median()}), such as \code{na.rm}.}
}
\value{
A numeric or logical vector with the same dimensions as the given random variable, where
each entry in the vector is the mean, median, or variance of the corresponding entry in \code{x}.
}
\description{
Compute summaries within elements of an \code{\link{rvar}} and over draws of each element,
producing an array of the same shape as the input random variable (except in
the case of \code{range()}, see \strong{Details}).
}
\details{
Summaries include expectations (\code{E()} or \code{mean()}), probabilities (\code{Pr()}),
medians (\code{median()}), spread (\code{var()}, \code{variance()}, \code{sd()}, \code{mad()}), sums and
products (\code{sum()}, \code{prod()}), extrema and ranges (\code{min()}, \code{max()}, \code{range()}),
logical summaries (\code{all()}, \code{any()}), and special value predicates (\code{is.finite()},
\code{is.infinite()}, \code{is.nan()}, \code{is.na()}).

Unless otherwise stated, these functions return a numeric array with the same shape
(same dimensions) as the input \code{\link{rvar}}, \code{x}.

\code{range(x)} returns an array with dimensions \code{c(2, dim(x))}, where the last
dimension contains the minimum and maximum values.

\code{is.infinite(x)}, \code{is.nan(x)}, and \code{is.na(x)} return logical arrays, where each
element is \code{TRUE} if \strong{any} draws in its corresponding element in \code{x} match
the predicate. Each elements in the result of \code{is.finite(x)} is \code{TRUE} if
\strong{all} draws in the corresponding element in \code{x} are finite.

Both \code{E()}, \code{mean()}, and \code{Pr()} return the means of each element in the input.
\code{Pr()} additionally checks that the provided \code{\link{rvar}}
is a logical variable (hence, taking its expectation results in a probability).

For consistency, \code{E()} and \code{Pr()} are also defined for base arrays so that
they can be used as summary functions in \code{summarise_draws()}.
}
\examples{

set.seed(5678)
x = rvar_rng(rnorm, 4, mean = 1:4, sd = 2)

# These should all be ~= c(1, 2, 3, 4)
E(x)
mean(x)
median(x)

# This ...
Pr(x < 1.5)
# ... should be about the same as this:
pnorm(1.5, mean = 1:4, sd = 2)

}
\seealso{
\link{rvar-summaries-within-draws} for summary functions within draws.
\link{rvar-dist} for density, CDF, and quantile functions of random variables.

Other rvar-summaries: 
\code{\link{rvar-summaries-within-draws}},
\code{\link{rvar_is_finite}()}
}
\concept{rvar-summaries}

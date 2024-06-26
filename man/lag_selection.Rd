% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Functions_BSS_SGL.R
\name{lag_selection}
\alias{lag_selection}
\title{Select the lag of the VAR model using total BIC method}
\usage{
lag_selection(
  data,
  method = c("sparse", "group sparse", "fLS"),
  group.case = c("columnwise", "rowwise"),
  group.index = NULL,
  lambda.1.cv = NULL,
  lambda.2.cv = NULL,
  mu = NULL,
  block.size = NULL,
  blocks = NULL,
  use.BIC = TRUE,
  an.grid = NULL,
  threshold = NULL,
  lag_candidates,
  verbose = FALSE
)
}
\arguments{
\item{data}{input data matrix, each column represents the time series component}

\item{method}{method is sparse, group sparse and fixed lowrank plus sparse}

\item{group.case}{two different types of group sparse, column-wise and row-wise, respectively.}

\item{group.index}{specify group sparse index. Default is NULL.}

\item{lambda.1.cv}{tuning parameter lambda_1 for fused lasso}

\item{lambda.2.cv}{tuning parameter lambda_2 for fused lasso}

\item{mu}{tuning parameter for low rank component, only available when method is set to "fLS".}

\item{block.size}{the block size}

\item{blocks}{the blocks}

\item{use.BIC}{use BIC for k-means part}

\item{an.grid}{a vector of an for grid searching.}

\item{threshold}{a numeric argument, give the threshold for estimated model parameter matrices. Default is NULL.}

\item{lag_candidates}{potential lag selection set}

\item{verbose}{A Boolean argument, if TRUE, it provides detailed information. Default is FALSE}
}
\value{
selected lag for VAR series
\describe{
    \item{select_lag}{An integer no less than 1 represents the selected lag of time series.}
}
}
\description{
Select the lag of the VAR model (if the lag is unknown) using BIC method for total segments
}
\examples{
\donttest{
nob <- 1000; p <- 15
brk <- c(floor(nob / 2), nob + 1)
m <- length(brk)
q.t <- 2 # the lag of VAR model for simulation
signals <- c(-0.8, 0.6, 0.4)
try <- simu_var(method = "sparse", nob = nob, k = p, brk = brk,
                signals = signals, lags_vector = c(1, 2),
                sp_pattern = "off-diagonal")
data <- try$series; data <- as.matrix(data)

# Apply lag selection to determine the lag for the given time series
lag_candi <- c(1, 2, 3, 4)
select_lag <- lag_selection(data = data,
                            method = "sparse", lag_candidates = lag_candi)
print(select_lag)
}
}

% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Functions_BSS_SGL.R
\name{tbss}
\alias{tbss}
\title{Block segmentation scheme (BSS).}
\usage{
tbss(
  data,
  method = c("sparse", "group sparse", "fLS"),
  group.case = c("columnwise", "rowwise"),
  group.index = NULL,
  lambda.1.cv = NULL,
  lambda.2.cv = NULL,
  mu = NULL,
  q = 1,
  max.iteration = 50,
  tol = 10^(-2),
  block.size = NULL,
  blocks = NULL,
  refit = FALSE,
  use.BIC = TRUE,
  an.grid = NULL,
  verbose = FALSE
)
}
\arguments{
\item{data}{input data matrix, with each column representing the time series component}

\item{method}{method: sparse, group sparse, and fixed low rank plus sparse. Default is sparse}

\item{group.case}{group sparse pattern: column, row.}

\item{group.index}{group index for group sparse case}

\item{lambda.1.cv}{tuning parameter lambda_1 for fused lasso}

\item{lambda.2.cv}{tuning parameter lambda_2 for fused lasso}

\item{mu}{tuning parameter for low rank component, only available when method is set to "fLS"}

\item{q}{the VAR lag}

\item{max.iteration}{max number of iteration for the Fused lasso}

\item{tol}{tolerance for the fused lasso}

\item{block.size}{the block size}

\item{blocks}{the blocks}

\item{refit}{logical; if TRUE, refit the VAR model for parameter estimation. Default is FALSE.}

\item{use.BIC}{use BIC for k-means part}

\item{an.grid}{a vector of an for grid searching}

\item{verbose}{a Boolean argument to determine whether provide detailed outputs for each step. Default is FALSE}
}
\value{
S3 object of class \code{VARDetect.result}, which contains the followings
\describe{
  \item{data}{the original dataset}
  \item{q}{the time lag user specified, a numeric value}
  \item{cp}{final estimated change points, a numeric vector}
  \item{sparse_mats}{estimated sparse components for each segment, a list of numeric matrices}
  \item{lowrank_mats}{estimated low rank components for each segment, a list of numeric matrices}
  \item{est_phi}{estimated final model parameters, the summation of the sparse and the low rank components}
  \item{time}{computation time for each step}
}
}
\description{
Perform the block segmentation scheme (BSS) algorithm to detect the structural breaks
in large scale high-dimensional non-stationary VAR models.
}
\examples{
#### sparse VAR model
nob <- (10^3) # number of time points
p <- 15; # number of time series components
brk <- c(floor(nob/3),floor(2*nob/3),nob+1); # true break points with nob+1 as the last element
m0 <- length(brk) -1; # number of break points
q.t <- 1; # the true AR order
m <- m0+1 #number of segments
try<-simu_var('sparse',nob=nob,k=p,lags=q.t,brk = brk,sp_pattern="off-diagonal",seed=1)
data <- try$series
data <- as.matrix(data)
#run the bss method
fit <- tbss(data, method = "sparse", q = q.t)
print(fit)
summary(fit)
plot(fit, data, display = "cp")
plot(fit, data, display = "param")


###### Example for fixed low rank plus sparse structure VAR model
nob <- 300
p <- 15
brk <- c(floor(nob/3), floor(2*nob/3), nob+1)
m <- length(brk)
q.t <- 1
signals <- c(-0.7, 0.7, -0.7)
rank <- c(2, 2, 2)
singular_vals <- c(1, 0.75)
info_ratio <- rep(0.35, 3)
try <- simu_var(method = "fLS", nob = nob, k = p, lags = 1, brk = brk,
                sigma = as.matrix(diag(p)), signals = signals, seed=1,
                rank = rank, singular_vals = singular_vals, info_ratio = info_ratio,
                sp_pattern = "off-diagonal", spectral_radius = 0.9)
data <- try$series
data <- as.matrix(data)
fit <- tbss(data, method = "fLS", mu = 150)
print(fit)
summary(fit)
plot(fit, data, display = "cp")
plot(fit, data, display = "param")
}

context("Solver")



test_that("test cpp implementation of MCPA, comparison with R code", {

  data("data.for.test", package = "tess3r")

  # compute laplacian
  W <- ComputeHeatKernelWeight(data.for.test$coord, 2.0)
  Lapl <- ComputeGraphLaplacian(W)

  # With R code
  set.seed(0)
  Rres <- SolveTess3Projected(data.for.test$X,
                              data.for.test$K,
                              data.for.test$d,
                              Lapl,
                              lambda = 1.0,
                              max.iteration = 25)

  # cpp code
  set.seed(0)
  # With cpp code
  XBin <- matrix(0.0, nrow(data.for.test$X), ncol(data.for.test$X) * (data.for.test$d + 1))
  X2XBin(data.for.test$X,data.for.test$d, XBin)
  Lapl <- as.matrix(Lapl)
  cppres <- list()
  cppres$G <- matrix(0.0, nrow = (data.for.test$d + 1) * data.for.test$L, ncol = data.for.test$K)
  cppres$Q <- matrix(runif(data.for.test$n * data.for.test$K), data.for.test$n, data.for.test$K)
  cppres$Q <- ProjectQ(cppres$Q)
  ComputeMCPASolution(XBin,
                      data.for.test$K,
                      Lapl,
                      lambdaPrim = 1.0,
                      data.for.test$d + 1,
                      maxIteration = 25,
                      tolerance = 1e-10,
                      Q = cppres$Q,
                      G = cppres$G,
                      verbose = FALSE)

  expect_lt(ComputeRmseWithBestPermutation(cppres$Q, Rres$Q), 1e-12)
  expect_lt(ComputeRmseWithBestPermutation(cppres$G, Rres$G), 1e-12)
})



test_that("test with copy and without copy", {

  data("data.for.test", package = "tess3r")

  # compute laplacian
  W <- ComputeHeatKernelWeight(data.for.test$coord, 2.0)
  Lapl <- ComputeGraphLaplacian(W)

  InitOpenMP(4)

  # with copy
  set.seed(502)
  XBin <- matrix(0.0, nrow(data.for.test$X), ncol(data.for.test$X) * (data.for.test$d + 1))
  X2XBin(data.for.test$X,data.for.test$d, XBin)
  Lapl <- as.matrix(Lapl)
  cppres.copy <- list()
  cppres.copy$G <- matrix(0.0, nrow = (data.for.test$d + 1) * data.for.test$L, ncol = data.for.test$K)
  cppres.copy$Q <- matrix(runif(data.for.test$n * data.for.test$K), data.for.test$n, data.for.test$K)
  cppres.copy$Q <- ProjectQ(cppres.copy$Q)
  time.copy <- system.time(ComputeMCPASolution(XBin,
                                               data.for.test$K,
                                               Lapl,
                                               lambdaPrim = 1.0,
                                               data.for.test$d + 1,
                                               maxIteration = 25,
                                               tolerance = 1e-10,
                                               Q = cppres.copy$Q,
                                               G = cppres.copy$G,
                                               verbose = FALSE))

  # without copy
  set.seed(502)
  # With cpp code
  XBin <- matrix(0.0, nrow(data.for.test$X), ncol(data.for.test$X) * (data.for.test$d + 1))
  X2XBin(data.for.test$X,data.for.test$d, XBin)
  Lapl <- as.matrix(Lapl)
  cppres.nocopy <- list()
  cppres.nocopy$G <- matrix(0.0, nrow = (data.for.test$d + 1) * data.for.test$L, ncol = data.for.test$K)
  cppres.nocopy$Q <- matrix(runif(data.for.test$n * data.for.test$K), data.for.test$n, data.for.test$K)
  cppres.nocopy$Q <- ProjectQ(cppres.nocopy$Q)
  time.nocpy <- system.time(ComputeMCPASolutionNoCopyX(XBin,
                                                       data.for.test$K,
                                                       Lapl,
                                                       lambdaPrim = 1.0,
                                                       data.for.test$d + 1,
                                                       maxIteration = 25,
                                                       tolerance = 1e-10,
                                                       Q = cppres.nocopy$Q,
                                                       G = cppres.nocopy$G,
                                                       verbose = FALSE))


  expect_lt(ComputeRmseWithBestPermutation(cppres.copy$Q, cppres.nocopy$Q), 1e-14)
  expect_lt(ComputeRmseWithBestPermutation(cppres.copy$G, cppres.nocopy$G), 1e-14)
})








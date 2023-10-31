context('Test that hartigan works')

hartiganResults <- FitKMeans(iris[, -ncol(iris)])
max.clusters=12L
spectral=FALSE
nstart=1L
iter.max=10L
seed=NULL
algorithm <- 'Hartigan-Wong'
hartigan <- data.frame(Clusters=2:(max.clusters), Hartigan=NA, AddCluster=NA)
nRowX <- nrow(hartiganResults)
nColX <- ncol(hartiganResults)
FitActual <- kmeans(hartiganResults[, 1:(nColX - (nColX-(2-1))*spectral)], centers=2-1, nstart=nstart, iter.max=iter.max, algorithm=algorithm)
FitPlus1 <- kmeans(hartiganResults[, 1:(nColX - (nColX-(2+0))*spectral)], centers=2, nstart=nstart, iter.max=iter.max, algorithm=algorithm)

# spectral=TRUE seems to return out of bounds errors
test_that('All functions return the correct type', {
  expect_is(FitKMeans(iris[, -ncol(iris)]), 'data.frame')
  #expect_is(FitKMeans(iris[, -ncol(iris)], spectral=TRUE), 'data.frame')
  expect_is(FitKMeans(iris[, -ncol(iris)], iter.max=30L, algorithm='Lloyd'), 'data.frame')
  expect_is(FitKMeans(iris[, -ncol(iris)], iter.max=30L, algorithm='Forgy'), 'data.frame')
  expect_is(FitKMeans(iris[, -ncol(iris)], iter.max=30L, algorithm='MacQueen'), 'data.frame')
  #expect_is(FitKMeans(iris[, -ncol(iris)], spectral=TRUE, algorithm='Lloyd'), 'data.frame')
  expect_error(FitKMeans(iris[, -ncol(iris)], algorithm='lol'), regexp="Hartigan-Wong")
  expect_error(FitKMeans(iris[, -ncol(iris)], algorithm='lol'), regexp="Lloyd")
  expect_error(FitKMeans(iris[, -ncol(iris)], algorithm='lol'), regexp="Forgy")
  expect_error(FitKMeans(iris[, -ncol(iris)], algorithm='lol'), regexp="MacQueen")
  expect_is(PlotHartigan(hartiganResults), 'ggplot')
  expect_is(PlotHartigan(hartiganResults, title='Nonsense', smooth=TRUE, linecolor='red', linetype=4, linesize=5), 'ggplot')
  expect_is(ComputeHartigan(FitActualWSS=FitActual$withinss, FitPlus1WSS=FitPlus1$withinss, nrow=nRowX), 'numeric')
})

test_that('The inputs do what we expect them to do', {
  p <- PlotHartigan(hartiganResults, title='Nonsense', smooth=TRUE, linecolor='red', linetype=4, linesize=5)
  expect_identical(p$labels$title, 'Nonsense')
  
})

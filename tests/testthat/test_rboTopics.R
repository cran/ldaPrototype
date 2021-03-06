context("rboTopics")

data("reuters_docs")
data("reuters_vocab")

mtopics = mergeTopics(LDARep(docs = reuters_docs, vocab = reuters_vocab, n = 2, K = 10, num.iterations = 5))
rbo = rboTopics(mtopics, k = 5, p = 0.9)
rbo2 = rboTopics(mtopics, k = 5, p = 0.9, pm.backend = "socket")

rbo3 = rboTopics(mtopics, k = 10, p = 0.1, progress = FALSE)
rbo4 = rboTopics(mtopics, k = 10, p = 0.1, pm.backend = "socket")

test_that("rboTopics_success", {
  tmp = 20 # n*K
  expect_equal(getParam(rbo), list(type = "RBO Similarity", k = 5, p = 0.9))
  expect_equal(names(getRelevantWords(rbo)), names(getConsideredWords(rbo)))
  expect_equal(length(getRelevantWords(rbo)), tmp)
  expect_equal(length(getConsideredWords(rbo)), tmp)
  expect_true(all(getRelevantWords(rbo) >= 5))
  expect_true(all(getConsideredWords(rbo) == getRelevantWords(rbo)))
  expect_true(all(as.integer(getRelevantWords(rbo)) == c(getRelevantWords(rbo))))
  expect_true(all(as.integer(getConsideredWords(rbo)) == c(getConsideredWords(rbo))))
  expect_equal(dim(getSimilarity(rbo)), rep(tmp, 2))
  expect_true(all(is.na(getSimilarity(rbo)[upper.tri(getSimilarity(rbo))])))
  expect_true(all(is.na(diag(getSimilarity(rbo)))))
  expect_true(all(getSimilarity(rbo)[lower.tri(getSimilarity(rbo))] >= 0))
  expect_true(all(getSimilarity(rbo)[lower.tri(getSimilarity(rbo))] <= 1))
  expect_equal(rbo, rbo2)

  expect_equal(getParam(rbo3), list(type = "RBO Similarity", k = 10, p = 0.1))
  expect_equal(names(getRelevantWords(rbo3)), names(getConsideredWords(rbo3)))
  expect_equal(length(getRelevantWords(rbo3)), tmp)
  expect_equal(length(getConsideredWords(rbo3)), tmp)
  expect_true(all(getRelevantWords(rbo3) >= 10))
  expect_true(all(getConsideredWords(rbo3) == getRelevantWords(rbo3)))
  expect_true(all(as.integer(getRelevantWords(rbo3)) == c(getRelevantWords(rbo3))))
  expect_true(all(as.integer(getConsideredWords(rbo3)) == c(getConsideredWords(rbo3))))
  expect_equal(dim(getSimilarity(rbo3)), rep(tmp, 2))
  expect_true(all(is.na(getSimilarity(rbo3)[upper.tri(getSimilarity(rbo3))])))
  expect_true(all(is.na(diag(getSimilarity(rbo3)))))
  expect_true(all(getSimilarity(rbo3)[lower.tri(getSimilarity(rbo3))] >= 0))
  expect_true(all(getSimilarity(rbo3)[lower.tri(getSimilarity(rbo3))] <= 1))
  expect_equal(rbo3, rbo4)
})

test_that("rboTopics_errors", {
  expect_error(rboTopics(mtopics, k = 5))
  expect_error(rboTopics(mtopics, p = 0.9))
  expect_error(rboTopics(mtopics, k = 0, p = 0.9))
  expect_error(rboTopics(mtopics, k = 12.4, p = 0.9))
  expect_error(rboTopics(mtopics, k = -1, p = 0.9))
  expect_error(rboTopics(mtopics, p = 1.1, k = 1))
  expect_error(rboTopics(mtopics, p = -0.4, k = 1))
  expect_silent(rboTopics(mtopics, p = 0.9, k = 1))
  expect_error(rboTopics(mtopics, ncpus = -1, pm.backend = "socket", k = 1, p = 0.9))
  expect_error(rboTopics(mtopics, ncpus = 3.2, pm.backend = "socket", k = 1, p = 0.9))
  expect_error(rboTopics(mtopics, pm.backend = TRUE, k = 1, p = 0.9))
  expect_error(rboTopics(mtopics, pm.backend = "", k = 1, p = 0.9))
  expect_error(rboTopics(mtopics, progress = "TRUE", k = 1, p = 0.9))
  colnames(mtopics)[1] = ""
  expect_error(rboTopics(mtopics, p = 0.9, k = 1))
  colnames(mtopics)[1:2] = "LDARep1.1"
  expect_error(rboTopics(mtopics, p = 0.9, k = 1))
  colnames(mtopics)[2] = "LDARep1.2"
  expect_silent(rboTopics(mtopics, p = 0.9, k = 1))
  expect_error(rboTopics(mtopics-1, p = 0.9, k = 1))
  expect_error(rboTopics(as.data.frame(mtopics), p = 0.9, k = 1))
  mtopics[sample(seq_len(nrow(mtopics)), 1), sample(seq_len(ncol(mtopics)), 1)] = NA
  expect_error(rboTopics(mtopics, p = 0.9, k = 1))
  expect_error(rboTopics(1:100, p = 0.9, k = 1))
  expect_error(rboTopics(p = 0.9, k = 1))
  expect_error(rboTopics())
})

test_that("print.TopicSimilarity", {
  expect_output(print(rbo), "TopicSimilarity Object")
  expect_output(print(rbo), "type: RBO Similarity")
  expect_output(print(rbo2), "TopicSimilarity Object")
  expect_output(print(rbo2), "type: RBO Similarity")
  expect_output(print(rbo3), "TopicSimilarity Object")
  expect_output(print(rbo3), "type: RBO Similarity")
})

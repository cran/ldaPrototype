context("jaccardTopics")

data("reuters_docs")
data("reuters_vocab")

mtopics = mergeTopics(LDARep(docs = reuters_docs, vocab = reuters_vocab, n = 2, K = 10, num.iterations = 5))
jacc = jaccardTopics(mtopics)
jacc2 = jaccardTopics(mtopics, pm.backend = "socket")

jacc3 = jaccardTopics(mtopics, atLeast = 1, limit.abs = max(mtopics)+1, progress = FALSE)
jacc4 = jaccardTopics(mtopics, atLeast = 1, limit.abs = max(mtopics)+1, pm.backend = "socket")

test_that("jaccardTopics_success", {
  tmp = 20 # n*K
  expect_equal(getParam(jacc), list(type = "Jaccard Coefficient", limit.rel = 1/500, limit.abs = 10, atLeast = 0))
  expect_equal(names(getRelevantWords(jacc)), names(getConsideredWords(jacc)))
  expect_equal(length(getRelevantWords(jacc)), tmp)
  expect_equal(length(getConsideredWords(jacc)), tmp)
  expect_true(all(getRelevantWords(jacc) >= 0))
  expect_true(all(getConsideredWords(jacc) >= 0))
  expect_true(all(as.integer(getRelevantWords(jacc)) == c(getRelevantWords(jacc))))
  expect_true(all(as.integer(getConsideredWords(jacc)) == c(getConsideredWords(jacc))))
  expect_equal(dim(getSimilarity(jacc)), rep(tmp, 2))
  expect_true(all(is.na(getSimilarity(jacc)[upper.tri(getSimilarity(jacc))])))
  expect_true(all(is.na(diag(getSimilarity(jacc)))))
  expect_true(all(getSimilarity(jacc)[lower.tri(getSimilarity(jacc))] >= 0))
  expect_true(all(getSimilarity(jacc)[lower.tri(getSimilarity(jacc))] <= 1))
  expect_equal(jacc, jacc2)

  expect_equal(getParam(jacc3), list(type = "Jaccard Coefficient", limit.rel = 1/500, limit.abs = max(mtopics)+1, atLeast = 1))
  expect_equal(names(getRelevantWords(jacc3)), names(getConsideredWords(jacc3)))
  expect_equal(length(getRelevantWords(jacc3)), tmp)
  expect_equal(length(getConsideredWords(jacc3)), tmp)
  expect_true(all(getRelevantWords(jacc3) >= 0))
  expect_true(all(getConsideredWords(jacc3) >= 0))
  expect_true(all(as.integer(getRelevantWords(jacc3)) == c(getRelevantWords(jacc3))))
  expect_true(all(as.integer(getConsideredWords(jacc3)) == c(getConsideredWords(jacc3))))
  expect_equal(dim(getSimilarity(jacc3)), rep(tmp, 2))
  expect_true(all(is.na(getSimilarity(jacc3)[upper.tri(getSimilarity(jacc3))])))
  expect_true(all(is.na(diag(getSimilarity(jacc3)))))
  expect_true(all(getSimilarity(jacc3)[lower.tri(getSimilarity(jacc3))] >= 0))
  expect_true(all(getSimilarity(jacc3)[lower.tri(getSimilarity(jacc3))] <= 1))
  expect_equal(jacc3, jacc4)
})

test_that("jaccardTopics_errors", {
  expect_error(jaccardTopics(mtopics, limit.abs = -1))
  expect_error(jaccardTopics(mtopics, limit.abs = 0.9))
  expect_error(jaccardTopics(mtopics, limit.rel = 1.1))
  expect_error(jaccardTopics(mtopics, limit.rel = -0.4))
  expect_error(jaccardTopics(mtopics, atLeast = -10))
  expect_error(jaccardTopics(mtopics, atLeast = length(reuters_vocab)+1))
  expect_error(jaccardTopics(mtopics, ncpus = -1, pm.backend = "socket"))
  expect_error(jaccardTopics(mtopics, ncpus = 3.2, pm.backend = "socket"))
  expect_error(jaccardTopics(mtopics, pm.backend = TRUE))
  expect_error(jaccardTopics(mtopics, pm.backend = ""))
  expect_error(jaccardTopics(mtopics, progress = "TRUE"))
  colnames(mtopics)[1] = ""
  expect_error(jaccardTopics(mtopics))
  colnames(mtopics)[1:2] = "LDARep1.1"
  expect_error(jaccardTopics(mtopics))
  colnames(mtopics)[2] = "LDARep1.2"
  expect_silent(jaccardTopics(mtopics))
  expect_error(jaccardTopics(mtopics-1))
  expect_error(jaccardTopics(as.data.frame(mtopics)))
  mtopics[sample(seq_len(nrow(mtopics)), 1), sample(seq_len(ncol(mtopics)), 1)] = NA
  expect_error(jaccardTopics(mtopics))
  expect_error(jaccardTopics(1:100))
  expect_error(jaccardTopics())
})

test_that("print.TopicSimilarity", {
  expect_output(print(jacc), "TopicSimilarity Object")
  expect_output(print(jacc), "type: Jaccard Coefficient")
  expect_output(print(jacc2), "TopicSimilarity Object")
  expect_output(print(jacc2), "type: Jaccard Coefficient")
  expect_output(print(jacc3), "TopicSimilarity Object")
  expect_output(print(jacc3), "type: Jaccard Coefficient")
})

# Fast, memory-light AUC via the Mann-Whitney U / rank-sum identity -
# mathematically equivalent to the trapezoidal area under the ROC curve.
# pROC::roc() was tried first but its memory use grew unboundedly (multiple
# GB and climbing) on this book's 300,000+ resolved loans, so a direct
# O(n log n) rank-based computation is used instead. n1/n0 are coerced to
# double: sum() of a logical vector returns a 32-bit integer, and n1 * n0
# (~86,000 * ~297,000 = ~25.6 billion) silently overflows that and returns
# NA - as it did here until this fix.
Compute_AUC <- function(actual, predicted){

  r  <- rank(predicted)
  n1 <- as.double(sum(actual == 1))
  n0 <- as.double(sum(actual == 0))

  (sum(r[actual == 1]) - n1 * (n1 + 1) / 2) / (n1 * n0)

}

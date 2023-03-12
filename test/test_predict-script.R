library(testthat)
source("./R/predict-script.R")

# Define the test cases for predict_drugs_workflow
test_that("predict_drugs_workflow returns the expected output", {
  #Test case 1
  expect_identical(colnames(result), c(".pred_class", "X1", "X2", "X3"))
  #Test case 2
  expect_true(all(result$.pred_class %in% c("no", "yes")))
  #Test case 3
  expect_equal(result$.pred_class, mock_predictions$.pred_class)
})

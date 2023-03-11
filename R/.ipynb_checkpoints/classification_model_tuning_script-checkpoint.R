#' Fit a k-nearest neighbor classifier and tune hyperparameters using cross-validation
#' 
#' 
#' @param data A data frame containing the predictor variables and "Cannabis" response variable
#' @param response_var A string specifying the name of the response variable in the data frame
#' @param neighbors A vector of integers specifying the number of nearest neighbors to consider.
#' @param weight_func The weight function to use for prediction. 
#' @param v The number of folds for cross-validation.
#' 
#' @return A tibble containing the hyperparameters, metric values, and other information for each model evaluated during cross-validation
#' 
#' @examples
#' # Fit and tune k-nearest neighbor classifier
#' knn_result <- knn_tune(data = drug_data, neighbors = 1:30, v = 5)
#' }
#' 

# knn_tune <- function(data, response_var, neighbors, weight_func = "rectangular", v) {
  
#   # Define nearest neighbor specification
#   knn_spec <- nearest_neighbor(weight_func = weight_func, neighbors = tune()) %>% 
#     set_engine("kknn") %>% 
#     set_mode("classification")
  
#   # Define recipe
#   recipe_obj <- recipe(as.formula(response_var, "~ .")), data = data) %>% 
#     step_scale(all_predictors()) %>% 
#     step_center(all_predictors())
  
#   # Define cross-validation
#   knn_vfold <- vfold_cv(data, v = v, strata = response_var)
  
#   # Define grid of hyperparameters
#   knn_grid <- tibble(neighbors = neighbors)
  
#   # Define workflow
#   knn_wf <- workflow() %>% 
#     add_recipe(recipe_obj) %>% 
#     add_model(knn_spec)
  
#   # Tune hyperparameters and evaluate models
#   knn_results <- knn_wf %>% 
#     tune_grid(resamples = knn_vfold, grid = knn_grid) %>% 
#     collect_metrics()
  
#   #write.csv(knn_results, "data/knn_tune.csv")
    
    
knn_tune <- function(data, k_range = 1:30, v = 5) {
    # Define the dependent variable
    dependent_var <- "Cannabis"
    # Define the independent variables
    predictor_vars <- colnames(data)[!colnames(data) %in% dependent_var]
    # Specify the recipe for data preprocessing
    drugs_recipe <- recipe(as.formula(paste(dependent_var, "~ .")), data = data) %>% 
                step_scale(all_predictors()) %>% 
                step_center(all_predictors())
    # Specify the specification for the classifier
    drugs_spec <- nearest_neighbor(weight_func = "rectangular", neighbors = tune()) %>% 
              set_engine("kknn") %>% 
              set_mode("classification")
    # Specify the cross-validation method
    drugs_vfold <- vfold_cv(data, v = v, strata = data[[dependent_var]])
    
    # Specify the grid for hyperparameter tuning
    gridvals <- tibble(neighbors = seq(k_range))
    
    # Create the workflow
    drugs_workflow <- workflow() %>% 
                  add_recipe(drugs_recipe) %>% 
                  add_model(drugs_spec) %>% 
                  tune_grid(resamples = drugs_vfold, grid = gridvals) %>% 
                  collect_metrics()
    
    return(drugs_workflow)

}


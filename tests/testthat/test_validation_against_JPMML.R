test_that("validation against JPMML evaluator works", {
  skip_on_cran()
  skip_on_ci()

  # Test against the JPMML Evaluator
  # https://github.com/jpmml/jpmml-evaluator-r
  #
  # Installation:
  # devtools::install_github("jpmml/jpmml-evaluator-r")

  skip_if_not_installed("jpmml")

  library("jpmml")


  ### lm
  data(iris)
  mod_file <- tempfile(fileext = ".pmml")
  on.exit(unlink(mod_file), add = TRUE)
  
  fit <- lm(Sepal.Length ~ ., data = iris)
  fit_pmml <- pmml(fit)
  save_pmml(fit_pmml, mod_file)

  evaluator <- newLoadingModelEvaluatorBuilder() |>
    loadFile(mod_file) |>
    build()

  evaluator <- evaluator |>
    verify()

  val_R <- unname(predict(fit, as.list(iris[1, ])))

  arguments <- as.list(iris[1, ])
  arguments$Species <- as.character(arguments$Species)

  val_JPMML <- evaluator |>
    evaluate(arguments)

  expect_equal(val_R, val_JPMML$Predicted_Sepal.Length)

  ### rpart
  library(rpart)
  mod_file_rpart <- tempfile(fileext = ".pmml")
  on.exit(unlink(mod_file_rpart), add = TRUE)
  
  fit <- rpart(Species ~ ., data = iris)
  fit_pmml <- pmml(fit)
  save_pmml(fit_pmml, mod_file_rpart)

  evaluator <- newLoadingModelEvaluatorBuilder() |>
    loadFile(mod_file_rpart) |>
    build()

  evaluator <- evaluator |>
    verify()

  val_R <- as.character(predict(fit, iris[1, ], type = "class"))

  arguments <- as.list(iris[1, ])

  val_JPMML <- evaluator |>
    evaluate(arguments)

  expect_equal(val_R, as.character(val_JPMML$Predicted_Species))

  ### randomForest
  library(randomForest)
  mod_file_rf <- tempfile(fileext = ".pmml")
  on.exit(unlink(mod_file_rf), add = TRUE)
  
  fit <- randomForest(Species ~ ., data = iris, ntree = 10)
  fit_pmml <- pmml(fit)
  save_pmml(fit_pmml, mod_file_rf)

  evaluator <- newLoadingModelEvaluatorBuilder() |>
    loadFile(mod_file_rf) |>
    build()

  evaluator <- evaluator |>
    verify()

  val_R <- as.character(predict(fit, iris[1, ], type = "class"))

  arguments <- as.list(iris[1, ])

  val_JPMML <- evaluator |>
    evaluate(arguments)

  expect_equal(val_R, as.character(val_JPMML$Predicted_Species))

  ### glm
  data(audit)
  mod_file_glm <- tempfile(fileext = ".pmml")
  on.exit(unlink(mod_file_glm), add = TRUE)
  
  fit <- glm(Adjusted ~ Age + Employment + Education + Marital + Occupation + Income + Sex + Deductions + Hours,
    data = audit, family = binomial(link = logit)
  )
  fit_pmml <- pmml(fit)
  save_pmml(fit_pmml, mod_file_glm)

  evaluator <- newLoadingModelEvaluatorBuilder() |>
    loadFile(mod_file_glm) |>
    build()

  evaluator <- evaluator |>
    verify()

  # Check prediction for first row
  val_R <- as.character(ifelse(predict(fit, audit[1, ], type = "response") > 0.5, 1, 0))

  arguments <- as.list(audit[1, ])
  # Ensure types match PMML expectations
  arguments$Age <- as.numeric(arguments$Age)
  arguments$Income <- as.numeric(arguments$Income)
  arguments$Deductions <- as.numeric(arguments$Deductions)
  arguments$Hours <- as.numeric(arguments$Hours)
  
  # Categorical fields should be strings
  arguments$Employment <- as.character(arguments$Employment)
  arguments$Education  <- as.character(arguments$Education)
  arguments$Marital    <- as.character(arguments$Marital)
  arguments$Occupation <- as.character(arguments$Occupation)
  arguments$Sex        <- as.character(arguments$Sex)

  val_JPMML <- evaluator |>
    evaluate(arguments)

  res_JPMML <- as.character(ifelse(as.numeric(val_JPMML$Predicted_Adjusted) > 0.5, 1, 0))
  expect_equal(val_R, res_JPMML)

  ### multinom
  library(nnet)
  mod_file_multinom <- tempfile(fileext = ".pmml")
  on.exit(unlink(mod_file_multinom), add = TRUE)
  
  fit <- multinom(Species ~ ., data = iris, trace = FALSE)
  fit_pmml <- pmml(fit)
  save_pmml(fit_pmml, mod_file_multinom)

  evaluator <- newLoadingModelEvaluatorBuilder() |>
    loadFile(mod_file_multinom) |>
    build()

  evaluator <- evaluator |>
    verify()

  val_R <- as.character(predict(fit, iris[1, ]))

  arguments <- as.list(iris[1, ])
  arguments$Species <- as.character(arguments$Species)

  val_JPMML <- evaluator |>
    evaluate(arguments)

  expect_equal(val_R, as.character(val_JPMML$Predicted_Species))

  ### svm
  library(e1071)
  mod_file_svm <- tempfile(fileext = ".pmml")
  on.exit(unlink(mod_file_svm), add = TRUE)
  
  fit <- svm(Species ~ ., data = iris)
  fit_pmml <- pmml(fit)
  save_pmml(fit_pmml, mod_file_svm)

  evaluator <- newLoadingModelEvaluatorBuilder() |>
    loadFile(mod_file_svm) |>
    build()

  evaluator <- evaluator |>
    verify()

  val_R <- as.character(predict(fit, iris[1, ]))

  arguments <- as.list(iris[1, ])
  arguments$Species <- as.character(arguments$Species)

  val_JPMML <- evaluator |>
    evaluate(arguments)

  expect_equal(val_R, as.character(val_JPMML$Predicted_Species))

  ### xgboost
  library(xgboost)
  data(iris)
  # Binary classification for simplicity
  iris_bin <- iris[iris$Species != "virginica", ]
  iris_bin$Species <- factor(as.character(iris_bin$Species))
  
  fit <- xgb.train(
    params = list(max_depth = 2, eta = 1, objective = "binary:logistic"),
    data = xgb.DMatrix(data = as.matrix(iris_bin[, 1:4]), label = as.numeric(iris_bin$Species) - 1),
    nrounds = 2
  )
  
  xgb_dump <- tempfile()
  on.exit(unlink(xgb_dump), add = TRUE)
  xgb.dump(fit, xgb_dump)

  mod_file_xgb <- tempfile(fileext = ".pmml")
  on.exit(unlink(mod_file_xgb), add = TRUE)
  
  fit_pmml <- pmml(fit,
    input_feature_names = colnames(iris_bin)[1:4],
    output_label_name = "Species",
    output_categories = levels(iris_bin$Species), 
    xgb_dump_file = xgb_dump
  )
  save_pmml(fit_pmml, mod_file_xgb)

  evaluator <- newLoadingModelEvaluatorBuilder() |>
    loadFile(mod_file_xgb) |>
    build()

  evaluator <- evaluator |>
    verify()

  # Check prediction for first row
  val_R <- as.character(predict(fit, as.matrix(iris_bin[1, 1:4])))
  # Result from predict is probability for class 1
  val_R_label <- levels(iris_bin$Species)[ifelse(val_R > 0.5, 2, 1)]

  arguments <- as.list(iris_bin[1, 1:4])
  # Ensure all are numeric
  arguments <- lapply(arguments, as.numeric)

  val_JPMML <- evaluator |>
    evaluate(arguments)

  expect_equal(val_R_label, as.character(val_JPMML$Predicted_Species))

  ### Arima
  skip("JPMML evaluator does not support ARIMA elements yet")
  library(forecast)
  mod_file_arima <- tempfile(fileext = ".pmml")
  on.exit(unlink(mod_file_arima), add = TRUE)
  
  fit <- Arima(WWWusage, order = c(2, 0, 2))
  fit_pmml <- pmml(fit, ts_type = "arima")
  save_pmml(fit_pmml, mod_file_arima)

  evaluator <- newLoadingModelEvaluatorBuilder() |>
    loadFile(mod_file_arima) |>
    build()

  evaluator <- evaluator |>
    verify()

  # Predicted value for first step ahead (h=1)
  val_R <- as.numeric(forecast(fit, h = 1)$mean)

  arguments <- list(h = 1)

  val_JPMML <- evaluator |>
    evaluate(arguments)

  expect_equal(val_R, val_JPMML$Predicted_ts_value)

  ### kmeans
  library(clue)
  mod_file_kmeans <- tempfile(fileext = ".pmml")
  on.exit(unlink(mod_file_kmeans), add = TRUE)
  
  fit <- kmeans(iris[, 1:4], 3)
  fit_pmml <- pmml(fit)
  save_pmml(fit_pmml, mod_file_kmeans)

  evaluator <- newLoadingModelEvaluatorBuilder() |>
    loadFile(mod_file_kmeans) |>
    build()

  evaluator <- evaluator |>
    verify()

  val_R <- as.character(cl_predict(fit, iris[1, 1:4]))

  arguments <- as.list(iris[1, 1:4])
  # Ensure consistent types
  arguments <- lapply(arguments, as.numeric)

  val_JPMML <- evaluator |>
    evaluate(arguments)

  expect_equal(val_R, as.character(val_JPMML$predictedValue))

  ### glmnet
  library(glmnet)
  mod_file_glmnet <- tempfile(fileext = ".pmml")
  on.exit(unlink(mod_file_glmnet), add = TRUE)
  
  fit <- cv.glmnet(data.matrix(iris[1:4]), data.matrix(iris[5]))
  fit_pmml <- pmml(fit)
  save_pmml(fit_pmml, mod_file_glmnet)

  evaluator <- newLoadingModelEvaluatorBuilder() |>
    loadFile(mod_file_glmnet) |>
    build()

  evaluator <- evaluator |>
    verify()

  val_R <- as.numeric(predict(fit, data.matrix(iris[1, 1:4])))

  arguments <- as.list(iris[1, 1:4])

  val_JPMML <- evaluator |>
    evaluate(arguments)

  expect_equal(val_R, as.numeric(val_JPMML$predictedValue))

  ### transformations
  box_obj <- xform_wrap(iris)
  box_obj <- xform_function(box_obj,
    orig_field_name = "Sepal.Length",
    new_field_name = "Sepal_Length_Squared",
    expression = "Sepal.Length * Sepal.Length"
  )
  mod_file_transf <- tempfile(fileext = ".pmml")
  on.exit(unlink(mod_file_transf), add = TRUE)
  
  fit <- lm(Petal.Width ~ Sepal.Length + Sepal_Length_Squared, data = box_obj$data)
  fit_pmml <- pmml(fit, transforms = box_obj)
  save_pmml(fit_pmml, mod_file_transf)

  evaluator <- newLoadingModelEvaluatorBuilder() |>
    loadFile(mod_file_transf) |>
    build()

  evaluator <- evaluator |>
    verify()

  val_R <- as.numeric(predict(fit, box_obj$data[1, ]))

  arguments <- as.list(iris[1, ])

  val_JPMML <- evaluator |>
    evaluate(arguments)

  expect_equal(val_R, as.numeric(val_JPMML$Predicted_Petal.Width))
})

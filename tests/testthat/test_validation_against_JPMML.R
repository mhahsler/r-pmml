test_that("validation against JPMML evaluator works", {
  skip_on_cran()
  skip_on_ci()
  if (system.file(package = "jpmml") == "") {
    skip("jpmml not installed")
  }

  library("jpmml")

  # Test against the JPMML Evaluator
  # https://github.com/jpmml/jpmml-evaluator-r
  #
  # Installation:
  # devtools::install_github("jpmml/jpmml-evaluator-r")

  ### lm
  data(iris)
  fit <- lm(Sepal.Length ~ ., data = iris)
  fit_pmml <- pmml(fit)
  save_pmml(fit_pmml, "model.pmml")

  evaluator <- newLoadingModelEvaluatorBuilder() |>
    loadFile("model.pmml") |>
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
  fit <- rpart(Species ~ ., data = iris)
  fit_pmml <- pmml(fit)
  save_pmml(fit_pmml, "model_rpart.pmml")

  evaluator <- newLoadingModelEvaluatorBuilder() |>
    loadFile("model_rpart.pmml") |>
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
  fit <- randomForest(Species ~ ., data = iris, ntree = 10)
  fit_pmml <- pmml(fit)
  save_pmml(fit_pmml, "model_rf.pmml")

  evaluator <- newLoadingModelEvaluatorBuilder() |>
    loadFile("model_rf.pmml") |>
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
  fit <- glm(Adjusted ~ Age + Employment + Education + Marital + Occupation + Income + Sex + Deductions + Hours,
    data = audit, family = binomial(link = logit)
  )
  fit_pmml <- pmml(fit)
  save_pmml(fit_pmml, "model_glm.pmml")

  evaluator <- newLoadingModelEvaluatorBuilder() |>
    loadFile("model_glm.pmml") |>
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

  val_JPMML <- evaluator |>
    evaluate(arguments)

  expect_equal(val_R, as.character(val_JPMML$Predicted_Adjusted))

  ### multinom
  library(nnet)
  fit <- multinom(Species ~ ., data = iris, trace = FALSE)
  fit_pmml <- pmml(fit)
  save_pmml(fit_pmml, "model_multinom.pmml")

  evaluator <- newLoadingModelEvaluatorBuilder() |>
    loadFile("model_multinom.pmml") |>
    build()

  evaluator <- evaluator |>
    verify()

  val_R <- as.character(predict(fit, iris[1, ]))

  arguments <- as.list(iris[1, ])

  val_JPMML <- evaluator |>
    evaluate(arguments)

  expect_equal(val_R, as.character(val_JPMML$Predicted_Species))

  ### svm
  library(e1071)
  fit <- svm(Species ~ ., data = iris)
  fit_pmml <- pmml(fit)
  save_pmml(fit_pmml, "model_svm.pmml")

  evaluator <- newLoadingModelEvaluatorBuilder() |>
    loadFile("model_svm.pmml") |>
    build()

  evaluator <- evaluator |>
    verify()

  val_R <- as.character(predict(fit, iris[1, ]))

  arguments <- as.list(iris[1, ])

  val_JPMML <- evaluator |>
    evaluate(arguments)

  expect_equal(val_R, as.character(val_JPMML$Predicted_Species))

  ### xgboost
  library(xgboost)
  # Temp file for xgboost dump
  xgb_dump <- tempfile()
  fit <- xgb.train(
    params = list(max_depth = 2, eta = 1, objective = "binary:logistic"),
    data = xgb.DMatrix(data = as.matrix(audit[1:100, c(2, 7, 9, 10, 12)]), label = audit[1:100, 13]),
    nrounds = 2
  )
  xgb.dump(fit, xgb_dump)

  fit_pmml <- pmml(fit,
    input_feature_names = colnames(audit[, c(2, 7, 9, 10, 12)]),
    output_label_name = "Adjusted",
    output_categories = c(0, 1), xgb_dump_file = xgb_dump
  )
  save_pmml(fit_pmml, "model_xgb.pmml")

  evaluator <- newLoadingModelEvaluatorBuilder() |>
    loadFile("model_xgb.pmml") |>
    build()

  evaluator <- evaluator |>
    verify()

  # Check prediction for first row
  val_R <- as.character(ifelse(predict(fit, as.matrix(audit[1, c(2, 7, 9, 10, 12)])) > 0.5, 1, 0))

  arguments <- as.list(audit[1, c(2, 7, 9, 10, 12)])
  # Ensure types match
  arguments$Age <- as.numeric(arguments$Age)
  arguments$Income <- as.numeric(arguments$Income)
  arguments$Deductions <- as.numeric(arguments$Deductions)
  arguments$Hours <- as.numeric(arguments$Hours)
  arguments$Education <- as.numeric(arguments$Education) # Check if numeric or factor? Audit Educ is factor?

  val_JPMML <- evaluator |>
    evaluate(arguments)

  expect_equal(val_R, as.character(val_JPMML$Predicted_Adjusted))

  ### Arima
  library(forecast)
  fit <- Arima(WWWusage, order = c(2, 0, 2))
  fit_pmml <- pmml(fit, ts_type = "arima")
  save_pmml(fit_pmml, "model_arima.pmml")

  evaluator <- newLoadingModelEvaluatorBuilder() |>
    loadFile("model_arima.pmml") |>
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
  fit <- kmeans(iris[, 1:4], 3)
  fit_pmml <- pmml(fit)
  save_pmml(fit_pmml, "model_kmeans.pmml")

  evaluator <- newLoadingModelEvaluatorBuilder() |>
    loadFile("model_kmeans.pmml") |>
    build()

  evaluator <- evaluator |>
    verify()

  val_R <- as.character(cl_predict(fit, iris[1, 1:4]))

  arguments <- as.list(iris[1, 1:4])

  val_JPMML <- evaluator |>
    evaluate(arguments)

  expect_equal(val_R, as.character(val_JPMML$predictedValue))

  ### glmnet
  library(glmnet)
  fit <- cv.glmnet(data.matrix(iris[1:4]), data.matrix(iris[5]))
  fit_pmml <- pmml(fit)
  save_pmml(fit_pmml, "model_glmnet.pmml")

  evaluator <- newLoadingModelEvaluatorBuilder() |>
    loadFile("model_glmnet.pmml") |>
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
  fit <- lm(Petal.Width ~ Sepal.Length + Sepal_Length_Squared, data = box_obj$data)
  fit_pmml <- pmml(fit, transforms = box_obj)
  save_pmml(fit_pmml, "model_transf.pmml")

  evaluator <- newLoadingModelEvaluatorBuilder() |>
    loadFile("model_transf.pmml") |>
    build()

  evaluator <- evaluator |>
    verify()

  val_R <- as.numeric(predict(fit, box_obj$data[1, ]))

  arguments <- as.list(iris[1, ])

  val_JPMML <- evaluator |>
    evaluate(arguments)

  expect_equal(val_R, as.numeric(val_JPMML$Predicted_Petal.Width))

  ### cleanup
  file.remove("model.pmml")
  file.remove("model_rpart.pmml")
  file.remove("model_rf.pmml")
  file.remove("model_glm.pmml")
  file.remove("model_multinom.pmml")
  file.remove("model_svm.pmml")
  file.remove("model_xgb.pmml")
  file.remove("model_arima.pmml")
  file.remove("model_kmeans.pmml")
  file.remove("model_glmnet.pmml")
  file.remove("model_transf.pmml")
  unlink(xgb_dump)
})

# Generate PMML for a xgb.Booster object from the package xgboost.

Generate PMML for a xgb.Booster object from the package xgboost.

## Usage

``` r
# S3 method for class 'xgb.Booster'
pmml(
  model,
  model_name = "xboost_Model",
  app_name = "R PMML Generator - Package pmml",
  description = "Extreme Gradient Boosting Model",
  copyright = NULL,
  model_version = NULL,
  transforms = NULL,
  missing_value_replacement = NULL,
  input_feature_names = NULL,
  output_label_name = NULL,
  output_categories = NULL,
  xgb_dump_file = NULL,
  parent_invalid_value_treatment = "returnInvalid",
  child_invalid_value_treatment = "asIs",
  ...
)
```

## Arguments

- model:

  An object created by the 'xgb.train' function.

- model_name:

  A name to be given to the PMML model.

- app_name:

  The name of the application that generated the PMML.

- description:

  A descriptive text for the Header element of the PMML.

- copyright:

  The copyright notice for the model.

- model_version:

  A string specifying the model version.

- transforms:

  Data transformations.

- missing_value_replacement:

  Value to be used as the 'missingValueReplacement' attribute for all
  MiningFields.

- input_feature_names:

  Input variable names used in training the model.

- output_label_name:

  Name of the predicted field.

- output_categories:

  Possible values of the predicted field, for classification models.

- xgb_dump_file:

  Name of file saved using 'xgb.dump' function.

- parent_invalid_value_treatment:

  Invalid value treatment at the top MiningField level.

- child_invalid_value_treatment:

  Invalid value treatment at the model segment MiningField level.

- ...:

  Further arguments passed to or from other methods.

## Value

PMML representation of the xgb.Booster object.

## Details

The `xgb.train` function takes as its input an `xgb.DMatrix` object. The
input field information is not stored in the R model object, hence the
field information must be passed on as inputs. This enables the PMML to
specify field names in its model representation. The R model object does
not store information about the fitted tree structure either. However,
this information can be extracted from the `xgb.model.dt.tree` function
and the file saved using the `xgb.dump` function. The xgboost library is
therefore needed in the environment and this saved file is needed as an
input as well.

The following objectives are currently supported: `multi:softprob`,
`multi:softmax`, `binary:logistic`.

The pmml exporter will throw an error if the xgboost model model only
has one tree.

The exporter only works with numeric matrices. Sparse matrices must be
converted to `matrix` objects before training an xgboost model for the
export to work correctly.

## References

[xgboost: Extreme Gradient
Boosting](https://CRAN.R-project.org/package=xgboost)

## See also

[`pmml()`](https://michael.hahsler.net/r-pmml/reference/pmml.md), [PMML
schema](https://dmg.org/pmml/v4-4-1/GeneralStructure.html)

## Author

Tridivesh Jena

## Examples

``` r
if (FALSE) { # \dontrun{
# Example using the xgboost package example model.

library(xgboost)
data(agaricus.train, package = "xgboost")
data(agaricus.test, package = "xgboost")

train <- agaricus.train
test <- agaricus.test

model1 <- xgb.train(
  params = list(max_depth = 2, eta = 1, objective = "binary:logistic"),
  data = xgb.DMatrix(train$data, label = train$label),
  nthread = 2, nrounds = 2
)

# Save the tree information in an external file:
xgb.dump(model1, "model1.dumped.trees")

# Convert to PMML:
model1_pmml <- pmml(model1,
  input_feature_names = colnames(train$data),
  output_label_name = "prediction1",
  output_categories = c("0", "1"),
  xgb_dump_file = "model1.dumped.trees"
)

# Multinomial model using iris data:
model2 <- xgb.train(
  params = list(max_depth = 2, eta = 1, objective = "multi:softprob", num_class = 3),
  data = xgb.DMatrix(as.matrix(iris[, 1:4]), label = as.numeric(iris[, 5]) - 1),
  nthread = 2, nrounds = 2
)

# Save the tree information in an external file:
xgb.dump(model2, "model2.dumped.trees")

# Convert to PMML:
model2_pmml <- pmml(model2,
  input_feature_names = colnames(as.matrix(iris[, 1:4])),
  output_label_name = "Species",
  output_categories = c(1, 2, 3), xgb_dump_file = "model2.dumped.trees"
)
} # }
```

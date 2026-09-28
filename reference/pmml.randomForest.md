# Generate the PMML representation for a randomForest object from the package randomForest.

Generate the PMML representation for a randomForest object from the
package randomForest.

## Usage

``` r
# S3 method for class 'randomForest'
pmml(
  model,
  model_name = "randomForest_Model",
  app_name = "R PMML Generator - Package pmml",
  description = "Random Forest Tree Model",
  copyright = NULL,
  model_version = NULL,
  transforms = NULL,
  missing_value_replacement = NULL,
  parent_invalid_value_treatment = "returnInvalid",
  child_invalid_value_treatment = "asIs",
  ...
)
```

## Arguments

- model:

  A randomForest object.

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

- parent_invalid_value_treatment:

  Invalid value treatment at the top MiningField level.

- child_invalid_value_treatment:

  Invalid value treatment at the model segment MiningField level.

- ...:

  Further arguments passed to or from other methods.

## Value

PMML representation of the randomForest object.

## Details

This function outputs a Random Forest in PMML format.

## References

[randomForest: Breiman and Cutler's random forests for classification
and regression](https://CRAN.R-project.org/package=randomForest)

## Author

Tridivesh Jena

## Examples

``` r
if (FALSE) { # \dontrun{
# Build a randomForest model
library(randomForest)
iris_rf <- randomForest(Species ~ ., data = iris, ntree = 20)

# Convert to pmml
iris_rf_pmml <- pmml(iris_rf)

rm(iris_rf)
} # }
```

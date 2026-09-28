# Generate the PMML representation for an rpart object from the package rpart.

Generate the PMML representation for an rpart object from the package
rpart.

## Usage

``` r
# S3 method for class 'rpart'
pmml(
  model,
  model_name = "RPart_Model",
  app_name = "R PMML Generator - Package pmml",
  description = "RPart Decision Tree Model",
  copyright = NULL,
  model_version = NULL,
  transforms = NULL,
  missing_value_replacement = NULL,
  dataset = NULL,
  ...
)
```

## Arguments

- model:

  An rpart object.

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

- dataset:

  Data used to train the rpart model.

- ...:

  Further arguments passed to or from other methods.

## Value

PMML representation of the rpart object.

## Details

Supports regression tree as well as classification. The object is
represented in the PMML TreeModel format.

## References

[rpart: Recursive Partitioning (on
CRAN)](https://CRAN.R-project.org/package=rpart)

## Author

Graham Williams

## Examples

``` r
if (FALSE) { # \dontrun{
library(rpart)

fit <- rpart(Species ~ ., data = iris)

fit_pmml <- pmml(fit)
} # }
```

# Generate the PMML representation for a multinom object from package nnet.

Generate the multinomial logistic model in the PMML RegressionModel
format. The function implements the use of numerical, categorical and
multiplicative terms involving both numerical and categorical variables.

## Usage

``` r
# S3 method for class 'multinom'
pmml(
  model,
  model_name = "multinom_Model",
  app_name = "R PMML Generator - Package pmml",
  description = "Multinomial Logistic Model",
  copyright = NULL,
  model_version = NULL,
  transforms = NULL,
  missing_value_replacement = NULL,
  ...
)
```

## Arguments

- model:

  A multinom object.

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

- ...:

  Further arguments passed to or from other methods.

## Value

PMML representation of the `multinom` object.

## References

[nnet: Feed-forward Neural Networks and Multinomial Log-Linear Models
(on CRAN)](https://CRAN.R-project.org/package=nnet)

## Author

Tridivesh Jena

## Examples

``` r
if (FALSE) { # \dontrun{
library(nnet)
fit <- multinom(Species ~ ., data = iris)
fit_pmml <- pmml(fit)
} # }
```

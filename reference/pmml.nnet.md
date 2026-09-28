# Generate the PMML representation for a nnet object from package nnet.

Generate the PMML representation for a nnet object from package nnet.

## Usage

``` r
# S3 method for class 'nnet'
pmml(
  model,
  model_name = "NeuralNet_model",
  app_name = "R PMML Generator - Package pmml",
  description = "Neural Network Model",
  copyright = NULL,
  model_version = NULL,
  transforms = NULL,
  missing_value_replacement = NULL,
  ...
)
```

## Arguments

- model:

  A nnet object.

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

PMML representation of the nnet object.

## Details

This function supports both regression and classification neural network
models. The model is represented in the PMML NeuralNetwork format.

## References

[nnet: Feed-forward Neural Networks and Multinomial Log-Linear Models
(on CRAN)](https://CRAN.R-project.org/package=nnet)

## Author

Tridivesh Jena

## Examples

``` r
if (FALSE) { # \dontrun{
library(nnet)
fit <- nnet(Species ~ ., data = iris, size = 4)
fit_pmml <- pmml(fit)

rm(fit)
} # }
```

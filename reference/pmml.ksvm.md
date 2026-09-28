# Generate the PMML representation for a ksvm object from the package kernlab.

Generate the PMML representation for a ksvm object from the package
kernlab.

## Usage

``` r
# S3 method for class 'ksvm'
pmml(
  model,
  model_name = "SVM_model",
  app_name = "R PMML Generator - Package pmml",
  description = "Support Vector Machine Model",
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

  A ksvm object.

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

  Data used to train the ksvm model.

- ...:

  Further arguments passed to or from other methods.

## Value

PMML representation of the ksvm object.

## Details

Both classification (multi-class and binary) as well as regression cases
are supported.

The following ksvm kernels are currently supported: rbfdot, polydot,
vanilladot, tanhdot.

The argument `dataset` is required since the `ksvm` object does not
contain information about the used categorical variable.

## References

[kernlab: Kernel-based Machine Learning Lab (on
CRAN)](https://CRAN.R-project.org/package=kernlab)

## Examples

``` r
if (FALSE) { # \dontrun{
# Train a support vector machine to perform classification.
library(kernlab)

model <- ksvm(Species ~ ., data = iris)

model_pmml <- pmml(model, dataset = iris)
} # }
```

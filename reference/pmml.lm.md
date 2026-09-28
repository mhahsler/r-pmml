# Generate the PMML representation for an lm object from the package stats.

Generate the PMML representation for an lm object from the package
stats.

## Usage

``` r
# S3 method for class 'lm'
pmml(
  model,
  model_name = "lm_Model",
  app_name = "R PMML Generator - Package pmml",
  description = "Linear Regression Model",
  copyright = NULL,
  model_version = NULL,
  transforms = NULL,
  missing_value_replacement = NULL,
  weights = NULL,
  ...
)
```

## Arguments

- model:

  An lm object.

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

- weights:

  The weights used for building the model.

- ...:

  Further arguments passed to or from other methods.

## Value

PMML representation of the `lm` object.

## Details

The resulting PMML representation will not encode interaction terms.
Currently, only numeric regression is supported.

## References

[R project: Fitting Linear
Models](http://stat.ethz.ch/R-manual/R-devel/library/stats/html/lm.md)

## Author

Rajarshi Guha

## Examples

``` r
if (FALSE) { # \dontrun{
fit <- lm(Sepal.Length ~ ., data = iris)
fit_pmml <- pmml(fit)
} # }
```

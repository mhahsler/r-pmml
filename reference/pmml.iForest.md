# Generate PMML for an iForest object from the **isofor** package.

Generate PMML for an iForest object from the **isofor** package.

## Usage

``` r
# S3 method for class 'iForest'
pmml(
  model,
  model_name = "isolationForest_Model",
  app_name = "R PMML Generator - Package pmml",
  description = "Isolation Forest Model",
  copyright = NULL,
  model_version = NULL,
  transforms = NULL,
  missing_value_replacement = NULL,
  anomaly_threshold = 0.6,
  parent_invalid_value_treatment = "returnInvalid",
  child_invalid_value_treatment = "asIs",
  ...
)
```

## Arguments

- model:

  An iForest object from package **isofor**.

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

- anomaly_threshold:

  Double between 0 and 1. Predicted values greater than this are
  classified as anomalies.

- parent_invalid_value_treatment:

  Invalid value treatment at the top MiningField level.

- child_invalid_value_treatment:

  Invalid value treatment at the model segment MiningField level.

- ...:

  Further arguments passed to or from other methods.

## Value

PMML representation of the `iForest` object.

## Details

This function converts the iForest model object to the PMML format. The
PMML outputs the anomaly score as well as a boolean value indicating
whether the input is an anomaly or not. This is done by simply comparing
the anomaly score with `anomaly_threshold`, a parameter in the `pmml`
function. The iForest function automatically adds an extra level to all
categorical variables, labelled "."; this is kept in the PMML
representation even though the use of this extra factor in the predict
function is unclear.

## References

[isofor package on GitHub](https://github.com/gravesee/isofor)

## See also

[`pmml()`](https://michael.hahsler.net/r-pmml/reference/pmml.md)

## Author

Tridivesh Jena

## Examples

``` r
if (FALSE) { # \dontrun{

# Build iForest model using iris dataset. Create an isolation
# forest with 10 trees. Sample 30 data points at a time from
# the iris dataset to fit the trees.
library(isofor)
data(iris)
mod <- iForest(iris, nt = 10, phi = 30)

# Convert to PMML:
mod_pmml <- pmml(mod)
} # }
```

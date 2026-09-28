# Generate PMML for an ARIMA object the **forecast** package.

Generate PMML for an ARIMA object the **forecast** package.

## Usage

``` r
# S3 method for class 'ARIMA'
pmml(
  model,
  model_name = "ARIMA_model",
  app_name = "R PMML Generator - Package pmml",
  description = "ARIMA Time Series Model",
  copyright = NULL,
  model_version = NULL,
  transforms = NULL,
  missing_value_replacement = NULL,
  ts_type = "statespace",
  cpi_levels = c(80, 95),
  ...
)
```

## Arguments

- model:

  An ARIMA object from the package forecast.

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

- ts_type:

  The type of time series representation for PMML: "arima" or
  "statespace".

- cpi_levels:

  Vector of confidence levels for prediction intervals.

- ...:

  Further arguments passed to or from other methods.

## Value

PMML representation of the `ARIMA` object.

## Details

The model is represented as a PMML TimeSeriesModel.

When `ts_type = "statespace"` (by default), the R object is exported as
StateSpaceModel in PMML.

When `ts_type = "arima"`, the R object is exported as ARIMA in PMML with
conditional least squares (CLS). Note that ARIMA models in R are
estimated using a state space representation. Therefore, when using CLS
with seasonal models, forecast results between R and PMML may not match
exactly. Additionally, when ts_type="arima", prediction intervals are
exported for non-seasonal models only. For ARIMA models with d=2, the
prediction intervals between R and PMML may not match.

OutputField elements are exported with dataType "string", and contain a
collection of all values up to and including the steps-ahead value
supplied during scoring. String output in this form is facilitated by
Extension elements in the PMML file, and is supported by Zementis Server
since version 10.6.0.0.

`cpi_levels` behaves similar to `levels` in
[`forecast::forecast`](https://generics.r-lib.org/reference/forecast.html):
values must be between 0 and 100, non-inclusive.

Models with a drift term will be supported in a future version.

Transforms are currently not supported for ARIMA models.

## Author

Dmitriy Bolotov

## Examples

``` r
if (FALSE) { # \dontrun{
library(forecast)

# non-seasonal model
data("WWWusage")
mod <- Arima(WWWusage, order = c(3, 1, 1))
mod_pmml <- pmml(mod)

# seasonal model
data("JohnsonJohnson")
mod_02 <- Arima(JohnsonJohnson,
  order = c(1, 1, 1),
  seasonal = c(1, 1, 1)
)
mod_02_pmml <- pmml(mod_02)

# non-seasonal model exported with Conditional Least Squares
data("WWWusage")
mod <- Arima(WWWusage, order = c(3, 1, 1))
mod_pmml <- pmml(mod, ts_type = "arima")
} # }
```

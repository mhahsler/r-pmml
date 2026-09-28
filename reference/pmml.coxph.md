# Generate the PMML representation for a coxph object from the package survival.

Generate the PMML representation for a coxph object from the package
survival.

## Usage

``` r
# S3 method for class 'coxph'
pmml(
  model,
  model_name = "CoxPH_Survival_Regression_Model",
  app_name = "R PMML Generator - Package pmml",
  description = "CoxPH Survival Regression Model",
  copyright = NULL,
  model_version = NULL,
  transforms = NULL,
  missing_value_replacement = NULL,
  ...
)
```

## Arguments

- model:

  A coxph object.

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

## Details

A coxph object is the result of fitting a proportional hazards
regression model, using the `coxph` function from the package survival.
Although the survival package supports special terms "cluster", "tt" and
"strata", only the special term "strata" is supported by the pmml
package. Note that special term "strata" cannot be a multiplicative
variable and only numeric risk regression is supported.

## References

[coxph: Survival Analysis](https://CRAN.R-project.org/package=survival)

## Author

Graham Williams

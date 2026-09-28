# Generate the PMML representation for a gbm object from the package gbm.

Generate the PMML representation for a gbm object from the package gbm.

## Usage

``` r
# S3 method for class 'gbm'
pmml(
  model,
  model_name = "GBM_Model",
  app_name = "R PMML Generator - Package pmml",
  description = "Generalized Boosted Tree Model",
  copyright = NULL,
  model_version = NULL,
  transforms = NULL,
  missing_value_replacement = NULL,
  ...
)
```

## Arguments

- model:

  A `gbm` object.

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

PMML representation of the gbm object.

## Details

The 'gbm' function uses various distribution types to fit a model;
currently only the "bernoulli", "poisson" and "multinomial" distribution
types are supported.

For all cases, the model output includes the gbm prediction type "link"
and "response".

## References

[gbm: Generalized Boosted Regression Models (on
CRAN)](https://CRAN.R-project.org/package=gbm)

## Author

Tridivesh Jena

## Examples

``` r
if (FALSE) { # \dontrun{
library(gbm)
data(audit)

mod <- gbm(Adjusted ~ .,
  data = audit[, -c(1, 4, 6, 9, 10, 11, 12)],
  n.trees = 3, interaction.depth = 4
)

mod_pmml <- pmml(mod)

# Classification example:
mod2 <- gbm(Species ~ .,
  data = iris, n.trees = 2,
  interaction.depth = 3, distribution = "multinomial"
)

# The PMML will include a regression model to read the gbm object outputs
# and convert to a "response" prediction type.
mod2_pmml <- pmml(mod2)
} # }
```

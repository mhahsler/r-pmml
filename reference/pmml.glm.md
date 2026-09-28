# Generate the PMML representation for a glm object from the package stats.

Generate the PMML representation for a glm object from the package
stats.

## Usage

``` r
# S3 method for class 'glm'
pmml(
  model,
  model_name = "General_Regression_Model",
  app_name = "R PMML Generator - Package pmml",
  description = "Generalized Linear Regression Model",
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

  A glm object.

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

PMML representation of the glm object.

## Details

The function exports the glm model in the PMML GeneralRegressionModel
format.

Note on glm models for 2-class problems: a dataset where the target
categorical variable has more than 2 classes may be turned into a
2-class problem by creating a new target variable that is TRUE for a
particular class and FALSE for all other classes. While the R formula
function allows such a transformation to be passed directly to it, this
may cause issues when the model is converted to PMML. Therefore, it is
advised to create a new 2-class separately, and then pass that variable
to glm(). This is shown in an example below.

## References

[R project: Fitting Generalized Linear
Models](http://stat.ethz.ch/R-manual/R-devel/library/stats/html/glm.md)

## Examples

``` r
if (FALSE) { # \dontrun{
data(iris)
mod <- glm(Sepal.Length ~ ., data = iris, family = "gaussian")
mod_pmml <- pmml(mod)
rm(mod, mod_pmml)

data(audit)
mod <- glm(Adjusted ~ Age + Employment + Education + Income, data = audit, family = binomial(logit))
mod_pmml <- pmml(mod)
rm(mod, mod_pmml)

# Create a new 2-class target from a 3-class variable:
data(iris)
dat <- iris[, 1:4]
# Add a new 2-class target "Species_setosa" before passing it to glm():
dat$Species_setosa <- iris$Species == "setosa"
mod <- glm(Species_setosa ~ ., data = dat, family = binomial(logit))
mod_pmml <- pmml(mod)
rm(dat, mod, mod_pmml)
} # }
```

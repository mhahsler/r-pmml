# Generate the PMML representation for a naiveBayes object from the package e1071.

Generate the PMML representation for a naiveBayes object from the
package e1071.

## Usage

``` r
# S3 method for class 'naiveBayes'
pmml(
  model,
  model_name = "naiveBayes_Model",
  app_name = "R PMML Generator - Package pmml",
  description = "NaiveBayes Model",
  copyright = NULL,
  model_version = NULL,
  transforms = NULL,
  missing_value_replacement = NULL,
  predicted_field,
  ...
)
```

## Arguments

- model:

  A naiveBayes object.

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

- predicted_field:

  Required parameter; the name of the predicted field.

- ...:

  Further arguments passed to or from other methods.

## Value

PMML representation of the naiveBayes object.

## Details

The PMML representation of the NaiveBayes model implements the
definition as specified by the Data Mining Group: intermediate
probability values which are less than the threshold value are replaced
by the threshold value. This is different from the prediction function
of the e1071 in which only probability values of 0 and standard
deviations of continuous variables of with the value 0 are replaced by
the threshold value. The two values will therefore not match exactly for
cases involving very small probabilities.

## References

- [e1071: Misc Functions of the Department of Statistics, Probability
  Theory Group (Formerly: E1071), TU Wien (on
  CRAN)](https://CRAN.R-project.org/package=e1071)

- A. Guazzelli, T. Jena, W. Lin, M. Zeller (2013). Extending the Naive
  Bayes Model Element in PMML: Adding Support for Continuous Input
  Variables. In *Proceedings of the 19th ACM SIGKDD Conference on
  Knowledge Discovery and Data Mining*.

## Author

Tridivesh Jena

## Examples

``` r
if (FALSE) { # \dontrun{
library(e1071)

data(houseVotes84)
house <- na.omit(houseVotes84)

model <- naiveBayes(Class ~ V1 + V2 + V3, data = house, threshold = 0.003)

model_pmml <- pmml(model, dataset = house, predicted_field = "Class")
} # }
```

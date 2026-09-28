# Generate the PMML representation of an svm object from the e1071 package.

Generate the PMML representation of an svm object from the e1071
package.

## Usage

``` r
# S3 method for class 'svm'
pmml(
  model,
  model_name = "LIBSVM_Model",
  app_name = "R PMML Generator - Package pmml",
  description = "Support Vector Machine Model",
  copyright = NULL,
  model_version = NULL,
  transforms = NULL,
  missing_value_replacement = NULL,
  dataset = NULL,
  detect_anomaly = TRUE,
  ...
)
```

## Arguments

- model:

  An svm object from package e1071.

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

  Required for one-classification only; data used to train the one-class
  SVM model.

- detect_anomaly:

  Required for one-classification only; boolean indicating whether to
  detect anomalies (TRUE) or inliers (FALSE).

- ...:

  Further arguments passed to or from other methods.

## Value

PMML representation of the svm object.

## Details

Classification and regression models are represented in the PMML
SupportVectorMachineModel format. One-Classification models are
represented in the PMML AnomalyDetectionModel format. Please see below
for details on the differences.

## Classification and Regression Models

Note that the sign of the coefficient of each support vector flips
between the R object and the exported PMML file for classification and
regression models. This is due to the minor difference in the
training/scoring formula between the LIBSVM algorithm and the DMG
specification. Hence the output value of each support vector machine has
a sign flip between the DMG definition and the svm prediction function.

In a classification model, even though the output of the support vector
machine has a sign flip, it does not affect the final predicted
category. This is because in the DMG definition, the winning category is
defined as the left side of threshold 0 while the LIBSVM defines the
winning category as the right side of threshold 0.

For a regression model, the exported PMML code has two OutputField
elements. The OutputField `predictedValue` shows the support vector
machine output per DMG definition. The OutputField
`svm_predict_function` gives the value corresponding to the R predict
function for the svm model. This output should be used when making model
predictions.

## One-Classification SVM Models

For a one-classification svm (OCSVM) model, the PMML has two OutputField
elements: `anomalyScore` and one of `anomaly` or `outlier`.

The OutputField `anomalyScore` is the signed distance to the separating
boundary; `anomalyScore` corresponds to the `decision.values` attribute
of the output of the svm predict function in R.

The second OutputField depends the value of `detect_anomaly`. By
default, `detect_anomaly` is TRUE, which results in the second
OutputField being `anomaly`. The `anomaly` OutputField is TRUE when an
anomaly is detected. This field conforms to the DMG definition of an
anomaly detection model. This value is the opposite of the prediction by
the e1071::svm object in R.

Setting `detect_anomaly` to FALSE results in the second field instead
being `inlier`. This OutputField is TRUE when an inlier is detected, and
conforms to the e1071 definition of one-class SVMs. This field is FALSE
when an anomaly is detected; that is, the R svm model predicts whether
an observation belongs to the class. When comparing the predictions from
R and PMML, this field should be used, since it will match R's output.

For example, say that for an an observation, the R OCSVM model predicts
a positive decision value of 0.4 and label of TRUE. According to the R
object, this means that the observation is an inlier. By default, the
PMML export of this model will give the following for the same input:
`anomalyScore = 0.4, anomaly = "false"`. According to the PMML, the
observation is not an anomaly. If the same R object is instead exported
with `detect_anomaly = FALSE`, the PMML will then give:
`anomalyScore = 0.4, inlier = "true"`, and this result agrees with R.

Note that there is no sign flip for `anomalyScore` between R and PMML
for OCSVM models.

To export a OCSVM model, an additional argument, `dataset`, is required
by the function. This argument expects a dataframe with data that was
used to train the model. This is necessary because for one-class svm,
the R svm object does not contain information about the data types of
the features used to train the model. The exporter does not yet support
the formula interface for one-classification models, so the default S3
method must be used to train the SVM. The data used to train the
one-class SVM must be numeric and not of integer class.

## References

- R project CRAN package: ***e1071**: Misc Functions of the Department
  of Statistics, Probability Theory Group (Formerly: E1071), TU Wien*
  <https://CRAN.R-project.org/package=e1071>

- Chang, Chih-Chung and Lin, Chih-Jen, *LIBSVM: a library for Support
  Vector Machines* <https://www.csie.ntu.edu.tw/~cjlin/libsvm/>

## See also

[`pmml()`](https://michael.hahsler.net/r-pmml/reference/pmml.md), [PMML
SVM
specification](https://dmg.org/pmml/v4-4-1/SupportVectorMachine.html)

## Examples

``` r
if (FALSE) { # \dontrun{
library(e1071)
data(iris)

# Classification with a polynomial kernel
fit <- svm(Species ~ ., data = iris, kernel = "polynomial")
fit_pmml <- pmml(fit)

# Regression
fit <- svm(Sepal.Length ~ Sepal.Width + Petal.Length + Petal.Width, data = iris)
fit_pmml <- pmml(fit)

# Anomaly detection with one-classification
fit <- svm(iris[, 1:4],
  y = NULL,
  type = "one-classification"
)
fit_pmml <- pmml(fit, dataset = iris[, 1:4])

# Inlier detection with one-classification
fit <- svm(iris[, 1:4],
  y = NULL,
  type = "one-classification",
  detect_anomaly = FALSE
)
fit_pmml <- pmml(fit, dataset = iris[, 1:4])
} # }
```

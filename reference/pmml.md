# Generate the PMML representation for R objects.

`pmml` is a generic function implementing S3 methods used to produce the
PMML (Predictive Model Markup Language) representation of an R model.
The resulting PMML file can then be imported into other systems that
accept PMML.

## Usage

``` r
pmml(
  model = NULL,
  model_name = "R_Model",
  app_name = "R PMML Generator - Package pmml",
  description = NULL,
  copyright = NULL,
  model_version = NULL,
  transforms = NULL,
  ...
)
```

## Arguments

- model:

  An object to be converted to PMML.

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

- ...:

  Further arguments passed to or from other methods.

## Value

An object of class `XMLNode` as that defined by the XML package. This
represents the top level, or root node, of the XML document and is of
type PMML. It can be written to file with `saveXML`.

## Details

The data transformation functions previously available in the separate
`pmmlTransformations` package have been merged into `pmml` starting with
version 2.0.0.

This function can also be used to output variable transformations in
PMML format. In particular, it can be used as a transformations
generator. Various transformation operations can be implemented in R and
those transformations can then be output in PMML format by calling the
function with a NULL value for the model input and a data transformation
object as the transforms input. Please see the documentation for
`xform_wrap` for more information on how to create a data transformation
object.

In addition, the `pmml` function can also be called using a pre-existing
PMML model as the first input and a data transformation object as the
transforms input. The result is a new PMML model with the transformation
inserted as a "LocalTransformations" element in the original model. If
the original model already had a "LocalTransformations" element, the new
information will be appended to that element. If the model variables are
derived directly from a chain of transformations defined in the
transforms input, the field names in the model are replaced with the
original field names with the correct data types to make a consistent
model. The covered cases include model fields derived from an original
field, model fields derived from a chain of transformations starting
from an original field and multiple fields derived from the same
original field.

This package exports models to PMML version 4.4.1.

Please note that package XML_3.95-0.1 or later is required to perform
the full and correct functionality of pmml.

If data used for an R model contains features of type `character`, these
must be converted to factors before the model is trained and converted
with `pmml`.

A list of all the supported models and packages is available in the
vignette:

[`vignette("packages_and_functions", package="pmml")`](https://michael.hahsler.net/r-pmml/articles/packages_and_functions.md).

## References

- [PMML home page](https://dmg.org/pmml/v4-4-1/GeneralStructure.html)

- [PMML
  transformations](https://dmg.org/pmml/v4-4-1/Transformations.html)

## See also

[`pmml.ada()`](https://michael.hahsler.net/r-pmml/reference/pmml.ada.md),
[`pmml.rules()`](https://michael.hahsler.net/r-pmml/reference/pmml.rules.md),
[`pmml.coxph()`](https://michael.hahsler.net/r-pmml/reference/pmml.coxph.md),
[`pmml.cv.glmnet()`](https://michael.hahsler.net/r-pmml/reference/pmml.cv.glmnet.md),
[`pmml.glm()`](https://michael.hahsler.net/r-pmml/reference/pmml.glm.md),
[`pmml.hclust()`](https://michael.hahsler.net/r-pmml/reference/pmml.hclust.md),
[`pmml.kmeans()`](https://michael.hahsler.net/r-pmml/reference/pmml.kmeans.md),
[`pmml.ksvm()`](https://michael.hahsler.net/r-pmml/reference/pmml.ksvm.md),
[`pmml.lm()`](https://michael.hahsler.net/r-pmml/reference/pmml.lm.md),
[`pmml.multinom()`](https://michael.hahsler.net/r-pmml/reference/pmml.multinom.md),
[`pmml.naiveBayes()`](https://michael.hahsler.net/r-pmml/reference/pmml.naiveBayes.md),
[`pmml.nnet()`](https://michael.hahsler.net/r-pmml/reference/pmml.nnet.md),
[`pmml.rpart()`](https://michael.hahsler.net/r-pmml/reference/pmml.rpart.md),
[`pmml.svm()`](https://michael.hahsler.net/r-pmml/reference/pmml.svm.md),
[`pmml.xgb.Booster()`](https://michael.hahsler.net/r-pmml/reference/pmml.xgb.Booster.md)

## Author

Graham Williams

## Examples

``` r
# Build an lm model
iris_lm <- lm(Sepal.Length ~ ., data = iris)

# Convert to pmml
iris_lm_pmml <- pmml(iris_lm)

# Create a data transformation object
iris_trans <- xform_wrap(iris)

# Transform the 'Sepal.Length' variable
iris_trans <- xform_min_max(iris_trans, xform_info = "column1->d_sl")

# Output the tranformation in PMML format
iris_trans_pmml <- pmml(NULL, transforms = iris_trans)
```

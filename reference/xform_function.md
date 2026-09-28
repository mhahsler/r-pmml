# Add a function transformation to a xform_wrap object.

Add a function transformation to a xform_wrap object.

## Usage

``` r
xform_function(
  wrap_object,
  orig_field_name,
  new_field_name = "newField",
  new_field_data_type = "numeric",
  expression,
  map_missing_to = NA
)
```

## Arguments

- wrap_object:

  Output of xform_wrap or another transformation function.

- orig_field_name:

  String specifying name(s) of the original data field(s) being used in
  the transformation.

- new_field_name:

  Name of the new field created by the transformation.

- new_field_data_type:

  R data type of the new field created by the transformation ("numeric"
  or "factor").

- expression:

  String expression specifying the transformation.

- map_missing_to:

  Value to be given to the transformed variable if the value of any
  input variable is missing.

## Value

R object containing the raw data, the transformed data and data
statistics. The `data` data frame will contain a new `new_field_name`
column, and `field_data` will contain a new `new_field_name` row.

## Details

Calculate the expression provided in `expression` for every row in the
`wrap_object$data` data frame. The `expression` argument must represent
a valid R expression, and any functions used in `expression` must be
defined in the current environment.

The name of the new field is optional (a default name is provided), but
an error will be thrown if attempting to create a field with a name that
already exists in the xform_wrap object.

When `new_field_data_type = "numeric"`, the `DerivedField` attributes in
PMML will be `dataType = "double"` and `optype = "continuous"`. When
`new_field_data_type = "factor"`, these attributes will be
`dataType = "string"` and `optype = "categorical"`.

## See also

[`xform_wrap()`](https://michael.hahsler.net/r-pmml/reference/xform_wrap.md)

## Examples

``` r
# Load the standard iris dataset:
data(iris)

# Wrap the data:
iris_box <- xform_wrap(iris)

# Perform a transform on the Sepal.Length field:
# the value is squared and then divided by 100
iris_box <- xform_function(iris_box,
  orig_field_name = "Sepal.Length",
  new_field_name = "Sepal.Length.Transformed",
  expression = "(Sepal.Length^2)/100"
)

# Combine two fields to create another new feature:
iris_box <- xform_function(iris_box,
  orig_field_name = "Sepal.Width, Petal.Width",
  new_field_name = "Width.Sum",
  expression = "Sepal.Width + Sepal.Length"
)

# Create linear model using the derived features:
fit <- lm(Petal.Length ~
Sepal.Length.Transformed + Width.Sum, data = iris_box$data)

# Create pmml from the fit:
fit_pmml <- pmml(fit, transform = iris_box)
```

# Rename a variable in the xform_wrap transform object.

Rename a variable in the xform_wrap transform object.

## Usage

``` r
rename_wrap_var(wrap_object, xform_info = NA, ...)
```

## Arguments

- wrap_object:

  Wrapper object obtained by using the xform_wrap function on the raw
  data.

- xform_info:

  Specification of details of the renaming.

- ...:

  Further arguments passed to or from other methods.

## Value

R object containing the raw data, the transformed data and data
statistics.

## Details

Once input data is wrapped by the **xform_wrap** function, it is
somewhat involved to rename a variable inside. This function makes it
easier to do so. Given a variable named **input_var** and the name one
wishes to rename it to, **output_var**, the rename command options are:

xform_info="input_var -\> output_var"

There are two methods in which the variables can be referred to. The
first method is to use its column number; given the **data** attribute
of the **boxData** object, this would be the order at which the variable
appears. This can be indicated in the format "column#". The second
method is to refer to the variable by its name. This method will work
even if the renamed value already exists; in which case there will be
two variables with the same name.

If no input variable name is provided, the original object is returned
with no renaming performed.

## See also

[`xform_wrap()`](https://michael.hahsler.net/r-pmml/reference/xform_wrap.md)

## Author

Tridivesh Jena

## Examples

``` r
# Load the standard iris dataset
data(iris)

# First wrap the data
iris_box <- xform_wrap(iris)

# We wish to refer to the variables "Sepal.Length" and
# "Sepal.Width" as "SL" and "SW"
iris_box <- rename_wrap_var(wrap_object = iris_box, xform_info = "column1->SL")
iris_box <- rename_wrap_var(wrap_object = iris_box, xform_info = "Sepal.Width->SW")
```

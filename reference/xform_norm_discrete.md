# Normalize discrete values in accordance with the PMML element **NormDiscrete**.

Normalize discrete values in accordance with the PMML element
**NormDiscrete**.

## Usage

``` r
xform_norm_discrete(
  wrap_object,
  xform_info = NA,
  input_var = NA,
  map_missing_to = NA,
  ...
)
```

## Arguments

- wrap_object:

  Output of xform_wrap or another transformation function.

- xform_info:

  Specification of details of the transformation: the name of the input
  variable to be transformed.

- input_var:

  The input variable name in the data on which the transformation is to
  be applied.

- map_missing_to:

  Value to be given to the transformed variable if the value of the
  input variable is missing.

- ...:

  Further arguments passed to or from other methods.

## Value

R object containing the raw data, the transformed data and data
statistics.

## Details

Define a new derived variable for each possible value of a categorical
variable. Given a categorical variable **catVar** with possible discrete
values **A** and **B**, this will create 2 derived variables
**catVar_A** and **catVar_B**. If, for example, the input value of
**catVar** is **A** then **catVar_A** equals 1 and **catVar_B** equals
0.

Given an input variable, **input_var** and **missingVal**, the desired
value of the transformed variable if the input variable value is
missing, the xform_norm_discrete command including all optional
parameters is in the format:

xform_info="input_var=input_variable, map_missing_to=missingVal"

There are two methods in which the input variable can be referred to.
The first method is to use its column number; given the **data**
attribute of the **boxData** object, this would be the order at which
the variable appears. This can be indicated in the format "column#". The
second method is to refer to the variable by its name.

The **xform_info** and **input_var** parameters provide the same
information. While either one may be used when using this function, at
least one of them is required. If both parameters are given, the
**input_var** parameter is used as the default.

The output of this transformation is a set of transformed variables, one
for each possible value of the input variable. For example, given
possible values of the input variable **val1**, **val2**, ... these
transformed variables are by default named **input_var_val1**,
**input_var_val2**, ...

## See also

[`xform_wrap()`](https://michael.hahsler.net/r-pmml/reference/xform_wrap.md)

## Author

Tridivesh Jena

## Examples

``` r
# Load the standard iris dataset, already available in R
data(iris)

# First wrap the data
iris_box <- xform_wrap(iris)

# Discretize the "Species" variable. This will find all possible
# values of the "Species" variable and define new variables. The
# parameter name used here should be replaced by the new preferred
# parameter name as shown in the next example below.
#
#   "Species_setosa" such that it is 1 if
#      "Species" equals "setosa", else 0;
#   "Species_versicolor" such that it is 1 if
#      "Species" equals "versicolor", else 0;
#   "Species_virginica" such that it is 1 if
#      "Species" equals "virginica", else 0

iris_box <- xform_norm_discrete(iris_box, input_var = "Species")

# Exact same operation performed with a different parameter name.
# Use of this new parameter is the preferred method as the previous
# parameter will be deprecated soon.

iris_box <- xform_wrap(iris)
iris_box <- xform_norm_discrete(iris_box, xform_info = "Species")
```

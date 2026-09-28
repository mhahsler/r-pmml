# Implement a map between discrete values in accordance with the PMML element **MapValues**.

Implement a map between discrete values in accordance with the PMML
element **MapValues**.

## Usage

``` r
xform_map(
  wrap_object,
  xform_info,
  table = NA,
  default_value = NA,
  map_missing_to = NA,
  ...
)
```

## Arguments

- wrap_object:

  Output of xform_wrap or another transformation function.

- xform_info:

  Specification of details of the transformation. It can be a text
  giving the external file name or a list of data frames. Even if only 1
  variable is to be transformed, the information for that map should be
  given as a list with 1 element.

- table:

  Name of external CSV file containing the map from input to output
  values.

- default_value:

  The default value to be given to the transformed variable. If
  'xform_info' is a list, this is a vector with each element
  corresponding to the corresponding list element.

- map_missing_to:

  Value to be given to the transformed variable if the value of the
  input variable is missing. If 'xform_info' is a list, this is a vector
  with each element corresponding to the corresponding list element.

- ...:

  Further arguments passed to or from other methods.

## Value

R object containing the raw data, the transformed data and data
statistics.

## Details

Map discrete values of an input variable to a discrete value of the
transformed variable. The map can be given in an external table file
referred to in the transform command or as a list of data frames, each
data frame defining a map transform for one variable.

Given a map from the combination of variables **InVar1**, **InVar2**,
... to the transformed variable **OutVar**, where the variables have the
data types **InType1**, **InType2**, ... and **OutType**, the map
command is in the format:


    xform_info = "[InVar1,InVar2,... -> OutVar][InType1,InType2,... -> OutType]"
    table = "TableFileName", default_value = "defVal", map_missing_to = "missingVal"

where **TableFileName** is the name of the CSV file containing the map.
The map can be a N to 1 map where N is greater or equal to 1. The data
types of the variables can be any of the ones defined in the PMML format
including integer, double or string. **defVal** is the default value of
the transformed variable and if any of the map input values are missing,
**missingVal** is the value of the transformed variable.

The arguments InType, OutType, default_value and map_missing_to are
optional. The CSV file containing the table should not have any row and
column identifiers, and the values given must be in the same order as in
the map command. If the data types of the variables are not given, the
data types of the input variables are attempted to be determined from
the **boxData** argument. If that is not possible, the data type is
assumed to be string.

It is also possible to give the maps to be implemented without an
external file using a list of data frames. Each data frame defines a map
for 1 input variable. Given a data frame with N+1 columns, it is assumed
that the map is a N to 1 map where the last column of the data frame
corresponds to the derived field. The 1st row is assumed to be the names
of the fields and the second row the data types of the fields. The rest
of the rows define the map; each combination of the input values in a
row is mapped to the value in the last column of that row. The second
row with the data types of the fields is not required. If not given, all
fields are assumed to be strings. In this input format, the
'default_value' and 'map_missing_to' parameters should be vectors. The
first element of each vector will correspond to the derived field
defined in the 1st element of the 'xform_info' list etc. These are made
clearer in the example below.

## See also

[`xform_wrap()`](https://michael.hahsler.net/r-pmml/reference/xform_wrap.md),
[`pmml()`](https://michael.hahsler.net/r-pmml/reference/pmml.md)

## Author

Tridivesh Jena

## Examples

``` r
# Load the standard audit dataset, part of the pmml package:
data(audit)

# First wrap the data:
audit_box <- xform_wrap(audit)
if (FALSE) { # \dontrun{
# One of the variables, "Sex", has 2 possible values: "Male"
# and "Female". If these string values have to be mapped to a
# numeric value, a file has to be created, say "map_audit.csv",
# whose content is, for example:
#
#  Male,1
#  Female,2
#
# Transform the variable "Gender" to a variable "d_gender"
# such that:
#    if Sex = "Male" then d_sex = "1"
#    if Sex = "Female" then d_sex = "2"
#
# Give "d_sex" the value 0 if the input variable value is
# missing.
audit_box <- xform_map(audit_box,
  xform_info = "[Sex -> d_sex][string->integer]",
  table = "map_audit.csv", map_missing_to = "0"
)
} # }
# Same as above, with an extra variable, but using data frames.
# The top 2 rows give the variable names and their data types.
# The rest represent the map. For example, the third row
# indicates that when the input variable "Sex" has the value
# "Male" and the input variable "Employment" has
# the value "PSLocal", the output variable "d_sex" should have
# the value 1.
t <- list()
m <- data.frame(
  c("Sex", "string", "Male", "Female"),
  c("Employment", "string", "PSLocal", "PSState"),
  c("d_sex", "integer", 1, 0),
  stringsAsFactors = TRUE
)
t[[1]] <- m

# Give default value as a vector and missing value as a string,
# this is only possible as there is only one map defined. If
# default values is not given, it will simply not be given in
# the PMML file as well. In general, the default values and the
# missing values should be given as a vector, each element of
# the vector corresponding to the element at the same index in
# the list. If these values are not given as a vector, they will
# be used for the first list element only.
audit_box <- xform_map(audit_box,
  xform_info = t, default_value = c(3),
  map_missing_to = "2"
)

# check what the pmml looks like
fit <- lm(Adjusted ~ ., data = audit_box$data)
fit_pmml <- pmml(fit, transforms = audit_box)
```

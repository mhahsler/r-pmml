# Introduction to xform_function

## Introduction

This vignette provides examples of how to use the `xform_function`
transformation to create new data features for PMML models.

Given a `xform_wrap` object and a transformation expression,
`xform_function` calculates data for a new feature and creates a new
`xform_wrap` object. When PMML is produced with
[`pmml::pmml()`](https://michael.hahsler.net/r-pmml/reference/pmml.md),
the transformation is inserted into the `LocalTransformations` node as a
`DerivedField`.

Multiple data fields and functions can be combined to produce a new
feature.

The code below uses
[`knitr::kable()`](https://rdrr.io/pkg/knitr/man/kable.html) to make
tables more readable.

## Single numeric input

Using the `iris` dataset as an example, let’s construct a new feature by
transforming one variable. Load the dataset and show the first few
lines:

``` r

data(iris)
kable(head(iris,3))
```

| Sepal.Length | Sepal.Width | Petal.Length | Petal.Width | Species |
|-------------:|------------:|-------------:|------------:|:--------|
|          5.1 |         3.5 |          1.4 |         0.2 | setosa  |
|          4.9 |         3.0 |          1.4 |         0.2 | setosa  |
|          4.7 |         3.2 |          1.3 |         0.2 | setosa  |

Create the `iris_box` object with `xform_wrap`:

``` r

iris_box <- xform_wrap(iris)
```

`iris_box` contains the data and transform information that will be used
to produce PMML later. The original data is in `iris_box$data`. Any new
features created with a transformation are added as columns to this data
frame.

``` r

kable(head(iris_box$data,3))
```

| Sepal.Length | Sepal.Width | Petal.Length | Petal.Width | Species |
|-------------:|------------:|-------------:|------------:|:--------|
|          5.1 |         3.5 |          1.4 |         0.2 | setosa  |
|          4.9 |         3.0 |          1.4 |         0.2 | setosa  |
|          4.7 |         3.2 |          1.3 |         0.2 | setosa  |

Transform and field information is in `iris_box$field_data`. The
field_data data frame contains information on every field in the
dataset, as well as every transform used. The `xform_function` column
contains expressions used in the `xform_function` transform.

``` r

kable(iris_box$field_data)
```

|  | type | dataType | orig_field_name | sampleMin | sampleMax | xformedMin | xformedMax | centers | scales | fieldsMap | transform | default | missingValue | xform_function |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| Sepal.Length | original | numeric | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA |
| Sepal.Width | original | numeric | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA |
| Petal.Length | original | numeric | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA |
| Petal.Width | original | numeric | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA |
| Species | original | factor | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA |

Now add a new feature, `Sepal.Length.Sqrt`, using `xform_function`:

``` r

iris_box <- xform_function(iris_box,orig_field_name="Sepal.Length",
                         new_field_name="Sepal.Length.Sqrt",
                         expression="sqrt(Sepal.Length)")
```

The new feature is calculated and added as a column to the
`iris_box$data` data frame:

``` r

kable(head(iris_box$data,3))
```

| Sepal.Length | Sepal.Width | Petal.Length | Petal.Width | Species | Sepal.Length.Sqrt |
|-------------:|------------:|-------------:|------------:|:--------|------------------:|
|          5.1 |         3.5 |          1.4 |         0.2 | setosa  |          2.258318 |
|          4.9 |         3.0 |          1.4 |         0.2 | setosa  |          2.213594 |
|          4.7 |         3.2 |          1.3 |         0.2 | setosa  |          2.167948 |

`iris_box$field_data` now contains a new row with the transformation
expression:

``` r

kable(iris_box$field_data[6,c(1:3,14)])
```

|                   | type    | dataType | orig_field_name | xform_function     |
|:------------------|:--------|:---------|:----------------|:-------------------|
| Sepal.Length.Sqrt | derived | numeric  | Sepal.Length    | sqrt(Sepal.Length) |

Construct a linear model for `Petal.Width` using this new feature, and
convert it to PMML:

``` r

fit <- lm(Petal.Width ~ Sepal.Length.Sqrt, data=iris_box$data)
fit_pmml <- pmml(fit, transform=iris_box)
```

Since the model predicts `Petal.Width` using a variable based on
`Sepal.Length`, the PMML will contain these two fields in the
`DataDictionary` and `MiningSchema`:

``` r

fit_pmml[[2]] #Data Dictionary node
#> <DataDictionary numberOfFields="2">
#>  <DataField name="Petal.Width" optype="continuous" dataType="double"/>
#>  <DataField name="Sepal.Length" optype="continuous" dataType="double"/>
#> </DataDictionary>
fit_pmml[[3]][[1]] #Mining Schema node
#> <MiningSchema>
#>  <MiningField name="Petal.Width" usageType="predicted" invalidValueTreatment="returnInvalid"/>
#>  <MiningField name="Sepal.Length" usageType="active" invalidValueTreatment="returnInvalid"/>
#> </MiningSchema>
```

The `LocalTransformations` node contains `Sepal.Length.Sqrt` as a
derived field:

``` r

fit_pmml[[3]][[3]]
#> <LocalTransformations>
#>  <DerivedField name="Sepal.Length.Sqrt" dataType="double" optype="continuous">
#> <Apply function="sqrt">
#>   <FieldRef field="Sepal.Length"/>
#> </Apply> 
#>  </DerivedField>
#> </LocalTransformations>
```

## Single categorical input

`xform_function` can also operate on categorical data. In this example,
let’s create a numeric feature that equals 1 when `Species` is `setosa`,
and 0 otherwise:

``` r

iris_box <- xform_wrap(iris)
iris_box <- xform_function(iris_box,orig_field_name="Species",
                         new_field_name="Species.Setosa",
                         expression="if (Species == 'setosa') {1} else {0}")
kable(head(iris_box$data,3))
```

| Sepal.Length | Sepal.Width | Petal.Length | Petal.Width | Species | Species.Setosa |
|-------------:|------------:|-------------:|------------:|:--------|---------------:|
|          5.1 |         3.5 |          1.4 |         0.2 | setosa  |              1 |
|          4.9 |         3.0 |          1.4 |         0.2 | setosa  |              1 |
|          4.7 |         3.2 |          1.3 |         0.2 | setosa  |              1 |

Create a linear model and check the `LocalTransformations` node:

``` r

fit <- lm(Petal.Width ~ Species.Setosa, data=iris_box$data)
fit_pmml <- pmml(fit, transform=iris_box)
fit_pmml[[3]][[3]]
#> <LocalTransformations>
#>  <DerivedField name="Species.Setosa" dataType="double" optype="continuous">
#> <Apply function="if">
#>   <Apply function="equal">
#>     <FieldRef field="Species"/>
#>     <Constant dataType="string">setosa</Constant>
#>   </Apply>
#>   <Constant dataType="double">1</Constant>
#>   <Constant dataType="double">0</Constant>
#> </Apply> 
#>  </DerivedField>
#> </LocalTransformations>
```

## Multiple input fields

Several fields can be combined to create new features. Let’s make a new
field from the ratio of sepal and petal lengths:

``` r

iris_box <- xform_wrap(iris)
iris_box <- xform_function(iris_box,orig_field_name="Sepal.Length,Petal.Length",
                         new_field_name="Length.Ratio",
                         expression="Sepal.Length / Petal.Length")
```

As before, the new field is added as a column to the `iris_box$data`
data frame:

``` r

kable(head(iris_box$data,3))
```

| Sepal.Length | Sepal.Width | Petal.Length | Petal.Width | Species | Length.Ratio |
|-------------:|------------:|-------------:|------------:|:--------|-------------:|
|          5.1 |         3.5 |          1.4 |         0.2 | setosa  |     3.642857 |
|          4.9 |         3.0 |          1.4 |         0.2 | setosa  |     3.500000 |
|          4.7 |         3.2 |          1.3 |         0.2 | setosa  |     3.615385 |

Fit a linear model using this new feature, and convert it to pmml:

``` r

fit <- lm(Petal.Width ~ Length.Ratio, data=iris_box$data)
fit_pmml <- pmml(fit, transform=iris_box)
```

The pmml will contain `Sepal.Length` and `Petal.Length` in the
`DataDictionary` and `MiningSchema`:

``` r

fit_pmml[[2]] #Data Dictionary node
#> <DataDictionary numberOfFields="3">
#>  <DataField name="Petal.Width" optype="continuous" dataType="double"/>
#>  <DataField name="Sepal.Length" optype="continuous" dataType="double"/>
#>  <DataField name="Petal.Length" optype="continuous" dataType="double"/>
#> </DataDictionary>
fit_pmml[[3]][[1]] #Mining Schema node
#> <MiningSchema>
#>  <MiningField name="Petal.Width" usageType="predicted" invalidValueTreatment="returnInvalid"/>
#>  <MiningField name="Sepal.Length" usageType="active" invalidValueTreatment="returnInvalid"/>
#>  <MiningField name="Petal.Length" usageType="active" invalidValueTreatment="returnInvalid"/>
#> </MiningSchema>
```

The `Local.Transformations` node contains `Length.Ratio` as a derived
field:

``` r

fit_pmml[[3]][[3]]
#> <LocalTransformations>
#>  <DerivedField name="Length.Ratio" dataType="double" optype="continuous">
#> <Apply function="/">
#>   <FieldRef field="Sepal.Length"/>
#>   <FieldRef field="Petal.Length"/>
#> </Apply> 
#>  </DerivedField>
#> </LocalTransformations>
```

## Using a previously derived feature

It is possible to pass a feature derived with `xform_function` to
another `xform_function` call. To do this, the second call to
`xform_function` must use the original data field names (instead of the
derived field) in the `orig_field_name` argument.

``` r

iris_box <- xform_wrap(iris)
iris_box <- xform_function(iris_box,orig_field_name="Sepal.Length,Petal.Length",
                         new_field_name="Length.Ratio",
                         expression="Sepal.Length / Petal.Length")

iris_box <- xform_function(iris_box,orig_field_name="Sepal.Length,Petal.Length,Sepal.Width",
                         new_field_name="Length.R.Times.S.Width",
                         expression="Length.Ratio * Sepal.Width")
kable(iris_box$field_data[6:7,c(1:3,14)])
```

|  | type | dataType | orig_field_name | xform_function |
|:---|:---|:---|:---|:---|
| Length.Ratio | derived | numeric | Sepal.Length,Petal.Length | Sepal.Length / Petal.Length |
| Length.R.Times.S.Width | derived | numeric | Sepal.Length,Petal.Length,Sepal.Width | Length.Ratio \* Sepal.Width |

``` r

fit <- lm(Petal.Width ~ Length.R.Times.S.Width, data=iris_box$data)
fit_pmml <- pmml(fit, transform=iris_box)
```

The pmml will contain `Sepal.Length`, `Petal.Length`, and `Sepal.Width`
in the `DataDictionary` and `MiningSchema`:

``` r

fit_pmml[[2]] #Data Dictionary node
#> <DataDictionary numberOfFields="4">
#>  <DataField name="Petal.Width" optype="continuous" dataType="double"/>
#>  <DataField name="Sepal.Length" optype="continuous" dataType="double"/>
#>  <DataField name="Petal.Length" optype="continuous" dataType="double"/>
#>  <DataField name="Sepal.Width" optype="continuous" dataType="double"/>
#> </DataDictionary>
fit_pmml[[3]][[1]] #Mining Schema node
#> <MiningSchema>
#>  <MiningField name="Petal.Width" usageType="predicted" invalidValueTreatment="returnInvalid"/>
#>  <MiningField name="Sepal.Length" usageType="active" invalidValueTreatment="returnInvalid"/>
#>  <MiningField name="Petal.Length" usageType="active" invalidValueTreatment="returnInvalid"/>
#>  <MiningField name="Sepal.Width" usageType="active" invalidValueTreatment="returnInvalid"/>
#> </MiningSchema>
```

The `Local.Transformations` node contains `Length.Ratio` and
`Length.R.Times.S.Width` as derived fields:

``` r

fit_pmml[[3]][[3]]
#> <LocalTransformations>
#>  <DerivedField name="Length.Ratio" dataType="double" optype="continuous">
#> <Apply function="/">
#>   <FieldRef field="Sepal.Length"/>
#>   <FieldRef field="Petal.Length"/>
#> </Apply> 
#>  </DerivedField>
#>  <DerivedField name="Length.R.Times.S.Width" dataType="double" optype="continuous">
#> <Apply function="*">
#>   <FieldRef field="Length.Ratio"/>
#>   <FieldRef field="Sepal.Width"/>
#> </Apply> 
#>  </DerivedField>
#> </LocalTransformations>
```

## Factor output

The resulting field can be numeric or factor. Note that factors are
exported with `dataType = "string"` and `optype = "categorical"` in
PMML. The following code creates a factor with 3 levels from
`Sepal.Length`:

``` r

iris_box <- xform_wrap(iris)

iris_box <- xform_function(wrap_object = iris_box,
                              orig_field_name = "Sepal.Length",
                              new_field_name = "SL_factor",
                              new_field_data_type = "factor",
                              expression = "if(Sepal.Length<5.1) {'level_A'} else if (Sepal.Length>6.6) {'level_B'} else {'level_C'}")

kable(head(iris_box$data, 3))
```

| Sepal.Length | Sepal.Width | Petal.Length | Petal.Width | Species | SL_factor |
|-------------:|------------:|-------------:|------------:|:--------|:----------|
|          5.1 |         3.5 |          1.4 |         0.2 | setosa  | level_C   |
|          4.9 |         3.0 |          1.4 |         0.2 | setosa  | level_A   |
|          4.7 |         3.2 |          1.3 |         0.2 | setosa  | level_A   |

The feature can then be used to create a model as usual:

``` r

fit <- lm(Petal.Width ~ SL_factor, data=iris_box$data)
fit_pmml <- pmml(fit, transform=iris_box)
```

## PMML functions supported by `xform_function`

The following R functions and operators are directly supported by
`xform_function`. Their PMML equivalents are listed in the second
column:

| R       | PMML           |
|:--------|:---------------|
| \+      | \+             |
| \-      | \-             |
| /       | /              |
| \*      | \*             |
| ^       | pow            |
| \<      | lessThan       |
| \<=     | lessOrEqual    |
| \>      | greaterThan    |
| \>=     | greaterOrEqual |
| &&      | and            |
| &       | and            |
| \|      | or             |
| \|\|    | or             |
| ==      | equal          |
| !=      | notEqual       |
| !       | not            |
| ceiling | ceil           |
| prod    | product        |
| log     | ln             |

For these functions, no extra code is required for translation.

The R function `prod` can be used as long as only numeric arguments are
specified. That is, `prod` can take an `na.rm` argument, but specifying
this in `xform_function` directly will not produce PMML equivalent to
the R expression.

Similarly, the R function `log` can be used directly as long as the
second argument (the base) is not specified.

## PMML functions not supported by `xform_function`

There are built-in functions defined in PMML that cannot be directly
translated to PMML using `xform_function` as described above.

In this case, an error will be thrown when R tries to calculate a new
feature using the function passed to `xform_function`, but does not see
that function in the environment.

It is still possible to make `xform_function` work, but the PMML
function must be defined in the R environment first.

Let’s use `isIn`, a PMML function, as an example. The function returns a
boolean indicating whether the first argument is contained in a list of
values. Detailed specification for this function is available on [this
DMG page](https://dmg.org/pmml/v4-4-1/BuiltinFunctions.html#boolean5).

One way to implement this in R is by using `%in%`, with the list of
values being represented by `...`:

``` r

isIn <- function(x, ...) {
  dots <- c(...)
  if (x %in% dots) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}

isIn(1,2,1,4)
#> [1] TRUE
```

This function can now be passed to `xform_function`. The following code
creates a feature that indicates whether `Species` is either `setosa` or
`versicolor`:

``` r

iris_box <- xform_wrap(iris)
iris_box <- xform_function(iris_box,orig_field_name="Species",
                         new_field_name="Species.Setosa.or.Versicolor",
                         expression="isIn(Species,'setosa','versicolor')")
```

The `data` data frame now contains the new feature:

``` r

kable(head(iris_box$data,3))
```

| Sepal.Length | Sepal.Width | Petal.Length | Petal.Width | Species | Species.Setosa.or.Versicolor |
|---:|---:|---:|---:|:---|---:|
| 5.1 | 3.5 | 1.4 | 0.2 | setosa | 1 |
| 4.9 | 3.0 | 1.4 | 0.2 | setosa | 1 |
| 4.7 | 3.2 | 1.3 | 0.2 | setosa | 1 |

Create a linear model and view the corresponding PMML for the function:

``` r

fit <- lm(Petal.Width ~ Species.Setosa.or.Versicolor, data=iris_box$data)
fit_pmml <- pmml(fit, transform=iris_box)
fit_pmml[[3]][[3]]
#> <LocalTransformations>
#>  <DerivedField name="Species.Setosa.or.Versicolor" dataType="double" optype="continuous">
#> <Apply function="isIn">
#>   <FieldRef field="Species"/>
#>   <Constant dataType="string">setosa</Constant>
#>   <Constant dataType="string">versicolor</Constant>
#> </Apply> 
#>  </DerivedField>
#> </LocalTransformations>
```

## PMML function not supported by `xform_function` - another example

As another example, let’s use R’s `mean` function to create a new
feature. PMML has a built-in `avg`, so we will define an R function with
this name.

``` r

avg <- function(...) {
  dots <- c(...)
  return(mean(dots))
}
```

Now use this function to take an average of several other features and
combine with another field:

``` r

iris_box <- xform_wrap(iris)
iris_box <- xform_function(iris_box,orig_field_name="Sepal.Length,Petal.Length,Sepal.Width",
                         new_field_name="Length.Average.Ratio",
                         expression="avg(Sepal.Length,Petal.Length)/Sepal.Width")
```

The `data` data frame now contains the new feature:

``` r

kable(head(iris_box$data,3))
```

| Sepal.Length | Sepal.Width | Petal.Length | Petal.Width | Species | Length.Average.Ratio |
|---:|---:|---:|---:|:---|---:|
| 5.1 | 3.5 | 1.4 | 0.2 | setosa | 0.9285714 |
| 4.9 | 3.0 | 1.4 | 0.2 | setosa | 1.0500000 |
| 4.7 | 3.2 | 1.3 | 0.2 | setosa | 0.9375000 |

Create a simple linear model and view the corresponding PMML for the
function:

``` r

fit <- lm(Petal.Width ~ Length.Average.Ratio, data=iris_box$data)
fit_pmml <- pmml(fit, transform=iris_box)
fit_pmml[[3]][[3]]
#> <LocalTransformations>
#>  <DerivedField name="Length.Average.Ratio" dataType="double" optype="continuous">
#> <Apply function="/">
#>   <Apply function="avg">
#>     <FieldRef field="Sepal.Length"/>
#>     <FieldRef field="Petal.Length"/>
#>   </Apply>
#>   <FieldRef field="Sepal.Width"/>
#> </Apply> 
#>  </DerivedField>
#> </LocalTransformations>
```

In the PMML, `avg` will be recognized as a valid function.

## PMML for arbitrary functions

The function `function_to_pmml` (part of the `pmml` package) makes it
possible to convert an R expression into PMML directly, without creating
a model or calculating values.

As long as the expression passed to the function is a valid R expression
(e.g., no unbalanced parentheses), it can contain arbitrary function
names not defined in R. Variables in the expression passed to
`xform_function` are always assumed to be field names, and not
substituted. That is, even if `x` has a value in the R environment, the
resulting expression will still use `x`.

``` r

function_to_pmml("1 + 2")
#> <Apply function="+">
#>   <Constant dataType="double">1</Constant>
#>   <Constant dataType="double">2</Constant>
#> </Apply>

x <- 3
function_to_pmml("foo(bar(x * y))")
#> <Apply function="foo">
#>   <Apply function="bar">
#>     <Apply function="*">
#>       <FieldRef field="x"/>
#>       <FieldRef field="y"/>
#>     </Apply>
#>   </Apply>
#> </Apply>
```

## More notes on functions

There are several limitations to parsing expressions in
`xform_function`.

Each transformation operates on one data row at a time. For example, it
is not possible to compute the mean of an entire feature column in
`xform_function`.

An expression such as `foo(x)` is treated as a function `foo` with
argument `x`. Consequently, passing in an R vector `c(1,2,3)` will
produce PMML where `c` is a function and `1,2,3` are the arguments:

``` r

function_to_pmml("c(1,2,3)")
#> <Apply function="c">
#>   <Constant dataType="double">1</Constant>
#>   <Constant dataType="double">2</Constant>
#>   <Constant dataType="double">3</Constant>
#> </Apply>
```

We can also see what happens when passing an `na.rm` argument to `prod`,
as mentioned in an above example:

``` r

function_to_pmml("prod(1,2,na.rm=FALSE)") #produces incorrect PMML
#> <Apply function="product">
#>   <Constant dataType="double">1</Constant>
#>   <Constant dataType="double">2</Constant>
#>   <Constant dataType="boolean">FALSE</Constant>
#> </Apply>
function_to_pmml("prod(1,2)") #produces correct PMML
#> <Apply function="product">
#>   <Constant dataType="double">1</Constant>
#>   <Constant dataType="double">2</Constant>
#> </Apply>
```

Additionally, passing in a vector to `prod` produces incorrect PMML:

``` r

prod(c(1,2,3))
#> [1] 6
function_to_pmml("prod(c(1,2,3))")
#> <Apply function="product">
#>   <Apply function="c">
#>     <Constant dataType="double">1</Constant>
#>     <Constant dataType="double">2</Constant>
#>     <Constant dataType="double">3</Constant>
#>   </Apply>
#> </Apply>
```

## More examples of functions

The following are additional examples of pmml produced from R
expressions.

Extra parentheses:

``` r

function_to_pmml("pmmlT(((1+2))*(x))")
#> <Apply function="pmmlT">
#>   <Apply function="*">
#>     <Apply function="+">
#>       <Constant dataType="double">1</Constant>
#>       <Constant dataType="double">2</Constant>
#>     </Apply>
#>     <FieldRef field="x"/>
#>   </Apply>
#> </Apply>
```

If-else expressions:

``` r

function_to_pmml("if(a<2) {x+3} else if (a>4) {4} else {5}")
#> <Apply function="if">
#>   <Apply function="lessThan">
#>     <FieldRef field="a"/>
#>     <Constant dataType="double">2</Constant>
#>   </Apply>
#>   <Apply function="+">
#>     <FieldRef field="x"/>
#>     <Constant dataType="double">3</Constant>
#>   </Apply>
#>   <Apply function="if">
#>     <Apply function="greaterThan">
#>       <FieldRef field="a"/>
#>       <Constant dataType="double">4</Constant>
#>     </Apply>
#>     <Constant dataType="double">4</Constant>
#>     <Constant dataType="double">5</Constant>
#>   </Apply>
#> </Apply>
```

## References

- [DMG PMML 4.4
  specification](https://dmg.org/pmml/v4-4-1/GeneralStructure.html)

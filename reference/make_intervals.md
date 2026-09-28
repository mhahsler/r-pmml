# Create Interval elements, most likely to add to a DataDictionary element.

Create Interval elements, most likely to add to a DataDictionary
element.

## Usage

``` r
make_intervals(
  closure = NULL,
  leftMargin = NULL,
  rightMargin = NULL,
  namespace = "4_4"
)
```

## Arguments

- closure:

  The 'closure' attribute of each 'Interval' element to be created in
  order.

- leftMargin:

  The 'leftMargin' attribute of each 'Interval' element to be created in
  order.

- rightMargin:

  The 'rightMargin' attribute of each 'Interval' element to be created
  in order.

- namespace:

  The namespace of the PMML model

## Value

PMML Intervals elements.

## Details

The 'Interval' element allows 3 attributes, all of which may be defined
in the 'make_intervals' function. The value of these attributes should
be provided as a list. Thus the elements of the 'leftMargin' for example
define the value of that attribute for each 'Interval' element in order.

## See also

[`make_values()`](https://michael.hahsler.net/r-pmml/reference/make_values.md)
to make Values child elements,
[`add_data_field_children()`](https://michael.hahsler.net/r-pmml/reference/add_data_field_children.md)
to add these xml fragments to the DataDictionary PMML element.

## Author

Tridivesh Jena

## Examples

``` r
# make 3 Interval elements
# we define the 3 Intervals as ,1]  (1,2)  and [2,
mi <- make_intervals(
  list("openClosed", "openOpen", "closedOpen"),
  list(NULL, 1, 2), list(1, 2, NULL)
)
```

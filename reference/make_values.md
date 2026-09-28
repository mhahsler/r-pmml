# Create Values element, most likely to add to a DataDictionary element.

Create Values element, most likely to add to a DataDictionary element.

## Usage

``` r
make_values(
  value = NULL,
  displayValue = NULL,
  property = NULL,
  namespace = "4_4"
)
```

## Arguments

- value:

  The 'value' attribute of each 'Value' element to be created in order.

- displayValue:

  The 'displayValue' attribute of each 'Value' element to be created in
  order.

- property:

  The 'property' attribute of each 'Value' element to be created in
  order.

- namespace:

  The namespace of the PMML model

## Value

PMML Values elements.

## Details

This function is used the same way as the `make_intervals` function. If
certain attributes for an element should not be included, they should be
input in the list as NULL.

## See also

[`make_intervals()`](https://michael.hahsler.net/r-pmml/reference/make_intervals.md)
to make Interval child elements,
[`add_data_field_children()`](https://michael.hahsler.net/r-pmml/reference/add_data_field_children.md)
to add these xml fragments to the DataDictionary PMML element.

## Author

Tridivesh Jena

## Examples

``` r
# define 3 values, none with a 'displayValue' attribute and 1 value
# defined as 'invalid'. The 2nd one is 'valid' by default.
mv <- make_values(
  list(1.1, 2.2, 3.3), list(NULL, NULL, NULL),
  list("valid", NULL, "invalid")
)
```

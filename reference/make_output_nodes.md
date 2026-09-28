# Add Output nodes to a PMML object.

Add Output nodes to a PMML object.

## Usage

``` r
make_output_nodes(
  name = "OutputField",
  attributes = NULL,
  expression = NULL,
  namespace = "4_4"
)
```

## Arguments

- name:

  The name of the element to be created.

- attributes:

  The node attributes to be added.

- expression:

  Post-processing information to be included in the element. This
  expression will be processed by `function_to_pmml`.

- namespace:

  The namespace of the PMML model.

## Value

List of nodes

## Details

Create a list of nodes with names `'name'`, attributes `'attributes'`
and child elements `'expression'`. `'expression'` is a string converted
to XML similar to `function_to_pmml`.

Meant to create OutputField elements, 'expressions' can be used to add
post-processing transformations to a model. To create multiple such
nodes, all the parameters must be given as lists of equal length.

## Author

Tridivesh Jena

## Examples

``` r
# Make two nodes, one with attributes
two_nodes <- make_output_nodes(
  name = list("OutputField", "OutputField"),
  attributes = list(list(name = "dbl", optype = "continuous"), NULL),
  expression = list("ln(x)", "ln(x/(1-x))")
)
```

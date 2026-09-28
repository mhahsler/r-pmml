# Add Output nodes to a PMML object.

Add Output nodes to a PMML object.

## Usage

``` r
add_output_field(
  xml_model = NULL,
  outputNodes = NULL,
  at = "End",
  xformText = NULL,
  nodeName = NULL,
  attributes = NULL,
  whichOutput = 1,
  namespace = "4_4"
)
```

## Arguments

- xml_model:

  The PMML model to which the OutputField elements are to be added

- outputNodes:

  The Output nodes to be added. These may be created using the
  'make_output_nodes' helper function

- at:

  Given an Output element, the 1 based index after which the given
  Output child element should be inserted at

- xformText:

  Post-processing information to be included in the OutputField element.
  This expression will be processed by the function_to_pmml function

- nodeName:

  The name of the element to be added

- attributes:

  The attributes to be added

- whichOutput:

  The index of the Output element

- namespace:

  The namespace of the PMML model

## Value

Output node with the OutputField elements inserted.

## Details

This function is meant to add any post-processing information to an
existing model via the OutputField element. One can also use this to
tell the PMML model to output other values not automatically added to
the model output. The first method is to use the 'make_output_nodes'
helper function to make a list of output elements to be added.
'whichOutput' lets the function know which of the Output elements we
want to work with; there may be more than one in a multiple model file.
One can then add those elements there, at the desired index given by the
'at' parameter; the elements are inserted after the OutputField element
at the 'at' index. In other words, find the 'whichOutput' Output
element, add the 'outputNodes' child elements (which should be
OutputField nodes) at the 'at' position in the child nodes. This
function can also be used with the 'nodeName' and 'attributes' to add
the list of attributes to an OutputField element with name 'nodeName'
element using the 'xml_model', 'outputNodes' and 'at' parameters.
Finally, one can use this to add the transformation expression given by
the 'xformText' parameter to the node with name 'nodeName'. The string
given via 'xformText' is converted to an XML expression similarly to the
function_to_pmml function. In other words, find the OutputField node
with the name 'nodeName' and add the list of attributes given with
'attributes' and also, add the child transformations given in the
'xformText' parameter.

## Author

Tridivesh Jena

## Examples

``` r
# Load the standard iris dataset
data(iris)

# Create a linear model and convert it to PMML
mod <- lm(Sepal.Length ~ ., iris)
pmod <- pmml(mod)

# Create additional output nodes
onodes0 <- make_output_nodes(
  name = list("OutputField", "OutputField"),
  attributes = list(list(
    name = "dbl",
    optype = "continuous"
  ), NULL),
  expression = list("ln(x)", "ln(x/(1-x))")
)
onodes2 <- make_output_nodes(
  name = list("OutputField", "OutputField"),
  attributes = list(
    list(
      name = "F1",
      dataType = "double", optype = "continuous"
    ),
    list(name = "F2")
  )
)

# Create new pmml objects with the output nodes appended
pmod2 <- add_output_field(
  xml_model = pmod, outputNodes = onodes2, at = "End",
  xformText = NULL, nodeName = NULL, attributes = NULL,
  whichOutput = 1
)
#> Warning: OutputField given, childNode and attributes ignored.
pmod2 <- add_output_field(
  xml_model = pmod, outputNodes = onodes0, at = "End",
  xformText = NULL, nodeName = NULL,
  attributes = NULL, whichOutput = 1
)
#> Warning: OutputField given, childNode and attributes ignored.

# Create nodes with attributes and transformations
pmod3 <- add_output_field(xml_model = pmod2, outputNodes = onodes2, at = 2)
#> Warning: OutputField given, childNode and attributes ignored.
pmod4 <- add_output_field(
  xml_model = pmod2, xformText = list("exp(x) && !x"),
  nodeName = "Predicted_Sepal.Length"
)
#> Warning: childNode will be added. outputNode and attributes will be ignored.

att <- list(datype = "dbl", optpe = "dsc")
pmod5 <- add_output_field(
  xml_model = pmod2, nodeName = "Predicted_Sepal.Length",
  attributes = att
)
#> Warning: attributes given, outputNode and childNode will be ignored
```

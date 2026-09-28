# Read in a file and parse it into an object of type XMLNode.

Read in a file and parse it into an object of type XMLNode.

## Usage

``` r
file_to_xml_node(file)
```

## Arguments

- file:

  The external file to be read in. This file can be any file in PMML
  format, regardless of the source or model type.

## Value

An object of class `XMLNode` as that defined by the XML package. This
represents the top level, or root node, of the XML document and is of
type PMML. It can be written to file with `saveXML`.

## Details

Read in an external file and convert it into an XMLNode to be used
subsequently by other R functions.

This format is the one that will be obtained when a model is constructed
in R and output in PMML format.

This function is mainly meant to be used to read in external files
instead of depending on models saved in R. As an example, the pmml
package requires as input an object of type XMLNode before its functions
can be applied. Function 'file_to_xml_node' can be used to read in an
existing PMML file, convert it to an XML node and then make it available
for use by any of the pmml functions.

## Author

Tridivesh Jena

## Examples

``` r
if (FALSE) { # \dontrun{
# Define some transformations:
iris_box <- xform_wrap(iris)
iris_box <- xform_z_score(iris_box, xform_info = "column1->d1")
iris_box <- xform_z_score(iris_box, xform_info = "column2->d2")

# Make a LocalTransformations element and save it to an external file:
pmml_trans <- pmml(NULL, transforms = iris_box)
write(toString(pmml_trans), file = "xform_iris.pmml")

# Later, we may need to read in the PMML model into R
# 'lt' below is now a XML Node, as opposed to a string:
lt <- file_to_xml_node("xform_iris.pmml")
} # }
```

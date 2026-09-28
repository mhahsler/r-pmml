# Add attribute values to an existing element in a given PMML file.

Add attribute values to an existing element in a given PMML file.

## Usage

``` r
add_attributes(
  xml_model = NULL,
  xpath = NULL,
  attributes = NULL,
  namespace = "4_4",
  ...
)
```

## Arguments

- xml_model:

  The PMML model in a XML node format. If the model is a text file, it
  should be converted to an XML node, for example, using the
  file_to_xml_node function.

- xpath:

  The XPath to the element to which the attributes are to be added.

- attributes:

  The attributes to be added to the data fields. The user should make
  sure that the attributes being added are allowed in the PMML schema.

- namespace:

  The namespace of the PMML model. This is frequently also the PMML
  version of the model.

- ...:

  Further arguments passed to or from other methods.

## Value

An object of class `XMLNode` as that defined by the XML package. This
represents the top level, or root node, of the XML document and is of
type PMML. It can be written to file with `saveXML`.

## Details

Add attributes to an arbitrary XML element. This is an experimental
function designed to be more general than the
'add_mining_field_attributes' and 'add_data_field_attributes' functions.

The attribute information can be provided as a vector. Multiple
attribute names and values can be passes as vector elements to enable
inserting multiple attributes. However, this function overwrites any
pre-existing attribute values, so it must be used with care. This
behavior is by design as this feature is meant to help an user add new
defined attribute values at different times. The XPath has to include
the namespace as shown in the examples.

## Author

Tridivesh Jena

## Examples

``` r
# Make a sample model:
fit <- lm(Sepal.Length ~ ., data = iris[, -5])
fit_pmml <- pmml(fit)

# Add arbitrary attributes to the 1st 'NumericPredictor' element. The
# attributes are for demostration only (they are not allowed under
# the PMML schema). The command assumes the default namespace.
fit_pmml_2 <- add_attributes(fit_pmml, "/p:PMML/descendant::p:NumericPredictor[1]",
  attributes = c(a = 1, b = "b")
)

# Add attributes to the NumericPredictor element which has
# 'Petal.Length' as the 'name' attribute:
fit_pmml_3 <- add_attributes(fit_pmml,
  "/p:PMML/descendant::p:NumericPredictor[@name='Petal.Length']",
  attributes = c(a = 1, b = "b")
)

# 3 NumericElements exist which have '1' as the 'exponent' attribute.
# Add new attributes to the 3rd one:
fit_pmml_4 <- add_attributes(fit_pmml,
  "/p:PMML/descendant::p:NumericPredictor[@exponent='1'][3]",
  attributes = c(a = 1, b = "b")
)

# Add attributes to the 1st element whose 'name' attribute contains
# 'Length':
fit_pmml_5 <- add_attributes(fit_pmml,
  "/p:PMML/descendant::p:NumericPredictor[contains(@name,'Length')]",
  attributes = c(a = 1, b = "b")
)
```

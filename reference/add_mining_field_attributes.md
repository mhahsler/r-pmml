# Add attribute values to an existing MiningField element in a given PMML file.

Add attribute values to an existing MiningField element in a given PMML
file.

## Usage

``` r
add_mining_field_attributes(
  xml_model = NULL,
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

- attributes:

  The attributes to be added to the mining fields. The user should make
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

The PMML format allows a MiningField element to have attributes
'usageType', 'missingValueReplacement' and 'invalidValueTreatment' which
although useful, may not always be present in a PMML model. This
function allows one to take an existing PMML file and add these
attributes to the MiningFields.

The attribute information should be provided as a dataframe; each row
corresponding to an attribute name and each column corresponding to a
variable name. This way one can add as many attributes to as many
variables as one wants in one step. On the other extreme, a one-by-one
data frame may be used to add one new attribute to one variable. This
function may be used multiple times to add new attribute values
step-by-step. This function overwrites any pre-existing attribute
values, so it must be used with care. However, this is by design as this
feature is meant to help an user defined new attribute values at
different times. For example, one may use this to impute missing values
in a model at different times.

## Author

Tridivesh Jena

## Examples

``` r
# Make a sample model
fit <- lm(Sepal.Length ~ ., data = iris[, -5])
fit_pmml <- pmml(fit)

# The resulting model has mining fields with no information
# besides fieldName, dataType and optype. This object is
# already an xml node (not an external text file), so there
# is no need to convert it to an xml node object.

# Create data frame with attribute information:
attributes <- data.frame(
  c("active", 1.1, "asIs"),
  c("active", 2.2, "asIs"),
  c("active", NA, "asMissing"),
  stringsAsFactors = TRUE
)
rownames(attributes) <- c(
  "usageType", "missingValueReplacement",
  "invalidValueTreatment"
)
colnames(attributes) <- c(
  "Sepal.Width", "Petal.Length",
  "Petal.Width"
)

# Although not needed in this first try, necessary to easily
# add new values later:
for (k in 1:ncol(attributes)) {
  attributes[[k]] <- as.character(attributes[[k]])
}

fit_pmml <- add_mining_field_attributes(fit_pmml, attributes, namespace = "4_4")
```

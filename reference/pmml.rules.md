# Generate the PMML representation for a rules or an itemset object from package arules.

Generate the PMML representation for a rules or an itemset object from
package arules.

## Usage

``` r
# S3 method for class 'rules'
pmml(
  model,
  model_name = "arules_Model",
  app_name = "R PMML Generator - Package pmml",
  description = "Association Rules Model",
  copyright = NULL,
  model_version = NULL,
  transforms = NULL,
  ...
)
```

## Arguments

- model:

  A rules or itemsets object.

- model_name:

  A name to be given to the PMML model.

- app_name:

  The name of the application that generated the PMML.

- description:

  A descriptive text for the Header element of the PMML.

- copyright:

  The copyright notice for the model.

- model_version:

  A string specifying the model version.

- transforms:

  Data transformations.

- ...:

  Further arguments passed to or from other methods.

## Value

PMML representation of the rules or itemsets object.

## Details

The model is represented in the PMML AssociationModel format.

## References

[arules: Mining Association Rules and Frequent
Itemsets](https://CRAN.R-project.org/package=arules)

## Author

Graham Williams, Michael Hahsler

## Examples

``` r
if (FALSE) { # \dontrun{

library(arules)
data(Adult)

rules <- apriori(Adult, support = 0.5, confidence = 0.9)

rules_pmml <- pmml(rules)
rules_pmml

} # }
```

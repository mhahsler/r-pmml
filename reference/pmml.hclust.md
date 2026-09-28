# Generate the PMML representation for a hclust object from the package amap.

Generate the PMML representation for a hclust object from the package
amap.

## Usage

``` r
# S3 method for class 'hclust'
pmml(
  model,
  model_name = "HClust_Model",
  app_name = "R PMML Generator - Package pmml",
  description = "Hierarchical Cluster Model",
  copyright = NULL,
  model_version = NULL,
  transforms = NULL,
  missing_value_replacement = NULL,
  centers,
  ...
)
```

## Arguments

- model:

  A hclust object.

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

- missing_value_replacement:

  Value to be used as the 'missingValueReplacement' attribute for all
  MiningFields.

- centers:

  A list of means to represent the clusters.

- ...:

  Further arguments passed to or from other methods.

## Value

PMML representation of the hclust object.

## Details

This function converts a hclust object created by the `hclusterpar`
function from the amap package. A `hclust` object is a cluster model
created hierarchically. The data is divided recursively until a criteria
is met. This function then takes the final model and represents it as a
standard k-means cluster model. This is possible since while the method
of constructing the model is different, the final model can be
represented in the same way.

To use this pmml function, therefore, one must pick the number of
clusters desired and the coordinate values at those cluster centers.
This can be done using the `hclusterpar` and `centers.hclust` functions
from the amap and `rattle` packages respectively.

The hclust object will be approximated by `k` centroids and is converted
into a PMML representation for kmeans clusters.

## References

[R project: Hierarchical
Clustering](http://stat.ethz.ch/R-manual/R-devel/library/stats/html/hclust.md)

## Author

Graham Williams

## Examples

``` r
if (FALSE) { # \dontrun{

# Cluster the 4 numeric variables of the iris dataset.
library(amap)
library(rattle)

model <- hclusterpar(iris[, -5])

# Get the information about the cluster centers. The last
# parameter of the function used is the number of clusters
# desired.
centerInfo <- centers.hclust(iris[, -5], model, 3)

# Convert to pmml
model_pmml <- pmml(model, centers = centerInfo)
} # }
```

# Generate the PMML representation for a kmeans object from the package stats.

The kmeans object (a cluster described by k centroids) is converted into
a PMML representation.

## Usage

``` r
# S3 method for class 'kmeans'
pmml(
  model,
  model_name = "KMeans_Model",
  app_name = "R PMML Generator - Package pmml",
  description = "KMeans cluster model",
  copyright = NULL,
  model_version = NULL,
  transforms = NULL,
  missing_value_replacement = NULL,
  algorithm_name = "KMeans: Hartigan and Wong",
  ...
)
```

## Arguments

- model:

  A kmeans object.

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

- algorithm_name:

  The variety of kmeans used.

- ...:

  Further arguments passed to or from other methods.

## Details

A kmeans object is obtained by applying the `kmeans` function from the
`stats` package. This method typically requires the user to normalize
all the variables; these operations can be done using transforms so that
the normalization information is included in PMML.

## References

[R project: K-Means
Clustering](http://stat.ethz.ch/R-manual/R-devel/library/stats/html/kmeans.md)

## Author

Graham Williams

## Examples

``` r
if (FALSE) { # \dontrun{
ds <- rbind(
  matrix(rnorm(100, sd = 0.3), ncol = 2),
  matrix(rnorm(100, mean = 1, sd = 0.3), ncol = 2)
)
colnames(ds) <- c("Dimension1", "Dimension2")
cl <- kmeans(ds, 2)
cl_pmml <- pmml(cl)
} # }
```

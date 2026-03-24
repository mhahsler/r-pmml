
<!-- README.md is generated from README.Rmd. Please edit that file -->

# <img src="man/figures/logo.png" align="right" height="139" /> R package pmml - Generate PMML for Various Models

[![Package on
CRAN](https://www.r-pkg.org/badges/version/pmml)](https://CRAN.R-project.org/package=pmml)
[![CRAN RStudio mirror
downloads](https://cranlogs.r-pkg.org/badges/pmml)](https://CRAN.R-project.org/package=pmml)
![License](https://img.shields.io/cran/l/pmml) [![r-universe
status](https://mhahsler.r-universe.dev/badges/pmml)](https://mhahsler.r-universe.dev/pmml)

## Overview

Export various machine learning and statistical models to PMML and
generate data transformations in PMML format.

Supported models include:

- Anomaly Detection
- Association Rules
- Clustering
- K Nearest Neighbors
- Linear Models
- Naive Bayes Classifiers
- Neural Networks
- Support Vector Machines
- Time Series
- Tree-based Models and Ensembles
- Survival analysis models

For a description of the supported packages, see the vignette:
[Supported Packages and Additional
Functions](https://mhahsler.github.io/r-pmml/articles/packages_and_functions.html).

## Installation

**Stable CRAN version:** Install from within R with

``` r
install.packages("pmml")
```

**Current development version:** Install from
[r-universe.](https://mhahsler.r-universe.dev/pmml)

``` r
install.packages("pmml",
    repos = c("https://mhahsler.r-universe.dev",
              "https://cloud.r-project.org/"))
```

## Example

``` r
library(pmml)

# Build an lm model
iris_lm <- lm(Sepal.Length ~ ., data = iris)

# Convert to pmml
iris_lm_pmml <- pmml(iris_lm)

iris_lm_pmml
#> <PMML version="4.4.1" xmlns="http://www.dmg.org/PMML-4_4" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.dmg.org/PMML-4_4 http://www.dmg.org/pmml/v4-4/pmml-4-4.xsd">
#>  <Header copyright="Copyright (c) 2026 mhahsler" description="Linear Regression Model">
#>   <Extension name="user" value="mhahsler" extender="SoftwareAG PMML Generator"/>
#>   <Application name="SoftwareAG PMML Generator" version="2.5.2.1"/>
#>   <Timestamp>2026-03-24 18:13:48.550694</Timestamp>
#>  </Header>
#>  <DataDictionary numberOfFields="5">
#>   <DataField name="Sepal.Length" optype="continuous" dataType="double"/>
#>   <DataField name="Sepal.Width" optype="continuous" dataType="double"/>
#>   <DataField name="Petal.Length" optype="continuous" dataType="double"/>
#>   <DataField name="Petal.Width" optype="continuous" dataType="double"/>
#>   <DataField name="Species" optype="categorical" dataType="string">
#>    <Value value="setosa"/>
#>    <Value value="versicolor"/>
#>    <Value value="virginica"/>
#>   </DataField>
#>  </DataDictionary>
#>  <RegressionModel modelName="lm_Model" functionName="regression" algorithmName="least squares">
#>   <MiningSchema>
#>    <MiningField name="Sepal.Length" usageType="predicted" invalidValueTreatment="returnInvalid"/>
#>    <MiningField name="Sepal.Width" usageType="active" invalidValueTreatment="returnInvalid"/>
#>    <MiningField name="Petal.Length" usageType="active" invalidValueTreatment="returnInvalid"/>
#>    <MiningField name="Petal.Width" usageType="active" invalidValueTreatment="returnInvalid"/>
#>    <MiningField name="Species" usageType="active" invalidValueTreatment="returnInvalid"/>
#>   </MiningSchema>
#>   <Output>
#>    <OutputField name="Predicted_Sepal.Length" optype="continuous" dataType="double" feature="predictedValue"/>
#>   </Output>
#>   <RegressionTable intercept="2.17126629215507">
#>    <NumericPredictor name="Sepal.Width" exponent="1" coefficient="0.495888938388551"/>
#>    <NumericPredictor name="Petal.Length" exponent="1" coefficient="0.829243912234806"/>
#>    <NumericPredictor name="Petal.Width" exponent="1" coefficient="-0.315155173326473"/>
#>    <CategoricalPredictor name="Species" value="setosa" coefficient="0"/>
#>    <CategoricalPredictor name="Species" value="versicolor" coefficient="-0.72356195778073"/>
#>    <CategoricalPredictor name="Species" value="virginica" coefficient="-1.02349781449083"/>
#>   </RegressionTable>
#>  </RegressionModel>
#> </PMML>

# Write to file: save_pmml(iris_lm_pmml,'iris_lm.pmml')
```

## Contributions

Please note that this project is released with a [Contributor Code of
Conduct](https://mhahsler.github.io/r-pmml/blob/master/.github/CODE_OF_CONDUCT.md).
By contributing to this project, you agree to abide by its terms.

## References

- [DMG PMML 4.4.1
  specification](http://dmg.org/pmml/v4-4-1/GeneralStructure.html)

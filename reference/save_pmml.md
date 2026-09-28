# Save a pmml object as an external PMML file.

Save a pmml object to an external PMML file.

## Usage

``` r
save_pmml(doc, name)
```

## Arguments

- doc:

  The pmml model.

- name:

  The name of the external file where the PMML is to be saved.

## Author

Tridivesh Jena

## Examples

``` r
if (FALSE) { # \dontrun{
# Make a gbm model:
library(gbm)
data(audit)

mod <- gbm(Adjusted ~ .,
  data = audit[, -c(1, 4, 6, 9, 10, 11, 12)],
  n.trees = 3,
  interaction.depth = 4
)

# Export to PMML:
pmod <- pmml(mod)

# Save to an external file:
save_pmml(pmod, "GBMModel.pmml")
} # }
```

# Audit: artificially constructed dataset

This is an artificial dataset consisting of fictional clients who have
been audited, perhaps for tax refund compliance. For each case an
outcome is recorded (whether the taxpayer's claims had to be adjusted or
not) and any amount of adjustment that resulted is also recorded.

## Format

A data frame containing:

|            |                                   |
|------------|-----------------------------------|
| Age        | Numeric                           |
| Employment | Categorical string with 7 levels  |
| Education  | Categorical string with 16 levels |
| Marital    | Categorical string with 6 levels  |
| Occupation | Categorical string with 14 levels |
| Income     | Numeric                           |
| Sex        | Categorical string with 2 levels  |
| Deductions | Numeric                           |
| Hours      | Numeric                           |
| Accounts   | Categorical string with 32 levels |
| Adjustment | Numeric                           |
| Adjusted   | Numeric value 0 or 1              |

## References

- Togaware rattle package : ***Audit dataset***  

- [DMG description of the Audit
  dataset](https://dmg.org/pmml_examples/index.html)

## Examples

``` r
data(audit, package = "pmml")
```

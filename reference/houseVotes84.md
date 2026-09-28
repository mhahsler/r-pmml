# Modified 1984 United States Congressional Voting Records Database

This data set includes votes for each of the U.S. House of
Representatives Congressmen on the 16 key votes identified by the CQA.
The CQA lists nine different types of votes: voted for, paired for, and
announced for (these three simplified to yea), voted against, paired
against, and announced against (these three simplified to nay), voted
present, voted present to avoid conflict of interest, and did not vote
or otherwise make a position known (these three simplified to an unknown
disposition). Originally containing a binomial variable "class" and 16
other binary variables, those 16 variables have been renamed to simply
"V1","V2",...,"V16".

## Format

A data frame containing:

|       |                  |
|-------|------------------|
| Class | Boolean variable |
| V1    | Boolean variable |
| V2    | Boolean variable |
| V3    | Boolean variable |
| V4    | Boolean variable |
| V5    | Boolean variable |
| V6    | Boolean variable |
| V7    | Boolean variable |
| V8    | Boolean variable |
| V9    | Boolean variable |
| V10   | Boolean variable |
| V11   | Boolean variable |
| V12   | Boolean variable |
| V13   | Boolean variable |
| V14   | Boolean variable |
| V15   | Boolean variable |
| V16   | Boolean variable |

## References

[UCI Machine Learning
Repository](http://archive.ics.uci.edu/ml/datasets/Congressional+Voting+Records)

## Examples

``` r
data(houseVotes84, package = "pmml")
```


<!-- README.md is generated from README.Rmd. Please edit that file -->

# CopyCat <img src="man/figures/sticker.png" align="right" width="250/"/>

<!-- badges: start -->
<!-- badges: end -->

CopyCat is a simple package to handle your own code snippets in R. Save
your code snippets as a data frame, CopyCat searches your data base and
copies the code to the clipboard.

## Installation

Install CopyCat from my github account with:

``` r
# install.packages("devtools")
devtools::install_github("edgar-treischl/CopyCat")
```

## Example

This is a basic example to show you how CopyCat searches within a data
frame for the code snippet you are looking for. For illustration
purposes, CopyCat comes with a tiny data set and some basic code
snippets.

``` r
## load library and provide a data frame 
library(copycat)
df <- copycat::df
head(df)
#> # A tibble: 6 x 3
#>   package    fct        code                                                    
#>   <chr>      <chr>      <chr>                                                   
#> 1 base       logit      "glm(am ~ mpg, family = binomial(link = 'logit'), data …
#> 2 base       lm         "lm(mpg ~ wt + cyl, data = mtcars)"                     
#> 3 tidyr      pivot_lon… "relig_income %>% pivot_longer(!religion, names_to = 'i…
#> 4 pwr        pwr_t_test "pwr.t.test(d=0.1, sig.level=0.05, power=NULL, n=32,typ…
#> 5 base       factor     "factor(var, levels = c(0, 1), labels = c(\"0\", \"1\")"
#> 6 dotwhisker dwplot     "dwplot(lm(mpg ~ wt + cyl, data = mtcars), vline = geom…
```

Let’s say you cannot remember how `pivot_longer` from the `tidyr`
package works. A code snippet is saved in `copycat::df` and
`copycat_code` just returns the code snippet.

``` r
## returns a code snippet
copycat_code("pivot_longer", df)
#> [1] "Your code my friend:"
#> relig_income %>% pivot_longer(!religion, names_to = 'income', values_to = 'count')
```

To work with your code snippets, `copy_that` saves the code to your
clipboard.

``` r
# saves the returned code to the clipboad
copy_that("pivot_longer", df)
#> [1] "You are ready to paste!"
```

If the code is based on implemented data – as the example here – you can
see how it works by pasting it into your console.

``` r
relig_income %>% 
  pivot_longer(!religion, names_to = 'income', values_to = 'count')
#> # A tibble: 180 x 3
#>    religion income             count
#>    <chr>    <chr>              <dbl>
#>  1 Agnostic <$10k                 27
#>  2 Agnostic $10-20k               34
#>  3 Agnostic $20-30k               60
#>  4 Agnostic $30-40k               81
#>  5 Agnostic $40-50k               76
#>  6 Agnostic $50-75k              137
#>  7 Agnostic $75-100k             122
#>  8 Agnostic $100-150k            109
#>  9 Agnostic >150k                 84
#> 10 Agnostic Don't know/refused    96
#> # … with 170 more rows
```

Ultimately, `copycat_package` returns the name of package in case you
cannot remember the name of the package anymore.

``` r
#search for a package name 
copycat_package("pivot_longer", df)
#> [1] "The package name:"
#> tidyr
```

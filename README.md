
<!-- README.md is generated from README.Rmd. Please edit that file -->

# CopyCat <img src="man/figures/sticker.png" align="right" width="200" alt="Copy Cat - Edgar Treischl"/>

<!-- badges: start -->

[![R-CMD-check](https://github.com/edgar-treischl/CopyCat/workflows/R-CMD-check/badge.svg)](https://github.com/edgar-treischl/CopyCat/actions)
<!-- badges: end -->

CopyCat is a small and personal package to copy, paste, and view code
snippets. All provided code snippets are minimal examples based on code
that runs with implemented data, which helps R learner to see how the
code works. CopyCat uses three different code sources. First, CopyCat
comes with a small data frame that includes code snippets from the cheat
sheets of the `ggplot2` and the `tidyr` package. Of course, you can use
your own code snippets as a data source as well. Second, CopyCat can
fetch and copy code that lives on Github. Ultimately, CopyCat searches
also within the R help files and vignettes for code that illustrates how
a function works. Thus, CopyCat was built as a personal package for the
lazy cats, but it will also help new R learner to manage code snippets.

## Installation

Install CopyCat from my github account with:

``` r
devtools::install_github("edgar-treischl/CopyCat",
                         build_vignettes = TRUE)
```

## Example snippets

I do not know how many times I have searched within my old scripts,
especially for a `ggplot` command that I have been used many times, but
I have forgotten the details. For this reason I started to create this
package. CopyCat comes with a small data set (`CopyCatCode`) that
contains minimal examples of several cheat sheets that run without
further ado. For example, let’s have a look at the minimal examples of
the ggplot2 package. The `CopyCatCode` data provides the package name,
the function, and the code of the minimal example:

``` r
## load library and provide a data frame 
library(copycat)

CopyCatCode %>% 
  filter(package == "ggplot2") %>% 
  arrange(fct)
#> # A tibble: 46 × 3
#>    package fct          code                                                    
#>    <chr>   <chr>        <chr>                                                   
#>  1 ggplot2 annotate     "ggplot(mtcars, aes(x=mpg)) +   \r\n  geom_histogram(co…
#>  2 ggplot2 facet_grid   "ggplot(mtcars, aes(hp, mpg)) + \r\n  geom_blank() + \r…
#>  3 ggplot2 facet_wrap   "ggplot(mtcars, aes(hp, mpg)) + \r\n  geom_blank() + \r…
#>  4 ggplot2 geom_abline  "ggplot(mpg, aes(cty, hwy))+\r\n  geom_point()+\r\n  ge…
#>  5 ggplot2 geom_area    "ggplot(mpg, aes(hwy))+\r\n  geom_area(stat = \"bin\")" 
#>  6 ggplot2 geom_bar     "ggplot(data=mpg, aes(x=class)) + geom_bar()"           
#>  7 ggplot2 geom_bin2d   "ggplot(diamonds, aes(carat, price))+ geom_bin2d(binwid…
#>  8 ggplot2 geom_boxplot "ggplot(diamonds, aes(x=color, y=carat, fill=color)) +\…
#>  9 ggplot2 geom_col     "ggplot(diamonds, aes(x=color, y=carat)) +\r\n  geom_co…
#> 10 ggplot2 geom_contour "ggplot(faithfuld, aes(waiting, eruptions, z = density)…
#> # … with 36 more rows
```

Let’s say you cannot remember how `pivot_longer` from the `tidyr`
package works. Just search for the corresponding code snippet via the
`copycat()` function, it searches for the code snippet and saves the
returned code to your clipboard. To see which code is returned, use the
corresponding `copycat_code()` function.

``` r
# copycat("pivot_longer") saves the returned code to the clipboad
#>[1] "🐈 Your code: relig_income %>% tidyr::pivot_longer(!religion, names_to = #>'income', values_to = 'count')"
# copycat_code() let us inspect what the function returned 
copycat_code("pivot_longer")
#> [1] "🐈 Your code: relig_income %>% tidyr::pivot_longer(!religion, names_to = 'income', values_to = 'count')"
```

Since the code is based on implemented data – as all examples listed in
CopyCat – you can see how it works just by pasting it into your console.
Alternatively, set the `run` option to `TRUE` and `copycat()` sends the
code to your console.

``` r
copycat("pivot_longer", run = T )
```

``` r
relig_income %>% 
  pivot_longer(!religion, names_to = 'income', values_to = 'count')
#> # A tibble: 180 × 3
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

Of course, the minimal examples will only run if the package has been
loaded and most of the time we know the package name. However, sometimes
we have to look up the package name if we do not use a function often.
The `copycat_package()` function returns the corresponding package name
and sends the code `library(...)` directly to your console. The
`copycat_package()` function copies the code also to the clipboard,
since you want to insert it into your script as well.

``` r
#search for a package name, copies the load and loads the library
copycat_package("pivot_longer")
#>[1] [1] "🐈 Mission accomplished, loaded and copied library: tidyr"
```

If you add typos by accident, if you are not sure whether the function
is written in small or large caps, you might be lucky and a similar
match is found in the data.

``` r
#typos and other mistakes 
copycat_package("bivot")
#> [1] "Did you mean pivot_longer from the tidyr package?"
#> [2] "Did you mean pivot_wider from the tidyr package?"
```

Unfortunately, this only works if a match is found at all.

``` r
copycat("bivatasa")
#>[1] "💩 Sooorry, I've got no idea what you are looking for!"
```

See the vignette for further examples how to use CopyCat for with
github, help and other vignette files.

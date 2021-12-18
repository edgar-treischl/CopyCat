
<!-- README.md is generated from README.Rmd. Please edit that file -->

# CopyCat <img src="man/figures/sticker.png" align="right" width="250/"/>

<!-- badges: start -->
<!-- badges: end -->

CopyCat is a simple package to handle (your own) code snippets and it
includes code snippets of the `ggplot2` and the `tidyr` package. It
provides minimal examples from the cheat sheets that can be executed
without further ado. Furthermore, you can also save your own code
snippets as an additional data source, CopyCat searches within your data
base and copies the code to the clipboard.

## Installation

Install CopyCat from my github account with:

``` r
# install.packages("devtools")
devtools::install_github("edgar-treischl/CopyCat")
```

## Example

I started to create this package because I do not know how many times I
searched within my old scripts, especially for some `ggplot` commands
that I have been applied in the past, but I have forgotten the details.
For this reason, CopyCat comes with a small data set (`CopyCatCode`)
that contains minimal examples of several cheat sheets. For example,
let’s have a look at the minimal examples of the ggplot2 package. The
`CopyCatCode` data provides the package name, the function, and the code
of the minimal example:

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
`copycat` function, it searches for the code snippet and saves the
returned code to your clipboard.

``` r
# saves the returned code to the clipboad
copycat_code("pivot_longer")
#> [1] "🐈 Your code: relig_income %>% tidyr::pivot_longer(!religion, names_to = 'income', values_to = 'count')"
```

Since the code is based on implemented data – as all examples listed in
CopyCat – you can see how it works just by pasting it into your console.

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
loaded. The `copycat_package()` function returns the code to load the
corresponding package and saves it into your clipboard, just in case you
cannot remember the name of the package anymore.

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
copycat_package("bivot_longer")
#> [1] "Did you mean pivot_longer from the tidyr package?"
```

Unfortunately, this only works if a match is found at all.

``` r
copycat("bivat")
#>[1] "💩 Sooorry, I've got no idea what you are looking for!"
```

CopyCat can also be connected to your Github repository to copy the
entire code of your old scripts. First, you have to setup the Github
account details, that CopyCat will search for you.

``` r
git_setup <- c(author = "edgar-treischl",
               repository = "Illustrations",
               branch = "master")
```

The `copycat_gitsearch()` function uses the Github API to search within
your repository and returns all R scripts.

``` r
copycat_gitsearch()
#> # A tibble: 3 × 1
#>   git_scripts             
#>   <chr>                   
#> 1 R/Simpsons_Paradox.R    
#> 2 R/boxplot_illustration.R
#> 3 R/boxplot_pitfalls.R
```

The `copycat_git()` function copies your file to your clipboard.

``` r
copycat_git("boxplot_illustration")
#>[1] "🐈 Mission accomplished!"
```

CopyCat started as a personal package, but feel free to use it for your
own data and code snippets. Just add your data frame with the same
variable names and CopyCat handles your own snippets.

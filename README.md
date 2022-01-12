
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
# install.packages("devtools")
devtools::install_github("edgar-treischl/CopyCat")
```

## Copycat Examples

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

## Github

CopyCat can also be connected to your Github repository to copy one of
your old scripts. First, you have to setup the Github account details,
that CopyCat will search. Provide the name of the author, the
repository, and the branch name.

``` r
git_setup <- c(author = "edgar-treischl",
               repository = "Illustrations",
               branch = "master")
```

The `copycat_gitsearch()` function uses the Github API to search within
your repository and returns all R scripts that live within the
repository

``` r
copycat_gitsearch()
#> # A tibble: 5 × 1
#>   git_scripts             
#>   <chr>                   
#> 1 R/Simpsons_Paradox.R    
#> 2 R/anscombe_quartet.R    
#> 3 R/boxplot_illustration.R
#> 4 R/boxplot_pitfalls.R    
#> 5 R/datasaurus.R
```

The `copycat_git()` function copies the code to your clipboard.

``` r
copycat_git("boxplot_illustration")
#>[1] "🐈 Mission accomplished!"
```

## Help files and vignettes

Often, all we need is code that runs to see how a functions work. For
this reason, CopyCat to search within the R help files and vignettes,
but returns only only the code listed in the vignette or the examples of
the help file. The `copycat_helpsearch()` function list all help files
of a package:

``` r
copycat_helpsearch("tidyr")
#>  [1] "billboard"         "chop"              "complete"         
#>  [4] "construction"      "deprecated-se"     "drop_na"          
#>  [7] "expand"            "expand_grid"       "extract"          
#> [10] "extract_numeric"   "fill"              "fish_encounters"  
#> [13] "full_seq"          "gather"            "hoist"            
#> [16] "nest"              "nest_legacy"       "pack"             
#> [19] "pipe"              "pivot_longer"      "pivot_longer_spec"
#> [22] "pivot_wider"       "pivot_wider_spec"  "reexports"        
#> [25] "relig_income"      "replace_na"        "separate"         
#> [28] "separate_rows"     "smiths"            "spread"           
#> [31] "table1"            "tidyr-package"     "tidyr_legacy"     
#> [34] "tidyr_tidy_select" "uncount"           "unite"            
#> [37] "us_rent_income"    "who"               "world_bank_pop"
```

And the `copycat_help()` function copies the examples section of a help
file into your clipboard. Again, to see what we have actually copied,
the corresponding `copycat_helpcode` function return only the code.

``` r
#copycat_help() saves examples of the help files into your clipboard
#copycat_help("tidyr", "drop_na")
copycat_helpcode("tidyr", "drop_na")
#> [1] "#Extracted examples:"                                       
#> [2] "     library(dplyr)"                                        
#> [3] "     df <- tibble(x = c(1, 2, NA), y = c(\"a\", NA, \"b\"))"
#> [4] "     df %>% drop_na()"                                      
#> [5] "     df %>% drop_na(x)"                                     
#> [6] "     "                                                      
#> [7] "     vars <- \"y\""                                         
#> [8] "     df %>% drop_na(x, any_of(vars))"                       
#> [9] "     "
```

The same function exist to search for and copy code from vignettes. The
`copycat_vigsearch()` returns all availabe vignettes.

``` r
copycat_vigsearch("tidyr")
#> [1] "nest.R"        "pivot.R"       "programming.R" "rectangle.R"  
#> [5] "tidy-data.R"   "in-packages.R"
```

And `copycat_vignette()` copies the entire script.

``` r
copycat_vignette("tidyr", "pivot")
#> "😎 copied that!"
```

To copy smaller code chunks to your clipboard is fine. Helpfiles and
especially vignettes are much longer. Therefore, we have to create a new
file and paste the code into your file. The `copycat_helpscript()`create
a new script with the examples of the help file, while
`copycat_vigscript()` does the same with the code from the vignette.

``` r
copycat_helpscript("tidyr", "pivot")
copycat_vigscript("tidyr", "pivot")
```

CopyCat has started as a personal package. Feel free to use it or manage
your own code snippets with it. Just add your data frame with the same
variable names of the small example data (`CopyCatCode`) and CopyCat
handles your own snippets.

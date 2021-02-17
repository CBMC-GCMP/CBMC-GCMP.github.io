---
title: "Updating Mean Trophic levels of a genera from FishBase"
output:
  md_document:
    variant: gfm
    preserve_yaml: TRUE
knit: (function(inputFile, encoding) {
  rmarkdown::render(inputFile, encoding = encoding, output_dir = "../_posts") })
author: "Fabio"
date: "16 February, 2021"
excerpt: "Updating Mean Trophic levels of a genera from FishBase"
layout: post
categories:
  - R Markdown
  - Jekyll

---

# Calculating Mean Trophic Leves of a genera from FishBase

I recently had the necessity to update the Trophic Levels on our Rocky
Reefs Monitoring database. Thus, i wondered if an automatic way to
access FishBase existed. It obviously does exist in the magnificent
package [rfishbase](https://github.com/ropensci/rfishbase).

I then searched for an easy tutorial on how to calculate mean Trophic
Levels in `r`, and i found this [“blog
post”](https://www.r-bloggers.com/2017/03/mean-trophic-levels-of-a-genera-from-fishbase/).
The blog post gave me a great head start. However, it is not currently
fully reproducible, so I decided to update the code. Also, I added the
possibility to add `a`and `b` parameters used to calculate fish biomass.

------------------------------------------------------------------------

Let’s begin! First let’s install the rfishbase package and loading it in
`r`

``` r
# install.packages("rfishbase")

library("rfishbase") # R Interface to 'FishBase'
```

I also load the `tidyverse` package wrapple to wrangle the datasets.

``` r
library(tidyverse) # Easily Load the 'Tidyverse', CRAN v1.3.0 
```

Following the same workflow from the post, I will find Trophic Levels of
all groupers (Serranidae) in the `fishbase` database.

``` r
groupers <- fishbase %>%
      filter(Family == "Serranidae") %>%
      mutate(gensp = paste(Genus, Species))

glimpse(groupers)
```

    ## Rows: 537
    ## Columns: 13
    ## $ SpecCode     <int> 351, 12690, 59850, 65330, 15036, 15038, 50141, 15040, ...
    ## $ Genus        <chr> "Acanthistius", "Acanthistius", "Acanthistius", "Acant...
    ## $ Species      <chr> "brasilianus", "cinctus", "fuscus", "joanae", "ocellat...
    ## $ SpeciesRefNo <int> 7392, 5755, 40817, 83528, 7300, 7300, 27363, 7300, 906...
    ## $ FBname       <chr> "Argentine seabass", "Yellowbanded perch", "Rapanui se...
    ## $ SubFamily    <chr> "Anthiinae", "Anthiinae", "Anthiinae", "Anthiinae", "A...
    ## $ FamCode      <int> 289, 289, 289, 289, 289, 289, 289, 289, 289, 289, 289,...
    ## $ GenCode      <int> 1020, 1020, 1020, 1020, 1020, 1020, 1020, 1020, 1020, ...
    ## $ SubGenCode   <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA...
    ## $ Family       <chr> "Serranidae", "Serranidae", "Serranidae", "Serranidae"...
    ## $ Order        <chr> "Perciformes", "Perciformes", "Perciformes", "Percifor...
    ## $ Class        <chr> "Actinopterygii", "Actinopterygii", "Actinopterygii", ...
    ## $ gensp        <chr> "Acanthistius brasilianus", "Acanthistius cinctus", "A...

The next step is to extract the information about the Trophic Levels for
each species, it is now where the difference from the previous blog
occurs. In the newest version of the `ecology` function you need to
specify **also** the `Species` name column. We will need this to merge
the dataset with the groupers species list dataframe.

``` r
groupers_TL <- ecology(groupers$gensp, fields = c("Species", "DietTroph"))

glimpse(groupers_TL)
```

    ## Rows: 537
    ## Columns: 2
    ## $ Species   <chr> "Acanthistius brasilianus", "Acanthistius cinctus", "Acan...
    ## $ DietTroph <dbl> NA, NA, NA, NA, NA, NA, NA, NA, 4.23, NA, NA, NA, 3.58, N...

As a bonus I also add another trait to the database to get `a` and `b`
parameters to calculate species biomass if needed. Insead of searching
in the `ecology` table of `rfishbase` we use the `length_weight()`
function to access length trait data.

``` r
ab <- length_weight(groupers$gensp, fields = c("Species", "a", "b"))

glimpse(ab)
```

    ## Rows: 820
    ## Columns: 3
    ## $ Species <chr> "Acanthistius brasilianus", "Acanthistius cinctus", "Acanth...
    ## $ a       <dbl> NA, NA, NA, NA, NA, NA, NA, NA, 0.10380, NA, NA, 0.02990, N...
    ## $ b       <dbl> NA, NA, NA, NA, NA, NA, NA, NA, 2.49700, NA, NA, 3.00000, N...

We’re almost there! We now merge the all parameters, the Trophic Levels,
a and b into a `grouper_traits` data frame using the `merge()` function
from the `tidyverse`.

``` r
groupers_traits <- merge(groupers_TL, ab)

glimpse(groupers_traits)
```

    ## Rows: 820
    ## Columns: 4
    ## $ Species   <chr> "Acanthistius brasilianus", "Acanthistius cinctus", "Acan...
    ## $ DietTroph <dbl> NA, NA, NA, NA, NA, NA, NA, NA, 4.23, NA, NA, NA, 3.58, N...
    ## $ a         <dbl> NA, NA, NA, NA, NA, NA, NA, NA, 0.10380, NA, NA, 0.02990,...
    ## $ b         <dbl> NA, NA, NA, NA, NA, NA, NA, NA, 2.49700, NA, NA, 3.00000,...

We then merge the traits with the groupers species list. Note that since
full species scientific notation is stored in different column names in
the two data.frames, we need to specify the `by.x` and `by.y` parameters
in the merge function.

``` r
d2 <- merge(groupers, groupers_traits, by.x = "gensp", by.y = "Species")

glimpse(d2)
```

    ## Rows: 820
    ## Columns: 16
    ## $ gensp        <chr> "Acanthistius brasilianus", "Acanthistius cinctus", "A...
    ## $ SpecCode     <int> 351, 12690, 59850, 65330, 15036, 15038, 50141, 15040, ...
    ## $ Genus        <chr> "Acanthistius", "Acanthistius", "Acanthistius", "Acant...
    ## $ Species      <chr> "brasilianus", "cinctus", "fuscus", "joanae", "ocellat...
    ## $ SpeciesRefNo <int> 7392, 5755, 40817, 83528, 7300, 7300, 27363, 7300, 906...
    ## $ FBname       <chr> "Argentine seabass", "Yellowbanded perch", "Rapanui se...
    ## $ SubFamily    <chr> "Anthiinae", "Anthiinae", "Anthiinae", "Anthiinae", "A...
    ## $ FamCode      <int> 289, 289, 289, 289, 289, 289, 289, 289, 289, 289, 289,...
    ## $ GenCode      <int> 1020, 1020, 1020, 1020, 1020, 1020, 1020, 1020, 1020, ...
    ## $ SubGenCode   <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA...
    ## $ Family       <chr> "Serranidae", "Serranidae", "Serranidae", "Serranidae"...
    ## $ Order        <chr> "Perciformes", "Perciformes", "Perciformes", "Percifor...
    ## $ Class        <chr> "Actinopterygii", "Actinopterygii", "Actinopterygii", ...
    ## $ DietTroph    <dbl> NA, NA, NA, NA, NA, NA, NA, NA, 4.23, NA, NA, NA, 3.58...
    ## $ a            <dbl> NA, NA, NA, NA, NA, NA, NA, NA, 0.10380, NA, NA, 0.029...
    ## $ b            <dbl> NA, NA, NA, NA, NA, NA, NA, NA, 2.49700, NA, NA, 3.000...

Last step! We want `R` to get the traits when available, and use the
average of the genus when not available. We will achieve this using the
`ifelse()` function in the `mutate()` step below. This will add the
needed columns of `trophic_levels`, `a`, and `b`parameters.

``` r
d3 <- d2 %>%
      group_by(Genus) %>%
      mutate(
            mntroph = mean(DietTroph, na.rm = T),
            a_mean = mean(a, na.rm = T),
            b_mean = mean(b, na.rm = T)
      ) %>%
      ungroup() %>%
      mutate(
            trophall = ifelse(is.na(DietTroph), mntroph, DietTroph),
            a_all = ifelse(is.na(a), a_mean, a),
            b_all = ifelse(is.na(b), b_mean, b)
      ) %>%
      select(Species = gensp, Family, Order, Class,
             a = a_all, b = b_all, trophic_level = trophall)

glimpse(d3)
```

    ## Rows: 820
    ## Columns: 7
    ## $ Species       <chr> "Acanthistius brasilianus", "Acanthistius cinctus", "...
    ## $ Family        <chr> "Serranidae", "Serranidae", "Serranidae", "Serranidae...
    ## $ Order         <chr> "Perciformes", "Perciformes", "Perciformes", "Percifo...
    ## $ Class         <chr> "Actinopterygii", "Actinopterygii", "Actinopterygii",...
    ## $ a             <dbl> 0.10380, 0.10380, 0.10380, 0.10380, 0.10380, 0.10380,...
    ## $ b             <dbl> 2.49700, 2.49700, 2.49700, 2.49700, 2.49700, 2.49700,...
    ## $ trophic_level <dbl> 4.23, 4.23, 4.23, 4.23, 4.23, 4.23, 4.23, 4.23, 4.23,...

Let’s check the data from *Mycteroperca* genus.

``` r
d3 %>% 
        filter(str_detect(Species, "Mycteroperca")) %>% 
        select(Species, a, b, trophic_level)
```

    ## # A tibble: 34 x 4
    ##    Species                         a     b trophic_level
    ##    <chr>                       <dbl> <dbl>         <dbl>
    ##  1 Mycteroperca acutirostris 0.00772  3             4.34
    ##  2 Mycteroperca acutirostris 0.013    3.03          4.34
    ##  3 Mycteroperca bonaci       0.00684  3.20          4.3 
    ##  4 Mycteroperca bonaci       0.0069   3.15          4.3 
    ##  5 Mycteroperca bonaci       0.00822  3.14          4.3 
    ##  6 Mycteroperca bonaci       0.0113   3.05          4.3 
    ##  7 Mycteroperca bonaci       0.0223   3.11          4.3 
    ##  8 Mycteroperca bonaci       0.146    2.55          4.3 
    ##  9 Mycteroperca cidi         0.0173   3.04          4.34
    ## 10 Mycteroperca fusca        0.00941  3             4.34
    ## # ... with 24 more rows

All done! Good fishing!

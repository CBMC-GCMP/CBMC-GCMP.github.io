---
title: "Calculate biomass and plotting"
output:
  md_document:
    variant: gfm
    preserve_yaml: TRUE
knit: (function(inputFile, encoding) {
  rmarkdown::render(inputFile, encoding = encoding, output_dir = "../_posts") })
author: "Fabio"
date: "19 February, 2021"
excerpt: "How to calculate biomass and then start plotting"
layout: post
categories:
  - R Markdown
  - Jekyll
---

# Loading libraries and data

``` r
library(tidyverse)

## Cargamos los datos desde internet

base <- read.csv("https://www.dropbox.com/s/st52i2c7yx3vyki/base_monitoreo.csv?dl=1")
```

# Data Wrangling

We filter by fishes and then calculate the biomass using the formula

``` r
base <- base %>% 
        filter(Label == "PEC") %>% 
        mutate(Biomass = (Quantity * A_ord * (Size^B_pen))/(Area * 100)) 
```

We then summarize data by region. First we sum by transect (our sampling
unit) and then we estimate by calculating the average.

``` r
grafico <- base %>% 
        group_by(Year, Region, Reef, Depth, Transect) %>% 
        summarise(Quantity = sum(Quantity), 
                  Biomass = sum(Biomass)) %>% 
        group_by(Year, Region) %>% 
        summarise(Quantity = mean(Quantity), 
                  Biomass = mean(Biomass))
```

# Graph

``` r
ggplot(grafico, aes(x = Region, y = Biomass)) +
        geom_col()
```

![](C:\Users\zephi\CBMC%20Dropbox\Fabio\CBMC-GCMP.github.io_posts\2021-2-19-calculating-biomass-and-plotting_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

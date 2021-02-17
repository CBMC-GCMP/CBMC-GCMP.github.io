---
title: "Updating Mean Trophic levels of a genera from FishBase"
output:
  md_document:
    variant: gfm
    preserve_yaml: TRUE
knit: (function(inputFile, encoding) {
  rmarkdown::render(inputFile, encoding = encoding, output_dir = "../_posts") })
author: "Fabio"
date: "17 February, 2021"
excerpt: "Updating Mean Trophic levels of a genera from FishBase"
layout: post
categories:
  - R Markdown
  - Jekyll

---

## Loading data and libraries

``` r
## Loading libraries
library(tidyverse) # Easily Install and Load the 'Tidyverse', CRAN v1.3.0
library(readxl) # Read Excel Files, CRAN v1.3.1


## Loading data

# All data
data_all <- read.csv("https://raw.githubusercontent.com/CBMC-GCMP/CBMC-GCMP.github.io/master/_data/monitoring_reef.csv") 

# Loading reef data with protection_status and coordinates
reef <- read.csv("https://raw.githubusercontent.com/CBMC-GCMP/CBMC-GCMP.github.io/master/_data/reef_list.csv")
```

## The problem

These two dataset can be easily merged using IDs, but it can be hard to
merge them without it, and using just the names. This as we saw in
class, creates other unwanted columns. Let’s imagine the common scenario
where we **DON’T** have a numeric ID. How do we create them?

The process is as follow:

1.  We manually create an ID for the `reef` table;
2.  We match the reef names which generates a vector of numbers;
3.  We create a new ID column called `IDReef` in the `data_all` dataset;
4.  We merge the two datasets by ID;
5.  **Celebrate!**

## Step 1: creating an ID in the `reef` dataset

Now, we want to manually create an ID column, we will call this `IDReef`
we can do this using the following code:

``` r
reef$IDReef <- 1:length(reef$Reef)
```

The `lenght()` function returns how many rows or observations are in the
object.

This approach is useful if we don’t want to specify a particular number,
which can change in time (for example if we add more sites in our
reference table).

## Step 2: matching the names of the reefs and obtaining a numeric ID

``` r
matched_ID_reefs <- match(data_all$Reef, reef$Reef)
```

## Step 3: Creating and ID in our main data

Now we just need to create an ID column into our data object `data_all`.
For convenience, we will call the column `IDReef` to match the same name
as the one we created in the `reef` data. We can easily achieve this by
using the code below:

``` r
data_all$IDReef <- matched_ID_reefs
```

## Step 4: Merging the two dataset by ID

Finally, we just go with the usual `merge` function. Note that the
number of observations in the `final` dataset is the same as the one
from the original dataset `data_all`.

``` r
test <- merge(data_all, reef, by = "IDReef")
```

From here, we can save the dataset for future reference or just rerun
the script!

R is FUN!!

## Step 6: CELEBRATE!

![](_gifs/celebration.gif)

## Bonus step: Not matching names

That’s all good Fabio, but what if I work with someone who has the
tendency to make a lot of typos!! So my reef names **DO not** match
perfectly! No worries! R has a solution for this too of course! There is
a nice
[solution](https://gis.stackexchange.com/questions/176722/how-to-join-a-table-to-a-shapefile-with-non-matching-ids-and-names-similar-stri)
here that uses a packages called
[`stringdist`](https://www.rdocumentation.org/packages/stringdist/versions/0.9.4.6/topics/stringdist),
which allow for partial matching of the names. Partial matching means
that the strings have to be similar, and *not identical*, to be matched!
Pretty cool right?!

With this I can see the matching names even if there are some small
differences in letters (e.g. typos), create an ID and then easily merge
the two dataset. Of course, the best thing would be to detect the typo
and correct it, but in thousands of observation this can be tricky!
Remeber, good programmers are lazy!

So how can we do it?

First we need to install the `stringdist` package we can use the
`install.packages()` function and then we load it using the `library`
function as follow:

``` r
library(stringdist) # Approximate String Matching, Fuzzy Text Search, and String Distance Functions, CRAN v0.9.6.3 
```

Then, we can achieve the partial matching by using the `amatch()`
function, you can see the the help page by running `help(amatch)`. A
match takes different arguments, the first is the list of names we have
(i.e. the complete reef list in our data), the second is a list of names
we want to compare it to (i.e. the names of the reefs in the reef table
data), the third is the `maxDist` argument which set how much
“different” the string can be. Translated, if `maxDist` is set to 3, we
can have 3 letters of difference in the names and these will still
match! Cool right? To be conservative we can set this to 1. This is
**very** useful in the case of typos etc. that you can’t or don’t want
to correct. Let’s get to it!

``` r
matched_ID_reefs <- amatch(data_all$Reef, reef$Reef, maxDist = 1)
```

You can then follow step 3 to 6 as they are to merge the two datasets!

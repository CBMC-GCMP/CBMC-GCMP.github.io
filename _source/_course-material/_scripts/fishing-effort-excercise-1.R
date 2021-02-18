#--------------------------------------------#
#Solution to the fishing effort 2.1 excercise#
#--------------------------------------------#
#------------dplyr SOLUTION--------------#
#--------------------------------------------#
#--By FF-------------------------------------#
#--------------------------------------------#

# Loading libraries -------------------------------------------------------

# First i load the libraries that i need


library(readxl) # this is to load the excel
library(tidyverse) # this is for everything else...


# Loading data ------------------------------------------------------------

df <- read_xlsx("data/fishing_effort.xlsx") # this loads data

head(df) #check that data are uploaded correctly


# Q1: Find which **region** has the highest mean fishing effort --------

(Q1 <- df %>% group_by(Region) %>%
         summarise(mean = mean(PFE), sd = sd(PFE)) %>%
         arrange(-mean))


# Q2: Find which **site** has the highest mean fishing effort in the Gulf --------

(Q2 <- df %>% group_by(Site) %>%
         summarise(mean = mean(PFE)) %>%
         arrange(-mean))


# Q3: Which **site** has the lowest mean fishing effort? --------

(Q3 <- df %>% group_by(Site) %>%
         summarise(mean = mean(PFE)) %>%
         arrange(mean))


# Q4: Find which **region** has the highest standard deviation in fishing effort in the Gulf --------

(Q4 <- df %>% group_by(Region) %>%
         summarise(mean = mean(PFE), sd = sd(PFE)) %>%
         arrange(-sd))


# Q5: Find which **site** has the highest number of pangas inside the highest **region** for fishing effort --------

(Q5 <- df %>% group_by(Region, Site) %>%
                filter(Region == "LaPaz") %>%
                summarise(mean = mean(Pangas)) %>%
                arrange(-mean))

df %>% select(Region) %>% 
        unique()




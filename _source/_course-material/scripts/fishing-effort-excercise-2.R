#--------------------------------------------#
#Solution to the fishing effort 2.1 excercise#
#--------------------------------------------#
#------------GRAPHICAL SOLUTION--------------#
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

(
        df %>% group_by(Region) %>%
                summarise(mean = mean(PFE), sd = sd(PFE)) %>%
                ggplot(aes(x = reorder(Region, mean), y = mean)) +
                geom_col(aes(fill = Region)) +
                geom_errorbar(aes(ymin = mean - sd, ymax = mean + sd)) +
                labs(x = "", y = "PFE mean values") +
                theme_bw() -> Q1
) # note the ending brackets to show the plot and save at the same time

ggsave(
        filename = "figs/fishing-effort-results-1/ex2_Q1.png",
        plot = Q1,
        device = "png",
        width = 6,
        height = 6,
        dpi = 300
) # saving the plot


# Q2: Find which **site** has the highest mean fishing effort in the Gulf --------

(
        df %>% group_by(Site) %>%
                summarise(mean = mean(PFE)) %>%
                top_n(n = 3, wt = mean) %>%
                ggplot(aes(x = reorder(Site, mean), y = mean)) +
                geom_col(aes(fill = Site)) +
                labs(x = "", y = "PFE mean values") +
                theme_bw() +
                theme(axis.text.x = element_text(angle = 90)) -> Q2
)

ggsave(
        filename = "figs/fishing-effort-results-1/ex2_Q2.png",
        plot = Q2,
        device = "png",
        width = 6,
        height = 6,
        dpi = 300
) # saving the plot


# Q3: Which **site** has the lowest mean fishing effort? --------

(
        df %>% group_by(Site) %>%
                summarise(mean = mean(PFE)) %>%
                filter(mean <= 5) %>%
                ggplot(aes(x = reorder(Site, -mean), y = mean)) +
                geom_col(aes(fill = Site)) +
                labs(x = "", y = "PFE mean values") +
                theme_bw() +
                theme(
                        axis.text.x = element_text(angle = 90),
                        legend.position = ""
                ) -> Q3
)

ggsave(
        filename = "figs/fishing-effort-results-1/ex2_Q3.png",
        plot = Q3,
        device = "png",
        width = 6,
        height = 6,
        dpi = 300
) # saving the plot



# Q4: Find which **region** has the highest standard deviation in fishing effort in the Gulf --------

(
        df %>% group_by(Region) %>%
                summarise(mean = mean(PFE), sd = sd(PFE)) %>%
                ggplot(aes(x = reorder(Region, sd), y = mean)) +
                geom_col(aes(fill = Region)) +
                geom_errorbar(aes(ymin = mean - sd, ymax = mean + sd)) +
                labs(x = "", y = "PFE mean values") +
                theme_bw() +
                theme(
                        axis.text.x = element_text(angle = 90),
                        legend.position = ""
                ) -> Q4
) # note the ending brackets to show the plot and save at the same time

ggsave(
        filename = "figs/fishing-effort-results-1/ex2_Q4.png",
        plot = Q4,
        device = "png",
        width = 6,
        height = 6,
        dpi = 300
) # saving the plot

# Q5: Find which **site** has the highest number of pangas inside the highest **region** for fishing effort --------

(
        df %>% group_by(Region, Site) %>%
                filter(Region == "LaPaz") %>%
                summarise(mean = mean(Pangas)) %>%
                ggplot(aes(x = reorder(Site, mean), y = mean)) +
                geom_col(aes(fill = Region)) +
                labs(x = "", y = "PFE mean values") +
                theme_bw()+
                theme(
                        axis.text.x = element_text(angle = 90),
                        legend.position = ""
                ) -> Q5
) # note the ending brackets to show the plot and save at the same time

ggsave(filename = "figs/fishing-effort-results-1/ex2_Q5.png",
       plot = Q5,
       device = "png", width = 6, height = 6, dpi = 300) # saving the plot

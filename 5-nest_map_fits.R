library(tidyverse)
library(patchwork)
library(readxl)
library(glue)
library(broom)
library(latex2exp)
theme_set(theme_bw()+
    theme(text = element_text(size = 18, color = "black"),
          panel.border = element_rect(color = "black", fill = NA, linewidth = 1),
          panel.background = element_rect(fill = "transparent", color = NA),
          plot.background = element_rect(fill="transparent", color=NA),
          legend.background = element_rect(fill = "transparent", color = NA),
          strip.background = element_rect(fill = "transparent", color = NA),
          strip.text = element_text(face = "bold"),
          strip.text.y = element_text(angle=0)))

# Find list of all files in the Data/fits directory with the pattern "csv" in their name
flist <- list.files(___)
# Read the files in the list and store them in a list of dataframes
d <- read_csv(___) |>
    nest(data = ___)  |> # nest the data in a list column called "data"
    mutate(___) |>  # remove the path from the file name
    separate(___) |>  # retrieve the information from the file name and store it into new columns
    mutate(temperature = ___, # remove the string "K" and convert to numeric
           time = ___, # remove all letters from the string "time" and convert to numeric
           ) |> 
    mutate(Lm = map_dbl(data, ___), # using map_dbl(), compute the mean of the column "L" for each dataframe in the list column "data"
           Ls = ___) # using map_dbl(), compute the standard deviation of the column "L" for each dataframe in the list column "data"

# Write a function to fit a linear model to the data given a dataframe "df"
# with columns "Lm" and "time" and use "1/Ls^2" for the weights
myfit <- function(df){
    lm(___)
}

# Fit the linear model to each dataframe in the list column "data"
# using the functions "myfit" and "map()"
d_fitted <- d |>
    ___ |> # remove the column "data" (we don't need it anymore
    nest(___) |> # nest the data as a function of temperature in a list column called "data"
    mutate(fit = ___, # do the fit on all elements (tibbles) of the column "data"
           tidied = ___, # tidy the results of the fit
           augmented = ___ # augment the results of the fit
           )


# Plot the evolution of the parameters of the fits
# Add vertical error bars
d_fitted |>
    unnest(tidied) |>
    mutate(term = ifelse(term == "(Intercept)", "Intercept", "Slope")) |> # rename the term "(Intercept)" to "intercept" and the term "x" to "slope"
    ggplot(___)

# Plot the data and the fits
d_fitted |>
    unnest(augmented) |>
    ggplot(___)


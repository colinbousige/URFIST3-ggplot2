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

# Find list of all files in the Data directory with the pattern "sample" in their name
flist <- list.files(path = "Data/fits",
                    pattern = "csv",
                    full.names = TRUE)
# Read the files in the list and store them in a list of dataframes
d <- read_csv(flist, id='file', col_names="L") |>
    nest(data = -file)  |> # nest the data in a list column called "data"
    mutate(file = basename(file)) |>  # remove the path from the file name
    separate(file, c("temperature", "time", NA)) |>  # retrieve the information from the file name and store it into new columns
    mutate(temperature = temperature |> str_remove("K") |> as.numeric(), # remove the string "K" and convert to numeric
           time = time |> str_remove_all("sec") |> as.numeric(), # remove all letters from the string "time" and convert to numeric
           ) |> 
    mutate(Lm = map_dbl(data, ~mean(.$L)), # using map_dbl(), compute the mean of the column "L" for each dataframe in the list column "data"
           Ls = map_dbl(data, ~sd(.$L))) # using map_dbl(), compute the standard deviation of the column "L" for each dataframe in the list column "data"

# Write a function to fit a linear model to the data given a dataframe "df"
# with columns "Lm" and "time" and use "1/Ls^2" for the weights
myfit <- function(df){
    lm(Lm ~ time, data = df, weights = 1/(Ls^2))
}

# Fit the linear model to each dataframe in the list column "data"
# using the functions "myfit" and "map()"
d_fitted <- d |>
    select(-data) |> # remove the column "data" (we don't need it anymore
    nest(data = -temperature) |> 
    mutate(fit = map(data, myfit), # do the fit on all elements (tibbles) of the column "data"
           tidied = map(fit, tidy), # tidy the results of the fit
           augmented = map(fit, augment) # augment the results of the fit
           )

# This is the same as the previous code, but defining the function "myfit"
#  directly in the "map()" function
d_fitted <- d |>
    select(-data) |> # remove the column "data" (we don't need it anymore
    nest(data = c(time, Lm, Ls)) |> 
    mutate(fit = map(data, ~lm(Lm ~ time, data = ., weights = 1/(Ls^2))),
           tidied = map(fit, tidy),
           augmented = map(fit, augment)
           )

# Plot the evolution of the parameters of the fits
# Add vertical error bars
d_fitted |>
    unnest(tidied) |>
    mutate(term = ifelse(term == "(Intercept)", "Intercept", "Slope")) |> # rename the term "(Intercept)" to "intercept" and the term "x" to "slope"
    ggplot(aes(x=temperature, 
               y=estimate)) +
    geom_point(size=3)+
    geom_errorbar(aes(ymin=estimate-std.error, ymax=estimate+std.error), 
                  width=.1)+
    facet_wrap(~term) +
    labs(color = "Time [s]",
         x = "Temperature [K]",
         y = "Estimate")

# Plot the data and the fits
d_fitted |>
    unnest(augmented) |>
    ggplot(aes(x=time, y=Lm, color = factor(temperature))) +
    geom_point(alpha = .2, size=5)+
    geom_line(aes(y=.fitted), linewidth=2)+
    labs(color = "Temperature [K]",
         x = "y",
         y = "x")


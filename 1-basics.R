# Just for Colin, do not run:
# server = livecode::serve_file()

library(tidyverse)
library(patchwork)
theme_set(theme_bw())

# # # # # # # # # # # # # # # # # # # # # # # # # # 
## Exercise 1: basic plots
# # # # # # # # # # # # # # # # # # # # # # # # # # 

# We will work with the well known table `mtcars` included in R:

?mtcars


### Basic stuff 1

# Modify the following code to add a color depending on the `gear` column:
mtcars %>% # we work on the mtcars dataset, send it to ggplot
    # define the x and y variables of the plot, and also the color:
    ggplot(aes(x = wt, y = mpg))+ 
        geom_point() # plot with points

# Now change the color and shape of the points, and add transparency
mtcars %>% 
    ggplot(aes(x = wt, y = mpg))+ 
        geom_point(___)

### Basic stuff 2

# What happens if you use `factor(gear)` instead?

P <- mtcars %>% # we work on the mtcars dataset, send it to ggplot
    # define the x and y variables of the plot, and also the color:
    ggplot(aes(x = wt, y = mpg, color = gear))+ 
        geom_point() # plot with points

### Tuning the plot
# Using the previously defined plot P:
# Add nice labels : 
# - wt = Weight (1000 lbs)
# - mpg = Miles/(US) gallon
# - gear = Number of forward gears
# - title : add a title
# Set colors to :
# - ones you define yourself
# - ones you define from the palette 'Set1' from scale_color_brewer()
# Force the x and y ranges to reach 0
# Reorganize the gears in descending order in the legend

P + ___

### Faceting 1

# Modify the following code to place each `carb` in a different facet. Also add a color, but remove the legend.
mtcars %>% # we work on the mtcars dataset, send it to ggplot
    ggplot(aes(x = wt, y = mpg))+ # define the x and y variables of the plot, and also the color
        geom_point() +   # plot with points
        facet____(___) + # add a faceting
        theme(___)       # remove the legend


### Faceting 2

# Modify the following code to arrange `mpg` vs `wt` plots on a grid showing `gear` vs `carb`. Also add a color depending on `cyl`. Also, try adding a free `x` scale range, or a free `y` scale range, or free `x` and `y` scale ranges.
mtcars %>% # we work on the mtcars dataset, send it to ggplot
    ggplot(aes(x = ___, y = ___))+ # define the x and y variables of the plot, and also the color
        geom_point() +   # plot with points
        facet____(___) # add a faceting


# # # # # # # # # # # # # # # # # # # # # # # # # 
## Exercise 2: arranging plots on a grid
# # # # # # # # # # # # # # # # # # # # # # # # # 

# We will look at data loaded into `df`. 
df <- read_table("Data/exo_fit.txt")
df

# Using `ggplot`, plot `y` as a function of `x` with points and save it into `Py`:

Py <- df %>% 
    ___
Py

# Add a straight line in `Py` resulting from a linear fit:

Py <- Py +
    geom_smooth(___)
Py

# Using `ggplot`, plot `z` as a function of `x` with a red line and save it into `Pz`:

Pz <- df %>% 
    ___
Pz

# Using `ggplot`, plot a histogram of `w` with transparent blue bars surrounded by a red line, and save it into `Pw`. You can play with the number of bins too.

Pw <- df %>% 
    ___
Pw

# Using `ggplot`, plot a density of `u` with a transparent blue area surrounded by a red line, and save it into `Pu`. Play with the `bw` parameter so that you see many peaks.

Pu <- df %>% 
    ___
Pu

# Using `ggplot`, plot the 2d density of `s` vs `w`, and add the points on top of it. Save it into `Psw`.
___

# Using `patchwork`, gather the 5 previous plots on a grid with 2 columns.


# Using `patchwork`, gather the previous plots on a grid with 3 plots in the 1st row, and 2 large plots in the 2nd row. Using `plot_annotation()`, add tags such as (a), (b)...


# Now, transform the tibble df to a tidy one using a pivot function, and gather all 5 plots on a grid with 2 columns, using `facet_wrap()` to add a facet for each variable. Use a color for each variable.
df %>% 
    pivot_____()


# # # # # # # # # # # # # # # # # # # # # # # # # 
## Exercise 3: statistical plots
# # # # # # # # # # # # # # # # # # # # # # # # # 

# Let's work on the `iris` dataset

# Plot the histogram of `Sepal.Length` for each species using geom_histogram()
iris %>% 
    ggplot(___)

# Plot the density of `Sepal.Length` for each species using geom_density()
iris %>% 
    ggplot(___)

# Compare the distributions of `Sepal.Length` for each species using geom_boxplot() or geom_violin()
iris %>% 
    ggplot(___)

iris %>% 
    ggplot(___)

# Add the original points to the boxplot or violin plot using geom_jitter(), add the mean value as a large point and show its value using geom_text()



# Using the package "ggstatsplot" (https://indrajeetpatil.github.io/ggstatsplot/)
library(ggstatsplot)
ggbetweenstats(
  data  = iris,
  x     = Species,
  y     = Sepal.Length,
  title = "Distribution of sepal length across Iris species"
)

# # # # # # # # # # # # # # # # # # # # # # # # # 
## Exercise 4: 3D plots
# # # # # # # # # # # # # # # # # # # # # # # # # 

# Let's work on `faithfuld` and plot as a 3D color plot the density, as a function of eruptions vs waiting
# Plot with geom_contour_filled() or geom_raster() and see the difference
# Add big red diamond points in (80, 4.4) and (53, 1.94) using either geom_point() or annotate("point", ...)

faithfuld %>% 
    ggplot(___)+
        geom_contour_filled()

faithfuld %>% 
    ggplot(___)+
        geom_raster()




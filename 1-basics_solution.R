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
mtcars |> # we work on the mtcars dataset, send it to ggplot
    # define the x and y variables of the plot, and also the color:
    ggplot(aes(x = wt, y = mpg, col = gear))+ 
        geom_point() # plot with points

# Now change the color and shape of the points, and add transparency
mtcars |> 
    ggplot(aes(x = wt, y = mpg, col = gear))+ 
        geom_point(alpha=0.5, shape=17, size=3)+
        scale_color_gradientn(colors=c("red", "blue", "green"))

### Basic stuff 2

# What happens if you use `factor(gear)` instead?

P <- mtcars |> # we work on the mtcars dataset, send it to ggplot
    # define the x and y variables of the plot, and also the color:
    ggplot(aes(x = wt, y = mpg, color = factor(gear)))+ 
        geom_point() # plot with points
P
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

P + labs(x="Weight (1000 lbs)", 
         y="Miles/(US) gallon", 
         color="Number of forward gears", 
         title="My title") +
    scale_color_brewer(palette="Set1") +
    guides(color=guide_legend(reverse=TRUE))

P + labs(x="Weight (1000 lbs)", 
         y="Miles/(US) gallon", 
         color="Number of forward gears", 
         title="My title") +
    scale_color_manual(values=c("black", "royalblue", "orange"))+
    guides(color=guide_legend(reverse=TRUE))

### Faceting 1

# Modify the following code to place each `carb` in a different facet. Also add a color, but remove the legend.
mtcars |> # we work on the mtcars dataset, send it to ggplot
    ggplot(aes(x = wt, y = mpg, color=factor(carb)))+ # define the x and y variables of the plot, and also the color
        geom_point() +   # plot with points
        facet_wrap(~carb) + # add a faceting
        theme(legend.position ='false')       # remove the legend

### Faceting 2

# Modify the following code to arrange `mpg` vs `wt` plots on a grid showing `gear` vs `carb`. Also add a color depending on `cyl`. Also, try adding a free `x` scale range, or a free `y` scale range, or free `x` and `y` scale ranges.
library(glue)
mtcars |> # we work on the mtcars dataset, send it to ggplot
    ggplot(aes(x = wt, y = mpg, color=factor(gear)))+ # define the x and y variables of the plot, and also the color
        geom_point() +   # plot with points
        facet_grid(glue('gear = {gear}') ~ glue("carb = {carb}"),
                   scale = 'free') +
        theme(strip.text.y = element_text(angle = 0),
              strip.background = element_blank(),
              strip.text = element_text(face = "bold"))

# # # # # # # # # # # # # # # # # # # # # # # # # 
## Exercise 2: arranging plots on a grid
# # # # # # # # # # # # # # # # # # # # # # # # # 

# We will look at data loaded into `df`. 
df <- read_table("Data/exo_fit.txt")
df

# Using `ggplot`, plot `y` as a function of `x` with points and save it into `Py`:

Py <- df |> 
    ggplot(aes(x = x, y = y)) + 
    geom_point()
Py

# Add a straight line in `Py` resulting from a linear fit:

Py <- Py +
    geom_smooth(method="lm")
Py

# Using `ggplot`, plot `z` as a function of `x` with a red line and save it into `Pz`:

Pz <- df |> 
    ggplot(aes(x = x, y = z)) + 
    geom_line(color="red")
Pz

# Using `ggplot`, plot a histogram of `w` with transparent blue bars surrounded by a red line, and save it into `Pw`. You can play with the number of bins too.

Pw <- df |> 
    ggplot(aes(x = w)) + 
    geom_histogram(fill="blue", 
                   alpha=0.5, 
                   color="red", 
                   bins=20)
Pw

# Using `ggplot`, plot a density of `u` with a transparent blue area surrounded by a red line, and save it into `Pu`. Play with the `bw` parameter so that you see many peaks.

Pu <- df |> 
    ggplot(aes(x = u)) + 
    geom_density(fill = "blue", 
                 alpha = 0.5, 
                 color = "red", 
                 bw = 0.1)
Pu

# Using `ggplot`, plot the 2d density of `s` vs `w`, and add the points on top of it. Save it into `Psw`.
Psw <- df |> 
    ggplot(aes(x = w, y = s)) + 
    geom_density_2d()+
    geom_point()
Psw

# Using `patchwork`, gather the 5 previous plots on a grid with 2 columns.
library(patchwork)
Py+Pz+Pw+Pu+Psw + plot_layout(ncol = 2)

# Using `patchwork`, gather the previous plots on a grid with 3 plots in the 1st row, and 2 large plots in the 2nd row. Using `plot_annotation()`, add tags such as (a), (b)...
(Py+Pz+Pw)/(Pu+Psw)+
    plot_annotation(tag_levels = 'a', 
                    tag_suffix = ')',
                    tag_prefix = '(')

# Now, transform the tibble df to a tidy one using a pivot function, and gather all 5 plots on a grid with 2 columns, using `facet_wrap()` to add a facet for each variable. Use a color for each variable.
df |> 
    pivot_longer(cols = -x, 
                 names_to = "variable", 
                 values_to = "value") %>%
    ggplot(aes(x=x, y=value, color=variable))+
        geom_point()+
        facet_wrap(~variable, 
                   scales = "free", 
                   ncol = 2)+
        theme(legend.position = "none")


# # # # # # # # # # # # # # # # # # # # # # # # # 
## Exercise 3: statistical plots
# # # # # # # # # # # # # # # # # # # # # # # # # 

# Let's work on the `iris` dataset

# Plot the histogram of `Sepal.Length` for each species using geom_histogram()
iris |> 
    ggplot(aes(x = Sepal.Length, group=Species, fill=Species))+
        geom_histogram(position='dodge')

# Plot the density of `Sepal.Length` for each species using geom_density()
iris |> 
    ggplot(aes(x = Sepal.Length, group=Species, fill=Species))+
        geom_density(alpha=0.5)

# Compare the distributions of `Sepal.Length` for each species using geom_boxplot() or geom_violin()
iris |> 
    ggplot(aes(x = Species, y=Sepal.Length, fill=Species))+
        geom_violin(color=NA, alpha=0.5)

iris |> 
    ggplot(aes(x = Species, y=Sepal.Length, color=Species))+
        geom_boxplot(alpha=0.5)

# Add the original points to the boxplot or violin plot using geom_jitter(), add the mean value as a large point and show its value using geom_text()
ave <- iris |> 
    group_by(Species) |> 
    summarise(mean=mean(Sepal.Length))

iris |> 
    ggplot(aes(x = Species, y=Sepal.Length, color=Species, fill=Species))+
        geom_violin(color=NA, alpha=0.2)+
        geom_jitter(width=.1)+
        stat_summary(fun=mean, geom="point", size=10)+
        geom_text(data=ave, aes(label=round(mean, 2)), y=8, size=10)

iris |> 
    ggplot(aes(x = Species, y=Sepal.Length, color=Species))+
        geom_boxplot()+
        geom_jitter(width=.1)+
        stat_summary(fun=mean, geom="point", size=10)+
        geom_text(data=ave, aes(label=round(mean, 2)), y=8, size=10)


# Using `ggExtra`, add a marginal histograms to a plot of `Sepal.Length` vs `Sepal.Width` 
library(ggExtra)
p <- iris |> 
    ggplot(aes(x = Sepal.Width, y=Sepal.Length, color=Species))+
        geom_point()+
        theme(legend.position = "bottom")
ggMarginal(p, groupColour = TRUE)

# Also, take a look at `ggscatterhist()` from the `ggpubr` package: https://rpkgs.datanovia.com/ggpubr/
ggpubr::ggscatterhist(
 iris, 
 x = "Sepal.Length", 
 y = "Sepal.Width",
 color = "Species", 
 margin.plot = "density",
 size = 3, alpha = 0.6,
 palette = c("#00AFBB", "#E7B800", "#FC4E07"),
 margin.params = list(color = "Species", size = 1),
 ggtheme=theme_bw(),
 legend = "right",
)


# Using the package "ggstatsplot" (https://indrajeetpatil.github.io/ggstatsplot/)
library(ggstatsplot)
ggbetweenstats(
  data  = iris,
  x     = Species,
  y     = Sepal.Length,
  title = "Distribution of sepal length across Iris species"
)

# # # # # # # # # # # # # # # # # # # # # # # # # 
# Note about the boxplot notch
# # # # # # # # # # # # # # # # # # # # # # # # # 
# The notch displays a confidence interval around the median

df <- tibble(group=c("A","B","C","D"),
             values=list(rnorm(1e1),rnorm(1e2),rnorm(1e3),rnorm(1e4))) |> 
    unnest(values)

# conf.int around the mean
df |> 
    nest(data=values) |> 
    mutate(ttest=map(data, ~t.test(.x$values)),
           ttest=map(ttest, broom::tidy)) |> 
    unnest(ttest)

# conf.int around the median
df |> 
    ggplot(aes(y=values, color=group))+
        geom_boxplot(notch = TRUE)

# # # # # # # # # # # # # # # # # # # # # # # # # 
## Exercise 4: 3D plots
# # # # # # # # # # # # # # # # # # # # # # # # # 

# Let's work on `faithfuld` and plot as a 3D color plot the density, as a function of eruptions vs waiting
# Plot with geom_contour_filled() or geom_raster() and see the difference
# Add big red diamond points in (80, 4.4) and (53, 1.94) using either geom_point() or annotate("point", ...)

faithfuld |> 
    ggplot(aes(x=waiting, y=eruptions, z=density))+
        geom_contour_filled()+
        annotate("point", y=c(4.4, 1.94), x=c(80, 53), color="red", size=10, shape=18)

faithfuld |> 
    ggplot(aes(x=waiting, y=eruptions))+
        geom_raster(aes(fill=density), interpolate = TRUE)+
        scale_fill_distiller(palette=4)+
        geom_point(data=tibble(waiting=c(80, 53), eruptions=c(4.4, 1.94)),
                   color="red", size=10, shape=18)

# Or plot it with lines on top of each other (ridgeline plot)
faithfuld |> 
    ggplot(aes(x=waiting, group=eruptions))+
        geom_line(aes(y=density+(as.numeric(factor(eruptions))-1)*.002, color=density))



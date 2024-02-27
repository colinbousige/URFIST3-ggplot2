library(tidyverse)
library(glue)
library(gganimate)
library(plotly)
library(ggthemes)
library(scales)
theme_set(theme_bw()+
          theme(text = element_text(size = 18, color = "black"),
                panel.border = element_rect(color = "black", fill = NA, linewidth = 1),
                panel.background = element_rect(fill = "white", color = NA),
                plot.background = element_rect(fill="white", color=NA),
                legend.background = element_rect(fill = "white", color = NA),
                strip.background = element_rect(fill = "white", color = NA),
                strip.text = element_text(face = "bold"),
                strip.text.y = element_text(angle=0)))

d <- read_csv("Data/religion_babies.csv")

# Create the plot that you want, without animations
P <- d |> 
    ggplot(aes(x     = Income, 
               y     = Fertility, 
               color = Religion, 
               size  = Population, 
               frame = Year, # frame and id: just for plotly
               id    = Country)) + 
        geom_point(alpha=0.8)+
        scale_size(guide = "none", range = c(3, 16))+
        scale_x_log10(breaks = 10^(-seq(-10,10,by=1)),
                      minor_breaks = rep(1:9, 2*10+1)*(10^rep(-10:10, each=9)),
                      labels = trans_format("log10", math_format(10^.x)))+
        coord_cartesian(xlim = c(100, 2e5), ylim = c(0, 10))+
        scale_colour_colorblind()+
        labs(x = 'Income in comparable $', 
             y = 'Babies per woman')+ 
        guides(colour = guide_legend(override.aes = list(size=8)))

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Using a `for loop` to create an animated plot
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
i <- 1
years <- sort(unique(d$Year))
# The `%+%` operator allows updating a ggplot object with new data
for(yy in years[seq(1, length(years), by=5)]){
    ggsave(glue("Plots/rel_babies_{str_pad(i,4,pad=\"0\")}.png"), 
           P %+% filter(d, Year == yy) + 
               labs(title = glue("Year: {yy}")),
           width = 10, height = 7, dpi = 500)
    i <- i + 1
}
# Make a gif with imagemagick 
system("convert Plots/rel_babies_*.png Plots/rel_babies.gif")
# Make a movie with ffmpeg
system("ffmpeg -framerate 5 -pattern_type glob -i 'Plots/rel_babies*.png' -c:v libx264 -pix_fmt yuv420p Plots/rel_babies.mp4")



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Using plotly to create an animated plot
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

PP <- ggplotly(P + scale_x_continuous(), 
               dynamicTicks = TRUE) |> 
  layout(yaxis = list(autorange = FALSE), 
         xaxis = list(autorange = FALSE, type = 'log', range=list(2, 5.5)))
htmlwidgets::saveWidget(PP, "Plots/rel_babies.html")


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Using gganimate to create an animated plot
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

anim <- P +
        labs(title = 'Year: {round(frame_time,0)}')+ 
        transition_time(Year) +
        ease_aes('linear')
animate(anim, renderer = ffmpeg_renderer(), width = 1800, height = 1200, res = 300)
anim_save('Plots/rel_babies_gganimate.mp4', animation = last_animation())
animate(anim, width = 1800, height = 1200, res = 300)
anim_save('Plots/rel_babies_gganimate.gif', animation = last_animation())


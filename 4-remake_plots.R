library(tidyverse)
library(glue)
library(patchwork)
library(ggthemes)
library(scales)
library(latex2exp)
theme_set(theme_bw()+
          theme(text = element_text(size = 18, color = "black"),
                panel.border = element_rect(color = "black", fill = NA, linewidth = 1),
                panel.background = element_rect(fill = "white", color = NA),
                plot.background = element_rect(fill="white", color=NA),
                legend.background = element_rect(fill = "white", color = NA),
                strip.background = element_rect(fill = "white", color = NA),
                strip.text = element_text(face = "bold"),
                strip.text.y = element_text(angle=0)))


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Try reproducing the pdf plots in "Data":
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# # # # # # # # # # # # # # # # # # # # # # # 
# - Data/adsorption.pdf: 
# # # # # # # # # # # # # # # # # # # # # # # 
adsorption <- read_csv("Data/adsorption.csv")



# # # # # # # # # # # # # # # # # # # # # # # 
# - Data/corrugation.pdf: 
# # # # # # # # # # # # # # # # # # # # # # # 
load("Data/corrugation0.RData")
load("Data/corrugation90.RData")
glimpse(corrugation0)
glimpse(corrugation90)



# # # # # # # # # # # # # # # # # # # # # # # 
# - Data/Gr.pdf: 
# # # # # # # # # # # # # # # # # # # # # # # 
Gr <- read_csv("Data/Gr.csv")




# # # # # # # # # # # # # # # # # # # # # # # 
# - Data/RBMs.pdf: 
# # # # # # # # # # # # # # # # # # # # # # # 
RBMs <- read_csv("Data/RBMs.csv")




# # # # # # # # # # # # # # # # # # # # # # # 
# - Data/image.pdf: 
# # # # # # # # # # # # # # # # # # # # # # # 
load("Data/image_bottom.RData")
load("Data/image_top.RData")
glimpse(top)
glimpse(bottom)


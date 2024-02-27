library(tidyverse)
library(patchwork)
theme_set(theme_bw())

# To read: https://blog.datawrapper.de/colors/

# To see all the available palettes in RColorBrewer, use:
RColorBrewer::display.brewer.all()

# The ggthemes package has a lot of palettes:
# https://jrnold.github.io/ggthemes/reference/index.html#color-shape-and-linetype-palettes

# Also, take a look at the hrbrthemes package: https://github.com/hrbrmstr/hrbrthemes

# A color palette I like, then you can just define tour own palette:
mycolors <- colorRampPalette(c("black","royalblue","seagreen","orange","red"))
mycolors(10)

# This website shows all the available palettes in R:
# https://github.com/EmilHvitfeldt/r-color-palettes/tree/main

# Awesome addon to select colors in Rstudio:
# https://github.com/daattali/colourpicker
install.packages("colourpicker")
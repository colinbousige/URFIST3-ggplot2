library(tidyverse)
library(patchwork)
theme_set(theme_bw())

# # # # # # # # # # # # # # # # # # # # # # # # 
# Tuning manually the legend
# https://aosmith.rbind.io/2020/07/09/ggplot2-override-aes/
# # # # # # # # # # # # # # # # # # # # # # # # 

d <- read_table("Data/exo_fit.txt")

d |> 
    ggplot(aes(x = x)) + 
    geom_point(aes(y = y))+
    geom_line(aes(y = z), color="royalblue")+
    geom_line(aes(y = w), color="red")

d |> 
    ggplot(aes(x = x)) + 
    geom_point(aes(y = y, color="black"))+
    geom_line(aes(y = z, color="royalblue"))+
    geom_line(aes(y = w, color="red"))

d |> 
    ggplot(aes(x = x)) + 
    geom_point(aes(y = y, color="y"), size=3)+
    geom_line(aes(y = z, color="z"), linewidth=1, linetype="dotted")+
    geom_line(aes(y = w, color="w"), linewidth=3)+
    scale_color_manual(values = c("y" = "black", 
                                  "z" = "royalblue", 
                                  "w" = "red"),
                       name = NULL)

d |> 
    ggplot(aes(x = x)) + 
    geom_point(aes(y = y, color="y"), size=3)+
    geom_line(aes(y = z, color="z"), linewidth=1, linetype="dotted")+
    geom_line(aes(y = w, color="w"), linewidth=3)+
    scale_color_manual(values = c("y" = "black", 
                                  "z" = "royalblue", 
                                  "w" = "red"),
                       breaks = c("y","z","w"),
                       name = NULL)+
    guides(color = guide_legend(override.aes = list(shape = c(16,NA,NA),
                                                    size = c(3,NA,NA),
                                                    linewidth = c(NA,1,3),
                                                    linetype = c("blank","dotted","solid"))))







# # # # # # # # # # # # # # # # # # # # # # # # 
# Logscales
# # # # # # # # # # # # # # # # # # # # # # # # 

#' Create a pretty logscale for ggplot2
#'
#' @param side 'btlr', defines on which sides to drow it
#' @param N =20, breaks will be in breaks = 10^(-N:N)
#' @param step =1, step between labels
#'
#' @return
#' @export
#'
#' @import ggplot2
#' @importFrom scales trans_format math_format
#'
#' @examples
#' library(ggplot2)
#' x <- seq(1,1e5,by=10)
#' y <- x
#' d <- data.frame(x,y)
#' ggplot(data=d, aes(x=x, y=y))+
#'   geom_line()+
#'   gglogscale()
#'
#' ggplot(data=d, aes(x=x, y=y))+
#'   geom_line()+
#'   gglogscale("bl", step=2)
gglogscale <- function(side='bt', N=20, step=1){
  output<-list(annotation_logticks(sides = side))
  if('b'%in%unlist(strsplit(side,"")) | 't'%in%unlist(strsplit(side,""))){
    output<-c(output,scale_x_log10(
      breaks = 10^(-seq(-N,N,by=step)),
      minor_breaks = rep(1:9, 2*N+1)*(10^rep(-N:N, each=9)),
      labels = scales::trans_format("log10", scales::math_format(10^.x))
    ))
  }
  if('l'%in%unlist(strsplit(side,"")) | 'r'%in%unlist(strsplit(side,""))){
    output<-c(output,scale_y_log10(
      breaks = 10^(-seq(-N,N,by=step)),
      minor_breaks = rep(1:9, 2*N+1)*(10^rep(-N:N, each=9)),
      labels = scales::trans_format("log10", scales::math_format(10^.x))
    ))
  }
  output
}


d <- tibble(x=seq(1,1e5,by=10),y=x)
ggplot(data=d, aes(x=x, y=y))+
  geom_line()+
  gglogscale()
ggplot(data=d, aes(x=x, y=y))+
  geom_line()+
  gglogscale("bl", step=2)

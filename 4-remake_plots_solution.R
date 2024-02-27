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


adsorption |> 
    filter(P>1e-6) |> 
    ggplot(aes(x=P, y=Vads, color=Sample))+
        scale_colour_manual(values=c('red','royalblue'))+
        geom_point(size=3)+
        geom_line(size=1)+
        xlab("$P$ [Pa]")+
        ylab("$V_{ads}$ [cm$^3$/g STP]")+
        gglogscale(side="bt",step=2)+
        theme(panel.grid.major = element_blank(),
              panel.grid.minor = element_blank())+
        scale_y_continuous(breaks=seq(0,80,20), 
                           limits=c(0,80))+
        scale_y_continuous(sec.axis = dup_axis(name=NULL, labels = NULL),limits=c(0,80),breaks=seq(0,80,20))+
        theme(legend.position = 'none')


# # # # # # # # # # # # # # # # # # # # # # # 
# - Data/corrugation.pdf: 
# # # # # # # # # # # # # # # # # # # # # # # 
load("Data/corrugation0.RData")
load("Data/corrugation90.RData")
glimpse(corrugation0)
glimpse(corrugation90)


corrugation0 |> 
    ggplot(aes(x=z, y=density))+
        geom_segment(data=tibble(x=-1.5, xend=2, y = 0:17+.05, yend = 0:17+.05), 
                    aes(x=x, xend=xend, y = y,yend = yend), 
                         linewidth=.5, color="grey92")+
        geom_ribbon(aes(color=allotrope, fill=allotrope, ymin=as.numeric(allotrope)-1+.05, ymax=density), linewidth=2, alpha=.2)+
        geom_line(data=corrugation90, aes(color=allotrope, y=density), linewidth=2, alpha=.8, lty=2)+
        geom_text(aes(x=-1.65, y=(as.numeric(allotrope)-1)*1+.05+.05, label=allotrope), 
                    check_overlap=TRUE, color="black",size=6)+
        geom_text(aes(x=2.05, y=(as.numeric(allotrope)-1)*1+.05+.05, 
                  label=glue(r"($\nu$ = {round(nu,2)})")), hjust = 0,
                  check_overlap=TRUE, color="black",size=6)+
        coord_cartesian(xlim=c(-1.6,2.5), ylim=c(.5, 16.5))+
        scale_x_continuous(breaks = seq(-2, 2, .5),
                           minor_breaks = seq(-1.5, 2, .25))+
        theme(legend.position = 'none',
            text=element_text(size=20),
            axis.text.y = element_blank(),
            panel.grid.major.y = element_blank(),
            panel.grid.minor.y = element_blank())+
        labs(x=r"($z - \langle z\rangle$ [\AA])",
            y='Density [arb. units]')+
        scale_colour_tableau(palette="Classic 20")+
        scale_fill_tableau(palette="Classic 20")


# # # # # # # # # # # # # # # # # # # # # # # 
# - Data/Gr.pdf: 
# # # # # # # # # # # # # # # # # # # # # # # 
Gr <- read_csv("Data/Gr.csv")

Gr |> 
    mutate(allotrope=factor(allotrope,
            labels=c(r"($\bm{\alpha}$)", r"($\bm{\beta}_{12}$)", 
                     r"($\bm{\chi}_3$)", r"($\bm{\alpha}_1$)", 
                     r"($\bm{\beta}_{13}$)", r"($\bm{\chi}_2$)"), 
                     ordered = TRUE)) |> 
    ggplot(aes(x = r, y = `G(r)`, color=type, alpha=type, linewidth=type)) +
        geom_line(linewidth=1.5)+
        facet_grid(allotrope~elements)+
        scale_color_manual(values=c("black", "orange"))+
        scale_alpha_manual(values=c(1, .7))+
        scale_linewidth_manual(values=c(1, .7))+
        scale_y_continuous(breaks=c(0,.5,1))+
        scale_x_continuous(breaks=seq(0,10,1))+
        coord_cartesian(ylim=c(0,1.15), xlim=c(1,10))+
        labs(x = "$r$ [\\AA]",
             y = "Normalized $g(r)$ [arb. units]",
             color=NULL)+
        theme(legend.position = "none", 
              panel.spacing.x = unit(1, "lines"), 
              text=element_text(size=20),
              strip.text.y = element_text(angle=0, size=15))


# # # # # # # # # # # # # # # # # # # # # # # 
# - Data/RBMs.pdf: 
# # # # # # # # # # # # # # # # # # # # # # # 
RBMs <- read_csv("Data/RBMs.csv")

colors <- colorRampPalette(c("royalblue", "seagreen", "orange"))(10)

RBMs |> 
    filter(w < 440 & w > 50) |> 
    ggplot(aes(x = w, group = run)) +
        labs(x = "Raman Shift [1/cm]", y = "Normalized Intensity [arb. units]") +
        geom_vline(xintercept = 101.5, alpha = .3) +
        geom_vline(xintercept = 139.972, alpha = .3) +
        geom_vline(xintercept = 293.3, alpha = .3) +
        geom_vline(xintercept = 322.578, alpha = .3) +
        geom_point(aes(y = Int + run * 1.2), size = 1, alpha = .5) +
        geom_line(aes(y = ytot + run * 1.2),
            color = "red", size = 1, alpha = 0.7
        ) +
        geom_line(aes(y = y1 + run * 1.2), color = colors[1], alpha = 0.5) +
        geom_line(aes(y = y2 + run * 1.2), color = colors[2], alpha = 0.5) +
        geom_line(aes(y = y3 + run * 1.2), color = colors[3], alpha = 0.5) +
        geom_line(aes(y = y4 + run * 1.2), color = colors[4], alpha = 0.5) +
        geom_line(aes(y = y5 + run * 1.2), color = colors[5], alpha = 0.5) +
        geom_line(aes(y = y6 + run * 1.2), color = colors[6], alpha = 0.5) +
        geom_line(aes(y = y7 + run * 1.2), color = colors[7], alpha = 0.5) +
        geom_line(aes(y = y8 + run * 1.2), color = colors[8], alpha = 0.5) +
        geom_line(aes(y = y9 + run * 1.2), color = colors[9], alpha = 0.5) +
        geom_line(aes(y = y10 + run * 1.2), color = colors[10], alpha = 0.5) +
        coord_cartesian(
            ylim = c(-0.3, 19.2),
            xlim = c(40, 555)
        ) +
        scale_x_continuous(breaks=seq(0,400,100))+
        annotate("text",
            x = 530, y = 1:length(unique(RBMs$P)) * 1.2 - 1.1,
            label = sort(unique(RBMs$P)),
            hjust = 1, size = 6
        ) +
        theme_bw() +
        theme(
            text = element_text(size = 21),
            axis.text = element_text(size = 21, colour = "black"),
            axis.text.y = element_blank(),
            axis.ticks = element_line(size = 1),
            panel.border = element_rect(colour = "black", size = 1),
            panel.grid = element_blank()
        ) +
        annotate("text",
            x = 551, y = 1.4,
            label = "\\,{\\huge$\\uparrow$}", size = 6, hjust = 1
        )

# # # # # # # # # # # # # # # # # # # # # # # 
# - Data/image.pdf: 
# # # # # # # # # # # # # # # # # # # # # # # 
load("Data/image_bottom.RData")
load("Data/image_top.RData")
glimpse(top)
glimpse(bottom)


Pdiff <- ggplot(bottom, aes(x,y))+ 
    geom_raster(aes(fill =value), interpolate = TRUE)+
    facet_wrap(~tit)+
    theme(axis.title = element_blank(), 
          axis.text = element_blank(),
          axis.ticks = element_blank(),
          legend.key.height = unit(.8, 'cm'))+
    coord_fixed(expand=FALSE)+
    labs(fill=NULL)+
    scale_fill_distiller(limits = c(-.151,.151), 
                         palette = "RdBu")


Pnz <- ggplot(top, aes(x,y))+ 
    geom_raster(aes(fill =value), interpolate = TRUE)+
    facet_wrap(~tit, nrow=1)+
    theme(axis.title = element_blank(), 
          axis.text = element_blank(),
          axis.ticks = element_blank())+
    coord_fixed(expand=FALSE)+
    labs(fill=NULL)+
    scale_fill_distiller(palette = "Greys")

Pnz/Pdiff


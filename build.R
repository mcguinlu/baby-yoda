library(dplyr)
library(brickr)
library(rgl)
library(httr)
library(ggplot2)

#Render a static  model

data <- "babyyoda.xlsx"

babyyoda <- readxl::read_xlsx(data, sheet = "BabyYoda") %>% 
  bricks_from_excel() 

# babyyoda %>% 
#   build_bricks(rgl_lit = F, outline_bricks = T, background_color = "#8a496b")

#Instructions
p <- babyyoda %>% 
  build_instructions() +
  ggplot2::theme(panel.grid = element_blank())

ggplot2::ggsave("babyyoda_instructions.png", p, device="png", width = 6, height = 4)

#Bricks
t <- babyyoda %>% 
  build_pieces()

ggplot2::ggsave("babyyoda_pieces.png", device="png", width = 8, height = 4)

# Load required packages

library(dplyr)
library(brickr)
library(rgl)
library(httr)
library(ggplot2)

# Load model from Excel template

data <- "babyyoda.xlsx"

babyyoda <- readxl::read_xlsx(data, sheet = "BabyYoda") %>% 
  bricks_from_excel() 

# Fix colours 
# As brickr can sometimes arbitarily split up a large block of identical colour
# bricks into a unhelpful building pattern, I used different colours in the
# Excel template to delineate where different bricks of the same colour are. The
# code below fixs the colouring/adjusts the pieces numbers to reflect the true
# model

babyyoda$Img_bricks <- babyyoda$Img_bricks %>%
  mutate(
    Lego_color = ifelse(Lego_name %in% c("Bright red","Bright blue","Dark red"),"#708E7C", Lego_color),
    Lego_color = ifelse(Lego_name %in% c("Medium lilac","Dark azur","Bright green"),"#5F3109", Lego_color),
    Lego_color = ifelse(Lego_name %in% c("Bright bluish green"),"#CCB98D", Lego_color),
    Lego_color = ifelse(Lego_name %in% c("Lavender","Spring yellowish green","Olive green","Vibrant coral"),"#F4F4F4", Lego_color)
    )

babyyoda$pieces <- babyyoda$pieces %>%
  mutate(
    Lego_color = ifelse(Lego_name %in% c("Bright red","Bright blue","Dark red"),"#708E7C", Lego_color),
    Lego_color = ifelse(Lego_name %in% c("Medium lilac","Dark azur","Bright green"),"#5F3109", Lego_color),
    Lego_color = ifelse(Lego_name %in% c("Bright bluish green"),"#CCB98D", Lego_color),
    Lego_color = ifelse(Lego_name %in% c("Lavender","Spring yellowish green","Olive green","Vibrant coral"),"#F4F4F4", Lego_color)
  ) %>%
  mutate(
    Lego_name = ifelse(Lego_name %in% c("Bright red","Bright blue","Dark red"),"Sand green", Lego_name),
    Lego_name = ifelse(Lego_name %in% c("Medium lilac","Dark azur","Bright green"),"Reddish brown", Lego_name),
    Lego_name = ifelse(Lego_name %in% c("Bright bluish green"),"Brick yellow", Lego_name),
    Lego_name = ifelse(Lego_name %in% c("Lavender","Spring yellowish green","Olive green","Vibrant coral"),"White", Lego_name)
  ) %>%
  
  group_by(Brick_size, Lego_color) %>%
  summarise(n = sum(n),Lego_name,Piece) %>%
  distinct()

# Render model
# Wrapped in an interact call so that it is now rendered when sourcing this
# script during the README build.

if (interactive()) {
babyyoda %>%
  build_bricks(rgl_lit = F, outline_bricks = T, background_color = "#8a496b")
}

# Create instructions image
p <- babyyoda %>% 
  build_instructions() 

p <- p +
  ggplot2::theme(panel.grid = element_blank())

ggplot2::ggsave("babyyoda_instructions.png", p, device="png", width = 6, height = 4)

# Create piece list image
p2 <- babyyoda %>% 
  build_pieces()

ggplot2::ggsave("babyyoda_pieces.png", device="png", width = 8, height = 4)

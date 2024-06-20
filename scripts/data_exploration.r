rm(list=ls())
gc()

library(here)
library(ggplot2)
library(dplyr)
library(lubridate) 

c1 <- read.csv(here(paste0("output/datacubes/csv/","0077925-240506114902167.csv")),  sep = "\t")

colnames(c1)

c1$year <- format(ym(c1$yearmonth), "%Y")

ag_c1 <- c1 %>%
  group_by(specieskey, year) %>%
  summarize(Total_Occ = sum(occurrences))

ag_c1[[3]]

sor_ag <- ag_c1 %>%
  arrange(Total_Occ, specieskey)


# data sorting
ag_c2 <- c1 %>%
  group_by(specieskey) %>%
  summarize(Total_Occ = sum(occurrences))

sor_plot <- ag_c2 %>%
  arrange(Total_Occ)

i <- 55
j <- 60

idx <- sor_plot[[1]][i:j]


filt_c1 <- ag_c1 %>%
  filter(specieskey %in% idx)

filt_c1$specieskey <- as.factor(filt_c1$specieskey)

#test <- ym(unique(ag_c1$yearmonth))
plot(filt_c1$year, filt_c1$Total_Occ, type = "p")

p <- ggplot(filt_c1, aes(x = year, y = Total_Occ, color = specieskey, group = specieskey, shape = specieskey)) +
  geom_line(alpha=0.5) +  # Use lines to connect points
  geom_point(size=6) + # Add points
#  scale_x_discrete(breaks = year[c(T,F,F)]) +
  labs(title = "Plot Colored by Species Key)", x = "Year", y = "Occurrences") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1, size=7), aspect.ratio = 1/4)
  

p + scale_color_brewer(palette = "Set1")

print(p)
class(ag_c1)

myDates <- Sy.Date("2015-10")   
str(myDate)

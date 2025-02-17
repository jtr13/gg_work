library(tidyverse)
library(rvest)
library(packageRank)
library(ggplot2)

gallery_packages <- read_csv("/Users/vivzh/OneDrive/Documents/gg_work/gallery_packages.csv")
View(gallery_packages)

cran_packages <- read_csv("/Users/vivzh/OneDrive/Documents/gg_work/cran_packages.csv")
View(cran_packages)

packages <- full_join(gallery_packages, cran_packages, by = c("package", "downloads"))
View(packages)

sorted_packages <- arrange(packages, desc(downloads))
View(sorted_packages)

write_csv(sorted_packages, "/Users/vivzh/OneDrive/Documents/gg_work/all_packages.csv")


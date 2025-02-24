library(tidyverse)
library(rvest)
library(packageRank)
library(ggplot2)

gallery_packages <- read_csv("generated_data/gallery_packages.csv")
#View(gallery_packages)

cran_packages <- read_csv("generated_data/cran_packages.csv")
#View(cran_packages)

packages <- full_join(gallery_packages, cran_packages, by = c("package", "downloads"))
#View(packages)

sorted_packages <- arrange(packages, desc(downloads))
#View(sorted_packages)

write_csv(sorted_packages, "generated_data/all_packages.csv")
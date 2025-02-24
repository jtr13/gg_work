library(tidyverse)
library(packageRank)

top_packages <- c("ggrepel", "cowplot","ggpubr", "ggsci", "ggsignif", "patchwork", "ggmap")

time_series <- function(pkg) {
  cranDownloads(packages = pkg, to = 2025)$cranlogs.data
}

allpackages <- map_dfr(top_packages, time_series)

ggplot(allpackages, aes(x = date, y = count, color = package)) + 
  geom_smooth(se = FALSE, linewidth = .75)


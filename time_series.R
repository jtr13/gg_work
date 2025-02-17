library(tidyverse)
library(ggplot2)
library(packageRank)

top_packages <- c("ggrepel", "cowplot","ggpubr", "ggsci", "ggsignif", "patchwork", "ggmap")

time_series <- function(pkg, start_date, end_date) {
  date_intervals <- seq(from = start_date, to = end_date, length.out = 30)
  download_counts <- numeric(30)
  cranDownloads(packages = pkg, to = 2025)$cranlogs.data
}

start_date = as.Date("2016-01-01")
end_date = as.Date("2025-01-01")
#date_intervals <- seq(from = start_date, to = end_date, length.out = 30)
#date_intervals
ggrepel_counts <- time_series("ggrepel", start_date, end_date)
ggrepel_counts

cowplot_counts <- time_series("cowplot", start_date, end_date)
cowplot_counts

p <- ggplot(ggrepel_counts, aes(x = date, y = cumulative)) + geom_line()

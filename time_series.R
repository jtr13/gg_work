library(tidyverse)
library(ggplot2)

top_packages <- c("ggrepel", "cowplot","ggpubr", "ggsci", "ggsignif", "patchwork", "ggmap")

time_series <- function(pkg, start_date, end_date) {
  date_intervals <- seq(from = start_date, to = end_date, length.out = 30)
  download_counts <- numeric(30)
  cd <- cranDownloads(packages = pkg, to = 2025)
  for (i in seq_along(date_intervals)) {
    dc <- cd$cranlogs.data$cumulative [
      cd$cranlogs.data$date == date_intervals[i]
    ]
    download_counts[i] <- ifelse(length(dc) == 0, NaN, dc)
  }
  dc_time = data.frame(date = date_intervals, downloads = download_counts)
}

start_date = as.Date("2016-01-01")
end_date = as.Date("2025-01-01")
#date_intervals <- seq(from = start_date, to = end_date, length.out = 30)
#date_intervals
ggrepel_counts <- time_series("ggrepel", start_date, end_date)
ggrepel_counts

cowplot_counts <- time_series("cowplot", start_date, end_date)
cowplot_counts

p <- ggplot(ggrepel_counts, aes(x = date, y = downloads)) +
  geom_line()

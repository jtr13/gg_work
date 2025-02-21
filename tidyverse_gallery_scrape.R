library(tidyverse)
library(rvest)
library(packageRank)
library(ggplot2)

df <- read_html("exts.ggplot2.tidyverse.org.html")

package_names <- df |>
  html_elements("div.card-content") |> 
  html_elements("span.card-title") |> 
  html_text()

package_names

get_total_downloads <- function(pkg, date) {
  cd <- cranDownloads(packages = pkg, to = 2025)
  cd$cranlogs.data$cumulative [
    cd$cranlogs.data$date == date
  ]
}

target_date <- Sys.Date()-2

downloads_count <- numeric(length(package_names))

for (i in seq_along(package_names)) {
  dc <- tryCatch(
    get_total_downloads(package_names[i], target_date),
    error = function(e) NA
  )
  downloads_count[i] <- ifelse(length(dc) == 0, NA, dc)
}

downloads_count

github_stars <- df |> 
  html_elements("span.github-btn") |>
  html_elements("a.gh-count") |> 
  html_text() |> as.numeric()

github_stars

gallery_packages <- data.frame(package = package_names, stars = github_stars, downloads = downloads_count, gallery = TRUE)
write_csv(gallery_packages, "/Users/vivzh/OneDrive/Documents/gg_work/gallery_packages.csv")
View(gallery_packages)

p <- ggplot(gallery_packages, aes(x = github_stars, y = downloads)) + 
  geom_point()
p

mod <- lm(github_stars ~ downloads, data = gallery_packages)
summary(mod)

p2 <- p +
  xlim(0, 750) +
  ylim(0, 5e5) +
  geom_smooth(method = 'lm', se = FALSE)
p2

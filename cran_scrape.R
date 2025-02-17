library(tidyverse)
library(rvest)
library(packageRank)
library(ggplot2)

df <- read_html("/Users/vivzh/OneDrive/Documents/gg_work/CRAN_ Available Packages By Name.html")

names <- df |>
  html_elements("span.CRAN") |> 
  html_text()

gg_start <- which(substr(names, 1, 2) == "gg")[1]
gg_end <- which(substr(names, 1, 2) == "gh")[1] - 1

gg_package_names <- names[gg_start:gg_end]
head(gg_package_names)
tail(gg_package_names)

remove_packages <- read.csv("non_ggplot_packages.csv")[[1]]
print(remove_packages)

ggplot_package_names <- gg_package_names[!gg_package_names %in% remove_packages]
length(ggplot_package_names)

desc <- df |>
  html_elements("div.container") |> 
  html_elements("table") |> 
  html_elements("tbody") |> 
  html_elements("tr") |> 
  html_elements("td") |> 
  html_text()

first_gg <- which(substr(desc, 1, 2) == "gg")[1]
end_gg <- which(substr(desc, 1, 2) == "gh")[1] - 1

desc_gg <- desc[first_gg:end_gg]
head(desc_gg)
tail(desc_gg)

gg_descriptions <- desc_gg[c(FALSE, TRUE)]
head(gg_descriptions)
tail(gg_descriptions)

remove_desc <- read.csv("non_ggplot_desc.csv")[[1]]
print(remove_desc)

ggplot_descriptions <- gg_descriptions[!gg_descriptions %in% remove_desc]
length(ggplot_descriptions)

#find packages and descriptions related to ggplot not start with gg
non_gg_desc <- desc[c(1:(first_gg-1), (end_gg+1):length(desc))]
gg_indices <- grep('ggplot', non_gg_desc)[-1]
gg_indices <- gg_indices[-match(30865, gg_indices)]
replace <- c(13588, 20251, 29832)
for (num in replace) {
  pos <- match(num, gg_indices)
  gg_indices[pos] <- gg_indices[pos] + 1
}

#saved down additional names and desc for future reference
add_ggplot_names <- non_gg_desc[gg_indices-1]
add_ggplot_desc <- non_gg_desc[gg_indices]
write_csv(data.frame(names = add_ggplot_names, indices = gg_indices-1), "add_ggplot_names.csv")
write_csv(data.frame(desc = add_ggplot_desc, indices = gg_indices), "add_ggplot_desc.csv")

add_gg_names <- read.csv("add_ggplot_names.csv")[[1]]
add_gg_desc <- read.csv("add_ggplot_desc.csv")[[1]]

all_ggplot_packages <- c(ggplot_package_names, add_gg_names)
all_ggplot_desc <- c(ggplot_descriptions, add_gg_desc)

get_total_downloads <- function(pkg, date) {
  cd <- cranDownloads(packages = pkg, to = 2025)
  cd$cranlogs.data$cumulative [
    cd$cranlogs.data$date == date
  ]
}

target_date <- Sys.Date()-2

downloads_count <- numeric(length(all_ggplot_packages))

for (i in seq_along(all_ggplot_packages)) {
  dc <- tryCatch(
    get_total_downloads(all_ggplot_packages[i], target_date),
    error = function(e) NA
  )
  downloads_count[i] <- ifelse(length(dc) == 0, NA, dc)
}

downloads_count

cran_packages <- data.frame(package = all_ggplot_packages, description = all_ggplot_desc, downloads = downloads_count, CRAN = TRUE)
write_csv(cran_packages, "/Users/vivzh/OneDrive/Documents/gg_work/cran_packages.csv")
View(cran_packages)

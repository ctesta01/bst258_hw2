library(fastverse)
library(readxl)
library(stringr)
# create URLs for downloading NHEFS data
url_trunks <- c("2012/10/nhefs_sas.zip", "2012/10/nhefs_stata.zip",
"2017/01/nhefs_excel.zip", "1268/20/nhefs.csv")
url_stub <- "https://cdn1.sph.harvard.edu/wp-content/uploads/sites/1268/"
data_urls <- lapply(url_trunks, function(url_trunk) {
paste0(url_stub, url_trunk)
})
# download and unzip files
temp <- tempfile()
for (i in seq_len(sum(str_count(url_trunks, "zip")))) {
download.file(data_urls[[i]], temp)
unzip(temp, exdir = "data")
}
download.file(data_urls[[4]], "data/nhefs.csv")
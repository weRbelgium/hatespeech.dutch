library(data.table)
hades <- list()
hades$original <- readLines("inst/extdata/original.csv", encoding = "UTF-8")
hades$cleaned <- readLines("inst/extdata/cleaned.csv", encoding = "UTF-8")
hades$expanded <- readLines("inst/extdata/expanded.csv", encoding = "UTF-8")
hades <- lapply(hades, FUN=function(x){
  x <- lapply(x, FUN=function(x){
    x <- strsplit(x, ",")[[1]]
    list(category = x[1], term = x[-1])
  })
  names(x) <- sapply(x, FUN=function(x) x$category)
  x <- x[sort(names(x))]
  x
})
dutch_racistspeech <- hades
dutch_racistspeech <- lapply(dutch_racistspeech, FUN=function(x){
  x <- lapply(x, as.data.table)
  rbindlist(x)
})
dutch_racistspeech <- rbindlist(dutch_racistspeech, idcol = "data_type")
save(dutch_racistspeech, file = "data/dutch_racistspeech.RData", compress = "xz")

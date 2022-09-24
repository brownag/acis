.acis_query_string <- function(params = list(),
                               base_url = "http://data.rcc-acis.org",
                               call = c(
                                 "StnMeta",
                                 "StnData",
                                 "MultiStnData",
                                 "GridData",
                                 "GridData2",
                                 "StnHourly",
                                 "General"
                               )) {
  call <- match.arg(call,  c("StnMeta", "StnData", "MultiStnData", "GridData", "GridData2", "StnHourly", "General"), several.ok = TRUE)
  file.path(base_url, paste0(call, "?",
                             paste(paste0(names(params), "=", utils::URLencode(as.character(params), reserved = TRUE)),
                                   collapse = "&"))
  )
}

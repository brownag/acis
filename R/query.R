#' ACIS Query Interface
#'
#' `acis_query()` builds URLs and makes requests to obtain data from the ACIS Web Services.
#'
#' @param call One of `"StnMeta"`, `"StnData"`, `"MultiStnData"`, `"GridData"`, `"GridData2"`, `"StnHourly"`, `"General"`
#' @param params A named _list_ of parameter values. For complex/nested inputs `params` can be a list with 1 element named `"params"` containing JSON input as character vector.
#' @param base_url Default: `"http://data.rcc-acis.org"`
#' @param query_string Return query URL rather than result? Default: `FALSE`
#' @return `acis_query()` returns result of downloading URL, _try-error_ on error. Unless otherwise specified in `params` the result is JSON (converted to _list_). Output types other than JSON include `output="csv"` (returned as `data.frame`) and `output="image"` (PNG returned as _SpatRaster_).
#' @export
#' @rdname query
#' @importFrom jsonlite read_json
#' @importFrom data.table fread
#' @importFrom terra rast
#' @examples
#' \donttest{
#' # ITHACA CORNELL UNIV (sid: 304174; -76.44905, 42.44915; 960m elev)
#' acis_query(
#'  "StnMeta",
#'  params = list(
#'    sids = 304174,
#'    output = 'json'
#'  )
#' )
#'
#' # get average+max temperature, and precipitation for January 2020
#' acis_query(
#'   "StnData",
#'   params = list(
#'     sid = 304174,
#'     sdate = '2020-01-01',
#'     edate = '2020-01-31',
#'     elems = 'avgt,maxt,pcpn',
#'     output = 'csv'
#'   )
#' )
#' }
acis_query <- function(call,
                       params,
                       base_url = "http://data.rcc-acis.org",
                       query_string = FALSE) {

  q <- .acis_query_string(params = params,
                          base_url = base_url,
                          call =  call)

  if (query_string) {
    return(q)
  }

  switch(tolower(trimws(params$output)),
         "csv" = {
            res <- try(data.table::fread(q))
            if (inherits(res, 'data.table')) {
             attr(res, "station_name") <- colnames(res)[1]
             colnames(res)[1] <- "V1"
             res <- as.data.frame(res)
            }
            res
         },
         "image" = {
            try(terra::rast(q))
         },
         { # default is JSON
            try(jsonlite::read_json(q))
         }
  )
}

#' @return `acis_call_names()` returns a character vector of available calls
#' @export
#' @rdname query
acis_call_names <- function() {
  c(
    "StnMeta",
    "StnData",
    "MultiStnData",
    "GridData",
    "GridData2",
    "StnHourly",
    "General"
  )
}

.acis_query_string <- function(params = list(),
                               base_url = "http://data.rcc-acis.org",
                               call = acis_call_names()) {

  call <- match.arg(call, acis_call_names(), several.ok = TRUE)

  file.path(base_url, paste0(call, "?",
                             paste(paste0(names(params), "=",
                                          utils::URLencode(as.character(params),
                                                           reserved = TRUE)),
                                   collapse = "&")))
}

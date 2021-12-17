#' copycat_helpfiles
#'
#' @param pkg A search string
#'
#' @return A list
#' @export
#'

copycat_helpfiles <- function(pkg){
  rdbfile <- file.path(find.package(pkg), "help", pkg)
  fetchRdDB <- utils::getFromNamespace("fetchRdDB", "tools")

  rdb <- fetchRdDB(rdbfile, key = NULL)
  names(rdb)
}

#' copycat_help
#'
#' @param pkg A search string
#' @param fn A search string
#'
#' @return A string
#' @export
#'

copycat_help <- function(pkg, fn) {
  rdbfile <- file.path(find.package(pkg), "help", pkg)
  fetchRdDB <- utils::getFromNamespace("fetchRdDB", "tools")
  rdb <- fetchRdDB(rdbfile, key = fn)
  to <- "txt"
  convertor <- switch(to,
                      txt   = tools::Rd2txt,
                      html  = tools::Rd2HTML,
                      latex = tools::Rd2latex,
                      ex    = tools::Rd2ex
  )

  f <- function(x) capture.output(convertor(x))
  text <- f(rdb)
  pattern <- "_\bE_\bx_\ba_\bm_\bp_\bl_\be_\bs:"
  empty_cells <- ""
  replace <- "#Extracted examples:"
  detect <- stringr::str_detect(text, pattern)
  empty <- stringr::str_detect(text, empty_cells)

  df <- data.frame(x = text,
                   y = detect,
                   z = empty)

  df$x <- stringr::str_replace(df$x, pattern, replace)
  df <- subset(df, z == TRUE)
  pos_data <- which(df$y == TRUE)
  lx <- length(df$x)
  x <- df$x[pos_data:lx]
  return(x)

}

#' copy_help
#'
#' @param pkg A search string
#' @param fn A search string
#'
#' @return A string
#' @export
#'

copy_help <- function(pkg, fn) {
  rdbfile <- file.path(find.package(pkg), "help", pkg)
  fetchRdDB <- utils::getFromNamespace("fetchRdDB", "tools")
  rdb <- fetchRdDB(rdbfile, key = fn)
  to <- "txt"
  convertor <- switch(to,
                      txt   = tools::Rd2txt,
                      html  = tools::Rd2HTML,
                      latex = tools::Rd2latex,
                      ex    = tools::Rd2ex
  )

  f <- function(x) capture.output(convertor(x))
  text <- f(rdb)
  pattern <- "_\bE_\bx_\ba_\bm_\bp_\bl_\be_\bs:"
  empty_cells <- ""
  replace <- "#Extracted examples:"
  detect <- stringr::str_detect(text, pattern)
  empty <- stringr::str_detect(text, empty_cells)

  df <- data.frame(x = text,
                   y = detect,
                   z = empty)

  df$x <- stringr::str_replace(df$x, pattern, replace)
  df <- subset(df, z == TRUE)
  pos_data <- which(df$y == TRUE)
  lx <- length(df$x)
  x <- df$x[pos_data:lx]
  clipr::write_clip(x)

}


#' copycat_helpfile
#'
#' @param pkg A search string
#' @param fn A search string
#' @param path A search string
#'
#' @return A string
#' @export
#'


copycat_inserthelp <- function(pkg, fn, path = NULL){
  path <- paste("~/", fn, "_examples.R", sep = "")
  fs::file_create(path)
  id <- rstudioapi::getSourceEditorContext()$id
  rstudioapi::navigateToFile(path)

  while(rstudioapi::getSourceEditorContext()$id == id){
    next()
    Sys.sleep(0.1) # slow down the while loop to avoid over-processing
  }
  id <- rstudioapi::getSourceEditorContext()$id
  text <- copy_help(pkg, fn)

  #range <- rstudioapi::document_range(c(1, 0), c(15,0))
  rstudioapi::insertText(text)
}




utils::globalVariables(c("utils", "capture.output", "z"))









